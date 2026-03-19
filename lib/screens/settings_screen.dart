import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedtest/providers/theme_manager.dart';
import 'package:speedtest/widgets/settings_confirmation_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  final Uri developerUrl = Uri.parse('https://aydigitalcentre.com');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Dark Theme',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Consumer<ThemeManager>(
              builder: (context, themeManager, child) => Switch(
                value: themeManager.isDark,
                onChanged: (toggle) {
                  themeManager.toggleTheme();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'History',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side:
                    BorderSide(color: Theme.of(context).colorScheme.secondary),
              ),
              child: Text('Clear History'),
              onPressed: () {
                showModal(
                    context: context,
                    builder: (BuildContext context) {
                      return SettingsConfirmationDialog();
                    });
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'About App',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (await canLaunchUrl(developerUrl)) {
                  await launchUrl(developerUrl);
                }
              },
              child: Text(
                'Developed by Anshul Yadav',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
