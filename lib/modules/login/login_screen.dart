import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/base/baseSnackBar.dart';
import 'package:social_media_app/bloc/authentication/authentication_bloc.dart';
import 'package:social_media_app/modules/sign_up/sign_up_screen.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../../bloc/authentication/authentication_state.dart';
import '../../constants/app_constants.dart';
import '../../constants/string_constants.dart';
import '../../utils/const_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final AuthenticationBloc _loginBloc;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loginBloc = AuthenticationBloc(AuthInitial());
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppConstants.login,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: AppConstants.email,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppConstants.pleaseEnterYourEmail;
                    } else if (!RegExp(StringConstants.emailRegex)
                        .hasMatch(value)) {
                      return AppConstants.enterValidEmail;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: AppConstants.password,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppConstants.pleaseEnterPassword;
                    } else if (value.length < 6) {
                      return AppConstants.passwordLengthValidation;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Login Button
                _loginBlocConsumer(),
                SizedBox(height: 10),
                // Signup Navigation
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text(AppConstants.doNotHaveAccountSignUp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BlocConsumer _loginBlocConsumer() {
    return BlocConsumer(
      bloc: _loginBloc,
      listener: (context, state) {
        if (state is AuthSuccess) {
          if (mounted) {
            baseError(
                errorText: AppConstants.loginSuccessful, context: context);
            Navigator.pushNamed(context, ConstRoutes.dashboard);
          }
        } else if (state is AuthError) {
          if (mounted) {
            baseError(errorText: state.errorText, context: context);
          }
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const CircularProgressIndicator();
        }
        return _loginButton();
      },
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          textStyle: TextStyle(fontSize: 18),
        ),
        child: Text(AppConstants.login),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _loginBloc.add(
        LoginEvent(
          loginParams: LoginParams(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        ),
      );
    }
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
