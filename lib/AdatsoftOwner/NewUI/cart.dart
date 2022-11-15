import 'package:petrosoft_india/AdatsoftOwner/NewUI/constants.dart';
import 'package:flutter/material.dart';


class CardModel {
  String name;
  String type;
  String balance;
  String valid;
  String moreIcon;
  String cardBackground;
  Color bgColor;
  Color firstColor;
  Color secondColor;

  CardModel(this.name, this.type, this.balance, this.valid, this.moreIcon,
      this.cardBackground, this.bgColor, this.firstColor, this.secondColor);
}

List<CardModel> cards = cardData
    .map((item) => CardModel(
    item['name'].toString(),
    item['type'].toString(),
    item['balance'].toString(),
    item['valid'].toString(),
    item['moreIcon'].toString(),
    item['cardBackground'].toString(),
    kBlackColor,
    kGreyColor,
    kBlackColor
))
    .toList();

var cardData = [
  {
    "name": "Prambors",
    "type": "assets/petrosoft_India/mastercard_logo.png",
    "balance": "6.352.251",
    "valid": "06/24",
    "moreIcon": 'assets/icons/more_icon_grey.svg',
    "cardBackground":'assets/icons/mastercard_bg.svg',
    "bgColor": kMasterCardColor,
    "firstColor": kGreyColor,
    "secondColor": kBlackColor
  },
  {
    "name": "Prambors",
    "type": "assets/petrosoft_India/jenius_logo.png",
    "balance": "20.528.337",
    "valid": "02/23",
    "moreIcon": 'assets/icons/more_icon_white.svg',
    "cardBackground":'assets/svg/jenius_bg.svg',
    "bgColor": kJeniusCardColor,
    "firstColor": kWhiteColor,
    "secondColor": kWhiteColor
  },

  {
    "name": "Prambors",
    "type": "assets/petrosoft_India/mastercard_logo.png",
    "balance": "6.352.251",
    "valid": "06/24",
    "moreIcon": 'assets/icons/more_icon_grey.svg',
    "cardBackground":'assets/svg/mastercard_bg.svg',
    "bgColor": kMasterCardColor,
    "firstColor": kGreyColor,
    "secondColor": kBlackColor
  },
  {
    "name": "Prambors",
    "type": "assets/petrosoft_India/jenius_logo.png",
    "balance": "20.528.337",
    "valid": "02/23",
    "moreIcon": 'assets/icons/more_icon_white.svg',
    "cardBackground":'assets/svg/jenius_bg.svg',
    "bgColor": kJeniusCardColor,
    "firstColor": kWhiteColor,
    "secondColor": kWhiteColor
  }
];



class TransactionModel {
  String name;
  String type;
  Color colorType;
  String signType;
  String amount;
  String information;
  String recipient;
  String date;
  String card;

  TransactionModel(this.name, this.type, this.colorType, this.signType,
      this.amount, this.information, this.recipient, this.date, this.card);
}

List<TransactionModel> transactions = transactionData
    .map((item) => TransactionModel(
    item['name'].toString(),
    item['type'].toString(),
    kOrangeColor,
    item['signType'].toString(),
    item['amount'].toString(),
    item['information'].toString(),
    item['recipient'].toString(),
    item['date'].toString(),
    item['card'].toString()
))
    .toList();

var transactionData = [
  {
    "name": "Outcome",
    "type": 'assets/icons/outcome_icon.svg',
    "colorType": kOrangeColor,
    "signType": "-",
    "amount": "200.000",
    "information": "Transfer to",
    "recipient": "Michael Ballack",
    "date": "12 Feb 2020",
    "card": "assets/petrosoft_India/mastercard_logo.png"
  },
  {
    "name": "Income",
    "type": 'assets/icons/income_icon.svg',
    "colorType": kGreenColor,
    "signType": "+",
    "amount": "352.000",
    "information": "Received from",
    "recipient": "Patrick Star",
    "date": "10 Feb 2020",
    "card": "assets/petrosoft_India/jenius_logo_blue.png"
  },
  {
    "name": "Outcome",
    "type": 'assets/icons/outcome_icon.svg',
    "colorType": kOrangeColor,
    "signType": "-",
    "amount": "53.265",
    "information": "Monthly Payment",
    "recipient": "Spotify",
    "date": "09 Feb 2020",
    "card": "assets/petrosoft_India/mastercard_logo.png"
  }
];
class MyFlutterApp {
  MyFlutterApp._();

  static const _kFontFamNavDrawer = 'nav_drawer';
  static const _kFontFamSlide = 'slide_icon';
  static const _kFontPkg = null;

  static const IconData navigation_drawer = IconData(0xe800, fontFamily: _kFontFamNavDrawer, fontPackage: _kFontPkg);
  static const IconData slide_icon = IconData(0xe801, fontFamily: _kFontFamSlide, fontPackage: _kFontPkg);
}