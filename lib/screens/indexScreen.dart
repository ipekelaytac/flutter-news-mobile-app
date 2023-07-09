import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:news_mobile_project/screens/ticket/sendTicketScreen.dart';
import 'package:news_mobile_project/screens/ticket/ticketsScreen.dart';
import '../bloc/settings/settings_cubit.dart';
import '../localizations/localizations.dart';
import 'newsScreen.dart';

class indexScreen extends StatefulWidget {
  const indexScreen({super.key});

  @override
  State<indexScreen> createState() => _indexScreenState();
}

class _indexScreenState extends State<indexScreen> {
  late final SettingsCubit settings;

  @override
  void initState() {
    settings = context.read<SettingsCubit>();
    super.initState();
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
            AppLocalizations.of(context).getTranslate('language_selection')),
        message: Text(
            AppLocalizations.of(context).getTranslate('language_selection2')),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              settings.changeLanguage("tr");
              Navigator.pop(context);
            },
            child: const Text('Turkce'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              settings.changeLanguage("en");
              Navigator.pop(context);
            },
            child: const Text('English'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).getTranslate('cancel')),
          ),
        ],
      ),
    );
  }

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  _showActionSheet(context);
                },
                child: Text(
                    '${AppLocalizations.of(context).getTranslate('language')} : ${settings.state.language}')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '${AppLocalizations.of(context).getTranslate('darkMode')}: '),
                Switch(
                  value: settings.state.darkMode,
                  onChanged: (value) {
                    settings.changeDarkMode(value);
                  },
                )
              ],
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Row(
                  children: [
                    Text(
                      '${AppLocalizations.of(context).getTranslate('send_ticket')}:',
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.messenger_outline,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => sendTicketScreen()));
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Row(
                  children: [
                    Text(
                        '${AppLocalizations.of(context).getTranslate('tickets')} :'),
                    IconButton(
                      icon: Icon(
                        Icons.message_outlined,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ticketsScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          ElevatedButton(
            child: Text(
                '${AppLocalizations.of(context).getTranslate('hello_world')}'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
