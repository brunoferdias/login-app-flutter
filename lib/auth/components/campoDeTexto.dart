import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CampoTexto extends StatefulWidget {
  final String hintText;
  final Widget prefixIcon;
  final bool obscureText;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;

  const CampoTexto({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.onSaved,
    this.controller,
  }) : super(key: key);

  @override
  _CampoTextoState createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.black26),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: widget.prefixIcon,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
        ),
        onSaved: widget.onSaved,
      ),
    );
  }
}
