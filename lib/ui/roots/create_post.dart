import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_study/data/services/auth_service.dart';
import 'package:flutter_study/internal/config/shared_prefs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/services/data_service.dart';
import '../../domain/models/post_model.dart';
import '../../domain/models/user.dart';
import '../../internal/dependencies/repository_module.dart';

class _ViewModelState {
  final String? description;
  final _api = RepositoryModule.apiRepository();
  final bool isLoading;
  final String? errorText;
  final String? userId;

  late XFile? image;
  _ViewModelState({
    this.description,
    this.isLoading = false,
    this.image,
    this.errorText,
    this.userId,
  });

  _ViewModelState copyWith({
    String? id,
    String? description,
    bool? isLoading = false,
    XFile? image,
    String? errorText,
  }) {
    return _ViewModelState(
      description: description ?? this.description,
      image: image,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText ?? this.errorText,
      userId: userId,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  var descriptionTec = TextEditingController();

  _ViewModel() {
    descriptionTec.addListener(() {
      state = state.copyWith(description: descriptionTec.text);
    });
  }

  var _state = _ViewModelState();
  _ViewModelState get state => _state;

  set state(_ViewModelState val) {
    _state = val;
    notifyListeners();
  }

  bool checkFields() {
    return (state.description?.isNotEmpty ?? false);
  }

  void publicatePost() async {
    state = state.copyWith(isLoading: true);
    try {
      //_dataService.publicatePost(state.) // добавить в конце

    } on NoNetworkException {
      state = state.copyWith(errorText: "нет сети");
    } on WrongCredentionalException {
      state = state.copyWith(errorText: "не правильный логин или пароль");
    } on ServerException {
      state = state.copyWith(errorText: "произошла ошибка на сервере");
    }
  }
}

class CreatePost extends StatelessWidget {
  CreatePost(String id, {Key? key}) : super(key: key);

  XFile? image;

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: viewModel.descriptionTec,
                  decoration:
                      const InputDecoration(hintText: "Enter Description"),
                ),
                //const SizedBox(height: 48,),
                ElevatedButton.icon(
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final img =
                        await _picker.pickImage(source: ImageSource.gallery);
                    viewModel.state = viewModel.state.copyWith(image: img);
                    setState(() {
                      image = img;
                    });
                    if (viewModel.state.image != null) {
                      var t = await viewModel.state._api.uploadTemp(
                          files: [File(viewModel.state.image!.path)]);
                      if (t.isNotEmpty) {
                        //await viewModel.state._api.addAvatarToUser(t.first);
                        //post.author=хранящийся юзер

                        // User? user = viewModel._user;
                        // String id = "";
                        PostModelCreate post = PostModelCreate(
                            visibleToSubscribersOnly: false,
                            contents: t,
                            description: viewModel.descriptionTec.text);
                        await viewModel.state._api.createPost(post);

                        // if (user != null) {
                        //   id = user.id;
                        // }

                        // PostModelCreate post = PostModelCreate(
                        //     authorId: viewModel.user!.id,
                        //     visibleToSubscribersOnly: false,
                        //     contents: t);
                        // await viewModel.state._api.createPost(post);

                      }
                    }
                  },
                  label: const Text('Choose Image'),
                  icon: const Icon(Icons.image),
                ),
                if (viewModel.state.errorText != null)
                  Text(viewModel.state.errorText!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget create(String id) => ChangeNotifierProvider<_ViewModel>(
        create: (context) => _ViewModel(),
        child: CreatePost(id),
      );

  void setState(Null Function() param0) {}
}
