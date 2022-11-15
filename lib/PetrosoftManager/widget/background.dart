import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/material.dart';

class OwnerBackground extends StatelessWidget {
  final Widget child;
  const OwnerBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  App.Type=="PetroOperator"|| App.Type=="PetroBuyer"||
        App.Type=="PetroOwner"?Container(
      width: double.infinity,
      height: size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.bottomRight,
          opacity: 20,
          image: AssetImage("assets/white_petrol.png",)

        )
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
         /* Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width: size.width * 0.35,
            ),
          ),*/
         /* Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/login_bottom.png",
              width: size.width * 0.4,
            ),
          ),*/
          child,
        ],
      ),
    ):Container(
      width: double.infinity,
      height: size.height,
      /*decoration: const BoxDecoration(
          image: DecorationImage(
              alignment: Alignment.bottomRight,
              opacity: 15,
              image: AssetImage("assets/wheatLogo.jpg")

          )
      ),*/
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          /* Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width: size.width * 0.35,
            ),
          ),*/
           Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/wheatLogo.jpg",
              width: size.width * 0.4,
            ),
          ),
          child,
        ],
      ),
    );
  }
}