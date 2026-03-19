import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedtest/providers/speed_test_provider.dart';
import 'package:speedtest/providers/theme_manager.dart';

class SettingsConfirmationDialog extends StatelessWidget {
  const SettingsConfirmationDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color themedColor = isLightTheme(context) ? Colors.black : Colors.white;
    return AlertDialog(
      content: RichText(
        text: TextSpan(
            text: 'Are you sure you want to ',
            style: TextStyle(
              fontSize: 20,
              color: themedColor,
            ),
            children: [
              TextSpan(
                text: 'Clear History ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '?'),
            ]),
      ),
      actions: <Widget>[
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).colorScheme.secondary),
            padding: EdgeInsets.symmetric(vertical: 8),
          ),
          child: Text(
            'Yes',
            style: TextStyle(fontSize: 20, color: themedColor),
          ),
          onPressed: () {
            context.read<SpeedTestProvider>().clearHistory();
            Navigator.pop(context);
          },
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).colorScheme.secondary),
            padding: EdgeInsets.symmetric(vertical: 8),
          ),
          child: Text(
            'No',
            style: TextStyle(fontSize: 20, color: themedColor),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
