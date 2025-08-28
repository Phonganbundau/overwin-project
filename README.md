# Overwin Mobile - Esports Betting Application

A comprehensive mobile application for esports betting built with Flutter (frontend) and Spring Boot (backend).

## 🏗️ Project Structure

```
overwin-mobile-master/
├── android/                 # Android-specific configurations
├── ios/                    # iOS-specific configurations  
├── lib/                    # Flutter source code
│   ├── app/               # App configuration and routing
│   ├── modules/           # Feature modules (auth, bets, esports, etc.)
│   └── shared/            # Shared services and widgets
├── backend/                # Spring Boot backend
│   ├── src/main/java/     # Java source code
│   └── src/main/resources/ # Configuration files
└── assets/                 # Images and static resources
```

## 🚀 Prerequisites

### Required Software
- **Flutter SDK** (3.16.0 or higher)
- **Java JDK** (17 or higher)
- **Maven** (3.6.0 or higher)
- **MySQL** (8.0 or higher)
- **Android Studio** (for Android development)
- **Xcode** (for iOS development, macOS only)

### System Requirements
- **Windows 10/11** or **macOS** or **Linux**
- **8GB RAM** minimum (16GB recommended)
- **2GB free disk space**

## 📱 Frontend Setup (Flutter)

### 1. Install Flutter
```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install
# Add Flutter to your PATH environment variable

# Verify installation
flutter doctor
```

### 2. Install Dependencies
```bash
# Navigate to project root
cd overwin-mobile-master

# Install Flutter dependencies
flutter pub get
```

### 3. Configure Android
```bash
# Open Android Studio and install Android SDK
# Set ANDROID_HOME environment variable

# Accept Android licenses
flutter doctor --android-licenses
```

### 4. Configure iOS (macOS only)
```bash
# Install Xcode from App Store
# Install iOS Simulator
# Accept iOS licenses
sudo xcodebuild -license accept
```

## 🖥️ Backend Setup (Spring Boot)

### 1. Install Java and Maven
```bash
# Install Java JDK 17+
# Install Maven 3.6.0+

# Verify installations
java -version
mvn -version
```

### 2. Setup Database
```bash
# Start MySQL service
# Create database
mysql -u root -p
CREATE DATABASE overwin_db;
```

### 3. Configure Database Connection
Edit `backend/src/main/resources/application.properties`:
```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/overwin_db
spring.datasource.username=your_username
spring.datasource.password=your_password

# Email Configuration (for email verification)
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=your_email@gmail.com
spring.mail.password=your_app_password
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
```

### 4. Run Database Migrations
```bash
# Navigate to backend directory
cd backend

# Run the SQL script to create tables
mysql -u root -p overwin_db < src/main/resources/Dump20250818.sql
```

## 🚀 Running the Application

### 1. Start Backend Server
```bash
# Navigate to backend directory
cd backend

# Run Spring Boot application
mvn spring-boot:run

# Backend will start on http://localhost:8080
```

### 2. Start Flutter App
```bash
# Open new terminal, navigate to project root
cd overwin-mobile-master

# List available devices
flutter devices

# Run on Android emulator
flutter run -d emulator-5554

# Run on iOS simulator (macOS only)
flutter run -d iPhone

# Run on connected device
flutter run -d <device-id>
```

## 🔧 Development Workflow

### Hot Reload (Flutter)
```bash
# Press 'r' in terminal for hot reload
# Press 'R' for hot restart
# Press 'q' to quit
```

### Backend Development
```bash
# The backend will automatically reload when you save changes
# Check logs in the terminal running mvn spring-boot:run
```

## 📱 Features

### Authentication
- User registration with email verification
- Secure login with JWT tokens
- Password recovery

### Esports Betting
- Browse upcoming matches
- Place single and combination bets
- Real-time odds updates
- Bet history and statistics

### User Management
- Profile management
- Balance tracking
- Bet history
- Email notifications

## 🔐 Environment Variables

### Backend (.env or application.properties)
```properties
# Database
DB_HOST=localhost
DB_PORT=3306
DB_NAME=overwin_db
DB_USERNAME=your_username
DB_PASSWORD=your_password

# JWT
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRATION=86400000

# Email
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your_email@gmail.com
MAIL_PASSWORD=your_app_password
```

## 🧪 Testing

### Backend Testing
```bash
cd backend
mvn test
```

### Flutter Testing
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/
```

## 📦 Building for Production

### Android APK
```bash
# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# APK will be in build/app/outputs/flutter-apk/
```

### iOS IPA (macOS only)
```bash
# Build iOS app
flutter build ios --release

# Open Xcode to archive and distribute
open ios/Runner.xcworkspace
```

## 🐛 Troubleshooting

### Common Issues

#### Flutter Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check Flutter doctor
flutter doctor -v
```

#### Backend Issues
```bash
# Check Java version
java -version

# Check Maven version
mvn -version

# Clean Maven cache
mvn clean install
```

#### Database Issues
```bash
# Check MySQL service status
sudo systemctl status mysql

# Restart MySQL
sudo systemctl restart mysql

# Check connection
mysql -u root -p -h localhost
```

### Debug Mode
```bash
# Enable debug logging in Flutter
flutter run --debug

# Enable debug logging in Spring Boot
# Add to application.properties:
logging.level.com.overwin=DEBUG
```



### Authentication
All protected endpoints require JWT token in Authorization header:
```
Authorization: Bearer <jwt_token>
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you encounter any issues:

1. Check the troubleshooting section above
2. Search existing issues in the repository
3. Create a new issue with detailed information:
   - Error messages
   - Steps to reproduce
   - Environment details
   - Screenshots (if applicable)

## 🔄 Updates

### Flutter Updates
```bash
flutter upgrade
flutter pub upgrade
```


