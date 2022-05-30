import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tripetrol_manage_app/src/models/cheque_model_creacion.dart';
import 'dart:convert';

import 'package:tripetrol_manage_app/src/utils/user_secure_storage.dart';

class ChequeCreateService extends ChangeNotifier {
  final String _url = 'acaditecapibeta.azurewebsites.net';
  Future<Map<String, dynamic>> crearCheque(ChequeModel cheque) async {
    final url = Uri.https(_url, '/api/cheques');
    final resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: chequeModelToJson(cheque));
    final decodedData = jsonDecode(resp.body);
    print(decodedData);
    if (decodedData.containsKey('ok')) {
      return {'ok': true};
    } else {
      return {'ok': false};
    }
  }

  Future<Map<String, dynamic>> aprobarCheque(int id) async {
    print(id);
    final url = Uri.https(_url, '/api/cheques/aprobado/$id');
    final _idUser = await UserSecureStorage.getIdUser();
    final _data = {
      "idAdmin": _idUser,
    };
    final resp = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(_data));

    final decodedData = jsonDecode(resp.body);
    print(decodedData);
    if (decodedData.containsKey('id')) {
      return {'ok': true};
    } else {
      return {'ok': false};
    }
  }

  Future<Map<String, dynamic>> anularCheque(int id) async {
    final url = Uri.http(_url, '/api/cheques/aprobado/$id');
    final _idUser = await UserSecureStorage.getIdUser();
    final _data = {
      "idAdmin": _idUser,
    };
    final resp = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(_data));

    final decodedData = jsonDecode(resp.body);
    print(decodedData);
    if (decodedData.containsKey('id')) {
      return {'ok': true};
    } else {
      return {'ok': false};
    }
  }
}
