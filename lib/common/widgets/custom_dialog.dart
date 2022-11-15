import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/material.dart';

class DialogBuilder {
  DialogBuilder(this.context);

  final BuildContext context;

  void showLoadingIndicator([String? text]) {
    showDialog(
      context: context,
      //barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => true,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),
              backgroundColor: Colors.white,
              content: LoadingIndicator(
                  text: text!
              ),
            )
        );
      },
    );
  }

  void hideOpenDialog() {
    Navigator.of(context).pop();
  }
}

class LoadingIndicator extends StatelessWidget{
  const LoadingIndicator({this.text = ''});

  final String text;

  @override
  Widget build(BuildContext context) {
    var displayedText = text;

    return Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
       height: 55,
        child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
             _getLoadingIndicator(),
              _getHeading(context),
              //_getText(displayedText)
            ]
        )
    );
  }

  Padding _getLoadingIndicator() {
    return App.Type=="PetroOperator"?
       Padding(
        child: SizedBox(
            child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(ColorsForApp.appThemeColorPetroOperator)
            ),
            width: 40,
            height: 40
        ),
        padding: EdgeInsets.only(bottom: 1)
    ):
    App.Type=="PetroBuyer"?
    Padding(
        child: SizedBox(
            child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(ColorsForApp.appThemeColorPetroCustomer)
            ),
            width: 40,
            height: 40
        ),
        padding: const EdgeInsets.only(bottom: 1)
    ):
    App.Type=="PetroOwner"?
     Padding(
        child: SizedBox(
            child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(ColorsForApp.appThemePetroOwner)
            ),
            width: 40,
            height: 40
        ),
        padding: EdgeInsets.only(bottom: 1)
    ) :App.Type=="AdatOwner"?
     Padding(
        child: SizedBox(
            child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(ColorsForApp.appThemeColorAdatOwner)
            ),
            width: 40,
            height: 40
        ),
        padding: const EdgeInsets.only(bottom: 1)
    ):
    App.Type=="AdatSeller" ?Padding(
        child: SizedBox(
            child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(UT.adatSoftSellerAppColor!)
            ),
            width: 40,
            height: 40
        ),
        padding: const EdgeInsets.only(bottom: 1)
    ):const Padding(
        child: SizedBox(
            child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black)
            ),
            width: 40,
            height: 40
        ),
        padding: EdgeInsets.only(bottom: 1)
    );
  }

  Widget _getHeading(context) {
    return const Padding(
          child: Text(
            'Please wait …',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16
            ),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.only(bottom: 4)
      );
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: const TextStyle(
          color: Colors.black,
          fontSize: 14
      ),
      textAlign: TextAlign.center,
    );
  }
}