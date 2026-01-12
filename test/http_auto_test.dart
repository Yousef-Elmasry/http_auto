import 'package:flutter_test/flutter_test.dart';

import 'package:http_auto/http_auto.dart';

void main() {
  test('HttpAuto test', () {
    Http.init(
      baseUrl: "http:localhost:3000",
      refreshTokenURL: "http:localhost:3000/refresh-token",
      accessToken: "uwfhruiwegh8349ywehtg78ehwertgwh45",
      refreshToken: "ewfhruiwegh8349ywehtg78ehwertgwh45",
    );
    Http.get(url: "/data");
    expect(Http.baseUrl, "http:localhost:3000");
  });
}
