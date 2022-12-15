import 'package:flutter/material.dart';
import 'package:flutter_study/data/services/auth_service.dart';
import 'package:flutter_study/data/services/data_service.dart';
import 'package:flutter_study/data/services/sync_service.dart';
import 'package:provider/provider.dart';
import '../../domain/models/post_model.dart';
import '../../domain/models/user.dart';
import '../../internal/config/app_config.dart';
import '../../internal/config/shared_prefs.dart';
import '../app_navigator.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();
  final _dataService = DataService();

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
  List<PostModel>? _posts;
  List<PostModel>? get posts => _posts;
  set posts(List<PostModel>? val) {
    _posts = val;
    notifyListeners();
  }

  Map<int, int> pager = <int, int>{};
  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  void asyncInit() async {
    user = await SharedPrefs.getStoredUser();
    await SyncService().syncPosts();
    posts = await _dataService.getPosts();
  }

  void _logout() async {
    await _authService.logout().then((value) => AppNavigator.toLoader());
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
    var screenWidth = MediaQuery.of(context).size.width;
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
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                // style: ElevatedButton.styleFrom(
                //     primary: Colors.blue, onPrimary: Colors.white),
                onPressed: () {
                  viewModel._toProfile();
                },
                child: const Text("Profile"),
              ),
            )
          ],
        )),
        body: Container(
            child: viewModel.posts == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemBuilder: (listContext, listIndex) {
                      Widget res;
                      var posts = viewModel.posts;
                      if (posts != null) {
                        var post = posts[listIndex];
                        res = Container(
                            color: Colors.grey,
                            height: screenWidth,
                            child: Column(children: [
                              Expanded(
                                  child: PageView.builder(
                                onPageChanged: ((value) =>
                                    viewModel.onPageChanged(listIndex, value)),
                                itemCount: post.contents.length,
                                itemBuilder: (pageContext, pageIndex) =>
                                    Container(
                                        color: Colors.amber,
                                        child: Image(
                                          image: NetworkImage(
                                              "$baseUrl${post.contents[pageIndex].contentLink}"),
                                        )),
                              )),
                              PageIndicator(
                                count: post.contents.length,
                                current: viewModel.pager[listIndex],
                              ),
                              Text(post.author.name),
                              Text(post.description ?? ""),
                            ]));
                      } else {
                        res = SizedBox.shrink();
                      }
                      return res;
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: viewModel.posts?.length ?? 0,
                  )));
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: const App(),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int count;
  final int? current;
  final double width;
  const PageIndicator(
      {Key? key, required this.count, required this.current, this.width = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    for (var i = 0; i < count; i++) {
      widgets.add(
        Icon(
          Icons.circle,
          size: i == (current ?? 0) ? width * 1.4 : width,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [...widgets],
    );
  }
}
