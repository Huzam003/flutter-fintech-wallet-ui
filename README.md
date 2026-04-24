# User App (Fintech Digital Wallet Mockup)

A professional Flutter-based Android mockup application built to showcase a digital wallet and payment experience. This project meticulously recreates a high-fidelity Figma design for internal reviews and client demonstrations.

> [!NOTE]
> **Mock Application:** This app is for demonstration purposes only. It does not include backend integration; all data is managed via local dummy JSON assets and simulated logic.

---

## 📑 Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
- [Setup Instructions](#setup-instructions)
- [How to Verify Screens and Features](#how-to-verify-screens-and-features)
- [Screens & Navigation](#screens--navigation)
- [State Management](#state-management)
- [Design System](#design-system)
- [Localization](#localization)

---

## 🔍 Overview

| Feature | Details |
|---|---|
| **App Name** | user_app |
| **Version** | 1.0.0+1 |
| **Platform** | Android (iOS compatible structure) |
| **Framework** | Flutter (Dart) |
| **Default Language** | Japanese |
| **Backend** | Mocked (Local JSON) |

---

## ✨ Key Features

- **Authentication Flows**
  - Email & Password login / registration.
  - OTP (One-Time Password) verification.
  - Biometric Authentication (Fingerprint/Face) using `local_auth`.
  - Passcode protection and password recovery flows.

- **Wallet & Home**
  - Real-time balance display with toggle visibility.
  - Smooth balance update animations.
  - Identity verification status banners.

- **Payments & Transfers**
  - Integrated QR Code scanner for instant payments.
  - Dynamic amount input and simulated transaction processing.
  - 3D Secure simulation and success screens.

- **Account Management**
  - Comprehensive KYC (Know Your Customer) flow with camera-based ID and selfie capture.
  - Bank account and Credit Card management.
  - Transaction history with detailed breakdowns.

---

## 🏗️ Project Structure

```text
lib/
├── main.dart                  # Entry point & theme configuration
├── l10n/                      # Internationalization (JA/EN support)
├── models/                    # Data models (User, Transaction)
├── providers/                 # State management (Provider)
├── screens/                   # UI Screens
├── services/                  # Business logic & hardware wrappers
├── theme/                     # Design system (colors, typography)
└── widgets/                   # Reusable UI components
```

---

## 🛠️ Tech Stack

### Core
- **Flutter / Dart**: Main UI framework.
- **Provider**: State management.
- **Flutter Localizations**: Support for Japanese and English.

### Device & Hardware
- **local_auth**: Android BiometricPrompt integration.
- **camera**: For KYC ID documents and selfie capture.
- **mobile_scanner**: High-performance QR/Barcode scanning.

---

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (Dart ^3.10.7)
- Android Studio / VS Code
- Android Device (API 21+) or Emulator

### Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the app:**
    ```bash
    flutter run
    ```

---

## 🎨 Design System

All design tokens are centralized in `lib/theme/design_system.dart`.

- **Colors**: Modern dark theme with premium neon accents.
- **Typography**: **Inter** (via Google Fonts) for a clean, global aesthetic.
- **Layout**: Standardized spacing and radius tokens for visual consistency.

---

## 🌐 Localization

The app supports **Japanese (Default)** and **English**.
Translations are located in `lib/l10n/`. To update strings:
```bash
flutter gen-l10n
```

---

## 📄 License

This project is licensed under the **MIT License**. See the `LICENSE` file for details.
