import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isPassword;
  final bool isRequired;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String)? validator;
  final VoidCallback? onSubmitted;
  final Function(String)? onChanged;
  final String? errorText;

  const CustomInput({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.focusNode,
    this.isPassword = false,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.onSubmitted,
    this.onChanged,
    this.errorText,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final hasFocus = widget.focusNode.hasFocus;
    final hasText = widget.controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          cursorColor: primary,
          obscureText: widget.isPassword && _obscureText,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          style: const TextStyle(fontSize: 18),
          onChanged: widget.onChanged,
          onSubmitted: (_) {
            if (widget.onSubmitted != null) {
              widget.onSubmitted!();
            }
          },
          decoration: InputDecoration(
            labelText: widget.isRequired
                ? '${widget.label} *'
                : widget.label,
            prefixIcon: Container(
              margin: const EdgeInsets.fromLTRB(5, 0, 20, 0),
              padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
              width: 30,
              child: Icon(
                widget.icon,
                size: 26,
                color: hasError
                    ? Colors.red
                    : (hasFocus || hasText)
                        ? primary
                        : (textColor ?? Colors.black),
              ),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined,
                      color: const Color(0xDC7C837F),
                      size: 20,
                    ),
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[100],
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.white,
                width: hasError ? 1 : 0,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.lightGreen,
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}