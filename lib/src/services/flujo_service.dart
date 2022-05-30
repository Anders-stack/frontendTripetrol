import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tripetrol_manage_app/src/models/flujo_model.dart';
import 'package:tripetrol_manage_app/src/utils/user_secure_storage.dart';

class FlujoService extends ChangeNotifier {
  final String _url = 'acaditecapibeta.azurewebsites.net';
  Future<Map<String, dynamic>> crearFlujo(FlujoModel flujo) async {
    final url = Uri.https(_url, '/api/flujos/');

    final resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: flujoModelToJson(flujo));

    final decodedData = jsonDecode(resp.body);
    print(decodedData);
    if (decodedData.containsKey('ok')) {
      return {'ok': true};
    } else {
      return {'ok': false};
    }
  }

  Future<Map<String, dynamic>> aprobarConductor(int id) async {
    print(id);
    final url = Uri.https(_url, '/api/flujos/aprobadoConductor/$id');

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
    if (decodedData['ok']) {
      return {'ok': true};
    } else {
      return {'ok': false};
    }
  }

  Future<Map<String, dynamic>> anularConductor(int id) async {
    final url = Uri.http(_url, '/api/flujos/rechazoConductor/$id');
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
    if (decodedData['ok']) {
      return {'ok': true};
    } else {
      return {'ok': false};
    }
  }
    Future<Map<String, dynamic>> aprobarCajero(int id) async {
    print(id);
    final url = Uri.https(_url, '/api/flujos/aprobadoCajero/$id');
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
    if (decodedData['ok']) {
      return {'ok': true};
    } else {
      return {'ok': false};
    }
  }

  Future<Map<String, dynamic>> anularCajero(int id) async {
    final url = Uri.https(_url, '/api/flujos/rechazoCajero/$id');
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
    if (decodedData['ok']) {
      return {'ok': true};
    } else {
      return {'ok': false};
    }
  }
}
