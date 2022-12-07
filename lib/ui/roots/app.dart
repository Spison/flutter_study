import 'package:flutter/material.dart';
import 'package:flutter_study/data/services/auth_service.dart';
import 'package:flutter_study/ui/roots/profile.dart';
import 'package:provider/provider.dart';
import '../../domain/models/user.dart';
import '../../internal/config/app_config.dart';
import '../../internal/config/shared_prefs.dart';
import '../../internal/config/token_storage.dart';
import '../../internal/dependencies/api_module.dart';
import '../app_navigator.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();

  _ViewModel({required this.context}) {
    asyncInit();
  }

  User? _user;

  User? get user => _user;

  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  Map<String, String>? headers;

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
  }

  void _logout() async {
    await _authService.logout().then((value) => AppNavigator.toLoader());
  }

  void _refresh() async {
    await _authService.tryGetUser();
  }

  void _toProfile() async {
    AppNavigator.toProfile();
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    return Scaffold(
      appBar: AppBar(
        // leading: (viewModel.user != null && viewModel.headers != null)
        //     ? CircleAvatar(
        //         backgroundImage: NetworkImage(
        //             "$baseUrl${viewModel.user!.avatarLink}",
        //             headers: viewModel.headers),
        //       )
        //     : null,
        title: Text(viewModel.user == null ? "Hi" : viewModel.user!.name),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh), onPressed: viewModel._refresh),
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: viewModel._logout),
        ],
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName:
                Text(viewModel.user == null ? "Hi" : viewModel.user!.name),
            accountEmail:
                Text(viewModel.user == null ? "Hi" : viewModel.user!.email),
            currentAccountPicture:
                (viewModel.user != null && viewModel.headers != null)
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                            "$baseUrl${viewModel.user!.avatarLink}",
                            headers: viewModel.headers),
                      )
                    : null,
          )
        ],
      )),
      body: Column(children: [
        ElevatedButton(
          onPressed: () {
            viewModel._toProfile();
            //Navigator.pushNamed(context, '/profile');
          },
          child: const Text("profile"),
        )
      ]),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: const App(),
    );
  }
}
