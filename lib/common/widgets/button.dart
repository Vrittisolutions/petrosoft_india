import 'package:flutter/material.dart';

class CommonButtonForAllApp extends StatelessWidget {
  CommonButtonForAllApp({Key? key, required this.onPressed,required this.title, required this.backgroundColor}) : super(key: key);
  final GestureTapCallback onPressed;
  final String title;
  var backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15.0,bottom: 10.0,),
        child: Container(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
              gradient:  LinearGradient(
                colors: [backgroundColor, backgroundColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(5, 5),
                  blurRadius: 10,
                )
              ],
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: TextButton(
            onPressed: onPressed,
            child:  Text(
              title,
              style: const TextStyle(fontSize:16,color: Colors.white),
            ),
          ),
        )
    );
  }
}