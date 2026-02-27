import 'package:cloud_firestore/cloud_firestore.dart';

class DemoDataService {
  static Future<void> populateDemoData() async {
    final firestore = FirebaseFirestore.instance;

    // 1. Populate Inventory
    final inventoryCollection = firestore.collection('inventory');
    final inventorySnapshot = await inventoryCollection.limit(1).get();
    
    // Only populate if it's empty
    if (inventorySnapshot.docs.isEmpty) {
      final demoItems = [
        {
          'name': 'Arduino Uno R3',
          'category': 'Microcontrollers',
          'desc': 'ATmega328P based microcontroller board',
          'qty': 15,
        },
        {
          'name': 'Raspberry Pi 4',
          'category': 'Microcontrollers',
          'desc': 'Model B - 4GB RAM',
          'qty': 5,
        },
        {
          'name': 'DHT11 Temp Sensor',
          'category': 'Sensors',
          'desc': 'Basic temperature and humidity sensor',
          'qty': 30,
        },
        {
          'name': 'Ultrasonic Sensor HC-SR04',
          'category': 'Sensors',
          'desc': 'Distance measuring transducer',
          'qty': 20,
        },
        {
          'name': 'Multimeter',
          'category': 'Tools',
          'desc': 'Digital multimeter for voltage, current, resistance',
          'qty': 0, // Out of stock example
        },
        {
          'name': 'Soldering Iron',
          'category': 'Tools',
          'desc': '60W adjustable temperature soldering iron',
          'qty': 8,
        },
        {
          'name': 'Breadboard - Half Size',
          'category': 'Components',
          'desc': '400 point solderless breadboard',
          'qty': 50,
        },
        {
          'name': 'Jumper Wires (M-M)',
          'category': 'Components',
          'desc': 'Pack of 65 mixed length male to male',
          'qty': 100,
        },
      ];

      for (var item in demoItems) {
        await inventoryCollection.add(item);
      }
    }

    // 2. Populate some mock requests and loans just to have visual data 
    // Usually these are tied to actual users, but we will add some dummy ones
    final requestsCollection = firestore.collection('requests');
    final requestsSnapshot = await requestsCollection.limit(1).get();

    if (requestsSnapshot.docs.isEmpty) {
      final demoRequests = [
        {
          'userId': 'demo_student_uid',
          'userEmail': 'student@idealab.com',
          'itemId': 'demo_item_1',
          'itemName': 'Arduino Uno R3',
          'status': 'pending',
          'timestamp': FieldValue.serverTimestamp(),
          'qty': 2,
        },
        {
          'userId': 'demo_student_uid',
          'userEmail': 'student@idealab.com',
          'itemId': 'demo_item_2',
          'itemName': 'Raspberry Pi 4',
          'status': 'approved',
          'timestamp': FieldValue.serverTimestamp(),
          'qty': 1,
        },
        {
          'userId': 'other_student_uid',
          'userEmail': 'john@idealab.com',
          'itemId': 'demo_item_3',
          'itemName': 'Multimeter',
          'status': 'pending',
          'timestamp': FieldValue.serverTimestamp(),
          'qty': 1,
        }
      ];

      for (var req in demoRequests) {
        await requestsCollection.add(req);
      }
    }

    // 3. Populate some active loans
    final loansCollection = firestore.collection('loans');
    final loansSnapshot = await loansCollection.limit(1).get();

    if (loansSnapshot.docs.isEmpty) {
      final now = DateTime.now();
      final lastWeek = now.subtract(const Duration(days: 9));
      
      final demoLoans = [
        {
          'requestId': 'demo_req_1',
          'itemName': 'Soldering Iron',
          'borrower': 'student@idealab.com',
          'status': 'borrowed',
          'issueDate': "${now.month}/${now.day}/${now.year}",
          'dueDate': "${now.add(const Duration(days: 7)).month}/${now.add(const Duration(days: 7)).day}/${now.year}",
          'timestamp': FieldValue.serverTimestamp(),
        },
        {
          'requestId': 'demo_req_2',
          'itemName': 'Oscilloscope',
          'borrower': 'jane@idealab.com',
          'status': 'overdue',
          'issueDate': "${lastWeek.month}/${lastWeek.day}/${lastWeek.year}",
          'dueDate': "${lastWeek.add(const Duration(days: 7)).month}/${lastWeek.add(const Duration(days: 7)).day}/${lastWeek.year}",
          'timestamp': FieldValue.serverTimestamp(),
        }
      ];

      for (var loan in demoLoans) {
        await loansCollection.add(loan);
      }
    }
  }
}
