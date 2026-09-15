# IdeaLab Equipment Manager (LendLab) 🛠️

A modern Flutter application designed for maker spaces, robotics labs, and university workshops. IdeaLab simplifies the process of tracking inventory, handling student requests, and managing equipment loans (microcontrollers, sensors, tools, and components).

## 🌟 Features

- **Role-Based Dashboards:** Dedicated interfaces for Students (borrowers) and Admins (managers).
- **Inventory Tracking:** Categorized inventory system (Microcontrollers, Sensors, Tools, Components).
- **Request System:** Students can browse the catalog and submit requests for specific quantities of items.
- **Loan Management:** Admins can approve/reject requests, issue equipment, and track active or overdue loans.
- **Real-time Database:** Powered by Firebase Cloud Firestore for instant updates across all devices.
- **Smart Onboarding:** Automatically generates demo inventory and sample requests on first launch for testing.

## 🚀 Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **Backend:** [Firebase](https://firebase.google.com/) (Authentication & Cloud Firestore)

## 🛠️ Getting Started

Follow these steps to get the project up and running on your local machine.

### Prerequisites
1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version 3.10.0 or higher recommended).
2. Install [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with the Flutter & Dart extensions.
3. Have a Google account to set up Firebase.

### Installation

1. Clone the repository:
```bash
git clone https://github.com/danyl-dnl/LendLab.git
cd LendLab
```

2. Fetch dependencies:
```bash
flutter pub get
```

3. Setup Firebase:
Initialize Firebase using the FlutterFire CLI or manually configure the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).

4. Run the app:
```bash
flutter run
```

## Project Structure

- `lib/`: Contains the Dart source code for the Flutter application.
- `android/` & `ios/`: Platform-specific configurations.
- `pubspec.yaml`: Flutter project metadata and dependencies.
