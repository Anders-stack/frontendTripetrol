import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripetrol_manage_app/src/utils/user_secure_storage.dart';
import 'package:tripetrol_manage_app/src/widgets/big_tile_list.dart';
import 'package:tripetrol_manage_app/src/widgets/header_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List idRol = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final rol = await UserSecureStorage.getIdRole() ?? '';

    idRol = [int.parse(rol)];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
            margin: const EdgeInsets.only(top: 250),
            child: _lista(context, idRol)),
        const IconHeader(
          icon: FontAwesomeIcons.oilCan,
          subtitulo: 'Bienvenido',
          titulo: 'Tripetrol',
          color1: Color(0xff526bf6),
          color2: Color(0xff67acf2),
        ),
      ]),
    );
  }
}

Widget _lista(context, idRol) {
  return ListView(
    children: _listaItems(context, idRol),
  );
}

List<Widget> _listaItems(BuildContext context, idRol) {
  return [
    BigListButton(
      icon: FontAwesomeIcons.fileInvoiceDollar,
      titulo: 'Preparar Cheque',
      color1: const Color(0xff66A9F2),
      color2: const Color(0xff536CF6),
      onPress: () {
        Navigator.pushNamed(context, 'creacionCheque');
      },
    ),
    BigListButton(
      icon: FontAwesomeIcons.fileSignature,
      titulo: 'Traslado de Garrafas',
      color1: const Color(0xffF2D572),
      color2: const Color(0xffE06AA3),
      onPress: () {
        Navigator.pushNamed(context, 'validarCheque');
      },
    ),
    BigListButton(
      icon: FontAwesomeIcons.mapSigns,
      titulo: 'Entrada y Salidad de camiones',
      color1: const Color(0xff317183),
      color2: const Color(0xff46997D),
      onPress: () {
        Navigator.pushNamed(context, 'entradaSalida');
      },
    ),
    BigListButton(
      icon: FontAwesomeIcons.cashRegister,
      titulo: 'Validacion Cajero',
      color1: const Color(0xff6989F5),
      color2: const Color(0xff906EF5),
      onPress: () {
        Navigator.pushNamed(context, 'validarCajero');
      },
    ),
    BigListButton(
      icon: FontAwesomeIcons.cashRegister,
      titulo: 'Validacion Conductor',
      color1: Color(0xff317183),
      color2: Color(0xff46997D),
      onPress: () {
        Navigator.pushNamed(context, 'validarConductor');
      },
    ),
    BigListButton(
      icon: FontAwesomeIcons.fileAlt,
      titulo: 'Ventas locales',
      color1: Color(0xff66A9F2),
      color2: Color(0xff536CF6),
      onPress: () {
        //Navigator.pushNamed(context, 'reportes');
      },
    ),
    BigListButton(
      icon: FontAwesomeIcons.fileAlt,
      titulo: 'Reportes',
      color1: Color(0xff66A9F2),
      color2: Color(0xff536CF6),
      onPress: () {
        Navigator.pushNamed(context, 'reportes');
      },
    )
  ];
}
