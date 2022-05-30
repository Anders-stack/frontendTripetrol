import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BigListButton extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final Color color1;
  final Color color2;
  final VoidCallback onPress;

  const BigListButton({
    required this.icon,
    required this.titulo,
    required this.onPress,
    this.color1 = Colors.grey,
    this.color2 = Colors.blueGrey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPress,
      child: Stack(children: [
        _ButtonBackground(
          icon: this.icon,
          color1: this.color1,
          color2: this.color2,
        ),
        Row(
          children: [
            const SizedBox(
              height: 140,
              width: 40,
            ),
            FaIcon(
              this.icon,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(
              height: 140,
              width: 20,
            ),
            Expanded(
              child: Text(
                this.titulo,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const FaIcon(
              FontAwesomeIcons.chevronRight,
              color: Colors.white,
            ),
            const SizedBox(
              height: 140,
              width: 40,
            ),
          ],
        )
      ]),
    );
  }
}

class _ButtonBackground extends StatelessWidget {
  final IconData icon;
  final Color color1;
  final Color color2;
  const _ButtonBackground({
    required this.icon,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(4, 6),
                blurRadius: 10)
          ],
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: <Color>[this.color1, this.color2])),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Positioned(
                right: -20,
                top: -20,
                child: FaIcon(
                  this.icon,
                  size: 150,
                  color: Colors.white.withOpacity(0.2),
                ))
          ],
        ),
      ),
    );
  }
}
