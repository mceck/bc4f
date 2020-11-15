import 'package:bc4f/service/firebase-service.dart';
import 'package:bc4f/service/offline-service.dart';
import 'package:bc4f/utils/prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/screens/login/login.dart';
import 'package:bc4f/utils/app-status.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/logger.dart';

class LoginBody extends StatefulWidget {
  static const route = '/login';

  final LoginMode mode;
  final void Function(LoginMode) onSetMode;
  final Function toggleOffline;

  const LoginBody({Key key, this.mode, this.onSetMode, this.toggleOffline})
      : super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwdCtrl = TextEditingController();
  final Map<String, bool> _dirty = {'email': false, 'password': false};
  String _authError = '';
  bool _loading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    if (kIsWeb) {
      // saved email on web
      _emailCtrl.text = Prefs().instance.getString(KEYSTORE_EMAIL) ?? '';
    } else {
      // autologin with mobile
      AppStatus().authStorage?.readAll()?.then((keyStore) {
        if (keyStore != null) {
          final email = keyStore[KEYSTORE_EMAIL] ?? '';
          final passwd = keyStore[KEYSTORE_PASSWORD] ?? '';
          if (email.isNotEmpty && passwd.isNotEmpty) {
            log.info('autologin $email');
            loading = true;
            FirebaseService.loginWithEmailAndPassword(email, passwd)
                .catchError((error) {
              setState(() {
                _authError = 'Email o password errata';
                _loading = false;
              });
            });
          }
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwdCtrl.dispose();
    super.dispose();
  }

  set loading(bool l) => setState(() => _loading = l);
  bool get loading => _loading;
  set rememberMe(bool r) => setState(() => _rememberMe = r);
  bool get rememberMe => _rememberMe;

  void _sendForm() {
    _setAllDirty();
    if (!_formKey.currentState.validate()) return;
    loading = true;
    if (widget.mode == LoginMode.Login) {
      //login
      final email = _emailCtrl.text.trim();
      final passwd = _passwdCtrl.text;
      FirebaseService.loginWithEmailAndPassword(email, passwd).then((success) {
        loading = false;
        if (rememberMe) {
          if (kIsWeb) {
            Prefs().instance.setString(KEYSTORE_EMAIL, email);
          } else {
            AppStatus().authStorage?.write(
                  key: KEYSTORE_EMAIL,
                  value: email,
                );
            AppStatus().authStorage?.write(
                  key: KEYSTORE_PASSWORD,
                  value: passwd,
                );
          }
        }
      });
    } else {
      FirebaseService.signupWithEmailAndPassword(
              _emailCtrl.text, _passwdCtrl.text)
          .then((_) => log.info('signup success'))
          .catchError(
            (err) => setState(() {
              _authError = 'Email già registrata';
              _loading = false;
            }),
          );
    }
  }

  void _setAllDirty() {
    _dirty.keys.forEach((key) => _dirty[key] = true);
  }

  void _setDirty(String id, String value) {
    if (value.isNotEmpty && !_dirty[id]) {
      _dirty[id] = true;
      _formKey.currentState.validate();
    }
  }

  void resetForm() {
    _dirty.keys.forEach((key) => _dirty[key] = false);
    _emailCtrl.text = '';
    _passwdCtrl.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    String _validate(String id, String value) {
      if (!_dirty[id]) return null;
      switch (id) {
        case 'email':
          if (value.isEmpty) return 'Inserisci un indirizzo email';
          final emailRegEx = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
          if (!emailRegEx.hasMatch(value))
            return 'Inserisci un indirizzo email valido';
          break;
        case 'password':
          if (value.isEmpty) return 'Inserisci una password';
          if (value.length < 6) return 'Inserisci una password più lunga';
          break;
        default:
      }

      return null;
    }

    return Center(
      child: loading
          ? CircularProgressIndicator()
          : SizedBox(
              width: 350,
              height: 500,
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.mode == LoginMode.Login ? 'Login' : 'Registrati',
                      style: TextStyle(color: Colors.grey[800], fontSize: 20),
                    ),
                    TextFormField(
                      onFieldSubmitted: (value) => _setDirty('email', value),
                      controller: _emailCtrl,
                      decoration: InputDecoration(labelText: 'e-mail'),
                      validator: (value) => _validate('email', value),
                    ),
                    TextFormField(
                      onFieldSubmitted: (value) => _setDirty('password', value),
                      controller: _passwdCtrl,
                      decoration: InputDecoration(labelText: 'password'),
                      obscureText: true,
                      //onFieldSubmitted: (value) => _sendForm(auth),
                      validator: (value) => _validate('password', value),
                    ),
                    SizedBox(height: 30),
                    if (widget.mode == LoginMode.Login)
                      CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text('Remember me'),
                          value: rememberMe,
                          onChanged: (val) {
                            rememberMe = val;
                          }),
                    SizedBox(height: 30),
                    RaisedButton(
                      color: primaryColor,
                      textColor: Colors.white,
                      onPressed: _sendForm,
                      child: Icon(Icons.send),
                    ),
                    SizedBox(height: 30),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          if (widget.mode == LoginMode.Login)
                            widget.onSetMode(LoginMode.Signup);
                          else
                            widget.onSetMode(LoginMode.Login);
                          resetForm();
                        });
                      },
                      child: Text(
                        widget.mode == LoginMode.Login
                            ? 'Registrati'
                            : 'Signin',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                    if (widget.toggleOffline != null)
                      FlatButton(
                        child: Text(
                          'Use offline',
                          style: TextStyle(color: primaryColor),
                        ),
                        onPressed: () {
                          OfflineService().init();
                          AppStatus().offlineMode = true;
                          AppStatus().toggleOffline = widget.toggleOffline;
                          widget.toggleOffline();
                        },
                      ),
                    Text(
                      _authError,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
