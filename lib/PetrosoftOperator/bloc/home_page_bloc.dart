import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petrosoft_india/PetrosoftOperator/bloc/APICall/home_repository_impl.dart';
import 'package:petrosoft_india/PetrosoftOperator/bloc/Model/HomePageModel.dart';
import 'package:petrosoft_india/PetrosoftOperator/bloc/home_page_event.dart';
import 'package:petrosoft_india/PetrosoftOperator/bloc/home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final HomeRepository _todoRepository;
  HomePageBloc(this._todoRepository) : super(HomePageInitial()) {

    on<HomePageEvent>((event, emit) async {
      try {
        List<HomePageClass> data = await _todoRepository.fetchData();
        emit(HomePageDataLoaded(data: data));
      } on Exception {
        emit(TodoError(message: "Couldn't fetch the list, please try again later!"));
      }
    });

  }
}