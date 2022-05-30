// To parse this JSON data, do
//
//     final chequeModel = chequeModelFromJson(jsonString);

import 'dart:convert';

ChequeModel chequeModelFromJson(String str) => ChequeModel.fromJson(json.decode(str));

String chequeModelToJson(ChequeModel data) => json.encode(data.toJson());

class ChequeModel {

    int? noCheque;
    int? idAdmin;
    bool rural;
    double? importe;
    int? noGarrafas;
    int? fechaPeticion;
    String? camiones;
    
    ChequeModel({
        this.noCheque,
        this.idAdmin,
        this.rural = false,
        this.importe,
        this.noGarrafas=0,
        this.fechaPeticion,
        this.camiones,
    });

    factory ChequeModel.fromJson(Map<String, dynamic> json) => ChequeModel(
        noCheque: json["No_CHEQUE"],
        idAdmin: json["ID_ADMIN"],
        rural: json["RURAL"],
        importe: json["IMPORTE"].toDouble(),
        noGarrafas: json["No_GARRAFAS"],
        fechaPeticion: json["FECHA_PETICION"],
        camiones: json["camiones"],
    );

    Map<String, dynamic> toJson() => {
        "No_CHEQUE": noCheque,
        "ID_ADMIN": idAdmin,
        "RURAL": rural,
        "IMPORTE": importe,
        "No_GARRAFAS": noGarrafas,
        "FECHA_PETICION": fechaPeticion,
        "camiones": camiones
    };
}
