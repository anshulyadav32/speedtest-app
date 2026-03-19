import 'package:flutter/material.dart';

class DialogShareCloseButton extends StatelessWidget {
  const DialogShareCloseButton({
    super.key,
    required this.size,
    required this.iconData,
    required this.label,
    required this.onPress,
  });

  final Size size;
  final IconData iconData;
  final String label;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.3,
      height: size.height * 0.05,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        onPressed: onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData),
            SizedBox(width: size.width * 0.01),
            Text(label),
          ],
        ),
      ),
    );
  }
}
