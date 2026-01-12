# http_auto

A lightweight Dart library that simplifies HTTP requests by automatically attaching authentication tokens and handling token refresh when they expire.

---

## 🚀 Features

* Simple and clean API for HTTP requests
* Automatic attachment of access tokens
* Built-in refresh token handling on `401 Unauthorized`
* Supports common HTTP methods: `GET`, `POST`, `PUT`, `DELETE`
* Designed to work smoothly with Flutter and Dart projects

---

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  http_auto: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## ⚙️ Initialization

Before making any requests, initialize the library:

```dart
Http.init(
  baseUrl: "https://api.example.com",
  refreshTokenURL: "/auth/refresh-token",
  accessToken: "YOUR_ACCESS_TOKEN",
  refreshToken: "YOUR_REFRESH_TOKEN",
);
```

---

## 📡 Usage Examples

### GET Request

```dart
final response = await Http.get(url: "/users");
```

### POST Request

```dart
final response = await Http.post(
  url: "/login",
  body: {
    "email": "test@example.com",
    "password": "123456",
  },
);
```

### PUT Request

```dart
final response = await Http.put(
  url: "/profile",
  body: {
    "name": "Ahmed",
  },
);
```

### DELETE Request

```dart
final response = await Http.delete(url: "/account");
```

---

## 🔐 Token Handling

* The access token is automatically sent with every request
* If a request returns `401 Unauthorized`, the library:

  1. Calls the refresh token endpoint
  2. Saves the new tokens
  3. Retries the original request automatically

---

## 🧪 Testing

Use the `test/` folder to write unit tests for your package logic using the `test` package.

---

## 📄 License

This project is licensed under the MIT License.

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

---

# 🇸🇦 الوصف باللغة العربية

## http_auto

مكتبة Dart خفيفة تسهل التعامل مع طلبات HTTP عن طريق إرسال رمز الوصول (Token) تلقائيًا ومعالجة انتهاء صلاحيته بشكل آلي.

---

## ✨ المميزات

* واجهة برمجية بسيطة ونظيفة للتعامل مع HTTP
* إرسال رمز الوصول (Access Token) تلقائيًا مع كل طلب
* معالجة تلقائية لرمز التجديد (Refresh Token) عند انتهاء الجلسة
* دعم لعمليات `GET` و `POST` و `PUT` و `DELETE`
* مناسبة لمشاريع Flutter و Dart

---

## ⚙️ التهيئة

يجب تهيئة المكتبة قبل الاستخدام:

```dart
Http.init(
  baseUrl: "https://api.example.com",
  refreshTokenURL: "/auth/refresh-token",
  accessToken: "ACCESS_TOKEN",
  refreshToken: "REFRESH_TOKEN",
);
```

---

## 📡 أمثلة الاستخدام

### GET

```dart
await Http.get(url: "/users");
```

### POST

```dart
await Http.post(
  url: "/login",
  body: {
    "email": "test@example.com",
    "password": "123456",
  },
);
```

---

## 🔐 إدارة الرموز (Tokens)

* يتم إرسال الرمز تلقائيًا مع كل طلب
* إذا أعاد الخادم الرمز `401`:

  * يتم طلب رمز التجديد (Refresh Token)
  * حفظ الرمز الجديد
  * إعادة إرسال الطلب الأصلي تلقائيًا

---

## 🧪 الاختبارات

استخدم المجلد `test/` لكتابة اختبارات للوحدات البرمجية الخاصة بالمكتبة.

---

## 📄 الرخصة

المشروع مرخص بموجب رخصة MIT.
