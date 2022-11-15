import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
@immutable
abstract class HomePageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HomePageDataFetched extends HomePageEvent {}