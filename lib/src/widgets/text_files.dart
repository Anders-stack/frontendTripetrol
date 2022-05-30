import 'package:flutter/material.dart';

class TextTile extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Color color1;
  final Color color2;
  const TextTile(
      {Key? key,
      required this.labelText,
      required this.hintText,
      this.color1 = Colors.lightBlue,
      this.color2 = Colors.lightGreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 80,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 6),
                    blurRadius: 10)
              ],
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(colors: <Color>[
                this.color1,
                this.color2 /*Color(0xff3498DB), Color(0xff27AE60)*/
              ])),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.35),
                  filled: true,
                  focusColor: Colors.redAccent,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 3)),
                  labelText: this.labelText,
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: this.hintText,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none)),
            ),
          ),
        ),
      ],
    );
  }
}

class TextTileForm extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Color color1;
  final Color color2;
  final void Function(String?)? onSaved;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  const TextTileForm(
      {Key? key,
      required this.labelText,
      required this.hintText,
      required this.onSaved,
      required this.validator,
      this.color1 = Colors.lightBlue,
      this.keyboardType = TextInputType.text,
      this.color2 = Colors.lightGreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 80,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(4, 6),
                    blurRadius: 10)
              ],
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(colors: <Color>[
                this.color1,
                this.color2 /*Color(0xff3498DB), Color(0xff27AE60)*/
              ])),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              keyboardType: this.keyboardType,
              onSaved: onSaved,
              validator: validator,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.35),
                  filled: true,
                  focusColor: Colors.redAccent,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white, width: 3)),
                  labelText: this.labelText,
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: this.hintText,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none)),
            ),
          ),
        ),
      ],
    );
  }
}
