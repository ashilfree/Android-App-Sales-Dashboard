import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/auth-screen.dart';
import '../widgets/customAppBar.dart';

class AqsSplashScreen extends StatefulWidget {
  @override
  _AqsSplashScreenState createState() => _AqsSplashScreenState();
}

class _AqsSplashScreenState extends State<AqsSplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  Color _iconAboutColor = Colors.white;
  Color _iconHomeColor = Color(0xff4A5459);
  Color _iconFbColor = Colors.white;
  bool homeActive = true;
  bool aboutActive = false;
  bool fbActive = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );
    Timer(
      Duration(milliseconds: 200),
      () => _animationController.forward(),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 1),
          end: Offset.zero,
        ).animate(_animationController),
        child: FadeTransition(
          opacity: _animationController,
          child: SizedBox(
            child: _getNavbar(context),
            height: 108,
          ),
        ),
      ),
      appBar: PreferredSize(
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, -1),
            end: Offset.zero,
          ).animate(_animationController),
          child: FadeTransition(
            opacity: _animationController,
            child: ClipPath(
              clipper: CustomAppBar(),
              child: Container(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, -1),
                end: Offset.zero,
              ).animate(_animationController),
              child: FadeTransition(
                opacity: _animationController,
                child: Container(
                  child: Image.asset(
                    'assets/images/Logo_AQS_3.png',
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.7,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1, 0),
                end: Offset.zero,
              ).animate(_animationController),
              child: FadeTransition(
                opacity: _animationController,
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: AutoSizeText(
                      "Bienvenue sur AQS Client Space.\n Votre application pour consulter en\n toute simplicité vos commandes,\n factures et solde.",
                      style: TextStyle(
                        fontSize: 20,
                        //color: Color(0xff4A5459),
                        color: Colors.black.withOpacity(.8),
                        fontWeight: FontWeight.bold,
                        height: 1.6,
                        fontFamily: 'Quicksand',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  decoration: BoxDecoration(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
              width: MediaQuery.of(context).size.width * 0.55,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(-1, 0),
                  end: Offset.zero,
                ).animate(_animationController),
                child: FadeTransition(
                  opacity: _animationController,
                  child: RawMaterialButton(
                    fillColor: Theme.of(context).accentColor,
                    splashColor: Theme.of(context).primaryColor,
                    textStyle: TextStyle(color: Colors.white),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'ENTRER',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right)
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                            transitionDuration: Duration(
                              milliseconds: 200,
                            ),
                            transitionsBuilder:
                                (context, animation, animationTime, child) {
                              animation = CurvedAnimation(
                                parent: animation,
                                curve: Curves.linear,
                              );
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                            pageBuilder: (context, animation, animationTime) {
                              return AuthScreen();
                            }),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print(' could not launch $command');
    }
  }

  Future<void> _launchInApp(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  _getNavbar(context) {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          child: ClipPath(
            clipper: NavBarClipper(),
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).accentColor.withOpacity(.7),
                      Theme.of(context).accentColor,
                    ]),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 45,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  setState(() {
                    _iconAboutColor = Color(0xff4A5459);
                    aboutActive = true;
                    homeActive = false;
                    _iconHomeColor = Colors.white;
                    _iconFbColor = Colors.white;
                    fbActive = false;
                  });
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return GestureDetector(
                          child: Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Positioned(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.9,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Center(
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                child: Image.asset(
                                                  'assets/images/AqsClient_logo.png',
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Center(
                                              child: new Text(
                                                'AQS Client Space',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff070707),
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.w200,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Center(
                                              child: new Text(
                                                'Version 2.1.1',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xff070707),
                                                  fontFamily: 'Quicksand',
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Center(
                                              child: FlatButton(
                                                textColor: Theme.of(context)
                                                    .accentColor,
                                                onPressed: () {
                                                  customLaunch(
                                                      'https://aqs.dz');
                                                },
                                                child: AutoSizeText(
                                                  "Allez Au Site Web Officiel",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily: 'OpenSans',
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  maxFontSize: 16,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 15,
                                  child: AutoSizeText(
                                    "Copyright 2020 DSI - BDD & DEV DEPT",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff070707),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Quicksand',
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    maxFontSize: 14,
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: ClipOval(
                                    child: Material(
                                      child: InkWell(
                                        splashColor: Color(0xff4A5459),
                                        child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: Icon(
                                              Icons.cancel,
                                              color: Color(0xff4A5459),
                                            )),
                                        onTap: () {
                                          setState(() {
                                            aboutActive = false;
                                            _iconAboutColor = Colors.white;
                                            homeActive = true;
                                            _iconHomeColor = Color(0xff4A5459);
                                          });
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).then((value) {
                    setState(() {
                      aboutActive = false;
                      _iconAboutColor = Colors.white;
                      homeActive = true;
                      _iconHomeColor = Color(0xff4A5459);
                    });
                  });
                },
                child: _buildNavItem(
                    ImageIcon(
                      AssetImage('assets/images/about_us.png'),
                      size: 25,
                      color: _iconAboutColor,
                    ),
                    aboutActive),
              ),
              SizedBox(
                width: 1,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _iconHomeColor = Color(0xff4A5459);
                    homeActive = true;
                    _iconAboutColor = Colors.white;
                    _iconFbColor = Colors.white;
                    aboutActive = false;
                    fbActive = false;
                  });
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: Duration(
                          milliseconds: 200,
                        ),
                        transitionsBuilder:
                            (context, animation, animationTime, child) {
                          animation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          );
                          return FadeTransition(
                            child: child,
                            opacity: animation,
                          );
                        },
                        pageBuilder: (context, animation, animationTime) {
                          return AqsSplashScreen();
                        }),
                  );
                },
                child: _buildNavItem(
                    ImageIcon(
                      AssetImage('assets/images/home.png'),
                      size: 25,
                      color: _iconHomeColor,
                    ),
                    homeActive),
              ),
              SizedBox(
                width: 1,
              ),
              InkWell(
                onTap: () {
                  _launchInApp('https://facebook.com/aqsofficielle');
                },
                child: _buildNavItem(
                    ImageIcon(
                      AssetImage('assets/images/fb.png'),
                      size: 25,
                      color: _iconFbColor,
                    ),
                    fbActive),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'A Propos',
                style: TextStyle(
                  color: Colors.white.withOpacity(.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 1,
              ),
              Text(
                'Accueil',
                style: TextStyle(
                  color: Colors.white.withOpacity(.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 1,
              ),
              Text(
                'Facebook',
                style: TextStyle(
                  color: Colors.white.withOpacity(.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildNavItem(ImageIcon icon, bool active) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Color(0xff1F804C).withOpacity(.9),
      child: CircleAvatar(
        radius: 25,
        backgroundColor:
            active ? Colors.white.withOpacity(.9) : Colors.transparent,
        child: icon,
      ),
    );
  }
}

class NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;
    path.cubicTo(sw / 12, 0, sw / 12, 2 * sh / 5, 2 * sw / 12, 2 * sh / 5);
    path.cubicTo(3 * sw / 12, 2 * sh / 5, 3 * sw / 12, 0, 4 * sw / 12, 0);
    path.cubicTo(
        5 * sw / 12, 0, 5 * sw / 12, 2 * sh / 5, 6 * sw / 12, 2 * sh / 5);
    path.cubicTo(7 * sw / 12, 2 * sh / 5, 7 * sw / 12, 0, 8 * sw / 12, 0);
    path.cubicTo(
        9 * sw / 12, 0, 9 * sw / 12, 2 * sh / 5, 10 * sw / 12, 2 * sh / 5);
    path.cubicTo(11 * sw / 12, 2 * sh / 5, 11 * sw / 12, 0, sw, 0);
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
