# Can I Bunk? 📚

A modern Flutter web application for students to track their attendance and make smart decisions about class attendance. Built with Firebase for authentication and data persistence.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## ✨ Features

### 🔐 Authentication
- **Email/Password Authentication** - Secure sign up and login
- **Google Sign-In** - Quick authentication with Google accounts
- **Protected Routes** - Automatic redirection based on auth state

### 📊 Attendance Tracking
- **Subject Management** - Add subjects with custom attendance requirements
- **Real-time Tracking** - Mark attendance for each class session
- **Smart Calculations** - Calculate safe skips based on current attendance
- **Visual Indicators** - Color-coded attendance status (Green/Yellow/Red)

### 📅 Timetable Management
- **Class Scheduling** - Add and manage class sessions
- **Current Class Detection** - Shows ongoing classes
- **Upcoming Class Alerts** - Notifications for upcoming classes
- **Weekly Schedule** - Organize classes by day of the week

### 💡 Smart Guidance
- **Attendance Guidance** - Get recommendations on attending/skipping classes
- **Safe Skip Calculator** - Know how many classes you can safely miss
- **Real-time Advice** - Context-aware suggestions based on your attendance

### ☁️ Cloud Integration
- **Firebase Firestore** - Secure cloud data storage
- **Real-time Sync** - Automatic data synchronization
- **Offline Support** - Works without internet connection
- **Cross-device Access** - Access data from any device

### 📱 User Experience
- **Modern UI** - Material Design 3 interface
- **Responsive Design** - Optimized for web and mobile
- **Dark/Light Themes** - Comfortable viewing in any environment
- **Intuitive Navigation** - Easy-to-use interface

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Firebase account
- Web browser (Chrome recommended for development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/can-i-bunk.git
   cd can-i-bunk
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication with Email/Password and Google providers
   - Enable Firestore Database
   - Enable Analytics
   - Update `lib/firebase_options.dart` with your Firebase configuration

4. **Run the app**
   ```bash
   flutter run -d web-server --web-port=8080
   ```

5. **Open in browser**
   Navigate to `http://localhost:8080`

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point & Firebase initialization
├── firebase_options.dart     # Firebase configuration
├── models/
│   ├── subject.dart          # Subject data model
│   ├── attendance.dart       # Attendance record model
│   └── class_session.dart    # Class session model
├── providers/
│   ├── auth_provider.dart    # Authentication state management
│   └── attendance_provider.dart # Attendance data management
├── screens/
│   ├── auth_screen.dart      # Login/Signup screen
│   ├── home_screen.dart      # Main dashboard
│   ├── dashboard_screen.dart # Detailed attendance view
│   └── timetable_screen.dart # Class schedule management
├── services/
│   ├── auth_service.dart     # Firebase Auth operations
│   └── notification_service.dart # Local notifications
└── widgets/                  # Reusable UI components
```

## 🔧 Configuration

### Firebase Configuration
Update the following in `lib/firebase_options.dart`:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_WEB_API_KEY',
  appId: 'YOUR_WEB_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'your-project-id',
  authDomain: 'your-project-id.firebaseapp.com',
  storageBucket: 'your-project-id.appspot.com',
  measurementId: 'YOUR_MEASUREMENT_ID',
);
```

### Environment Variables
No additional environment variables required. All configuration is handled through Firebase options.

## 🎯 Usage

### First Time Setup
1. **Sign Up/Login** - Create an account or sign in with Google
2. **Add Subjects** - Add your courses with minimum attendance requirements
3. **Schedule Classes** - Set up your weekly timetable
4. **Track Attendance** - Mark attendance after each class

### Daily Usage
1. **Check Current Class** - View ongoing or upcoming classes
2. **Mark Attendance** - Update attendance status
3. **Get Guidance** - Receive recommendations for attendance decisions
4. **Monitor Progress** - Track attendance across all subjects

## 🏗️ Architecture

### State Management
- **Provider Pattern** - Clean separation of business logic and UI
- **ChangeNotifier** - Reactive state updates
- **MultiProvider** - Hierarchical state management

### Data Flow
```
UI Components → Providers → Services → Firebase/Local Storage
      ↑              ↑            ↑              ↑
   User Actions ← State Updates ← API Calls ← Data Sync
```

### Storage Strategy
- **Local First** - Immediate access with SharedPreferences
- **Cloud Backup** - Automatic sync to Firebase Firestore
- **Offline Support** - Full functionality without internet
- **Conflict Resolution** - Firebase data takes precedence

## 🔒 Security

- **Firebase Authentication** - Secure user authentication
- **User-specific Data** - Isolated data storage per user
- **Secure API Keys** - Environment-specific configuration
- **Data Encryption** - Firebase handles data encryption at rest

## 📊 Analytics

The app tracks the following events:
- App opens
- User sign-ups/logins
- Subject additions
- Attendance marking
- Class session creation

## 🧪 Testing

### Running Tests
```bash
flutter test
```

### Integration Testing
```bash
flutter test integration_test/
```

## 🚀 Deployment

### Web Deployment
```bash
flutter build web
firebase deploy
```

### Mobile Deployment
```bash
# Android
flutter build apk
flutter build appbundle

# iOS
flutter build ios
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.




