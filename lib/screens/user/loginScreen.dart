import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../bloc/settings/settings_cubit.dart';
import '../../localizations/localizations.dart';

class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  late SettingsCubit settings;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final url = Uri.parse('https://api.qline.app/api/login');
    final response = await http.post(
      url,
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Başarılı giriş durumu
      final data = json.decode(response.body);
      final success = data['success'];

      if (success) {
        List<String> user_data = [
          //Giriş yapan kullanıcının bilgilerini saklama.
          data["name"],
          data["email"],
          data["phone"],
          data["token"],
        ];
        settings.userLogin(user_data);
        // Başarılı giriş durumunda anasayfaya yönlendirme.
        context.push('/anasayfa');
      } else {
        // Giriş başarısız olduğunda hata mesajı.
        final errorMessage = data['msg'];
        setState(() {
          _errorMessage = errorMessage;
        });
      }
    } else {
      // Sunucuyla ilgili bir hata oluştuğunda hata mesajı.
      setState(() {
        _errorMessage = 'Sunucuyla iletişim kurulurken bir hata oluştu.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    settings = context.read<SettingsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: Container(
                        height: 300.0,
                        width: 300.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage(
                            settings.state.language == 'tr'
                                ? 'assets/images/hosgeldin.jpeg'
                                : 'assets/images/welcome.png',
                          ),
                          fit: BoxFit.contain,
                        ))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        context.push('/kayitol');
                      },
                      child: Container(
                          height: 100,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                topLeft: Radius.circular(30),
                              )),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context).getTranslate('register_info')}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Center(
                                      child: Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ))
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Form(
                      child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          //height: 30,
                          child: TextFormField(
                            controller: _emailController,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              labelText:
                                  "${AppLocalizations.of(context).getTranslate('user_name')}",
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.black,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: _passwordController,
                          style: TextStyle(color: Colors.black),
                          obscureText: true,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.black),
                            labelText:
                                "${AppLocalizations.of(context).getTranslate('passwd')}",
                            prefixIcon: Icon(
                              Icons.password,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.black,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    height: 40,
                                    child: CupertinoButton(
                                      // context.push('/anasayfa');
                                      onPressed: _isLoading ? null : _login,

                                      color: Colors.black,
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                          child: Text(
                                              '${AppLocalizations.of(context).getTranslate('login')}')),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    _errorMessage,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                )
              ],
            ),
          )),
    );
  }
}
