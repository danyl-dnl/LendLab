import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme.dart';
import '../auth/login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  Future<void> _handleAction(BuildContext context, String reqId, String action, Map<String, dynamic> reqData) async {
    try {
      final reqRef = FirebaseFirestore.instance.collection('requests').doc(reqId);

      if (action == 'approve') {
        await reqRef.update({'status': 'approved'});
        
        final issueDate = DateTime.now();
        final dueDate = issueDate.add(const Duration(days: 7));
        
        await FirebaseFirestore.instance.collection('loans').add({
          'requestId': reqId,
          'itemName': reqData['itemName'],
          'borrower': reqData['userEmail'],
          'status': 'borrowed',
          'issueDate': "${issueDate.month}/${issueDate.day}/${issueDate.year}",
          'dueDate': "${dueDate.month}/${dueDate.day}/${dueDate.year}",
          'timestamp': FieldValue.serverTimestamp(),
        });

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Approved & Loan Created')));
      } else if (action == 'reject') {
        await reqRef.update({'status': 'rejected'});
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request Rejected')));
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Action failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('Admin Dashboard', style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.grey)),
            Text('IDEALab Control', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('requests').where('status', isEqualTo: 'pending').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final pendingCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
          final docs = snapshot.hasData ? snapshot.data!.docs : [];

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.pending_actions, color: Colors.black54, size: 28),
                              const SizedBox(height: 8),
                              Text('$pendingCount', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                              const Text('Pending Requests', style: TextStyle(fontSize: 12, color: Colors.black54)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('loans').where('status', isEqualTo: 'returned').snapshots(),
                          builder: (context, returnedSnapshot) {
                            final returnedCount = returnedSnapshot.hasData ? returnedSnapshot.data!.docs.length : 0;
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.green, size: 28),
                                  const SizedBox(height: 8),
                                  Text('$returnedCount', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                  const Text('Items Returned', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Text('Recent Requests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                ),

                Expanded(
                  child: docs.isEmpty
                    ? const Center(child: Text('No pending requests!'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          final docId = docs[index].id;
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.person, color: Colors.white),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(data['userEmail'] ?? 'Unknown User', style: const TextStyle(fontWeight: FontWeight.bold)),
                                            Text(data['itemName'] ?? 'Unknown Item', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        data['timestamp'] != null 
                                          ? (data['timestamp'] as Timestamp).toDate().toString().split('.')[0]
                                          : 'Recent',
                                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () => _handleAction(context, docId, 'reject', data),
                                          style: OutlinedButton.styleFrom(foregroundColor: Colors.grey),
                                          child: const Text('Reject'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () => _handleAction(context, docId, 'approve', data),
                                          child: const Text('Approve'),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          );
                        },
                      ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
