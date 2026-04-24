# ユーザーアプリ (User App)

Figmaデザインをもとに構築されたFlutter製Androidモックアプリです。社内レビューおよびクライアント向けデモを目的としており、デジタルウォレット／決済体験をFigma仕様に忠実に再現しています。

> **注意：** 本アプリはモックアプリケーションです。バックエンドおよびサーバー連携は一切含まれていません。すべてのデータはローカルのダミーJSONアセットで管理されています。

---

## 目次

- [概要](#概要)
- [機能一覧](#機能一覧)
- [プロジェクト構成](#プロジェクト構成)
- [技術スタック・依存パッケージ](#技術スタック依存パッケージ)
- [セットアップ手順](#セットアップ手順)
- [画面・ナビゲーション](#画面ナビゲーション)
- [状態管理](#状態管理)
- [デザインシステム](#デザインシステム)
- [多言語対応](#多言語対応)
- [ダミーデータ](#ダミーデータ)
- [納品物](#納品物)

---

## 概要

| 項目 | 内容 |
|---|---|
| アプリ名 | user_app |
| バージョン | 1.0.0+1 |
| プラットフォーム | Android（iOS対応可能な構造） |
| フレームワーク | Flutter（Dart） |
| Dart SDK | ^3.10.7 |
| デフォルト言語 | 日本語 |
| バックエンド | なし（モック／ローカルデータのみ） |

---

## 機能一覧

- **認証**
  - メールアドレス＆パスワードによるログイン
  - 氏名・フリガナ・電話番号を含むユーザー登録
  - OTP（ワンタイムパスワード）認証
  - 生体認証（指紋／顔認証）— Android BiometricPrompt使用
  - パスコード認証
  - パスワード忘れ・再設定フロー

- **ホーム／ウォレット**
  - 残高表示（表示／非表示切り替え）
  - 残高更新アニメーション
  - 本人確認ステータスバナー

- **支払い**
  - カメラによるQRコードスキャンで決済開始
  - 支払い金額入力
  - ダミー決済処理・完了画面
  - 3Dセキュア画面（ダミーUI）

- **チャージ（残高追加）**
  - 銀行口座またはクレジットカードによるチャージ
  - 金額入力・処理中・完了画面

- **取引履歴**
  - 履歴一覧
  - 全履歴表示
  - 取引詳細画面

- **アカウント・プロフィール**
  - プロフィール画面（氏名・フリガナ・電話番号・メール）
  - アカウント情報画面
  - 事業者情報画面

- **支払い方法**
  - 銀行口座の登録
  - クレジットカードの登録

- **本人確認（KYC）**
  - 身分証明書カメラ撮影
  - セルフィー撮影
  - 顔撮影イントロ・撮影画面
  - アップロード完了画面

- **設定・セキュリティ**
  - 設定画面
  - セキュリティ画面（認証設定）
  - プライバシーポリシー画面
  - 利用規約画面

---

## プロジェクト構成

```
lib/
├── main.dart                  # アプリのエントリーポイント、ルーティング、テーマ設定
├── l10n/                      # 多言語対応（日本語／英語）
│   ├── app_localizations.dart
│   ├── app_localizations_en.dart
│   └── app_localizations_ja.dart
├── models/
│   ├── user.dart              # ユーザーデータモデル
│   └── transaction.dart       # 取引データモデル
├── providers/                 # 状態管理（Provider）
│   ├── auth_provider.dart
│   ├── payment_methods_provider.dart
│   ├── settings_provider.dart
│   └── verification_provider.dart
├── screens/                   # 全画面（画面一覧セクション参照）
├── services/
│   ├── auth_service.dart      # 認証ロジック（ダミー・ローカルのみ）
│   ├── biometric_service.dart # 生体認証ラッパー
│   └── camera_service.dart    # カメラユーティリティ
├── theme/
│   └── design_system.dart     # カラー・タイポグラフィ・寸法定義
└── widgets/                   # 再利用可能なUIコンポーネント
    ├── animated_success_indicator.dart
    ├── bottom_nav_bar.dart
    ├── loading_spinner.dart
    ├── nav_observer.dart
    └── number_keypad.dart

assets/
├── data/                      # ダミーJSONデータファイル
└── icons/                     # アプリアイコンアセット
```

---

## 技術スタック・依存パッケージ

### コア
| パッケージ | 用途 |
|---|---|
| `flutter` | UIフレームワーク |
| `flutter_localizations` | 多言語対応 |
| `provider ^6.0.0` | 状態管理 |

### デバイス機能
| パッケージ | 用途 |
|---|---|
| `local_auth ^2.1.0` | 生体認証（指紋／顔認証） |
| `camera ^0.10.5` | カメラ撮影（身分証明書・セルフィー） |
| `image_picker ^1.2.1` | ギャラリーからの画像選択 |
| `mobile_scanner ^7.0.0` | QRコードスキャン |

### UI・ユーティリティ
| パッケージ | 用途 |
|---|---|
| `google_fonts ^6.1.0` | Interフォント |
| `cupertino_icons ^1.0.8` | iOSスタイルアイコン |
| `lucide_icons_flutter ^3.1.10` | Lucideアイコンセット |
| `animated_checkmark ^3.1.0` | 成功アニメーションウィジェット |
| `intl ^0.20.2` | 日付・数値フォーマット、i18n |
| `path_provider ^2.1.0` | ファイルシステムパス |

### 開発用依存パッケージ
| パッケージ | 用途 |
|---|---|
| `build_runner ^2.4.0` | コード生成 |
| `json_serializable ^6.7.0` | JSONシリアライズ |
| `flutter_lints ^6.0.0` | Lintルール |

---

## セットアップ手順

### 前提条件

- Flutter SDK（Dart ^3.10.7 対応）
- Android Studio または VS Code（Flutter拡張機能インストール済み）
- Androidデバイスまたはエミュレーター（APIレベル21以上）
- 生体認証のテストには、指紋または顔認証が設定された実機が必要です

### インストール

```bash
# 1. リポジトリをクローン
git clone <repository-url>
cd "flutter app"

# 2. 依存パッケージをインストール
flutter pub get

# 3. 接続済みデバイスまたはエミュレーターで実行
flutter run
```

### APKビルド

```bash
flutter build apk --release
```

出力先：
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 画面・ナビゲーション

アプリはFlutterの`Navigator`と名前付きルートを使用しています。エントリーポイントは`SplashScreen`で、認証フローへ遷移します。

### 認証フロー
| ルート | 画面 |
|---|---|
| `/splash` | SplashScreen — 起動アニメーション |
| `/welcome` | WelcomeScreen — オンボーディング |
| `/login` | LoginScreen — ログイン |
| `/register` | RegisterScreen — 新規登録 |
| `/otp` | OTPScreen — 認証コード入力 |
| `/forgot-password` | ForgotPasswordScreen — パスワード忘れ |
| `/set-password` | SetPasswordScreen — パスワード設定 |
| `/password-reset-success` | PasswordResetSuccessScreen — リセット完了 |

### メインアプリ（ログイン後）
| ルート | 画面 |
|---|---|
| `/home` | AppRoot — ボトムナビゲーションシェル |
| `/charge` | ChargeScreen — チャージ |
| `/payment` | PaymentScreen — 支払い |
| `/history` | HistoryScreen — 履歴 |
| `/profile` | ProfileScreen — プロフィール |

### 支払い・チャージフロー
| ルート | 画面 |
|---|---|
| `/qr-scanner` | QRScannerScreen — QRスキャン |
| `/payment-amount` | PaymentAmountScreen — 支払い金額入力 |
| `/biometric-auth` | BiometricAuthScreen — 生体認証 |
| `/processing` | ProcessingScreen — 処理中 |
| `/payment-success` | PaymentSuccessScreen — 支払い完了 |
| `/charge-amount` | ChargeAmountScreen — チャージ金額入力 |
| `/charge-processing` | ChargeProcessingScreen — チャージ処理中 |
| `/charge-success` | ChargeSuccessScreen — チャージ完了 |
| `/three-d-secure` | ThreeDSecureScreen — 3Dセキュア |

### アカウント・設定
| ルート | 画面 |
|---|---|
| `/account-info` | AccountInfoScreen — アカウント情報 |
| `/settings` | SettingsScreen — 設定 |
| `/security` | SecurityScreen — セキュリティ |
| `/set-up-auth` | SetUpAuthenticationScreen — 認証設定 |
| `/passcode-auth` | PasscodeAuthScreen — パスコード認証 |
| `/privacy` | PrivacyPolicyScreen — プライバシーポリシー |
| `/terms` | TermsOfUseScreen — 利用規約 |

### 本人確認（KYC）
| ルート | 画面 |
|---|---|
| `/verification-camera` | IdDocumentCameraScreen — 身分証撮影 |
| `/selfie-capture` | SelfieCaptureScreen — セルフィー撮影 |
| `/upload-success` | UploadSuccessScreen — アップロード完了 |

### 支払い方法
| ルート | 画面 |
|---|---|
| `/register-bank` | RegisterBankAccountScreen — 銀行口座登録 |
| `/register-credit-card` | RegisterCreditCardScreen — クレジットカード登録 |

### その他
| ルート | 画面 |
|---|---|
| `/full-history` | FullHistoryScreen — 全取引履歴 |
| `/business-info` | BusinessInfoScreen — 事業者情報 |
| `/registration-success` | RegistrationSuccessScreen — 登録完了 |

---

## 状態管理

`provider`パッケージを使用し、5つの`ChangeNotifier`プロバイダーで構成されています。

| プロバイダー | 担当 |
|---|---|
| `AuthProvider` | ユーザー認証状態 |
| `TransactionProvider` | 残高および入出金履歴（リアルタイム更新対応） |
| `SettingsProvider` | アプリ設定（生体認証、パスコード等） |
| `PaymentMethodsProvider` | 支払い方法（銀行口座、カード） |
| `VerificationProvider` | 本人確認ステータス |

すべてのプロバイダーは`main.dart`の`MultiProvider`でルートに登録されています。

---

## デザインシステム

すべてのデザイントークンは`lib/theme/design_system.dart`で定義されています。

### カラー
| トークン | 値 | 用途 |
|---|---|---|
| `background` | `#030F1E` | メイン背景 |
| `surface` | `#0D1B2A` | カード・サーフェス |
| `surfaceLight` | `#1B263B` | 入力フィールド |
| `primaryBlue` | `#3A96FF` | プライマリボタン・アクセント |
| `neonBlue` | `#2EC5FF` | フォーカスボーダー・グロー |
| `textPrimary` | `#FFFFFF` | 見出し・本文 |
| `textSecondary` | `white38` | ヒント・ラベル |
| `success` | `#00E676` | 成功ステータス |
| `error` | `#FF4D4D` | エラーステータス |
| `warning` | `#FFAB00` | 警告ステータス |

### タイポグラフィ
フォント：**Inter**（Google Fonts経由）

| スタイル | サイズ | ウェイト |
|---|---|---|
| `headlineLarge` | 28px | Bold |
| `headlineMedium` | 22px | SemiBold |
| `bodyLarge` | 16px | Regular |
| `bodyMedium` | 14px | Regular |
| `labelSmall` | 12px | Medium |

### 余白・角丸
```
パディング:  S=8  M=16  L=24  XL=32
角丸:        S=8  M=12  L=24
```

---

## 多言語対応

アプリは**日本語（ja）**と**英語（en）**に対応しており、デフォルトは日本語です。

ローカライズファイルは`lib/l10n/`に格納されています：
- `app_localizations.dart` — ベースクラス
- `app_localizations_ja.dart` — 日本語文字列
- `app_localizations_en.dart` — 英語文字列

文字列の追加・更新を行う場合は該当ファイルを編集後、以下を実行してください：
```bash
flutter gen-l10n
```

---

## ダミーデータ

本アプリはモックのため、**実際のバックエンドやAPIは使用していません**。すべてのデータはシミュレーションです。

- **ユーザーデータ**：`assets/data/dummy_users.json`から読み込み
- **認証**：空でなければどのメールアドレス／パスワードの組み合わせでもログイン可能
- **OTP認証**：任意の6桁コードで認証成功
- **残高**：デフォルトのダミー残高 ¥10,000
- **生体認証**：デバイスの実際の生体認証ハードウェアを使用（実機が必要）
- **支払い・チャージ**：すべての処理は短いディレイでシミュレーション

### デフォルトテストアカウント
```
メールアドレス: user@example.com
パスワード:     password123
```

---

## 納品物

当初の契約に基づく本プロジェクトの納品物は以下の通りです：

- ✅ Android APK（リリースビルド）
- ✅ Flutterソースコード一式（本リポジトリ）
- ✅ READMEドキュメント（本ファイル）

> サーバー／API実装、認証バックエンド、API仕様書は**本プロジェクトのスコープに含まれません。**  
> 本アプリは社内レビューおよび提案用のモック開発です。