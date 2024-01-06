import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());


  static OnBoardingCubit get(context) => BlocProvider.of<OnBoardingCubit>(context);

  int index = 0;
  void changeScreen({required int ind}){
    index = ind;

    emit(ScreenChangedSuccessfully());
  }
}
