import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';
import 'package:tripetrol_manage_app/src/utils/utils.dart';
import 'package:tripetrol_manage_app/src/widgets/header_icon.dart';
import 'package:tripetrol_manage_app/src/widgets/list_text_container.dart';

class ValidarCajero extends StatefulWidget {
  ValidarCajero({Key? key}) : super(key: key);

  @override
  _ValidarCajeroState createState() => _ValidarCajeroState();
}

class _ValidarCajeroState extends State<ValidarCajero> {
  late int _idFlujo;
  late String _nombreRamplista;
  late bool _entradaSalida;
  late String _fechaFlujo;
  late String _matricula;
  late int _garrafasLLenas;
  late int _garrafasVacias;
  late double _valorDelProducto;
  List flujos = [];
  late List element;
  final String _url = 'acaditecapibeta.azurewebsites.net';
  @override
  void initState() {
    super.initState();
    getFlujos();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _crearFondo(context),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                    child: Container(
                  height: 180.0,
                )),
                ListTextContainer(childrenLista: [
                  _selFlujo(),
                  _nombreRampl(),
                  _salida(),
                  _matriculaCamion(),
                  _garraLLenas(),
                  _garraVacias(),
                  _importe(),
                ]),
                _botonValidar(),
                _botonAnular()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future getFlujos() async {
    final url = Uri.https(_url, '/api/flujos/peticionCa');

    var resp = await http.get(
      url,
    );

    final decodedData = jsonDecode(resp.body);
    //print(decodedData);
  }

  Widget _selFlujo() {
    return SearchChoices.single(
      value: _fechaFlujo,
      hint: const Text('Seleccionar la fecha de la transacion'),
      items: flujos
          .map((list) => DropdownMenuItem(
                child: Text(list['FECHA'].toString()),
                value: list['FECHA'].toString(),
              ))
          .toList(),
      onChanged: (value) {
        element = flujos.where((map) => map['FECHA'] == value).toList();
        _idFlujo = element[0]['ID'];
        _nombreRamplista = element[0]['Nombre'];
        _entradaSalida = element[0]['Salida'];
        _fechaFlujo = element[0]['FECHA'];
        _matricula = element[0]['MATRICULA'];
        _garrafasLLenas = element[0]['GARRAFAS_LLENAS'];
        _garrafasVacias = element[0]['GARRAFAS_VACIAS'];
        _valorDelProducto = element[0]['VALOR_PRODUCTO'].toDouble();
        setState(() {
          _fechaFlujo = value;
        });
      },
      isExpanded: true,
    );
  }

  _nombreRampl() {
    return ListTile(
      title: const Text('Nombre del Ramplista:'),
      subtitle:
          _nombreRamplista == null ? Text('-') : Text('$_nombreRamplista'),
    );
  }

  Widget _matriculaCamion() {
    return ListTile(
      title: Text('Matricula del Camion:'),
      subtitle: _matricula == null ? Text('-') : Text('$_matricula'),
    );
  }

  Widget _garraLLenas() {
    return ListTile(
      title: const Text('Garrafas Llenas:'),
      subtitle: _garrafasLLenas == null ? Text('-') : Text('$_garrafasLLenas'),
    );
  }

  Widget _garraVacias() {
    return ListTile(
      title: const Text('Garrafas Vacias:'),
      subtitle: _garrafasVacias == null ? Text('-') : Text('$_garrafasVacias'),
    );
  }

  Widget _importe() {
    return ListTile(
      title: const Text('Importe:'),
      subtitle:
          _valorDelProducto == null ? Text('-') : Text('$_valorDelProducto'),
    );
  }

  Widget _salida() {
    return ListTile(title: Text('Entrada / Salida:'), subtitle: _eS());
  }

  Widget _eS() {
    if (_entradaSalida == null) {
      return Text('-');
    } else if (_entradaSalida) {
      return Text('Entrada');
    } else {
      return const Text('Salida');
    }
  }

  Widget _botonValidar() {
    return ElevatedButton(
      onPressed: () {
        _validar(_idFlujo);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: const Text(
          'Validar',
        ),
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(10.0),
        shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
      ),
    );
  }

  Widget _botonAnular() {
    return ElevatedButton(
      onPressed: () {
        _anular(_idFlujo);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: const Text(
          'Anular',
        ),
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(10.0),
        shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
      ),
    );
  }

  _validar(int id) async {
    final _flujoService = Provider.of(context, listen: false);

    Map info = await _flujoService.aprobarCajero(id);

    if (info['ok']) {
      operacionExitosa(context, 'Validado', 'home');
      //Navigator.pushNamed(context, 'home');
    } else {
      mostrarAlerta(context, 'Contactese con el administrador');
    }
  }

  void _anular(int id) async {
    
    final _flujoService = Provider.of(context, listen: false);
    Map info = await _flujoService.anularCajero(id);

    if (info['ok']) {
      operacionExitosa(context, 'Anulado', 'home');
      //Navigator.pushNamed(context, 'home');
    } else {
      mostrarAlerta(context, 'Contactese con el administrador');
    }
  }

  _crearFondo(BuildContext context) {
    return const SmallIconHeader(
      icon: FontAwesomeIcons.fileSignature,
      titulo: 'Validacion de flujos Cajero',
      color1: Color(0xff526bf6),
      color2: Color(0xff67acf2),
    );
  }
}
