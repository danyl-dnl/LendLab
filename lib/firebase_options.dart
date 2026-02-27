import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // This is the config you pasted earlier. Real apps use flutterfire cli.
    return const FirebaseOptions(
      apiKey: "AIzaSyBHZEmeyYFAJ2S0BG9dpJqoOujXYILV4S4",
      authDomain: "idealab-983b0.firebaseapp.com",
      projectId: "idealab-983b0",
      storageBucket: "idealab-983b0.firebasestorage.app",
      messagingSenderId: "1063605984910",
      appId: "1:1063605984910:web:982a18855b683423fcf3df",
      measurementId: "G-YK1H4V9FBJ",
    );
  }
}
