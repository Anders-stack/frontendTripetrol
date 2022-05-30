import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';
import 'package:tripetrol_manage_app/src/models/flujo_model.dart';
import 'package:tripetrol_manage_app/src/services/flujo_service.dart';
import 'package:tripetrol_manage_app/src/utils/user_secure_storage.dart';
import 'package:tripetrol_manage_app/src/utils/utils.dart';
import 'package:tripetrol_manage_app/src/widgets/header_icon.dart';
import 'package:tripetrol_manage_app/src/widgets/list_text_container.dart';
import 'package:tripetrol_manage_app/src/widgets/text_files.dart';

class SalidaScreen extends StatefulWidget {
  SalidaScreen({Key? key}) : super(key: key);

  @override
  _SalidaScreenState createState() => _SalidaScreenState();
}

class _SalidaScreenState extends State<SalidaScreen> {
  final formKey = GlobalKey<FormState>();

  late String _seleccionCamion;
  late int _idCamion;
  late String _numeroMatricula;
  late int _idConductor;
  late String _nombreCondutor;
  late double _valorUnitario;

  late List element;
  bool _saving = true;
  FlujoModel flujo = new FlujoModel();

  List camiones = [];
  final String _url = 'acaditecapibeta.azurewebsites.net';
  @override
  void initState() {
    super.initState();
    getPrecioUnit();
    getCamiones();
    //getConductores();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _crearFondo(context),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SafeArea(
                          child: Container(
                        height: 165.0,
                      )),
                      ListTextContainer(childrenLista: [
                        _selCamion(),
                      ]),
                      _noGarrafasLlenas(),
                      ListTextContainer(childrenLista: [
                        _nombreChofer(),
                        _noGarrafasVacias(),
                        _precioUnitario(),
                        _precioTotal(),
                      ]),
                      _botonFlujo(formKey)
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selCamion() {
    return SearchChoices.single(
      value: _seleccionCamion,
      hint: const Text('Seleccionar el # de placa'),
      items: camiones
          .map((list) => DropdownMenuItem(
                child: Text(list['MATRICULA']),
                value: list['MATRICULA'],
              ))
          .toList(),
      onChanged: (value) {
        element = camiones.where((map) => map['MATRICULA'] == value).toList();
        _idCamion = element[0]['ID'];
        _numeroMatricula = element[0]['MATRICULA'];
        _idConductor = element[0]['ID_CONDUCTOR'];
        _nombreCondutor = element[0]['Nombre'];
        setState(() {
          _seleccionCamion = value;
        });
      },
      isExpanded: true,
    );
  }

  Future getPrecioUnit() async {
    final url = Uri.https(_url, '/api/flujos/precio');

    var resp = await http.get(
      url,
    );

    final decodedData = jsonDecode(resp.body);
    setState(() {
      _valorUnitario = (decodedData[0]['VALOR_PRODUCTO']).toDouble();
    });

    print(decodedData);
  }

  Future getCamiones() async {
    final url = Uri.https(_url, '/api/flujos/camiones');

    var resp = await http.get(
      url,
    );

    final decodedData = jsonDecode(resp.body);
    setState(() {
      camiones = decodedData;
      _saving = false;
    });
    print(decodedData);
  }

  Widget _nombreChofer() {
    return ListTile(
      title: const Text('Nombre conductor:'),
      subtitle: _nombreCondutor == null ? Text('-') : Text('$_nombreCondutor'),
    );
  }

  Widget _precioUnitario() {
    return ListTile(
      title: const Text('Precio unitario:'),
      subtitle: Text(_valorUnitario.toString()),
    );
  }

  Widget _precioTotal() {
    return ListTile(
      title: const Text('Valor del producto:'),
      subtitle: flujo.garrafasLlenas == null
          ? Text('-')
          : Text((flujo.garrafasLlenas! * _valorUnitario).toString()),
    );
  }

  Widget _noGarrafasLlenas() {
    return TextTileForm(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      labelText: '# de Garrafas Llenas',
      hintText: '0000',
      onSaved: (value) => flujo.garrafasLlenas = int.parse(value!),
      validator: (value) {
        String valor = value ?? '';
        if (valor.isEmpty) {
          return 'Inserte algun valor';
        } else {
          final n = num.tryParse(valor);
          return (n == null) ? 'Ingrese un valor correcto' : null;
        }
      },
    );
  }

  Widget _noGarrafasVacias() {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(labelText: '# de Garrafas Vacias'),
      onSaved: (value) => flujo.garrafasVacias = int.parse(value!),
      validator: (value) {
        String valor = value ?? '';
        if (valor.isEmpty) {
          return 'Inserte algun valor';
        } else {
          final n = num.tryParse(valor);
          return (n == null) ? 'Ingrese un valor correcto' : null;
        }
      },
    );
  }

  Widget _botonFlujo(formKey) {
    return ElevatedButton(
      onPressed: () => {_submit(formKey)},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: const Text(
          'Guardar Salida',
        ),
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(10.0),
        shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
      ),
    );
  }

  void _submit(formKey) async {
    setState(() {
      _saving = true;
    });
    if (!formKey.currentState.validate()) {
      setState(() {
        _saving = false;
      });
      return;
    }
    formKey.currentState.save();
    flujo.fecha = DateTime.now().millisecondsSinceEpoch;
    
    final _idUser = await UserSecureStorage.getIdUser() ?? '0';
    flujo.idRamplista = _idUser;
    flujo.salida = true;
    flujo.idCamion = _idCamion;
    flujo.idConductor = _idConductor;
    flujo.valorProducto = flujo.garrafasLlenas! * _valorUnitario;
    final flujoService = 
      Provider.of<FlujoService>(context, listen: false);
    Map info = await flujoService.crearFlujo(flujo);
    if (info['ok']) {
      setState(() {
        _saving = false;
      });
      operacionExitosa(context, 'Salida registrada correctamente', 'home');
      //Navigator.pushNamed(context, 'home');
    } else {
      setState(() {
        _saving = false;
      });
      mostrarAlerta(context, 'Contactese con el administrador');
    }
  }

  _crearFondo(BuildContext context) {
    return const SmallIconHeader(
      icon: FontAwesomeIcons.users,
      titulo: 'Salida de Camion',
      color1: Color(0xff526bf6),
      color2: Color(0xff67acf2),
    );
  }
}
