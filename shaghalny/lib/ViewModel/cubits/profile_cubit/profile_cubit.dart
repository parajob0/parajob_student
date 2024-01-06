import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shaghalny/Model/user_model/user_model.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of<ProfileCubit>(context);

  Future<void>getYourJobHistory(PreferenceCubit cubit)async{
    Map<String,dynamic>jobs = cubit.userModel?.jobHistory??{};
    for(String jobId in jobs.keys){
      String value = jobs[jobId];
      print(jobId);
      print(value);
    }
  }

}