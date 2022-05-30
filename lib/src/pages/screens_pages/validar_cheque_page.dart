import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripetrol_manage_app/src/widgets/big_tile_list.dart';
import 'package:tripetrol_manage_app/src/widgets/header_icon.dart';

class ChequeValdidScreen extends StatefulWidget {
  const ChequeValdidScreen({Key? key}) : super(key: key);

  @override
  _ChequeValdidScreenState createState() => _ChequeValdidScreenState();
}

class _ChequeValdidScreenState extends State<ChequeValdidScreen> {
  @override
  @override
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
                  height: 145.0,
                )),
                _botonEntrada(),
                _botonSalida(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonEntrada() {
    return BigListButton(
      icon: FontAwesomeIcons.signInAlt,
      titulo: 'Traslado Salida',
      onPress: () {
        Navigator.pushNamed(context, 'trasladoSalida');
      },
      color1: const Color(0xff317183),
      color2: const Color(0xff46997D),
    );
  }

  Widget _botonSalida() {
    return BigListButton(
      icon: FontAwesomeIcons.externalLinkAlt,
      titulo: 'Traslado Entrada',
      onPress: () {
        Navigator.pushNamed(context, 'trasladoEntrada');
      },
      color1: const Color(0xffF2D572),
      color2: const Color(0xffE06AA3),
    );
  }

  _crearFondo(BuildContext context) {
    return const SmallIconHeader(
      icon: FontAwesomeIcons.users,
      titulo: 'Traslado de Camiones',
      color1: Color(0xff526bf6),
      color2: Color(0xff67acf2),
    );
  }
}
