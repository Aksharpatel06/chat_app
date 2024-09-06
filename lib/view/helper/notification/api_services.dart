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

String serverKey = '';

final appJson = {
  "type": "service_account",
  "project_id": "chat-app-5384f",
  "private_key_id": "71440bb653f45c35b399c329bcabdaba8786d888",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC4CK2eZ0pc6yxs\n+4Sn/LsLLSQVeMQUAnO97G7u/MQDdGLyAhIPVJiCate4f/QgCK8o2DuU6zrxfTkW\nbzHJSlReqTcmzTPqON417bnznNS9c5JvsmziKIRK0te9qubdhNJSOz8DWfg8+93A\nTyamKUmBgnYCLkiHie0ygGOAoIdvgln6eeXTIv489J8pqudlhE8ItcQZ+FDfpQBR\nK+mou/I5XjlMLH7EoLPratjJp2b8WsA1xn66z4xnQCqZwsmDGN78qzqJ3GXPM4Fq\nCfmzIcId2G0jmI4GF1zai/P/xkOYTdV9PF47nVxhlPUgV/chomfPkROFzWu16KeA\ns+kZmSujAgMBAAECggEADgiPYLxkpchDJ35Yg8zYYIZNMZv3a8UyGUH9xZidw9us\nreKtiOC9DnjiQU30ijrPTJCMnpL/eCnB4C2TgNN7soo5y+oq8snqW/doTiTf7iBx\ngrX66pYHXINOc0akezDlLuMYr4M9VD0qkD8Y5ePRGKCfqhPocPl6DndO3yCeo0iO\nfeyaUypTYMF9JMUY8kdarcwKEMk/tYXW9cxxoVS8Ps1Ryq8O/GaAZmlXAim4/yze\nyD1PWfk7FBDgdkzXqi2Mg7VGbAoV4a4zukZVr2M22VCr70538xl631TnkhVeZjZB\nBcULqyGgDoRgmPW2eXzV3MjsFXt4pDWImBTfdZ49TQKBgQD27wAu/RWlMBySwauq\nRrTfYIvkdsglXsZl65G7PuWWe8u6a5We51MqBv3uudGIej7AFzsKeR1w0WZTHOFj\nKOCDjX6GPvhHITGWOz/zDGli+gYcZI6ZqlHi98m0f8NbFU6EB86TlqIEeBtcj36P\nL484MPfJFMBX0hNEbanazW41HQKBgQC+yncdUym5gPqun98voPWM2QWJOpHBRe6W\nHMo8DQyNGC/hqm0KQXmndDQVZglKoAgtpzxOTz2eOJjVwz+1PSN/nKx62j7evI0h\nBabclWk9136MefdSJiraYP14SMSELqWB99iF96um/z/Ovshge2Uae5jcshREv/4E\n3VS3D47HvwKBgQDyMoljjShl1UKxTvQpFyDg17leZIL65HKEFQHjPlXBu7qfJlai\nfRG87w6xz+AMlJpnnmFybEjMFxbd/j2zHKzZWzb2RV0PpycTyxl2Mn5LbiAASUD0\nx3F5xMA6IfZiqAtSxLWBXQWcjJGJv9TKbEN1QdJHj+r4ODxdqZIn4cZuoQKBgG04\nIDo0WmVsVZVTxgNRBGCN+CJX2gqnSu66Knd4DOBUoUxxMJy3YLogxpQdZmJG/IeN\n/fLiX+bMhYmRjU3mYwTxnrdxap49mBj4UE5kZevWCgbG53MqkEuVTGToWz9EKNEf\nHd+LKcOeyVtEUhcRbI5dhOOKOholQnhsb8uf51+nAoGAFnQb8+s9IKLeSOGyEbQF\nxwkeZmqnzAtmUyJEQ++j3Cvo2q4X0pPply+EQFafVOpm+zoBOhV03QqNaGTCzACR\nGT9TfE7XJBxBEO+U9FmYMupmjBEKTKc4nS0lH3WzujUGAUipENzXqhAawGDoA2H1\n9CvijEWjYumrvKeg26/2uds=\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-jt5v7@chat-app-5384f.iam.gserviceaccount.com",
  "client_id": "110332302935930008900",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-jt5v7%40chat-app-5384f.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
};