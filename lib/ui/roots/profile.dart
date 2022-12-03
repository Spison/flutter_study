import 'package:flutter/material.dart';
import '../../internal/config/app_config.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var viewModel = context.watch<_ViewModel>();//Над уточнить, что это
    return Scaffold(
      appBar: AppBar(
        //title: Text(viewModel.user!.name), //заменить на ник/логин
        title: const Text("login"),
      ),
      body: Row(children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.network(
                //"$baseUrl${viewModel.user!.avatarLink}",
                "https://sun9-57.userapi.com/impg/gN3RucJP71dWDcRIkHzRuSa-OTdr8ZKPep1mdQ/q9V2TZ0xidQ.jpg?size=957x1280&quality=96&sign=930b48baf86f9313ee6684e434cbb49d&type=album",
              ),
            ),
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              children: const [
                //Text(viewModel.user!.name),
                //Text(viewModel.user!.email),
                //Text(viewModel.user!.birthdate),
                Text("name"),
                Text("viewModel.user!.email"),
                Text("viewModel.user!.birthdate"),
                //Text(viewModel.user!.postscount),
              ],
            )
          ],
        ),
      ]),
    );
  }
  /* static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: const Profile(),
    );
  } */
}
