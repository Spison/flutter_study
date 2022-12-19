import 'package:flutter/material.dart';
import 'package:flutter_study/ui/roots/loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/user.dart';
import '../../../internal/config/app_config.dart';
import '../../../internal/config/shared_prefs.dart';
import 'profile_view_model.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var viewModel = context.watch<_ViewModel>();
    var viewModel = context.watch<ProfileViewModel>();
    var dtf = DateFormat("dd.MM.yyyy");
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: (viewModel.user != null
            ? Text(viewModel.user!.name)
            : const Text("login")),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: (viewModel.user != null)
            ? Row(children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Image.network(
                        //avatar,
                        (viewModel.avatar == null
                            ? "https://it-events.com/system/ckeditor/pictures/9440/content_dd_logo_rus.jpg"
                            : "$baseUrl${viewModel.user!.avatarLink}"),
                        width: 150,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {viewModel.changePhoto()},
                      child: const Text("Change photo"),
                    )
                  ],
                ),
                Column(
                    //textDirection: TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "email: ${viewModel.user!.email}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Birthday: ${dtf.format(viewModel.user!.birthDate)}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ]),
              ])
            : null,
      )),
    );
  }

  static create(context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProfileViewModel(context: context),
      child: const Profile(),
    );
  }
}
