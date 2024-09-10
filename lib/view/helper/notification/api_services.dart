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

  Future<String> getServerToken() async {
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final privateKey = jsonEncode(appJson);
    final client = ServiceAccountCredentials.fromJson(privateKey);

    final servicesClient = await clientViaServiceAccount(client, scopes);

    String serverToken = servicesClient.credentials.accessToken.data;
    log("Server Token: \n $serverToken \n \n");
    return serverToken;
  }

  // onclick method call
  Future<void> sendMessage(String title, String body, String token) async {

    Map notification = {
      "message": {
        "token": token, // Use a valid FCM token here
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {"response": "Message Done !"}
      }
    };

    final jsonNotification = jsonEncode(notification);

    try {
      // String serverToken = getServerToken().toString();
      String serverToken =
          // 'ya29.a0AcM612zxzUJjOmpZFKh-EOVGj5sYJh5sJjGuJUqkxQ6OG0ZcsX2c8_fm8es8P78i-N32qh3lh1_uRtsTXNfiUtUXQMxiUSQ5J1qJg_xu9lzLMeiJIkD-NgsJ0T7YFqkTVqQUeGj9a6agnuyDO9nA4553u1bvFPKl-HuaBvjOaCgYKAbkSARESFQHGX2MiR2yCd3zKjc8-CSaYzLJWlg0175';
          'ya29.a0AcM612yOYUmywhry3Pjn0DqpEu1zss-eVTTmjLOB6nc5ehU6-8naGs6H_LiVeNEADyqxHC2ViFhZjm5PbScqs4ID7fdIWWDQFqlntdIG0Qa7oLT3jrV_9bHU92TvO5XwNOc_BOy7GUNppDsG8vdM5W23kZsG5RIGWU11gxl9aCgYKAaUSARESFQHGX2Mi-1zMt9gM9Lc6uQOSjPSpyg0175';
      log('$title----------------------------$body-------------$token');
      var response = await http.post(Uri.parse(baseUrl),
          body: jsonNotification,
          headers: <String, String>{
            'Authorization': 'Bearer $serverToken',
            'Content-Type': 'application/json',
          });

      if (response.statusCode == 200) {
        log('Successfully sent message: ${response.body}');
      } else {
        log('Error sending message: ${response.body}');
      }
    } catch (e) {
      log("Api error: ${e.toString()}");
    }
  }
}

String serverKey =
    'ya29.c.c0ASRK0GbvFwvcMJ_ixdsSKLEZO0KY9DfaO7RUjIIQJLAfkrUERpMxlW4RRb7Fpk2HFVZxv5uLqLmfWTO5oEJNLQgH3VRHC68aazRF2JDKhE74eBArlXXRPtyfxu7dlhf1sWxmp1pbo6EKXfnDL-EFON1V5kA56MlZ5XQHN94DrEvKBXLl90RPIOzHgUua1PYQkOCmNnVi9xgdf3CucPyOHaBhBObIp4X25AIWuBGSZIIi3xtuoF-zlbkmI_OGuA8tloexzxPfIuc5yDIWhOcjBCjtNWnMlW0CKFZLr_GSMpSzxL6DqAkWo8izvDQN0J7dmV6Q4kHTrEyiYwgnDCd729W078CBk4z316qfDQI6Ag2x4PsX_0JyALAG384AgwXf0V5ksI7Wgzwhk-hob9YoiBWzZnyfWeYMz6U21cb5OIROBVYWvdWj75rflwxBisQ645a-kSnIqmawIBOxyeYvY25iXn5_1R-6qufxOUm6eIcsSaw813BJr1I95i-oVlzSmB-lxvlo-I2IRy7YdOYBwnfi_eYlnlQVXxbR_577WkRu4oqr25Ic0QVxUtMOr_12dBm_eWwbZskxYwIe1altwhgxZbYtxdd83VUZm2uzsMq_vmRwB3IVhWbY3h9b_wrY-n521MamOtuXRw8Rp7wXmlScVlbFW2FupmR0t8kFr7lRk14o4gcbmI6enmxW2Z8xYIi3ysp3bapy_qmp0d2weecBq_icJWS_OF7but0401Q7eyQXl9Rkm3pQkRsc6Z3Junf3hwX8gR43FzwRWv3c5rdpIU1oWV7lfvt-sI-rj3Ixj3OnOXqsb4azXXhOYXazxbBd0Ux5uMd92epktS6jjfJaqBUJlo_6-x4Ww0QXBM4_FsizfYQ-5hv6Io8qwrVVyZxrqknhn2k3oigV-WcxzpOX7uy380VOn_grsQ88nswfOi3Mk-OOYVU5bdajog75BcbvB3-iO-04rywFZWVzav5sfoxSdSpcOt5Ql4oyfVQwjri3Q35hjMx';
final appJson = {
  "type": "service_account",
  "project_id": "chat-app-5384f",
  "private_key_id": "114a51d9a1289fbd0730e41b18ae8bf3c2816115",
  "private_key":
      "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCxWkQ06ysgtWLd\nXkbFvrWEyNb7uIZ3htk+YQXuqnDjVKmRNkgdgaCR5zaSN+B9C1KdopKvsDHUyVG4\nc2h5MYn8xYeROwyYbwiwHF7+SQiGNc5RLhc1jyVyKOQDkeQaV1n5/6M+84GoAtI1\nrSVARLx/1vsXe6yIe1lW470Bbcv9TiEE6NHxAu9tPqBV7Liz6kFj8xgTpfUmLYrk\newNel5Ud/h2mClgeox9V0f9ku37F5vjFOGgm7vRto4dXD5/kaGTpf72teCWKFXaQ\nPXHLORo7Ufdva8pV38IvbGRTbL2q5JVdtlkfg/72fdIsArH1n5gFgn3KcCnIqA47\n/AYUPM7BAgMBAAECggEACz540o4SVumJEhXXENRtd7SwBJeHVu6iuVS3ZpFBxPfq\nJD23xr8gKf/pss1+Gw9rtnjHKgJWtnHpD3OprP1aDT+Mv8VpoARyHZA+6YpB0xh4\nMydj605fBmTXR+6o8o6VMsdlVyljD/7VyvdmRDPXa5d6pdt+bcy8NkkMA5otc6q0\nYkTy+bQ4Kvf7N95MofXuka85Gf29io1h3Mlmy4YmJVXWQoIg9JRXsFkmVbB1monu\nx56Zr7OonbuPl/O9reL+mU6OoSYkC8NLLVYo0vMBdEeClAeMhgNseZmtF+xthN98\nm8kt6CF+wzSST1FCqYCwkakQx1kIZR/MhdUMD1TcbQKBgQDW0Vkn4TE7905hhbFM\neopFrqy2XKze69gfnxU7NcCRGYqA2Lalc3qwt8ZfxlbkdRJoxCgI2lL71ZmgMeE0\neW5zWqzsGCCfIyZSR9snzY9RbSaYMT84mCBTPG9ZHGFnnaWVDt5q9ymMjei3ZB+7\nGA5ZbOrZfAi3Pqzm3NcDySX+DwKBgQDTWju7pIotQc4Zu2ANI9ZernLhDfrHeBL5\npa6CqkqPO1lzvzGY/oBWLR6epJEhbp4jl/2/Fo3H1ZQkK/Am7X3jPsd8ZDBzXqg6\nu4RZ0Y8klybSTULmjAec+OTZVWMbUQT+gSHiXtsJ7qF0/QXmXjFPNboOYKcrrMe6\npfa+npQ2LwKBgCkKnDcDTi2/xQjayxHqg4pmofbBZAG/G26HLT4/uce/Englb1fS\n5UjoA41+zlEdkOPVPjTayWn12EED5pvo61I8q7b7sRfWVlb4BYXoPw52hR4kooiE\ngACHFlr3EiECvITq71GOYTDKWADZrzpGkU9CgOgGS3//CHefD7FYd9q/AoGBAKbB\nPvfh7pOeo/pxeGtlpzG0+jbPTNosxuvp6TJ3IbS44u8MHxnTU3aqysnolgmGuYbj\n2PT32o2c2fFgKW7NWtH9Km/erMuaF6mfYeFsEkCQcbTj+LDmMuuLBSTk1fkrh4E2\naYGtzaycdw9Sw2DrWIRio5XMdJllDYEaiQAFJnNJAoGAc4wovZVRQTi52+H7P6wm\nUML7/38WGNnsXVmtCUu4jVcqOqSCFR4Bc0tsm6f/wWYlKMpWuaNBJoRYQ2exO7ui\np7uKnzd9GjENPKpYvFuYVzG2iFFz5JM/Kj+vq5+qIbCTtYtav/q7W30HA1Y9DdLd\nuBcz73AwI/xXLNkMi9BU4Ls=\n-----END PRIVATE KEY-----\n",
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
