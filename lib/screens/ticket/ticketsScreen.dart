import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/settings/settings_cubit.dart';
import '../../localizations/localizations.dart';
import '../indexScreen.dart';
import '../newsScreen.dart';

class ticketsScreen extends StatefulWidget {
  @override
  _ticketsScreenState createState() => _ticketsScreenState();
}

class _ticketsScreenState extends State<ticketsScreen> {
  late final SettingsCubit settings;

  @override
  void initState() {
    settings = context.read<SettingsCubit>();
    super.initState();
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

  List<Ticket> tickets = [
    Ticket('Ticket Başlık 1', 'Açık', DateTime.now()),
    Ticket('Ticket Başlık 2', 'Tamamlandı', DateTime.now()),
    Ticket('Ticket Başlık 3', 'Devam Ediyor', DateTime.now()),
  ];

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
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (BuildContext context, int index) {
          return TicketCard(ticket: tickets[index]);
        },
      ),
    );
  }
}

class Ticket {
  final String title;
  final String status;
  final DateTime date;

  Ticket(this.title, this.status, this.date);
}

class TicketCard extends StatelessWidget {
  final Ticket ticket;

  TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/destekler/1');
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          title: Text(
            ticket.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                'Durum: ${ticket.status}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Tarih: ${ticket.date.toString()}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }
}
