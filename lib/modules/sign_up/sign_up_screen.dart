import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/base/baseSnackBar.dart';
import 'package:social_media_app/bloc/authentication/authentication_bloc.dart';
import 'package:social_media_app/bloc/authentication/authentication_event.dart';
import 'package:social_media_app/bloc/authentication/authentication_state.dart';
import '../../base/base_back_icon_button.dart';
import '../../constants/app_constants.dart';
import '../../constants/string_constants.dart';
import '../../utils/const_routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(AuthInitial());
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _authenticationBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BaseBackIconButton(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppConstants.signUp,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: AppConstants.username,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppConstants.pleaseEnterUsername;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),

                // Email Field
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
                SizedBox(height: 15),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: AppConstants.confirmPassword,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return AppConstants.passwordsDoNotMatch;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Signup Button
                _signUpBlocConsumer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BlocConsumer _signUpBlocConsumer() {
    return BlocConsumer(
      bloc: _authenticationBloc,
      listener: (context, state) {
        if (state is AuthSuccess) {
          if (mounted) {
            baseError(
                errorText: AppConstants.accountCreatedSuccessfully,
                context: context);
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
        return _signUpButton();
      },
    );
  }

  Widget _signUpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _signup,
        child: Text(AppConstants.signUp),
      ),
    );
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      _authenticationBloc.add(
        SignUpEvent(
          signUpParams: SignUpParams(
            password: _passwordController.text.trim(),
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
          ),
        ),
      );
    }
  }
}

class SignUpParams {
  final String username;
  final String password;
  final String email;

  SignUpParams({
    required this.password,
    required this.username,
    required this.email,
  });
}
