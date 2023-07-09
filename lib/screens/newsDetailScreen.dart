import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_mobile_project/screens/newsScreen.dart';
import 'package:go_router/go_router.dart';

import '../bloc/settings/settings_cubit.dart';
import '../localizations/localizations.dart';
import 'indexScreen.dart';

class newsDetailScreen extends StatefulWidget {
  final String newsID;
  const newsDetailScreen({super.key, required this.newsID});

  @override
  State<newsDetailScreen> createState() => _newsDetailScreenState();
}

class _newsDetailScreenState extends State<newsDetailScreen> {
  Dio dio = Dio();
  late final SettingsCubit settings;

  bool loading = true;
  String title = '';
  String content = '';
  String image = '';
  String date = '';

  loadUser() async {
    final response = await dio
        .get('https://www.nginx.com/wp-json/wp/v2/posts/' + widget.newsID);
    print(response.data);
    loading = false;
    title = response.data["yoast_head_json"]["title"];
    content = response.data["yoast_head_json"]["description"];
    image = response.data['yoast_head_json']['twitter_image'];
    date = response.data['date'].substring(0, 10);
    setState(() {});
  }

  @override
  void initState() {
    settings = context.read<SettingsCubit>();
    loadUser();
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                image != ""
                    ? Image.network(image)
                    : Image.network("https://www.thinkink.com/News.jpg"),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      content,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Tarih:  ' + date,
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
