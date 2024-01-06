import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'timer_cubit_event.dart';
part 'timer_cubit_state.dart';

class TimerCubitBloc extends HydratedBloc<TimerCubitEvent, TimerCubitState> {
  TimerCubitBloc() : super(TimerCubitInitial()) {
    on<TimerCubitEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  TimerCubitState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(TimerCubitState state) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
