import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_networking_project/firebase/data_service.dart';
import 'package:school_networking_project/pages/create_user.dart';
import 'package:school_networking_project/pages/main_pages/class_screen.dart';
import 'package:school_networking_project/pages/main_pages/home_screen.dart';
import 'package:school_networking_project/pages/main_pages/profile_screen.dart';
import 'package:school_networking_project/pages/main_pages/search_screen.dart';
import 'package:school_networking_project/types/user_info.dart' as local;
import '../firebase/auth_firebase_service.dart';
import 'login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late ValueNotifier<GraphQLClient> client;
  final HttpLink httpLink = HttpLink("http://localhost:4000/");
  Future<local.UserInfo>? user;

  void callback(local.UserInfo? userInfo) {
    setState(() {
      user = DataService().getOrCreateUser(
        client,
        {
          "userID": userInfo!.id,
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<firebase.User?>(
      stream: firebase.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoginScreen();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        local.UserInfo firebaseUserInfo = local.UserInfo(
          name: AuthService.user!.displayName,
          email: AuthService.user!.email,
          photoUrl: AuthService.user!.photoURL,
          schoolInfo: null,
        );

        firebaseUserInfo.id = AuthService.user!.uid;

        client = ValueNotifier<GraphQLClient>(
          GraphQLClient(
            link: httpLink,
            cache: GraphQLCache(
              partialDataPolicy: PartialDataCachePolicy.acceptForOptimisticData,
            ),
          ),
        );

        user = DataService().getOrCreateUser(
          client,
          firebaseUserInfo.toJson(),
        );

        return FutureBuilder<local.UserInfo>(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Err...");
            } else if (snapshot.hasData) {
              if (snapshot.data!.exists!) {
                return MainScreen(
                  client: client,
                );
              } else {
                return CreateUser(
                  client: client,
                  callback: callback,
                );
              }
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.client,
  });

  final ValueNotifier<GraphQLClient> client;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: widget.client,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
          title: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        AuthService.user!.photoURL!,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Text(
                  "${AuthService.user!.displayName}",
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBarFb3(
          pageController: _pageController,
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            HomeScreen(client: widget.client),
            SearchScreen(client: widget.client),
            ClassScreen(client: widget.client),
            ProfileScreen(client: widget.client),
          ],
        ),
      ),
    );
  }
}

class BottomNavBarFb3 extends StatefulWidget {
  const BottomNavBarFb3({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  State<BottomNavBarFb3> createState() => _BottomNavBarFb3State();
}

class _BottomNavBarFb3State extends State<BottomNavBarFb3> {
  final List<bool> selected = [
    true,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).secondaryHeaderColor,
      child: SizedBox(
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconBottomBar2(
                text: "Home",
                icon: selected[0] ? Icons.home : Icons.home_outlined,
                selected: selected[0],
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < selected.length; i++) {
                      selected[i] = false;
                    }

                    selected[0] = true;

                    widget.pageController.animateToPage(
                      0,
                      duration: const Duration(
                        milliseconds: 500,
                      ),
                      curve: Curves.easeInOut,
                    );
                  });
                },
              ),
              const Spacer(),
              IconBottomBar(
                text: "Search",
                icon: Icons.search_outlined,
                selected: selected[1],
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < selected.length; i++) {
                      selected[i] = false;
                    }

                    selected[1] = true;

                    widget.pageController.animateToPage(
                      1,
                      duration: const Duration(
                        milliseconds: 500,
                      ),
                      curve: Curves.easeInOut,
                    );
                  });
                },
              ),
              IconBottomBar(
                text: "Cart",
                icon: Icons.class_outlined,
                selected: selected[2],
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < selected.length; i++) {
                      selected[i] = false;
                    }

                    selected[2] = true;

                    widget.pageController.animateToPage(
                      2,
                      duration: const Duration(
                        milliseconds: 500,
                      ),
                      curve: Curves.easeInOut,
                    );
                  });
                },
              ),
              IconBottomBar(
                text: "Calendar",
                icon: Icons.person_4_outlined,
                selected: selected[3],
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < selected.length; i++) {
                      selected[i] = false;
                    }

                    selected[3] = true;

                    widget.pageController.animateToPage(
                      3,
                      duration: const Duration(
                        milliseconds: 500,
                      ),
                      curve: Curves.easeInOut,
                    );
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  const IconBottomBar({
    Key? key,
    required this.text,
    required this.icon,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 25,
            color: selected ? Theme.of(context).primaryColor : Colors.black,
          ),
        ),
      ],
    );
  }
}

class IconBottomBar2 extends StatelessWidget {
  const IconBottomBar2({
    Key? key,
    required this.text,
    required this.icon,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: selected
          ? Theme.of(context).primaryColor
          : Theme.of(context).disabledColor,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }
}
