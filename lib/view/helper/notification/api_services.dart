import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart';

class ApiService {
  ApiService._();

  static ApiService apiService = ApiService._();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static const String baseUrl =
      'https://fcm.googleapis.com/v1/projects/chat-app-5384f/messages:send';

  Future<void> getServerToken() async {
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final privateKey = jsonEncode(appJson);
    final client = ServiceAccountCredentials.fromJson(privateKey);

    final servicesClient = await clientViaServiceAccount(client, scopes);

    final serverToken = servicesClient.credentials.accessToken.data;
    log("Server Token: \n $serverToken \n \n");
  }

  // onclick method call
  Future<void> sendMessage(String title, String body, String token) async {
    Map notification = {
      "message": {
        "token": token, //cloud
        "notification": {"title": title, "body": body},
        "data": {"response": "Message Done !"}
      }
    };

    final jsonNotification = jsonEncode(notification);

    try {
      var response = await http.post(Uri.parse(baseUrl),
          body: jsonNotification,
          headers: <String, String>{
            'Authorization': 'Bearer $serverKey',
            'Content-Type': 'application/json',
          });

      if (response.statusCode == 200) {
        log('Successfully sent message: ${response.body}');
      } else {
        log('Error sending message: ${response.body}');
      }
    } catch (e) {
      log("Api error:${e.toString()}");
    }
  }
}

String serverKey =
    'ya29.c.c0ASRK0GbvFwvcMJ_ixdsSKLEZO0KY9DfaO7RUjIIQJLAfkrUERpMxlW4RRb7Fpk2HFVZxv5uLqLmfWTO5oEJNLQgH3VRHC68aazRF2JDKhE74eBArlXXRPtyfxu7dlhf1sWxmp1pbo6EKXfnDL-EFON1V5kA56MlZ5XQHN94DrEvKBXLl90RPIOzHgUua1PYQkOCmNnVi9xgdf3CucPyOHaBhBObIp4X25AIWuBGSZIIi3xtuoF-zlbkmI_OGuA8tloexzxPfIuc5yDIWhOcjBCjtNWnMlW0CKFZLr_GSMpSzxL6DqAkWo8izvDQN0J7dmV6Q4kHTrEyiYwgnDCd729W078CBk4z316qfDQI6Ag2x4PsX_0JyALAG384AgwXf0V5ksI7Wgzwhk-hob9YoiBWzZnyfWeYMz6U21cb5OIROBVYWvdWj75rflwxBisQ645a-kSnIqmawIBOxyeYvY25iXn5_1R-6qufxOUm6eIcsSaw813BJr1I95i-oVlzSmB-lxvlo-I2IRy7YdOYBwnfi_eYlnlQVXxbR_577WkRu4oqr25Ic0QVxUtMOr_12dBm_eWwbZskxYwIe1altwhgxZbYtxdd83VUZm2uzsMq_vmRwB3IVhWbY3h9b_wrY-n521MamOtuXRw8Rp7wXmlScVlbFW2FupmR0t8kFr7lRk14o4gcbmI6enmxW2Z8xYIi3ysp3bapy_qmp0d2weecBq_icJWS_OF7but0401Q7eyQXl9Rkm3pQkRsc6Z3Junf3hwX8gR43FzwRWv3c5rdpIU1oWV7lfvt-sI-rj3Ixj3OnOXqsb4azXXhOYXazxbBd0Ux5uMd92epktS6jjfJaqBUJlo_6-x4Ww0QXBM4_FsizfYQ-5hv6Io8qwrVVyZxrqknhn2k3oigV-WcxzpOX7uy380VOn_grsQ88nswfOi3Mk-OOYVU5bdajog75BcbvB3-iO-04rywFZWVzav5sfoxSdSpcOt5Ql4oyfVQwjri3Q35hjMx';

final appJson = {
  "type": "service_account",
  "project_id": "chat-app-5384f",
  "private_key_id": "e40e7dabd9b457374d3c62e28d5994be75a7f6b6",
  "private_key":
      "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDjMMzXglQ9ACxL\nwa9+Br2IsEDZZt3ys6059+C1uZZUtHsqjTtbgwPu0Kp9h3jQqVk6/kHU9Yqz8l3j\nM0xi1XZoyIoZHfg7Ovtwk/RVedc9TbulLLKw9QE04NczLNqj7vqwgdz0JwIyns14\nFCfpUp1X/ksJNZpHTw73TXoNLy+TBqc1hKTkvP2TLtr6G2gOrRhJrYVMabXnMn9s\njhiwp46QqgylkB56NPMcRDwq5z33XNMe4uhgNX0VxRJIchhVe+HWTPZIij0WJRVz\nIzSW7HkOc1bS9WLNyKqmxt9rdZ7U9eMmK9PgyAK7W0OUsEknpqH4WR7CTdyc0arJ\nURx8NJHhAgMBAAECggEAAuXodwdOk8igyAacensTh97XtO4+/o2UNB0ZXLgVVtdG\nivBqRWySbEV1J0zHGcJPRRVhOZo4PrtkvzU0UD5w2D1WpaNgO0ExW+pHP5/iQwHu\n1tiPHvrBHS+RDzIPR/AQepftfZ/Rw1uLO3DmYW+QWkMAKgnpAefcRQNT/z8O2E1D\nRRWYH1Xdv47BPXfR+tpXO8y3lBzQbzMRvxnY7PJCQEQRqq6RnPHtEuDshFg/hxI2\nPnvmoVVpbiLWv9y/yU+IuC7Jokp3MMHTGRAeqyJuqq+V/B4DeGrxclk9QSLUC8Y1\ndpTtN+ugnhps44mK2lvY4ezSSO+Lm7PQA1mDVDoIEQKBgQD30MVaGhApiye6J5GS\nwh+FLgKbEICGj8qK3ejdtOmvnfbR7bUeR6kRrnRWQL5uao0N6y7wlS1JnlDRs06b\nccsAknGQMZAhhlScwMoqlTzvOvXlGFCA9PxoG0BTB0YlXyov/DfcnmrajnIy+ATY\ns1OKNwO6gKRyv4JR4k+lLaY2zwKBgQDqsaZszb2lDMX3G7TfgR/r3nBPpSFcqGZw\n1JaGEgoPK48dtBvUQClFn2ukm4hj+BGC2GevJakJ9YjN12+Ju3pdEJAf8Pmnb6gY\nRZKw0ZQKGJ5PhfmGdhGB197cgY6nNWlUmyKSj0W4Lm2pHvzGOe2o+SgBul1N7C+W\nZyad+GXYTwKBgHgseJeyDeZngfNnHtQBaVGnN0JFJV6bukfPRw7EnZI5UykIUg2G\nCLn3VJlDOlXHO/Hk+9VVMioCKQUYI+WDsELtwT6Amnl3b+64GxG9X1hPylC3ksqG\ngyRlGrNo0p5q4MV2VQyakgy8iSqoVYlUpQ1gkmFN4vF2Z1cYHTFnyrPHAoGBAOES\nUWpSvKaGY2uhlIoriPNotQiMcjwr+2IFXf1hW2hE+9EeovmgNnRgeJi518kXY6O5\n6WVclonIgNP24S6TLrwFYFJhhOp/+BKe1hjgRDqSdXAKKcw7enqtDTsmvCm63TKY\nPEWVROVnER95aiyn7TV5DFbr5QMPmGuCrNQeHX2dAoGATBRnU4TH8loaQCY5YMz4\nRK7r9U5+5+7sGg0xkjVrxynckrb7/NRb1KeflVTiGhgQsXilMt0eqgZ5Mc0poQUm\nW518VgPHNcCnM4eX0x4zfKtZcwCZtFETVV1r+6GT6wLXiBwEDIt8Dt+7u0WawD8b\nPgysFzDM7exdOUnwD9DxzfE=\n-----END PRIVATE KEY-----\n",
  "client_email":
      "firebase-adminsdk-jt5v7@chat-app-5384f.iam.gserviceaccount.com",
  "client_id": "110332302935930008900",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url":
      "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-jt5v7%40chat-app-5384f.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
};
