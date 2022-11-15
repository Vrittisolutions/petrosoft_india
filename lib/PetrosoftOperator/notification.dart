import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class NotificationScreen extends StatefulWidget {
   final String notification;

  const NotificationScreen({Key? key, required this.notification}) : super(key: key);


  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.blue[50],
     appBar: AppBar(
       title: Text("Notification"),
     ),
     body:bodyUI()
   );
  }
  Widget bodyUI(){
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(15.0),
          child: Center(child: Text(widget.notification),),
        ),
      ],
    );
  }

}

