import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/settings/settings_cubit.dart';
import '../../localizations/localizations.dart';
import '../indexScreen.dart';
import '../newsScreen.dart';

class messageTicketScreen extends StatefulWidget {
  final String ticketID;

  messageTicketScreen({required this.ticketID});

  @override
  _messageTicketScreenState createState() => _messageTicketScreenState();
}

class _messageTicketScreenState extends State<messageTicketScreen> {
  List<Message> messages = [];
  late final SettingsCubit settings;

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
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    String messageText = _messageController.text;
    setState(() {
      messages.add(Message(
        content: messageText,
        isSentByUser: true,
      ));
      messages.add(Message(
        content: 'Örnek yanıt',
        isSentByUser: false,
      ));
      _messageController.clear();
    });
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
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.blueGrey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context).getTranslate("ticket_title"),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .getTranslate("ticket_subject"),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                Message message = messages[index];
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  alignment: message.isSentByUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: message.isSentByUser
                          ? Colors.blue[200]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      message.content,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)
                          .getTranslate("ticket_message"),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String content;
  final bool isSentByUser;

  Message({required this.content, required this.isSentByUser});
}
