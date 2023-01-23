import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/bloc/SideNavigation/sidenavigation_bloc.dart';
import 'package:watchlist/screens/AccountPage/account.dart';
import 'package:watchlist/screens/HomePage/home.dart';
// import 'package:watchlist/screens/SearchPage/searchPage.dart';
import 'package:watchlist/screens/SideMenu.dart';
// import 'package:watchlist/screens/LoginPage/login.dart';
// import 'package:watchlist/screens/moviePageDetailed.dart';
import 'package:watchlist/screens/MoviesPage/movies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:watchlist/services/getmoviedetails.dart';

import 'bloc/MovieTappedOnHomeBloc/movietap_bloc.dart';
import 'bloc/NavigationBloc/navigation_bloc.dart';
import 'model/movie_response.dart';
import 'services/getSearch.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Searching hs = Searching();
  List<MovieResponse> ms = await hs.getHomePage();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp(ms: ms)));
  runApp(MyApp(ms: ms));
}

class MyApp extends StatelessWidget {
  final List<MovieResponse> ms;
  const MyApp({super.key, required this.ms});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        // primaryColor: Color.fromARGB(255, 255, 255, 255),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavigationBloc()),
          BlocProvider(create: (context) => MovietapBloc(SearchingMovie())),
          BlocProvider(create: (context) => SideNavigationBloc())
        ],
        child: MyHomePage(title: 'My WatchList Application', ms: ms),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final List<MovieResponse> ms;
  const MyHomePage({super.key, required this.title, required this.ms});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(widget.title)),
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          if (state is NavigationHome) {
            return Home(ms: widget.ms);
          } else if (state is NavigationMovies) {
            return const Movies();
          } else if (state is NavigationAccount) {
            return const Account();
          } else {
            throw Exception();
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
              selectedItemColor: Colors.purple,
              unselectedItemColor: const Color.fromARGB(255, 252, 233, 255),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              onTap: (value) {
                if (value == 0) {
                  BlocProvider.of<NavigationBloc>(context).add(HomeClicked());
                  BlocProvider.of<SideNavigationBloc>(context)
                      .add(HomePressed());
                  BlocProvider.of<MovietapBloc>(context)
                      .add(MovieInitalComeBack());
                } else if (value == 1) {
                  BlocProvider.of<NavigationBloc>(context).add(MoviesClicked());
                } else if (value == 2) {
                  BlocProvider.of<NavigationBloc>(context)
                      .add(AccountClicked());
                }
              },
              currentIndex: state.index,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: "HomePage"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.movie), label: "Movies"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "Account"),
              ]);
        },
      ),
      drawer: const DrawerWidget(),
    );
  }
}
