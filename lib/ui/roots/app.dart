import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_study/data/services/auth_service.dart';
import 'package:flutter_study/data/services/data_service.dart';
import 'package:provider/provider.dart';
import '../../domain/models/post_model.dart';
import '../../domain/models/user.dart';
import '../../internal/config/app_config.dart';
import '../../internal/config/shared_prefs.dart';
import '../app_navigator.dart';
import 'profile/profile.dart';

class AppViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();
  final _dataService = DataService();
  final _lvc = ScrollController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  AppViewModel({required this.context}) {
    asyncInit();
    _lvc.addListener(() {
      var max = _lvc.position.maxScrollExtent;
      var current = _lvc.offset;
      var percent = (current / max * 100);
      if (percent > 80) {
        if (!isLoading) {
          isLoading = true;
          Future.delayed(const Duration(seconds: 1)).then((value) {
            posts = <PostModel>[...posts!, ...posts!];
            isLoading = false;
          });
        }
      }
    });
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? val) {
    _avatar = val;
    notifyListeners();
  }

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
    var img = await NetworkAssetBundle(Uri.parse("$baseUrl${user!.avatarLink}"))
        .load("$baseUrl${user!.avatarLink}?v=1");
    avatar = Image.memory(
      img.buffer.asUint8List(),
      fit: BoxFit.fill,
    );
    posts = await _dataService.getPosts();
  }

  void _logout() async {
    await _authService.logout().then((value) => AppNavigator.toLoader());
  }

  void onClick() {
    //var offset = _lvc.offset;
    _lvc.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeInCubic);
  }

  void _toProfile(BuildContext bc) async {
    // AppNavigator.toProfile(bc);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (__) => Profile.create(bc)));
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AppViewModel>();
    var screenWidth = MediaQuery.of(context).size.width;
    var itemCount = viewModel.posts?.length ?? 0;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: viewModel.onClick,
          child: const Icon(Icons.arrow_circle_up_outlined),
        ),
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
                  Text(viewModel.user == null ? "Name" : viewModel.user!.name),
              accountEmail: Text(
                  viewModel.user == null ? "email" : viewModel.user!.email),
              currentAccountPicture: (viewModel.user != null)
                  ? CircleAvatar(
                      backgroundImage: viewModel.avatar?.image,
                    )
                  : null,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                // style: ElevatedButton.styleFrom(
                //     primary: Colors.blue, onPrimary: Colors.white),
                onPressed: () {
                  viewModel._toProfile(context);
                },
                child: const Text("Profile"),
              ),
            )
          ],
        )),
        body: Container(
            child: viewModel.posts == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                          child: ListView.separated(
                        controller: viewModel._lvc,
                        itemBuilder: (listContext, listIndex) {
                          Widget res;
                          var posts = viewModel.posts;
                          if (posts != null) {
                            var post = posts[listIndex];
                            res = Container(
                              padding: const EdgeInsets.all(10),
                              height: screenWidth,
                              color: Colors.grey,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: PageView.builder(
                                      onPageChanged: (value) => viewModel
                                          .onPageChanged(listIndex, value),
                                      itemCount: post.contents.length,
                                      itemBuilder: (pageContext, pageIndex) =>
                                          Container(
                                        color: Colors.yellow,
                                        child: Image(
                                            image: NetworkImage(
                                          "$baseUrl${post.contents[pageIndex].contentLink}",
                                        )),
                                      ),
                                    ),
                                  ),
                                  PageIndicator(
                                    count: post.contents.length,
                                    current: viewModel.pager[listIndex],
                                  ),
                                  Text(post.description ?? "")
                                ],
                              ),
                            );
                          } else {
                            res = const SizedBox.shrink();
                          }
                          return res;
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: itemCount,
                      )),
                      if (viewModel.isLoading) const LinearProgressIndicator()
                    ],
                  )));
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppViewModel(context: context),
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
