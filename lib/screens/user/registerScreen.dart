import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../bloc/settings/settings_cubit.dart';
import '../../localizations/localizations.dart';

class registerScreen extends StatefulWidget {
  @override
  _registerScreenState createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  late SettingsCubit settings;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final url = Uri.parse('https://api.qline.app/api/register');
    var passwd = _passwordController.text;

    final response = await http.post(
      url,
      body: {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': passwd,
        'confirm_password': passwd,
      },
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Başarılı kayıt durumu
      final data = json.decode(response.body);
      final success = data['success'];

      if (success) {
        List<String> user_data = [
          //Kayıt olan kullanıcının bilgilerini saklama.
          data["name"],
          data["email"],
          data["phone"],
          data["token"],
        ];
        settings.userLogin(user_data);
        // Başarılı kayıt durumunda anasayfaya yönlendirme.
        context.push('/anasayfa');
      } else {
        // Kayıt başarısız olduğunda hata mesajı.
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
          color: Colors.white70,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Center(
                    child: Container(
                        height: 230.0,
                        width: 250.0,
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
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        context.push('/giris');
                      },
                      child: Container(
                          height: 100,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context).getTranslate('login_info')}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Center(
                                      child: Icon(
                                    Icons.arrow_circle_left_outlined,
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
                  padding: const EdgeInsets.only(top: 10),
                  child: Form(
                      child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          //height: 30,
                          child: TextField(
                            controller: _nameController,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              labelText:
                                  "${AppLocalizations.of(context).getTranslate('name_required')}  ",
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
                          height: 15,
                        ),
                        SizedBox(
                          child: TextField(
                            controller: _emailController,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              labelText:
                                  "${AppLocalizations.of(context).getTranslate('mail_required')} ",
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
                          height: 15,
                        ),
                        SizedBox(
                          child: TextField(
                            controller: _phoneController,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              labelText:
                                  "${AppLocalizations.of(context).getTranslate('phone_required')} ",
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
                          height: 15,
                        ),
                        TextField(
                          controller: _passwordController,
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.visiblePassword,
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
                          height: 20,
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
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _register,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        padding: EdgeInsets.all(10),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                      ),
                                      child: Center(
                                          child: _isLoading
                                              ? CircularProgressIndicator()
                                              : Text(
                                                  '${AppLocalizations.of(context).getTranslate('register')}')),
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
