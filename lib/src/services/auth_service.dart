import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tripetrol_manage_app/src/utils/user_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final String _url = 'acaditecapibeta.azurewebsites.net';
  Future<Map<String, dynamic>> nuevoUsuario(
      String name, String email, String password) async {
    final url = Uri.https(_url, '/api/usuarios');
    final authData = {
      "Nombre": name,
      "email": email,
      "pass": password,
      "estado": true,
      "G_Sync": false
    };

    final resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('ok')) {
      return {'ok': true};
    } else {
      return {'ok': false};
    }
  }

  Future<Map<String, dynamic>> loginUsuario(
      String email, String password) async {
    final url = Uri.https(_url, '/api/auth/login');
    final authData = {
      "email": email,
      "pass": password,
    };
    final resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('token')) {
      int _idS;
      await UserSecureStorage.setIdUser(
          decodedResp['usuario']['id'].toString());
      await UserSecureStorage.setIdToken(decodedResp['token']);
      _idS = decodedResp['usuario']['ID_ROLE'];

      //print(decodedResp);
      await UserSecureStorage.setIdRole(jsonEncode(_idS));
      return {'ok': true, 'id_token': decodedResp['token']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['msg']};
    }
  }
}
