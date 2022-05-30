// To parse this JSON data, do
//
//     final chequeModel = chequeModelFromJson(jsonString);

import 'dart:convert';

FlujoModel flujoModelFromJson(String str) =>
    FlujoModel.fromJson(json.decode(str));

String flujoModelToJson(FlujoModel data) => json.encode(data.toJson());

class FlujoModel {
  int? idRamplista;
  int? fecha;
  bool? salida;
  int? idCamion;
  int? idConductor;
  int? garrafasLlenas;
  int? garrafasVacias;
  double? valorProducto;

  FlujoModel(
      {this.idRamplista,
      this.fecha,
      this.salida,
      this.idCamion,
      this.idConductor,
      this.garrafasLlenas,
      this.garrafasVacias,
      this.valorProducto});

  factory FlujoModel.fromJson(Map<String, dynamic> json) => FlujoModel(
        idRamplista: json["ID_RAMPLISTA"],
        fecha: json["FECHA"],
        salida: json["SALIDA"],
        idCamion: json["ID_CAMION"],
        idConductor: json["ID_CONDUCTOR"],
        garrafasLlenas: json["GARRAFAS_LLENAS"],
        garrafasVacias: json["GARRAFAS_VACIAS"],
        valorProducto: json["VALOR_PRODUCTO"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "ID_RAMPLISTA": idRamplista,
        "FECHA": fecha,
        "SALIDA": salida,
        "ID_CAMION": idCamion,
        "ID_CONDUCTOR": idConductor,
        "GARRAFAS_LLENAS": garrafasLlenas,
        "GARRAFAS_VACIAS": garrafasVacias,
        "VALOR_PRODUCTO": valorProducto
      };
}
