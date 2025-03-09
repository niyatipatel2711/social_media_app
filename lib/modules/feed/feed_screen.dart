import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/base/baseSnackBar.dart';
import 'package:social_media_app/bloc/add_post/add_post_bloc.dart';
import 'package:social_media_app/bloc/add_post/add_post_event.dart';
import 'package:social_media_app/bloc/add_post/add_post_state.dart';

import '../../constants/app_constants.dart';
import '../../constants/string_constants.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _postController = TextEditingController();
  SharedPreferences? _prefs;
  String? _username;
  late final AddPostBloc _addPostBloc;

  @override
  void initState() {
    super.initState();
    _addPostBloc = AddPostBloc(AddPostInitialState());
    _initSharedPref();
  }

  @override
  void dispose() {
    super.dispose();
    _postController.dispose();
    _addPostBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.posts),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(StringConstants.posts)
                  .orderBy(StringConstants.timestamp, descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData ||
                    (snapshot.data?.docs != null &&
                        snapshot.data!.docs.isEmpty)) {
                  return Center(child: Text(AppConstants.noPostsYet));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text(doc[StringConstants.username],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(doc[StringConstants.message]),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPostDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addPostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppConstants.addAPost),
        content: TextField(
          controller: _postController,
          decoration: InputDecoration(hintText: AppConstants.enterYourMessage),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppConstants.cancel),
          ),
          _addPostBlocConsumer(),
        ],
      ),
    );
  }

  BlocConsumer _addPostBlocConsumer() {
    return BlocConsumer(
      bloc: _addPostBloc,
      listener: (context, state) {
        if (state is AddPostSuccessState) {
          if (mounted) {
            baseError(
                errorText: AppConstants.postAddedSuccessfully,
                context: context);
            _postController.clear();
            Navigator.pop(context);
          }
        } else if (state is AddPostErrorState) {
          if (mounted) {
            baseError(errorText: state.errorText, context: context);
          }
        }
      },
      builder: (context, state) {
        if (state is AddPostLoadingState) {
          return const CircularProgressIndicator();
        }
        return _postButton();
      },
    );
  }

  Widget _postButton() {
    return ElevatedButton(
      onPressed: () {
        _addPost(context);
        Navigator.pop(context);
      },
      child: Text(AppConstants.post),
    );
  }

  Future _initSharedPref() async {
    _prefs = await SharedPreferences.getInstance();
    _getUsername();
  }

  void _getUsername() {
    _username = _prefs?.getString(StringConstants.username);
  }

  // Function to add a post
  void _addPost(BuildContext context) async {
    if (_postController.text.trim().isEmpty) return;
    _addPostBloc.add(
      AddPostEvent(
        addPostParams: AddPostParams(
          username: _username ?? AppConstants.anonymous,
          message: _postController.text.trim(),
        ),
      ),
    );
  }
}

class AddPostParams {
  final String username;
  final String message;

  AddPostParams({required this.username, required this.message});
}
