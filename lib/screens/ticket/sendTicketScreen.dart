import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/settings/settings_cubit.dart';
import '../../localizations/localizations.dart';
import '../indexScreen.dart';
import '../newsScreen.dart';

class sendTicketScreen extends StatefulWidget {
  @override
  _sendTicketScreenState createState() => _sendTicketScreenState();
}

class _sendTicketScreenState extends State<sendTicketScreen> {
  late final SettingsCubit settings;
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  askLogout() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context).getTranslate("logout")),
        content:
            Text(AppLocalizations.of(context).getTranslate("logout_confirm")),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(AppLocalizations.of(context).getTranslate("yes")),
            onPressed: () {
              settings.userLogout();
              Navigator.of(context).pop();
              GoRouter.of(context).replace('/giris');
            },
          ),
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context).getTranslate("no")),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    settings = context.read<SettingsCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => indexScreen()));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.newspaper,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => newsScreen()));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: askLogout,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context).getTranslate("ticket_subject"),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context).getTranslate("ticket_title"),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context).getTranslate("ticket_message"),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                String subject = _subjectController.text;
                String title = _titleController.text;
                String message = _messageController.text;

                _subjectController.clear();
                _titleController.clear();
                _messageController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(AppLocalizations.of(context)
                          .getTranslate("ticket_send_response"))),
                );
              },
              child: Text(
                  AppLocalizations.of(context).getTranslate("ticket_send")),
            ),
          ],
        ),
      ),
    );
  }
}
