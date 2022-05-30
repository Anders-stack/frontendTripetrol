import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:rolling_switch/rolling_switch.dart';
import 'package:tripetrol_manage_app/src/models/cheque_model_creacion.dart';
import 'package:tripetrol_manage_app/src/services/cheque_create.dart';
import 'package:tripetrol_manage_app/src/utils/user_secure_storage.dart';
import 'package:tripetrol_manage_app/src/widgets/header_icon.dart';
import 'package:tripetrol_manage_app/src/widgets/text_files.dart';
import 'package:search_choices/search_choices.dart';

class ChequeCreatePage extends StatefulWidget {
  ChequeCreatePage({Key? key}) : super(key: key);

  @override
  State<ChequeCreatePage> createState() => _ChequeCreatePageState();
}

class _ChequeCreatePageState extends State<ChequeCreatePage> {
  final formKey = GlobalKey<FormState>();
  ChequeModel cheque = ChequeModel();
  List camiones = [];
  List<DropdownMenuItem<dynamic>>? camionesSearch = [];
  List<int> selCamiones = [];
  final String _url = 'acaditecapibeta.azurewebsites.net';

  @override
  void initState() {
    super.initState();
    getCamiones(_url).then((value) => setState(() => (camionesSearch = value
        .map<DropdownMenuItem>((list) => DropdownMenuItem(
              child: Text('Camion No ' + list['ID_CONDUCTOR'].toString()),
              value: list['ID_CONDUCTOR'],
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
                    _noCheque(cheque),
                    _importe(cheque),
                    _noGarrafas(cheque),
                    _switchRural(cheque),
                    //_selecionCamion(camiones, selCamiones, context, setState),
                    SearchChoices.multiple(
                        selectedItems: selCamiones,
                        hint: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text("Seleccionar camiones"),
                        ),
                        items: camionesSearch,
                        onChanged: (value) {
                          setState(() {
                            selCamiones = value;
                          });
                        },
                        closeButton: (selectedItems) {
                          return (selectedItems.isNotEmpty
                              ? "Save ${'(' + selectedItems.length.toString() + ')'}"
                              : "Save without selection");
                        },
                        isExpanded: true),
                    _botonCheque(
                        cheque, formKey, context, selCamiones, camionesSearch),
                  ],
                )),
          ),
        ),
      ]),
    );
  }
}

Future getCamiones(_url) async {
  final url = Uri.https(_url, '/api/flujos/camiones');
  var resp = await http.get(
    url,
  );
  final decodedData = jsonDecode(resp.body);
  return decodedData;
}

Widget _botonAdd(selCamiones, camionesSearch) {
  return ElevatedButton(
    onPressed: () {
      final String camioStr =
          selCamiones.map((i) => camionesSearch[i].value).toList().join("-");
      //selCamiones.map((i) =>
      //camionesSearch[i].value).toList();

      print(camioStr);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: const Text(
        'Prueba',
      ),
    ),
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(10.0),
      shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
    ),
  );
}

Widget _listaCamiones(cheque) {
  return Text('data');
}

_crearFondo(BuildContext context) {
  return const SmallIconHeader(
    icon: FontAwesomeIcons.users,
    titulo: 'Creacion Cheques',
    color1: Color(0xff526bf6),
    color2: Color(0xff67acf2),
  );
}

Widget _noCheque(cheque) {
  return TextTileForm(
      labelText: 'Numero de Cheque',
      hintText: '0000',
      onSaved: (value) => cheque.noCheque = int.parse(value!),
      validator: (value) {
        String valor = value ?? '';
        if (valor.isEmpty) {
          return 'Inserte algun valor';
        } else {
          final n = num.tryParse(valor);
          return (n == null) ? 'Ingrese un valor correcto' : null;
        }
      },
      keyboardType: TextInputType.number);
}

Widget _importe(cheque) {
  return TextTileForm(
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    labelText: 'Importe',
    hintText: '00,00',
    onSaved: (value) => cheque.importe = double.parse(value!),
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

Widget _noGarrafas(cheque) {
  return TextTileForm(
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    labelText: '# de Garrafas',
    hintText: '0000',
    onSaved: (value) => cheque.noGarrafas = int.parse(value!),
    validator: (value) {
      String valor = value ?? '';
      if (valor.isEmpty) {
        return null;
      } else {
        final n = num.tryParse(valor);
        return (n == null) ? 'Ingrese un valor correcto' : null;
      }
    },
  );
}

Widget _switchRural(cheque) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: RollingSwitch.icon(
      onChanged: (bool state) {
        cheque.rural = state;
      },
      rollingInfoRight: const RollingIconInfo(
        icon: FontAwesomeIcons.tractor,
        text: Text('Rural'),
        backgroundColor: Colors.greenAccent,
      ),
      rollingInfoLeft: const RollingIconInfo(
        icon: FontAwesomeIcons.city,
        backgroundColor: Colors.blueAccent,
        text: Text('Ciudad'),
      ),
    ),
  );
}

Widget _botonCheque(cheque, formKey, context, selCamiones, camionesSearch) {
  return ElevatedButton(
    onPressed: () {
      cheque.camiones =
          selCamiones.map((i) => camionesSearch[i].value).toList().join("-");
      _submit(cheque, formKey, context);
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

void _submit(cheque, formKey, context) async {
  if (!formKey.currentState.validate()) {
    return;
  }
  formKey.currentState.save();
  cheque.fechaPeticion = DateTime.now().millisecondsSinceEpoch;
  final id = await UserSecureStorage.getIdUser() ?? '0';
  cheque.idAdmin = int.parse(id);

  final chequeCreationService =
      Provider.of<ChequeCreateService>(context, listen: false);
  Map info = await chequeCreationService.crearCheque(cheque);
  print(info);
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
