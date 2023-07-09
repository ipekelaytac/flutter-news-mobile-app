import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/settings/settings_cubit.dart';
import '../localizations/localizations.dart';
import 'indexScreen.dart';

class newsScreen extends StatefulWidget {
  const newsScreen({super.key});

  @override
  State<newsScreen> createState() => _newsScreenState();
}

class _newsScreenState extends State<newsScreen> {
  late final SettingsCubit settings;
  int curpage = 1;
  late ScrollController scControl;
  List<dynamic> news = [];
  bool pageLoading = false;

  @override
  void initState() {
    super.initState();
    loadNews();
    settings = context.read<SettingsCubit>();
    scControl = ScrollController();
    scControl.addListener(_scLissen);
  }

  loadNews({int page = 1}) async {
    setState(() {
      pageLoading = true;
    });
    Dio dio = Dio();
    var response =
        await dio.get("https://www.nginx.com/wp-json/wp/v2/posts?page=$page");
    if (response.statusCode == 200) {
      print(response.data);
      if (page == 1) {
        news = response.data;
      } else {
        news.addAll(response.data);
      }
      curpage = page;
      pageLoading = false;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Hata oluştu")));
      setState(() {
        pageLoading = false;
      });
    }
  }

  _scLissen() {
    if (scControl.offset >= scControl.position.maxScrollExtent &&
        !scControl.position.outOfRange) {
      loadNews(page: curpage + 1);
    }
  }

  Widget getNews() {
    if (news != null) {
      var haberler = news
          .map((e) => Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(width: 4),
                    borderRadius: BorderRadius.circular(15)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  onPressed: () {
                    context.push('/haberler/' + e['id'].toString());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: e["yoast_head_json"]["twitter_image"] != null
                            ? Image.network(
                                e["yoast_head_json"]["twitter_image"])
                            : Image.network(
                                "https://www.thinkink.com/News.jpg"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        e["yoast_head_json"]["title"].length >
                                                10
                                            ? e["yoast_head_json"]["title"]
                                                .substring(0, 33)
                                            : e["yoast_head_json"]["title"],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Wrap(
                                    children: [
                                      Text(
                                        e["yoast_head_json"]["description"]
                                                    .length >
                                                10
                                            ? e["yoast_head_json"]
                                                        ["description"]
                                                    .substring(0, 33) +
                                                '...'
                                            : e["yoast_head_json"]
                                                ["description"],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        e["date"].substring(0, 10),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      pageLoading
                          ? Column(
                              children: [
                                LinearProgressIndicator(),
                                const Text('Devamı Yükleniyor')
                              ],
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ))
          .toList();
      return Column(
        children: haberler,
      );
    } else {
      return Text("Loading");
    }
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
        body: SizedBox.expand(
          child: SingleChildScrollView(controller: scControl, child: getNews()),
        ));
  }
}
