import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;

  final String label;
  final String? hint;

  final IconData? prefixIcon;
  final IconData? suffixIcon;

  final bool obscureText;
  final bool showPasswordToggle;

  final TextInputType keyboardType;

  final String? Function(String?)?
      validator;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onTap;

  final bool readOnly;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.keyboardType =
        TextInputType.text,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField>
      createState() =>
          _CustomTextFieldState();
}

class _CustomTextFieldState
    extends State<CustomTextField> {
  late bool obscure;

  @override
  void initState() {
    super.initState();

    obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,

      keyboardType:
          widget.keyboardType,

      obscureText: obscure,

      validator: widget.validator,

      onChanged: widget.onChanged,

      onTap: widget.onTap,

      readOnly: widget.readOnly,

      maxLines:
          obscure ? 1 : widget.maxLines,

      decoration: InputDecoration(
        labelText: widget.label,

        hintText: widget.hint,

        prefixIcon:
            widget.prefixIcon == null
                ? null
                : Icon(
                    widget.prefixIcon,
                    color:
                        AppColors.primary,
                  ),

        suffixIcon:
            widget.showPasswordToggle
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                    icon: Icon(
                      obscure
                          ? Icons
                              .visibility_off_outlined
                          : Icons
                              .visibility_outlined,
                    ),
                  )
                : widget.suffixIcon ==
                        null
                    ? null
                    : Icon(
                        widget.suffixIcon,
                      ),
      ),
    );
  }
}

