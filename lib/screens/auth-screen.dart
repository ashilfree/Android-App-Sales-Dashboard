import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../helper/style.dart';
import '../models/error_handler.dart';
import '../models/error_toast.dart';
import '../providers/auth.dart';
import '../widgets/Admin_Sprint/forget_admin_password.dart';
import '../widgets/Client_Sprint/forget_client_password.dart';
import '../widgets/errorDialog.dart';
import '../widgets/password_pattern_conditions.dart';

enum AuthMode { login, email, fLogin, fLoginAdmin, uLogin, uLoginAdmin }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              color: Colors.grey[200],
            ),
          ),
          Image.asset(
            'assets/images/001.png',
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(136, 37, 70, 1).withOpacity(0.5),
                  Color.fromRGBO(31, 128, 76, 1).withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AuthCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  LocalAuthentication _auth = LocalAuthentication();
  bool _checkBio = false;
  bool _isBioFinger = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  @override
  void didChangeDependencies() {
    final auth = Provider.of<Auth>(context);
    switch (auth.authMode) {
      case "emailSendOK":
        _authMode = AuthMode.email;
        break;
      case "fLogin":
        _authMode = AuthMode.fLogin;
        break;
      case "uLogin":
        _authMode = AuthMode.uLogin;
        break;
      case "fLoginAdminAdmin":
        _authMode = AuthMode.fLoginAdmin;
        break;
      case "uLoginAdminAdmin":
        _authMode = AuthMode.uLoginAdmin;
        break;
      case "fLoginSuperAdmin":
        _authMode = AuthMode.fLoginAdmin;
        break;
      case "uLoginSuperAdmin":
        _authMode = AuthMode.uLoginAdmin;
        break;
      default:
        _authMode = AuthMode.login;
    }
    super.didChangeDependencies();
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      switch (_authMode) {
        case AuthMode.login:
          await Provider.of<Auth>(context, listen: false)
              .login(_authData['email']);
          break;
        case AuthMode.fLogin:
          // if (_checkBio && _isBioFinger) {
          //   showDialog(
          //     context: context,
          //     builder: (_) => AlertDialog(
          //       title: Text("utilisation d'empreinte"),
          //       content: Text("Voulez vous utiliser l'empreinte digital?"),
          //       actions: [
          //         RaisedButton(
          //           color: Colors.red,
          //           onPressed: () {
          //             Navigator.pop(context, true);
          //           },
          //           child: Text("Oui"),
          //         ),
          //         RaisedButton(
          //           color: Color(0xff4A5459),
          //           onPressed: () {
          //             Navigator.pop(context, false);
          //           },
          //           child: Text("Non"),
          //         )
          //       ],
          //     ),
          //     barrierDismissible: true,
          //   ).then((value) async {
          //     print(value);
          //     Provider.of<Auth>(context, listen: false)
          //         .setUseFingerprint(value);
          //     Provider.of<Auth>(context, listen: false)
          //         .setPassword(_authData['password']);
          //     await Provider.of<Auth>(context, listen: false)
          //         .fLogin(_authData['password'])
          //         .then((value) {
          //       if (value) {
          //         Navigator.of(context).pop();
          //       }
          //     });
          //   });
          // } else {
            await Provider.of<Auth>(context, listen: false)
                .fLogin(_authData['password'])
                .then((value) {
              if (value) {
                Navigator.of(context).pop();
              }
            });
          // }
          break;
        case AuthMode.uLogin:
          await Provider.of<Auth>(context, listen: false)
              .uLogin(_authData['password'])
              .then((value) {
            if (value) {
              Navigator.of(context).pop();
            }
          });
          break;
        case AuthMode.fLoginAdmin:
          // if (_checkBio && _isBioFinger) {
          //   showDialog(
          //     context: context,
          //     builder: (_) => AlertDialog(
          //       title: Text("Utilisation d'empreinte"),
          //       content: Text("Voulez vous utiliser l'empreinte digital?"),
          //       actions: [
          //         RaisedButton(
          //           color: Colors.red,
          //           onPressed: () {
          //             Navigator.pop(context, true);
          //           },
          //           child: Text("Oui"),
          //         ),
          //         RaisedButton(
          //           color: Color(0xff4A5459),
          //           onPressed: () {
          //             Navigator.pop(context, false);
          //           },
          //           child: Text("Non"),
          //         )
          //       ],
          //     ),
          //     barrierDismissible: true,
          //   ).then((value) async {
          //     print(value);
          //     Provider.of<Auth>(context, listen: false)
          //         .setUseFingerprint(value);
          //     Provider.of<Auth>(context, listen: false)
          //         .setPassword(_authData['password']);
          //     await Provider.of<Auth>(context, listen: false)
          //         .fLoginAdmin(_authData['password'])
          //         .then((value) {
          //       if (value) {
          //         Navigator.of(context).pop();
          //       }
          //     });
          //   });
          // } else {
            await Provider.of<Auth>(context, listen: false)
                .fLoginAdmin(_authData['password'])
                .then((value) {
              if (value) {
                Navigator.of(context).pop();
              }
            });
          // }
          break;
        case AuthMode.uLoginAdmin:
          await Provider.of<Auth>(context, listen: false)
              .uLoginAdmin(_authData['password'])
              .then((value) {
            if (value) {
              Navigator.of(context).pop();
            }
          });
          break;
      }
    } on SocketException catch (e) {
      final err = ErrorHandler.err(e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(err['errorMessage'], err['buttonTxt']);
          });
    } catch (error) {
      if (error.toString().contains('time_out_err')) {
        ErrorToast.showToast();
      } else {
        final err = ErrorHandler.err(error.toString());
        showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(err['errorMessage'], err['buttonTxt']);
            });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 8.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Logo_AQS_3.png'),
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                    Container(
                      height: 270,
                      constraints: BoxConstraints(minHeight: 270),
                      width: deviceSize.width * 0.75,
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: _authMode == AuthMode.email
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new AutoSizeText(
                                    "Un lien d'activation de votre compte a été envoyé à votre e-mail ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff070707),
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxFontSize: 18,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  new AutoSizeText(
                                    'Veuillez consulter votre boite e-mail.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).accentColor,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxFontSize: 18,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RaisedButton(
                                    color: Theme.of(context).accentColor,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                        bottom: 8.0,
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: 'OpenSans'),
                                      ),
                                    ),
                                    textColor: Theme.of(context).primaryColor,
                                    onPressed:
                                        Provider.of<Auth>(context).setLogin,
                                  )
                                ],
                              )
                            : Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      if (_authMode == AuthMode.login)
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'E-Mail'),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value.isEmpty ||
                                                !EmailValidator.validate(
                                                    value)) {
                                              return 'Email invalide !';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _authData['email'] = value;
                                          },
                                        ),
                                      if ((_authMode == AuthMode.fLogin) ||
                                          (_authMode == AuthMode.uLogin) ||
                                          (_authMode == AuthMode.fLoginAdmin) ||
                                          (_authMode == AuthMode.uLoginAdmin))
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Mot de passe'),
                                          obscureText: true,
                                          controller: _passwordController,
                                          validator: (value) {
                                            var res;
                                            if (value.isEmpty ||
                                                value.length < 8) {
                                              res =
                                                  'Le mot de passe est trop court !';
                                            } else {
                                              if (!validator.password(value)) {
                                                res =
                                                    'Le mot de passe invalid !';
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return PasswordPatternConditions();
                                                    });
                                              }
                                            }
                                            return res;
                                          },
                                          onSaved: (value) {
                                            _authData['password'] = value;
                                          },
                                        ),
                                      if (_authMode == AuthMode.fLogin ||
                                          _authMode == AuthMode.fLoginAdmin)
                                        TextFormField(
                                          enabled:
                                              (_authMode == AuthMode.fLogin ||
                                                  _authMode ==
                                                      AuthMode.fLoginAdmin),
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Confirmez le mot de passe'),
                                          obscureText: true,
                                          validator:
                                              (_authMode == AuthMode.fLogin ||
                                                      _authMode ==
                                                          AuthMode.fLoginAdmin)
                                                  ? (value) {
                                                      if (value !=
                                                          _passwordController
                                                              .text) {
                                                        return 'Les mots de passe ne correspondent pas !';
                                                      }
                                                      return null;
                                                    }
                                                  : null,
                                        ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      if (_isLoading)
                                        CircularProgressIndicator()
                                      else
                                        RaisedButton(
                                          child: Text(
                                              _authMode == AuthMode.login
                                                  ? 'SUIVANT'
                                                  : 'CONFIRMER'),
                                          onPressed: _submit,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30.0, vertical: 8.0),
                                          color: Theme.of(context).accentColor,
                                          textColor: Theme.of(context)
                                              .primaryTextTheme
                                              .button
                                              .color,
                                        ),
                                      if ((_authMode == AuthMode.uLogin ||
                                              _authMode ==
                                                  AuthMode.uLoginAdmin) &&
                                          Provider.of<Auth>(context,
                                                  listen: false)
                                              .useFingerprint)
                                        IconButton(
                                          icon: Icon(
                                            Icons.fingerprint,
                                            size: 50,
                                          ),
                                          onPressed: _startAuth,
                                          iconSize: 60,
                                        ),
                                      if (_authMode == AuthMode.uLogin)
                                        ForgetClientPassword(),
                                      if (_authMode == AuthMode.uLoginAdmin)
                                        ForgetAdminPassword(),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if ((_authMode == AuthMode.uLogin) ||
            (_authMode == AuthMode.uLoginAdmin) ||
            (_authMode == AuthMode.fLogin) ||
            (_authMode == AuthMode.fLoginAdmin))
          Positioned(
            top: 25,
            left: 10,
            child: FlatButton(
              textColor: aqsGrayColor,
              onPressed: () {
                 _formKey.currentState.reset();
                _passwordController.text = '';
                Provider.of<Auth>(context, listen: false).changeAccount();
              },
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
      ],
    );
  }

  void _checkBiometrics() async {
    try {
      final bio = await _auth.canCheckBiometrics;
      setState(() {
        _checkBio = bio;
      });
      print('List Biometrics = $_checkBio');
      if (bio) _listsBioAndFingerType();
    } catch (error) {
      print(error);
    }
  }

  void _listsBioAndFingerType() async {
    List<BiometricType> _listType;
    try {
      _listType = await _auth.getAvailableBiometrics();
    } on PlatformException catch (error) {
      print(error.message);
    }
    print('List Biometrics = $_listType');

    if (_listType.contains(BiometricType.fingerprint)) {
      setState(() {
        _isBioFinger = true;
      });
      print(_isBioFinger);
    }
  }

  void _startAuth() async {
    var _isAuthenticated = false;
    AndroidAuthMessages _androidMsg = AndroidAuthMessages(
      signInTitle: 'Authentifié Par Empreinte',
    );
    try {
      _isAuthenticated = await _auth.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint',
        useErrorDialogs: true,
        stickyAuth: true,
        androidAuthStrings: _androidMsg,
      );
    } on PlatformException catch (error) {
      print(error.message);
    }

    if (_isAuthenticated) {
      if (_authMode == AuthMode.uLogin) {
        await Provider.of<Auth>(context, listen: false)
            .uLogin(Provider.of<Auth>(context, listen: false).password)
            .then((value) {
          if (value) {
            Navigator.of(context).pop();
          }
        });
      } else {
        await Provider.of<Auth>(context, listen: false)
            .uLoginAdmin(Provider.of<Auth>(context, listen: false).password)
            .then((value) {
          if (value) {
            Navigator.of(context).pop();
          }
        });
      }
    }
  }
}
