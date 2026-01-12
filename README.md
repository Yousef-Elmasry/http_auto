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

# 🇸🇦 الوصف بالعربي

## http_auto

مكتبة Dart خفيفة بتسهّل التعامل مع طلبات HTTP عن طريق إرسال التوكن تلقائيًا والتعامل مع انتهاء صلاحيته بشكل أوتوماتيكي.

---

## ✨ المميزات

* واجهة بسيطة ونظيفة للتعامل مع HTTP
* إرسال Access Token تلقائيًا مع كل طلب
* التعامل التلقائي مع Refresh Token عند انتهاء الجلسة
* دعم عمليات `GET` و `POST` و `PUT` و `DELETE`
* مناسبة لمشاريع Flutter و Dart

---

## ⚙️ التهيئة

لازم تهيّئ المكتبة قبل الاستخدام:

```dart
Http.init(
  baseUrl: "https://api.example.com",
  refreshTokenURL: "/auth/refresh-token",
  accessToken: "ACCESS_TOKEN",
  refreshToken: "REFRESH_TOKEN",
);
```

---

## 📡 أمثلة استخدام

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

## 🔐 إدارة التوكن

* التوكن بيتبعت تلقائي مع كل Request
* لو السيرفر رجّع `401`:

  * يتم طلب Refresh Token
  * حفظ التوكن الجديد
  * إعادة إرسال الطلب تلقائيًا

---

## 🧪 الاختبارات

استخدم فولدر `test/` لكتابة اختبارات للوحدات البرمجية الخاصة بالمكتبة.

---

## 📄 الرخصة

المشروع مرخّص تحت رخصة MIT.
