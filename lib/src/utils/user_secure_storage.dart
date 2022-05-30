import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyIdUser = 'idUser';
  static const _keyIdToken = 'idToken';
  static const _keyIdRole = 'idRole';

  static setIdUser(String idUser) async =>
      await _storage.write(key: _keyIdUser, value: idUser);
  static getIdUser() async => await _storage.read(key: _keyIdUser);

  static setIdToken(String idUser) async =>
      await _storage.write(key: _keyIdToken, value: idUser);
  static getIdToken() async => await _storage.read(key: _keyIdToken);
  
  static setIdRole(String idUser) async =>
      await _storage.write(key: _keyIdRole, value: idUser);
  static getIdRole() async => await _storage.read(key: _keyIdRole);
}
