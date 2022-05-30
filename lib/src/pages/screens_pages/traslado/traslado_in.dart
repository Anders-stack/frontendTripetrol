import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';
import 'package:tripetrol_manage_app/src/models/traslado_model.dart';
import 'package:tripetrol_manage_app/src/services/traslado_service.dart';
import 'package:tripetrol_manage_app/src/utils/user_secure_storage.dart';
import 'package:tripetrol_manage_app/src/widgets/header_icon.dart';
import 'package:tripetrol_manage_app/src/widgets/list_text_container.dart';

class TrasladoInScreen extends StatefulWidget {
  TrasladoInScreen({Key? key}) : super(key: key);

  @override
  State<TrasladoInScreen> createState() => _TrasladoInScreenState();
}

class _TrasladoInScreenState extends State<TrasladoInScreen> {
  final formKey = GlobalKey<FormState>();
  TrasladoModel trasladoIn = TrasladoModel();
  final String _url = 'acaditecapibeta.azurewebsites.net';
  final List lista = [];
  int? id;
  final TextEditingController _noCamionController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _propietarioController = TextEditingController();
  final TextEditingController _noGarrafasController = TextEditingController();
  final TextEditingController _noGarrafasInController = TextEditingController();
  Map selectedItem = {};
  List<DropdownMenuItem<dynamic>>? camionesSearch = [];
  String? selectedVal;
  @override
  @override
  void initState() {
    super.initState();

    initUsuario(trasladoIn);
    getPeticiones(_url, lista)
        .then((value) => setState((() => camionesSearch = value
            .map<DropdownMenuItem>((item) => DropdownMenuItem(
                  child: Text('Camion No ' +
                      item['NO_CAMION'].toString() +
                      ' con orden ' +
                      item['id'].toString()),
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
                        onChanged: (e) {
                          print(e['CARGA_GARRAFAS']);
                          _noCamionController.value = _noCamionController.value
                              .copyWith(text: e['NO_CAMION'].toString());
                          trasladoIn.noCamion = e['NO_CAMION'];
                          id = e['id'];
                          trasladoIn.placa = e['PLACA'];
                          _placaController.value =
                              _placaController.value.copyWith(text: e['PLACA']);
                          trasladoIn.propietario = e['PROPIETARIO'];
                          _propietarioController.value = _propietarioController
                              .value
                              .copyWith(text: e['PROPIETARIO']);
                          trasladoIn.cargaGarrafas = e['CARGA_GARRAFAS'];
                          _noGarrafasController.value = _noGarrafasController
                              .value
                              .copyWith(text: e['CARGA_GARRAFAS'].toString());
                          trasladoIn.cargaRetorno = e['CARGA_GARRAFAS'];
                          _noGarrafasInController.value =
                              _noGarrafasInController.value.copyWith(
                                  text: e['CARGA_GARRAFAS'].toString());

                          trasladoIn.idConductor = e['ID_CONDUCTOR'];
                          trasladoIn.entrada = false;
                          setState(() {});
                        },
                        isExpanded: true),
                    ListTextContainer(childrenLista: [
                      _noCamion(trasladoIn, _noCamionController),
                      _placa(trasladoIn, _placaController),
                      _propietario(trasladoIn, _propietarioController),
                      _noGarrafas(trasladoIn, _noGarrafasController),
                      _noGarrafasIn(trasladoIn, _noGarrafasInController),
                      _noPerdidas(trasladoIn),
                      _botonTraslado(trasladoIn, formKey, context, id)
                    ])
                  ],
                )),
          ),
        ),
      ]),
    );
  }
}

Future getPeticiones(_url, lista) async {
  final url = Uri.https(_url, '/api/traslado/peticiones');
  var resp = await http.get(
    url,
  );
  final decodedData = jsonDecode(resp.body);
  return decodedData['traslado'];
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

Widget _placa(trasladoOut, _placaController) {
  return TextFormField(
    controller: _placaController,
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
        fillColor: Colors.grey,
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

Widget _noGarrafasIn(trasladoOut, _controller) {
  return TextFormField(
    controller: _controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: const InputDecoration(
        labelText: 'Carga de Retorno',
        labelStyle: TextStyle(color: Colors.black),
        fillColor: Colors.blueAccent,
        filled: true),
    onSaved: (value) => trasladoOut.cargaRetorno = int.parse(value!),
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

Widget _noPerdidas(trasladoOut) {
  return TextFormField(
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: const InputDecoration(
        labelText: 'Carga de garrafas',
        labelStyle: TextStyle(color: Colors.black),
        fillColor: Colors.blueAccent,
        filled: true),
    initialValue: '0',
    onSaved: (value) => trasladoOut.perdidas = int.parse(value!),
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

Widget _botonTraslado(trasladoOut, formKey, context, id) {
  return ElevatedButton(
    onPressed: () {
      _submit(trasladoOut, formKey, context, id);
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

void _submit(trasladoOut, formKey, context, id) async {
  if (!formKey.currentState.validate()) {
    return;
  }
  formKey.currentState.save();

  trasladoOut.fechaEntrada = DateTime.now().millisecondsSinceEpoch;

  final trasladoCreationService =
      Provider.of<TrasladoCreateService>(context, listen: false);
  Map info = await trasladoCreationService.updateTraslado(trasladoOut, id);
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
    titulo: 'Traslado regreso',
    color1: Color(0xff526bf6),
    color2: Color(0xff67acf2),
  );
}
