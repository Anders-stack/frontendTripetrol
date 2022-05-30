import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tripetrol_manage_app/src/models/traslado_model.dart';
import 'dart:convert';

import 'package:tripetrol_manage_app/src/utils/user_secure_storage.dart';

class TrasladoCreateService extends ChangeNotifier {
  final String _url = 'acaditecapibeta.azurewebsites.net';
  Future<Map<String, dynamic>> crearTraslado(TrasladoModel traslado) async {
    final url = Uri.https(_url, 'api/traslado');
    final resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: trasladoModelToJson(traslado));
    final decodedData = jsonDecode(resp.body);
    print(decodedData);
    if (decodedData.containsKey('ok')) {
      return {'ok': true};
    } else {
      return {'ok': false};
    }
  }

  Future<Map<String, dynamic>> updateTraslado(
      TrasladoModel traslado, int id) async {
    print(id);
    final url = Uri.https(_url, '/api/traslado/in');
    final _data = trasladoModelToJson(traslado);
    final _dataf = jsonDecode(_data);
    _dataf['ID'] = id;
    final resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(_dataf));

    final decodedData = jsonDecode(resp.body);
    print(decodedData);
    if (decodedData.containsKey('ok')) {
      return {'ok': true};
    } else {
      return {'ok': false};
    }
  }
}
