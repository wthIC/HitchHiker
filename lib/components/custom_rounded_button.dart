import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  const CustomRoundedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isRed = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isRed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isRed
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: onPressed == null
                ? const SizedBox(
                    height: 24.0,
                    width: 24.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Text(
                    text,
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
          ),
        ),
      ),
    );
  }
}
