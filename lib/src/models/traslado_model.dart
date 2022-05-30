// To parse this JSON data, do
//
//     final trasladoModel = trasladoModelFromJson(jsonString);

import 'dart:convert';

TrasladoModel trasladoModelFromJson(String str) =>
    TrasladoModel.fromJson(json.decode(str));

String trasladoModelToJson(TrasladoModel data) => json.encode(data.toJson());

class TrasladoModel {
  TrasladoModel({
    this.idOperador,
    this.rol,
    this.noCamion,
    this.idConductor,
    this.placa,
    this.propietario,
    this.cargaGarrafas,
    this.cargaRetorno,
    this.perdidas,
    this.entrada = true,
    this.fechaEntrada,
    this.idCheque,
  });

  int? idOperador;
  int? rol;
  int? noCamion;
  int? idConductor;
  String? placa;
  String? propietario;
  int? cargaGarrafas;
  int? cargaRetorno;
  int? perdidas;
  bool? entrada;
  int? fechaEntrada;
  int? idCheque;

  factory TrasladoModel.fromJson(Map<String, dynamic> json) => TrasladoModel(
        idOperador: json["ID_OPERADOR"],
        rol: json["ROL"],
        noCamion: json["NO_CAMION"],
        idConductor: json["ID_CONDUCTOR"],
        placa: json["PLACA"],
        propietario: json["PROPIETARIO"],
        cargaGarrafas: json["CARGA_GARRAFAS"],
        cargaRetorno: json["CARGA_RETORNO"],
        perdidas: json["PERDIDAS"],
        entrada: json["ENTRADA"],
        fechaEntrada: json["FECHA_ENTRADA"],
        idCheque: json["id_cheque"],
      );

  Map<String, dynamic> toJson() => {
        "ID_OPERADOR": idOperador,
        "ROL": rol,
        "NO_CAMION": noCamion,
        "ID_CONDUCTOR": idConductor,
        "PLACA": placa,
        "PROPIETARIO": propietario,
        "CARGA_GARRAFAS": cargaGarrafas,
        "CARGA_RETORNO": cargaRetorno,
        "PERDIDAS": perdidas,
        "ENTRADA": entrada,
        "FECHA_ENTRADA": fechaEntrada,
        "id_cheque": idCheque,
      };
}
