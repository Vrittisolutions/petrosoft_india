import 'package:flutter/material.dart';
import 'package:petrosoft_india/PetrosoftOperator/bloc/Model/HomePageModel.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class HomePageState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {
}

class HomePageDataLoaded extends HomePageState {
  final List<HomePageClass> data;
  HomePageDataLoaded({required this.data});
}

class TodoError extends HomePageState {
  final String message;
  TodoError({required this.message});
}