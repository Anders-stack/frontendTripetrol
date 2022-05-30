import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';
import 'package:tripetrol_manage_app/src/models/traslado_model.dart';
import 'package:tripetrol_manage_app/src/services/traslado_service.dart';
import 'package:tripetrol_manage_app/src/utils/user_secure_storage.dart';
import 'package:tripetrol_manage_app/src/widgets/header_icon.dart';
import 'package:tripetrol_manage_app/src/widgets/list_text_container.dart';

class TrasladoOutScreen extends StatefulWidget {
  TrasladoOutScreen({Key? key}) : super(key: key);

  final String _url = 'acaditecapibeta.azurewebsites.net';
  @override
  State<TrasladoOutScreen> createState() => _TrasladoOutScreenState();
}

class _TrasladoOutScreenState extends State<TrasladoOutScreen> {
  final formKey = GlobalKey<FormState>();
  TrasladoModel trasladoOut = TrasladoModel();
  final String _url = 'acaditecapibeta.azurewebsites.net';
  final List lista = [];
  final TextEditingController _noCamionController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _propietarioController = TextEditingController();
  final TextEditingController _noGarrafasController = TextEditingController();

  Map selectedItem = {};
  String? selectedVal;
  List<DropdownMenuItem<dynamic>>? camionesSearch = [];
  @override
  void initState() {
    super.initState();
    initUsuario(trasladoOut);
    getCamiones(_url, lista)
        .then((value) => setState((() => camionesSearch = value
            .map<DropdownMenuItem>((item) => DropdownMenuItem(
                  child: Text('Camion No ' +
                      item['Camion'].toString() +
                      ' con cheque No' +
                      item['No_CHEQUE'].toString()),
                  value: item,
                ))
            .toList())));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        _crearFondo(context),
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    SafeArea(
                        child: Container(
                      height: 145.0,
                    )),
                    //_selecionCamion(camiones, selCamiones, context, setState),
                    SearchChoices.single(
                        value: selectedVal,
                        hint: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text("Seleccionar camion"),
                        ),
                        searchHint: "Seleccionar camion",
                        items: camionesSearch,
                        onChanged: (value) async {
                          setState(() {
                            _noCamionController.value = _noCamionController
                                .value
                                .copyWith(text: value['Camion']);
                            trasladoOut.noCamion = int.parse(value['Camion']);
                            trasladoOut.idCheque = value['ID'];
                            getCamion(_url, value['Camion']).then((resp) {
                              trasladoOut.placa = resp['MATRICULA'];
                              _placaController.value = _placaController.value
                                  .copyWith(text: resp['MATRICULA']);
                              trasladoOut.propietario = resp['Propietario'];
                              _propietarioController.value =
                                  _propietarioController.value
                                      .copyWith(text: resp['Propietario']);

                              trasladoOut.idConductor = resp['ID_PROP'];
                            });
                          });
                        },
                        isExpanded: true),
                    ListTextContainer(childrenLista: [
                      _noCamion(trasladoOut, _noCamionController),
                      _placa(trasladoOut, _placaController),
                      _propietario(trasladoOut, _propietarioController),
                      _noGarrafas(trasladoOut, _noGarrafasController),
                      _botonTraslado(trasladoOut, formKey, context)
                    ])
                  ],
                )),
          ),
        ),
      ]),
    );
  }
}

Future getCamiones(_url, lista) async {
  final url = Uri.https(_url, '/api/cheques/peticiones');
  var resp = await http.get(
    url,
  );
  final decodedData = jsonDecode(resp.body);
  decodedData.forEach((e) => (e['camiones'].split("-").forEach((i) {
        lista.add({
          'No_CHEQUE': e['No_Cheque'],
          'ID': e['ID'],
          'Fecha': e['FECHA_PETICION'],
          'Camion': i
        });
      })));
  return lista;
}

Future getCamion(_url, id) async {
  final url = Uri.https(_url, '/api/camiones');
  var resp = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({'id': id}));

  final decodedData = jsonDecode(resp.body);
  return decodedData;
}

Future initUsuario(traslado) async {
  final rol = await UserSecureStorage.getIdRole() ?? '';
  traslado.rol = int.parse(rol);
  final user = await UserSecureStorage.getIdUser() ?? '';
  traslado.idOperador = int.parse(user);
}

Widget _noCamion(trasladoOut, _noCamionController) {
  return TextFormField(
    controller: _noCamionController,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: const InputDecoration(
        labelText: 'Numero de camion',
        labelStyle: TextStyle(color: Colors.black),
        fillColor: Colors.grey,
        filled: true),
    onSaved: (value) => trasladoOut.noCamion = int.parse(value!),
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

Widget _placa(trasladoOut, _controller) {
  return TextFormField(
    controller: _controller,
    decoration: const InputDecoration(
        labelText: 'Placa',
        labelStyle: TextStyle(color: Colors.black),
        fillColor: Colors.grey,
        filled: true),
    onSaved: (value) => trasladoOut.placa = value,
    validator: (value) {
      String valor = value ?? '';
      if (valor.isEmpty) {
        return 'Inserte algun valor';
      }
    },
  );
}

Widget _propietario(trasladoOut, _controller) {
  return TextFormField(
    controller: _controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: const InputDecoration(
        labelText: 'Propietario',
        labelStyle: TextStyle(color: Colors.black),
        fillColor: Colors.grey,
        filled: true),
    onSaved: (value) => trasladoOut.propietario = value,
    validator: (value) {
      String valor = value ?? '';
      if (valor.isEmpty) {
        return 'Inserte algun valor';
      }
    },
  );
}

Widget _noGarrafas(trasladoOut, _controller) {
  return TextFormField(
    controller: _controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: const InputDecoration(
        labelText: 'Carga de garrafas',
        labelStyle: TextStyle(color: Colors.black),
        fillColor: Colors.blueAccent,
        filled: true),
    onSaved: (value) => trasladoOut.cargaGarrafas = int.parse(value!),
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

Widget _botonTraslado(trasladoOut, formKey, context) {
  return ElevatedButton(
    onPressed: () {
      _submit(trasladoOut, formKey, context);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: const Text(
        'Ingresar',
      ),
    ),
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(10.0),
      shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
    ),
  );
}

void _submit(trasladoOut, formKey, context) async {
  if (!formKey.currentState.validate()) {
    return;
  }
  formKey.currentState.save();

  final trasladoCreationService =
      Provider.of<TrasladoCreateService>(context, listen: false);
  Map info = await trasladoCreationService.crearTraslado(trasladoOut);
  if (info['ok']) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Informacion Correcta'),
            content: const Text('Peticion de Cheque guardada exitosamente'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pushNamed(context, 'home'),
                  child: const Text('ok'))
            ],
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Informacion incorrecta'),
            content: const Text('Contactese con el administrador'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('ok'))
            ],
          );
        });
  }
}

_crearFondo(BuildContext context) {
  return const SmallIconHeader(
    icon: FontAwesomeIcons.users,
    titulo: 'Creacion Cheques',
    color1: Color(0xff526bf6),
    color2: Color(0xff67acf2),
  );
}
