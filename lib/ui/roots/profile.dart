import 'package:flutter/material.dart';
import 'package:flutter_study/data/clients/api_client.dart';
import 'package:provider/provider.dart';
import '../../domain/models/user.dart';
import '../../internal/config/app_config.dart';
import '../../internal/config/shared_prefs.dart';
import '../../internal/config/token_storage.dart';
import '../app_navigator.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>(); //Над уточнить, что это
    return Scaffold(
      appBar: AppBar(
        title: (viewModel.user != null && viewModel.headers != null
            ? Text(viewModel.user!.name)
            : const Text("login")),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: (viewModel.user != null && viewModel.headers != null)
            ? Row(children: [
                //Text("hey,dude"),
                Align(
                  alignment: Alignment.topLeft,
                  child: Image.network(
                    //avatar,
                    (viewModel.user!.avatarLink == null
                        ? "https://it-events.com/system/ckeditor/pictures/9440/content_dd_logo_rus.jpg"
                        : "$baseUrl${viewModel.user!.avatarLink}"),
                    width: 150,
                  ),
                ),
                Column(
                    textDirection: TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "email: ${viewModel.user!.email}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Birthday: ${viewModel.user!.birthDate.substring(0, 10)}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20),
                      ),
                      // Text(
                      //   "добавить в будущем подписчиков",
                      //   textAlign: TextAlign.left,
                      //   style: const TextStyle(fontSize: 20),
                      // ),
                    ]),
              ])
            : null,
      )),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: const Profile(),
    );
  }
}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
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
}
