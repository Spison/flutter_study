import 'package:flutter/material.dart';
import 'package:flutter_study/data/services/auth_service.dart';
import 'package:flutter_study/main.dart';
import 'package:flutter_study/ui/app_navigator.dart';
import 'package:provider/provider.dart';

class _ViewModelState {
  final String? login;
  final String? email;
  final String? password;
  final String? passwordRetry;
  final DateTime? birthDate;

  final bool isLoading;
  final String? errorText;

  const _ViewModelState({
    this.login,
    this.email,
    this.password,
    this.passwordRetry,
    this.birthDate,
    this.isLoading = false,
    this.errorText,
  });

  _ViewModelState copyWith({
    String? login,
    String? email,
    String? password,
    String? passwordRetry,
    DateTime? birthDate,
    bool? isLoading = false,
    String? errorText,
  }) {
    return _ViewModelState(
      login: login ?? this.login,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordRetry: passwordRetry ?? this.passwordRetry,
      birthDate: birthDate ?? this.birthDate,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText ?? this.errorText,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  var loginTec = TextEditingController();
  var emailTec = TextEditingController();
  var passwTec = TextEditingController();
  var passwRetryTec = TextEditingController();
  late DateTime? birthDayTec;
  final _authService = AuthService();

  BuildContext context;
  _ViewModel({required this.context}) {
    loginTec.addListener(() {
      state = state.copyWith(login: loginTec.text);
    });
    emailTec.addListener(() {
      state = state.copyWith(email: emailTec.text);
    });
    passwTec.addListener(() {
      state = state.copyWith(password: passwTec.text);
    });
    passwRetryTec.addListener(() {
      state = state.copyWith(passwordRetry: passwRetryTec.text);
    });
  }

  var _state = const _ViewModelState();
  _ViewModelState get state => _state;

  set state(_ViewModelState val) {
    _state = val;
    notifyListeners();
  }

  bool checkFields() {
    return (state.login?.isNotEmpty ?? false) &&
        (state.email?.isNotEmpty ?? false) &&
        (state.password?.isNotEmpty ?? false) &&
        (state.passwordRetry?.isNotEmpty ?? false);
  }

  void registration() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService
          .reg(state.login, state.email, state.password, state.passwordRetry,
              birthDayTec!)
          .then((value) {
        AppNavigator.toLoader()
            .then((value) => {state = state.copyWith(isLoading: false)});
      });
    } on NoNetworkException {
      state = state.copyWith(errorText: "нет сети");
    } on WrongCredentionalException {
      state = state.copyWith(errorText: "не правильный логин или пароль");
    } on ServerException {
      state = state.copyWith(errorText: "произошла ошибка на сервере");
    }
  }
}

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

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
                TextField(
                  controller: viewModel.loginTec,
                  decoration: const InputDecoration(hintText: "Enter Login"),
                ),
                TextField(
                  controller: viewModel.emailTec,
                  decoration: const InputDecoration(hintText: "Enter Email"),
                ),
                TextField(
                  controller: viewModel.passwTec,
                  decoration: const InputDecoration(hintText: "Enter Password"),
                ),
                TextField(
                  controller: viewModel.passwRetryTec,
                  decoration: const InputDecoration(hintText: "Retry Password"),
                ),
                ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1940),
                        lastDate: DateTime.now(),
                      ).then((date) {
                        viewModel.birthDayTec = date!;
                      });
                    },
                    child: const Text("Select your date of birth")),
                ElevatedButton(
                    onPressed: () {
                      viewModel.checkFields() ? viewModel.registration() : null;
                    },
                    child: const Text(
                        "Register")), //добавить проверку на ввод всех полей
                if (viewModel.state.errorText != null)
                  Text(viewModel.state.errorText!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
        create: (context) => _ViewModel(context: context),
        child: const Register(),
      );
}
