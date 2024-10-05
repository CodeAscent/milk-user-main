import 'dart:convert';

import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/params.dart';
import 'package:water/Utils/urls.dart';

class HttpWrapper {
  static d.Dio dio = new d.Dio();

  static Future<String?> token() async {
    String? token = appState.apiToken;
    return token;
  }

 static Map<String, String> headers = {
      "api-token": appState.apiToken,
      "content-type": "application/json"
    };

  //   : {'content-type': 'application/json', 'Authorization': 'Bearer $token'};

  static getRequest(String value) async {
    try {
      final url = Urls.baseUrl + value;
      final res = await http.get(Uri.parse(url), headers: headers);
      
      return res;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> postRequest(String value, Object? body) async {
    try {
      Logger().w(body);
      final Uri url = Uri.parse(Urls.baseUrl + value);
      final res =
          await http.post(url, body: jsonEncode(body), headers:  headers);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  static Widget networkImageRequest(String src) {
    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          src,
          //   fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/icons/image 15.png',
            fit: BoxFit.cover,
          ),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
