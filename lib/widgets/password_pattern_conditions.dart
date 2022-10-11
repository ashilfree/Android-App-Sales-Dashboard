import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PasswordPatternConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    new AutoSizeText(
                      'Mot de passe invalid ?',
                      maxLines: 1,
                      maxFontSize: 19,
                      style: TextStyle(
                        fontSize: 19,
                        color: Color(0xff070707),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    new AutoSizeText(
                      'Votre mot de passe doit contenir les éléments suivants:\n\n- Une lettre minuscule\n- Une lettre majuscule\n- Un numéro\n- Un caractère spécial\n- Minimum 8 caractères',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff070707),
                        fontFamily: 'Quicksand',
                      ),
                    ),
                  ],
                ),
              ),
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
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
