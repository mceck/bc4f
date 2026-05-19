import 'package:bc4f/service/firebase-service.dart';
import 'package:bc4f/service/offline-service.dart';
import 'package:bc4f/utils/prefs.dart';
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

  const LoginBody({super.key, required this.mode, required this.onSetMode});

  @override
  State<LoginBody> createState() => _LoginBodyState();
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
    super.initState();
    if (kIsWeb) {
      _emailCtrl.text =
          Prefs().instance?.getString(KEYSTORE_EMAIL) ?? '';
    } else {
      AppStatus().authStorage?.readAll().then((keyStore) {
        final email = keyStore[KEYSTORE_EMAIL] ?? '';
        final passwd = keyStore[KEYSTORE_PASSWORD] ?? '';
        if (email.isNotEmpty && passwd.isNotEmpty) {
          log.info('autologin $email');
          _setLoading(true);
          FirebaseService.loginWithEmailAndPassword(email, passwd)
              .catchError((error) {
            if (!mounted) return;
            setState(() {
              _authError = 'Email o password errata';
              _loading = false;
            });
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwdCtrl.dispose();
    super.dispose();
  }

  void _setLoading(bool l) {
    if (mounted) setState(() => _loading = l);
  }

  bool get rememberMe => _rememberMe;
  set rememberMe(bool r) => setState(() => _rememberMe = r);

  void _sendForm() {
    _setAllDirty();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _setLoading(true);
    if (widget.mode == LoginMode.login) {
      final email = _emailCtrl.text.trim();
      final passwd = _passwdCtrl.text;
      FirebaseService.loginWithEmailAndPassword(email, passwd).then((_) {
        _setLoading(false);
        if (rememberMe) {
          if (kIsWeb) {
            Prefs().instance?.setString(KEYSTORE_EMAIL, email);
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
      }).catchError((err) {
        if (!mounted) return;
        setState(() {
          _authError = 'Email o password errata';
          _loading = false;
        });
      });
    } else {
      FirebaseService.signupWithEmailAndPassword(
              _emailCtrl.text, _passwdCtrl.text)
          .then((_) => log.info('signup success'))
          .catchError((err) {
        if (!mounted) return;
        setState(() {
          _authError = 'Email già registrata';
          _loading = false;
        });
      });
    }
  }

  void _setAllDirty() {
    _dirty.keys.forEach((key) => _dirty[key] = true);
  }

  void _setDirty(String id, String value) {
    if (value.isNotEmpty && !(_dirty[id] ?? false)) {
      _dirty[id] = true;
      _formKey.currentState?.validate();
    }
  }

  String? _validate(String id, String? value) {
    if (!(_dirty[id] ?? false)) return null;
    switch (id) {
      case 'email':
        if (value == null || value.isEmpty) return 'Inserisci un indirizzo email';
        final emailRegEx = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+\-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
        if (!emailRegEx.hasMatch(value)) {
          return 'Inserisci un indirizzo email valido';
        }
        break;
      case 'password':
        if (value == null || value.isEmpty) return 'Inserisci una password';
        if (value.length < 6) return 'Inserisci una password più lunga';
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Center(
      child: _loading
          ? const CircularProgressIndicator()
          : SizedBox(
              width: 350,
              height: 500,
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      widget.mode == LoginMode.login ? 'Login' : 'Registrati',
                      style: TextStyle(
                          color: Colors.grey[800], fontSize: 20),
                    ),
                    TextFormField(
                      onFieldSubmitted: (v) => _setDirty('email', v),
                      controller: _emailCtrl,
                      decoration:
                          const InputDecoration(labelText: 'e-mail'),
                      validator: (v) => _validate('email', v),
                    ),
                    TextFormField(
                      onFieldSubmitted: (v) => _setDirty('password', v),
                      controller: _passwdCtrl,
                      decoration:
                          const InputDecoration(labelText: 'password'),
                      obscureText: true,
                      validator: (v) => _validate('password', v),
                    ),
                    const SizedBox(height: 30),
                    if (widget.mode == LoginMode.login)
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Remember me'),
                        value: rememberMe,
                        onChanged: (val) => rememberMe = val ?? false,
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white),
                      onPressed: _sendForm,
                      child: const Icon(Icons.send),
                    ),
                    const SizedBox(height: 30),
                    if (AppStatus().refreshAuthState != null)
                      TextButton(
                        onPressed: () {
                          OfflineService().init();
                          AppStatus().offlineMode = true;
                          AppStatus().refreshAuthState!();
                        },
                        child: Text(
                          'Use offline',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    Text(
                      _authError,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
