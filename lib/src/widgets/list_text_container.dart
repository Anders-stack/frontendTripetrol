import 'package:flutter/material.dart';

class ListTextContainer extends StatelessWidget {
  final List<Widget> childrenLista;
  final Color color1;
  final Color color2;
  const ListTextContainer(
      {      required this.childrenLista,
      this.color1 = Colors.lightBlue,
      this.color2 = Colors.lightGreen});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: <Color>[this.color1, this.color2]),
          boxShadow: [
            BoxShadow(
                offset: const Offset(3, 4),
                blurRadius: 10,
                color: Colors.black.withOpacity(0.5))
          ]),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: childrenLista,
          ),
        ),
      ),
    );
  }
}
