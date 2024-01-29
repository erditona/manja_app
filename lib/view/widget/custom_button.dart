import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;

  const CustomIconButton({
    required this.onPressed,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.grey.withOpacity(0.5),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: icon,
        ),
      ),
    );
  }
}
