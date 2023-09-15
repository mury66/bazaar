import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/layouts/shop_app/log_in/cubit/states.dart';
import 'package:task/network/remote/dio_helper.dart';
import 'package:task/network/remote/end_points/end_points.dart';
import '../../../../models/shop_app/login_model/login_model.dart';

class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit(): super(LoginInitialState());

  late LoginModel userDataModel;

  bool isVisible = false;

  IconData passSuffix = Icons.visibility_outlined;

  void changePasswordVisibility()
  {
    isVisible=!isVisible;
    print(isVisible);
    isVisible ? passSuffix=Icons.visibility_off_outlined : passSuffix=Icons.visibility_outlined;
    emit(LoginChangePasswordVisibility());
  }


  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({required String email, required String password})
  {
    emit(LoginLoadingState());
    DioHelper.postData(
        lang: "ar",
        url: LOGIN,
        data: {
          "email":email,
          "password":password
        },
    ).then((value){
      //print(value.data);
      userDataModel= LoginModel.fromjson(value.data);
      //print(userDataModel.message);
      emit(LoginSuccessState(userDataModel));
    }).catchError((onError)
      {
        print(onError.toString());
        emit(LoginErrorState(onError.toString()));
      }
    );
  }
}