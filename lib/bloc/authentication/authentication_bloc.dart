import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/bloc/authentication/authentication_event.dart';
import 'package:social_media_app/modules/sign_up/sign_up_provider.dart';
import '../../modules/login/login_provider.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthEvent, AuthState> {
  AuthenticationBloc(AuthState incrementState) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        await LoginProvider.loginUser(loginParams: event.loginParams);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(errorText: e.toString()));
      }
    });

    on<SignUpEvent>((event, emit) {
      try {
        emit(AuthLoading());
        SignUpProvider.signUpUser(signUpParams: event.signUpParams);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(errorText: e.toString()));
      }
    });
  }
}
