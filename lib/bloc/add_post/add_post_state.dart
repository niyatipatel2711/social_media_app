import 'package:flutter/material.dart';

@immutable
sealed class AddPostState {}

class AddPostInitialState extends AddPostState {}

class AddPostLoadingState extends AddPostState {}

class AddPostSuccessState extends AddPostState {}

class AddPostErrorState extends AddPostState {
  final String? errorCode;
  final String errorText;

  AddPostErrorState({this.errorCode, required this.errorText});
}
