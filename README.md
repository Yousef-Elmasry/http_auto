# http_auto

A powerful and lightweight Dart library designed to simplify HTTP requests in Flutter and Dart applications by automatically managing authentication tokens and handling token refresh seamlessly. Say goodbye to repetitive authentication code and focus on building amazing features!

---

## 🚀 Features

* **🔐 Automatic Token Management**: Access tokens are automatically attached to every request in the `Authorization` header
* **🔄 Smart Token Refresh**: Automatically refreshes expired tokens when receiving `401 Unauthorized` responses
* **🔁 Automatic Retry**: After refreshing tokens, the original request is automatically retried without any additional code
* **💾 Secure Storage**: Uses `flutter_secure_storage` to securely store tokens on the device
* **📡 Full HTTP Support**: Supports all common HTTP methods: `GET`, `POST`, `PUT`, `DELETE`
* **🎯 Flexible Configuration**: Customize request headers and body globally or per-request
* **📊 Event Callbacks**: Monitor token refresh lifecycle with `onRefreshStart`, `onRefreshSuccess`, and `onRefreshError` callbacks
* **🌐 URL Flexibility**: Supports both relative URLs (using base URL) and absolute URLs
* **🔧 JWT Support**: Includes JWT decoder utilities for token inspection
* **✨ Zero Boilerplate**: Reduces authentication-related code by up to 90%

---

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  http_auto: ^1.1.2
```

Then run:

```bash
flutter pub get
```

---

## ⚙️ Initialization

Before making any requests, initialize the library with your API configuration:

```dart
import 'package:http_auto/http_auto.dart';

Http.init(
  baseUrl: "https://api.example.com",
  refreshTokenURL: "/auth/refresh-token",
  accessToken: "YOUR_ACCESS_TOKEN",
  refreshToken: "YOUR_REFRESH_TOKEN",
  
  // Optional: Set default headers for all requests
  requestHeaders: {
    "Content-Type": "application/json",
    "x-client-type": "flutter",
    "x-app-version": "1.0.0",
  },
  
  // Optional: Set default body parameters for all requests
  requestBody: {
    "device_id": "device_unique_id",
  },
  
  // Optional: Callbacks for token refresh events
  onRefreshStart: () {
    print("Token refresh started...");
    // Show loading indicator
  },
  onRefreshSuccess: () {
    print("Token refreshed successfully!");
    // Hide loading indicator
  },
  onRefreshError: (error) {
    print("Token refresh failed: $error");
    // Navigate to login screen
  },
);
```

### Initialization Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `baseUrl` | `String` | ✅ Yes | The base URL of your API (e.g., "https://api.example.com") |
| `refreshTokenURL` | `String` | ✅ Yes | The endpoint path for refreshing tokens (e.g., "/auth/refresh-token") |
| `accessToken` | `String` | ✅ Yes | Your current access token |
| `refreshToken` | `String` | ✅ Yes | Your current refresh token |
| `requestHeaders` | `Map<String, String>?` | ❌ No | Default headers to include in all requests |
| `requestBody` | `Map<String, dynamic>?` | ❌ No | Default body parameters to include in all requests |
| `onRefreshStart` | `Function?` | ❌ No | Callback fired when token refresh starts |
| `onRefreshSuccess` | `Function?` | ❌ No | Callback fired when token refresh succeeds |
| `onRefreshError` | `Function(dynamic)?` | ❌ No | Callback fired when token refresh fails |

---

## 📡 Usage Examples

### GET Request

```dart
// Simple GET request
final response = await Http.get(url: "/users");

// GET request with custom headers
final response = await Http.get(
  url: "/users",
  headers: {
    "x-custom-header": "value",
  },
);

// GET request with absolute URL (bypasses baseUrl)
final response = await Http.get(url: "https://external-api.com/data");
```

### POST Request

```dart
// POST request with body
final response = await Http.post(
  url: "/login",
  body: {
    "email": "user@example.com",
    "password": "secure_password",
  },
);

// POST request with custom headers
final response = await Http.post(
  url: "/api/users",
  body: {
    "name": "John Doe",
    "email": "john@example.com",
  },
  headers: {
    "x-request-id": "unique-id",
  },
);
```

### PUT Request

```dart
// Update user profile
final response = await Http.put(
  url: "/profile",
  body: {
    "name": "Updated Name",
    "bio": "New bio text",
  },
);
```

### DELETE Request

```dart
// Delete resource
final response = await Http.delete(url: "/users/123");

// DELETE with optional body
final response = await Http.delete(
  url: "/users/123",
  body: {
    "reason": "User requested deletion",
  },
);
```

### Handling Responses

```dart
try {
  final response = await Http.get(url: "/users");
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print("Success: $data");
  } else {
    print("Error: ${response.statusCode}");
  }
} catch (e) {
  print("Exception: $e");
}
```

---

## 🔐 Token Management

### How Token Refresh Works

1. **Automatic Token Attachment**: Every request automatically includes `Authorization: Bearer {access_token}` header
2. **401 Detection**: When a request returns `401 Unauthorized`, the library detects token expiration
3. **Automatic Refresh**: The library calls your refresh token endpoint with the stored refresh token
4. **Token Update**: New access token is securely saved to storage
5. **Request Retry**: The original request is automatically retried with the new token
6. **Error Handling**: If refresh fails, the `onRefreshError` callback is triggered

### Manual Token Management

```dart
import 'package:http_auto/http_auto.dart';

// Save tokens manually
await write("new_access_token", "new_refresh_token");

// Get all tokens
final tokens = await getAll();
print("Access: ${tokens['access_token']}");
print("Refresh: ${tokens['refresh_token']}");

// Get specific token
final accessToken = await getValue('access_token');

// Clear all tokens (logout)
await clearAll();

// Delete specific token
await deleteValue('access_token');
```

### Token Storage

Tokens are stored securely using `flutter_secure_storage`, which uses:
- **iOS**: Keychain Services
- **Android**: EncryptedSharedPreferences with AES encryption
- **Web**: Encrypted cookies or localStorage

---

## 🎯 Advanced Features

### Custom Headers Per Request

```dart
final response = await Http.get(
  url: "/data",
  headers: {
    "x-custom-header": "value",
    "Accept": "application/xml",
  },
);
```

### Global Default Headers and Body

```dart
Http.init(
  baseUrl: "https://api.example.com",
  refreshTokenURL: "/auth/refresh",
  accessToken: "token",
  refreshToken: "refresh",
  
  // These will be added to ALL requests
  requestHeaders: {
    "x-app-version": "2.0.0",
    "x-platform": "mobile",
  },
  
  requestBody: {
    "timestamp": DateTime.now().toIso8601String(),
  },
);
```

### JWT Token Decoding

```dart
import 'package:jwt_decoder/jwt_decoder.dart';

final token = await getValue('access_token');
final decodedToken = JwtDecoder.decode(token);

print("Expires at: ${decodedToken.expirationDate}");
print("User ID: ${decodedToken['user_id']}");
print("Is expired: ${JwtDecoder.isExpired(token)}");
```

---

## 🔄 Token Refresh Flow Diagram

```
Request → Add Authorization Header → Send Request
                                    ↓
                            Response Received
                                    ↓
                        Status Code = 401?
                    ↙                    ↘
                No                      Yes
                ↓                        ↓
        Return Response      →  Call Refresh Endpoint
                                    ↓
                            Refresh Successful?
                        ↙                    ↘
                    Yes                      No
                    ↓                        ↓
            Save New Token          Trigger onRefreshError
                    ↓                        ↓
            Retry Original Request  →  Handle Error
                    ↓
            Return Response
```

---

## 🛠️ Best Practices

1. **Initialize Early**: Call `Http.init()` in your app's initialization (e.g., `main()` or `initState()`)
2. **Handle Errors**: Always wrap requests in try-catch blocks
3. **Use Callbacks**: Implement refresh callbacks to provide user feedback during token refresh
4. **Secure Storage**: Never store tokens in plain text or SharedPreferences
5. **Token Validation**: Use JWT decoder to check token expiration before making requests
6. **Error Handling**: Implement proper error handling for network failures and API errors

---

## 🧪 Testing

Use the `test/` folder to write unit tests for your package logic using the `test` package.

Example test:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http_auto/http_auto.dart';

void main() {
  test('Http initialization test', () {
    Http.init(
      baseUrl: "https://api.test.com",
      refreshTokenURL: "/refresh",
      accessToken: "test_token",
      refreshToken: "test_refresh",
    );
    
    expect(Http.baseUrl, "https://api.test.com");
  });
}
```

---

## 📄 License

This project is licensed under the MIT License.

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

---

## 📚 Additional Resources

- [Flutter Secure Storage Documentation](https://pub.dev/packages/flutter_secure_storage)
- [HTTP Package Documentation](https://pub.dev/packages/http)
- [JWT Decoder Documentation](https://pub.dev/packages/jwt_decoder)

---

# 🇸🇦 الوصف باللغة العربية

## http_auto

مكتبة Dart قوية وخفيفة الوزن مصممة لتبسيط طلبات HTTP في تطبيقات Flutter و Dart من خلال إدارة رموز المصادقة تلقائيًا والتعامل مع تحديث الرموز بسلاسة. وداعًا للكود المتكرر للمصادقة وركز على بناء الميزات الرائعة!

---

## 🚀 المميزات

* **🔐 إدارة تلقائية للرموز**: يتم إرفاق رموز الوصول تلقائيًا مع كل طلب في رأس `Authorization`
* **🔄 تحديث ذكي للرموز**: يقوم بتحديث الرموز المنتهية الصلاحية تلقائيًا عند استلام استجابة `401 Unauthorized`
* **🔁 إعادة المحاولة التلقائية**: بعد تحديث الرموز، يتم إعادة إرسال الطلب الأصلي تلقائيًا دون الحاجة لأي كود إضافي
* **💾 تخزين آمن**: يستخدم `flutter_secure_storage` لتخزين الرموز بشكل آمن على الجهاز
* **📡 دعم كامل لـ HTTP**: يدعم جميع طرق HTTP الشائعة: `GET` و `POST` و `PUT` و `DELETE`
* **🎯 تكوين مرن**: قم بتخصيص رؤوس الطلبات ونص الطلب بشكل عام أو لكل طلب
* **📊 استدعاءات الأحداث**: راقب دورة حياة تحديث الرمز باستخدام استدعاءات `onRefreshStart` و `onRefreshSuccess` و `onRefreshError`
* **🌐 مرونة في الروابط**: يدعم الروابط النسبية (باستخدام الرابط الأساسي) والروابط المطلقة
* **🔧 دعم JWT**: يتضمن أدوات فك تشفير JWT لفحص الرموز
* **✨ بدون كود متكرر**: يقلل من كود المصادقة بنسبة تصل إلى 90%

---

## 📦 التثبيت

أضف الحزمة إلى ملف `pubspec.yaml`:

```yaml
dependencies:
  http_auto: ^1.1.2
```

ثم قم بتشغيل:

```bash
flutter pub get
```

---

## ⚙️ التهيئة

قبل إجراء أي طلبات، قم بتهيئة المكتبة بإعدادات API الخاصة بك:

```dart
import 'package:http_auto/http_auto.dart';

Http.init(
  baseUrl: "https://api.example.com",
  refreshTokenURL: "/auth/refresh-token",
  accessToken: "YOUR_ACCESS_TOKEN",
  refreshToken: "YOUR_REFRESH_TOKEN",
  
  // اختياري: تعيين رؤوس افتراضية لجميع الطلبات
  requestHeaders: {
    "Content-Type": "application/json",
    "x-client-type": "flutter",
    "x-app-version": "1.0.0",
  },
  
  // اختياري: تعيين معاملات نص افتراضية لجميع الطلبات
  requestBody: {
    "device_id": "device_unique_id",
  },
  
  // اختياري: استدعاءات لأحداث تحديث الرمز
  onRefreshStart: () {
    print("بدأ تحديث الرمز...");
    // عرض مؤشر التحميل
  },
  onRefreshSuccess: () {
    print("تم تحديث الرمز بنجاح!");
    // إخفاء مؤشر التحميل
  },
  onRefreshError: (error) {
    print("فشل تحديث الرمز: $error");
    // الانتقال إلى شاشة تسجيل الدخول
  },
);
```

### معاملات التهيئة

| المعامل | النوع | مطلوب | الوصف |
|---------|------|-------|-------|
| `baseUrl` | `String` | ✅ نعم | الرابط الأساسي لـ API الخاص بك (مثال: "https://api.example.com") |
| `refreshTokenURL` | `String` | ✅ نعم | مسار نقطة النهاية لتحديث الرموز (مثال: "/auth/refresh-token") |
| `accessToken` | `String` | ✅ نعم | رمز الوصول الحالي |
| `refreshToken` | `String` | ✅ نعم | رمز التحديث الحالي |
| `requestHeaders` | `Map<String, String>?` | ❌ لا | رؤوس افتراضية لتضمينها في جميع الطلبات |
| `requestBody` | `Map<String, dynamic>?` | ❌ لا | معاملات نص افتراضية لتضمينها في جميع الطلبات |
| `onRefreshStart` | `Function?` | ❌ لا | استدعاء يتم تشغيله عند بدء تحديث الرمز |
| `onRefreshSuccess` | `Function?` | ❌ لا | استدعاء يتم تشغيله عند نجاح تحديث الرمز |
| `onRefreshError` | `Function(dynamic)?` | ❌ لا | استدعاء يتم تشغيله عند فشل تحديث الرمز |

---

## 📡 أمثلة الاستخدام

### طلب GET

```dart
// طلب GET بسيط
final response = await Http.get(url: "/users");

// طلب GET مع رؤوس مخصصة
final response = await Http.get(
  url: "/users",
  headers: {
    "x-custom-header": "value",
  },
);

// طلب GET مع رابط مطلق (يتجاوز baseUrl)
final response = await Http.get(url: "https://external-api.com/data");
```

### طلب POST

```dart
// طلب POST مع نص
final response = await Http.post(
  url: "/login",
  body: {
    "email": "user@example.com",
    "password": "secure_password",
  },
);

// طلب POST مع رؤوس مخصصة
final response = await Http.post(
  url: "/api/users",
  body: {
    "name": "أحمد محمد",
    "email": "ahmed@example.com",
  },
  headers: {
    "x-request-id": "unique-id",
  },
);
```

### طلب PUT

```dart
// تحديث ملف المستخدم الشخصي
final response = await Http.put(
  url: "/profile",
  body: {
    "name": "الاسم المحدث",
    "bio": "نص السيرة الذاتية الجديد",
  },
);
```

### طلب DELETE

```dart
// حذف مورد
final response = await Http.delete(url: "/users/123");

// DELETE مع نص اختياري
final response = await Http.delete(
  url: "/users/123",
  body: {
    "reason": "طلب المستخدم الحذف",
  },
);
```

### التعامل مع الاستجابات

```dart
try {
  final response = await Http.get(url: "/users");
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print("نجح: $data");
  } else {
    print("خطأ: ${response.statusCode}");
  }
} catch (e) {
  print("استثناء: $e");
}
```

---

## 🔐 إدارة الرموز

### كيف يعمل تحديث الرمز

1. **إرفاق الرمز تلقائيًا**: كل طلب يتضمن تلقائيًا رأس `Authorization: Bearer {access_token}`
2. **اكتشاف 401**: عندما يعيد الطلب `401 Unauthorized`، تكتشف المكتبة انتهاء صلاحية الرمز
3. **التحديث التلقائي**: تستدعي المكتبة نقطة نهاية تحديث الرمز مع رمز التحديث المخزن
4. **تحديث الرمز**: يتم حفظ رمز الوصول الجديد بشكل آمن في التخزين
5. **إعادة المحاولة**: يتم إعادة إرسال الطلب الأصلي تلقائيًا مع الرمز الجديد
6. **معالجة الأخطاء**: إذا فشل التحديث، يتم تشغيل استدعاء `onRefreshError`

### إدارة الرموز يدويًا

```dart
import 'package:http_auto/http_auto.dart';

// حفظ الرموز يدويًا
await write("new_access_token", "new_refresh_token");

// الحصول على جميع الرموز
final tokens = await getAll();
print("الوصول: ${tokens['access_token']}");
print("التحديث: ${tokens['refresh_token']}");

// الحصول على رمز محدد
final accessToken = await getValue('access_token');

// مسح جميع الرموز (تسجيل الخروج)
await clearAll();

// حذف رمز محدد
await deleteValue('access_token');
```

### تخزين الرموز

يتم تخزين الرموز بشكل آمن باستخدام `flutter_secure_storage`، والذي يستخدم:
- **iOS**: Keychain Services
- **Android**: EncryptedSharedPreferences مع تشفير AES
- **Web**: ملفات تعريف الارتباط المشفرة أو localStorage

---

## 🎯 الميزات المتقدمة

### رؤوس مخصصة لكل طلب

```dart
final response = await Http.get(
  url: "/data",
  headers: {
    "x-custom-header": "value",
    "Accept": "application/xml",
  },
);
```

### رؤوس ونص افتراضية عامة

```dart
Http.init(
  baseUrl: "https://api.example.com",
  refreshTokenURL: "/auth/refresh",
  accessToken: "token",
  refreshToken: "refresh",
  
  // سيتم إضافة هذه إلى جميع الطلبات
  requestHeaders: {
    "x-app-version": "2.0.0",
    "x-platform": "mobile",
  },
  
  requestBody: {
    "timestamp": DateTime.now().toIso8601String(),
  },
);
```

### فك تشفير رمز JWT

```dart
import 'package:jwt_decoder/jwt_decoder.dart';

final token = await getValue('access_token');
final decodedToken = JwtDecoder.decode(token);

print("ينتهي في: ${decodedToken.expirationDate}");
print("معرف المستخدم: ${decodedToken['user_id']}");
print("منتهي الصلاحية: ${JwtDecoder.isExpired(token)}");
```

---

## 🔄 مخطط تدفق تحديث الرمز

```
طلب → إضافة رأس Authorization → إرسال الطلب
                                    ↓
                            استلام الاستجابة
                                    ↓
                        رمز الحالة = 401؟
                    ↙                    ↘
                لا                      نعم
                ↓                        ↓
        إرجاع الاستجابة      →  استدعاء نقطة تحديث الرمز
                                    ↓
                            نجح التحديث؟
                        ↙                    ↘
                    نعم                      لا
                    ↓                        ↓
            حفظ الرمز الجديد          تشغيل onRefreshError
                    ↓                        ↓
            إعادة المحاولة للطلب الأصلي  →  معالجة الخطأ
                    ↓
            إرجاع الاستجابة
```

---

## 🛠️ أفضل الممارسات

1. **التهيئة المبكرة**: استدعِ `Http.init()` في تهيئة التطبيق (مثل `main()` أو `initState()`)
2. **معالجة الأخطاء**: دائمًا لف الطلبات في كتل try-catch
3. **استخدام الاستدعاءات**: نفذ استدعاءات التحديث لتوفير ملاحظات للمستخدم أثناء تحديث الرمز
4. **التخزين الآمن**: لا تخزن الرموز أبدًا كنص عادي أو في SharedPreferences
5. **التحقق من الرمز**: استخدم فك تشفير JWT للتحقق من انتهاء صلاحية الرمز قبل إجراء الطلبات
6. **معالجة الأخطاء**: نفذ معالجة مناسبة للأخطاء لفشل الشبكة وأخطاء API

---

## 🧪 الاختبارات

استخدم مجلد `test/` لكتابة اختبارات الوحدات البرمجية للمكتبة باستخدام حزمة `test`.

مثال على الاختبار:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http_auto/http_auto.dart';

void main() {
  test('اختبار تهيئة Http', () {
    Http.init(
      baseUrl: "https://api.test.com",
      refreshTokenURL: "/refresh",
      accessToken: "test_token",
      refreshToken: "test_refresh",
    );
    
    expect(Http.baseUrl, "https://api.test.com");
  });
}
```

---

## 📄 الرخصة

هذا المشروع مرخص بموجب رخصة MIT.

---

## 🤝 المساهمة

المساهمات مرحب بها! لا تتردد في فتح المشاكل أو إرسال طلبات السحب.

---

## 📚 موارد إضافية

- [وثائق Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [وثائق حزمة HTTP](https://pub.dev/packages/http)
- [وثائق JWT Decoder](https://pub.dev/packages/jwt_decoder)
