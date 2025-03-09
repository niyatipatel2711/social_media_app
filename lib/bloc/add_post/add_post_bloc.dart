import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/bloc/add_post/add_post_event.dart';
import 'package:social_media_app/bloc/add_post/add_post_state.dart';
import 'package:social_media_app/modules/feed/add_post_provider.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  AddPostBloc(AddPostState incrementState) : super(AddPostInitialState()) {
    on<AddPostEvent>((event, emit) async {
      try {
        emit(AddPostLoadingState());
        await AddPostProvider.addPost(event.addPostParams);
        emit(AddPostSuccessState());
      } catch (e) {
        emit(AddPostErrorState(errorText: e.toString()));
      }
    });
  }
}
