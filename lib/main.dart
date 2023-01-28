import 'dart:async';
import 'package:cache_manager/cache_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/bloc/InternetBloc/internet_bloc.dart';
import 'package:watchlist/bloc/ListSectionMovie/list_section_movie_bloc.dart';
import 'package:watchlist/bloc/SideNavigation/sidenavigation_bloc.dart';
import 'package:watchlist/networkConnectivity.dart';
import 'package:watchlist/screens/AccountPage/account.dart';
import 'package:watchlist/screens/HomePage/home.dart';
import 'package:watchlist/screens/SideMenu.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavigationBloc()),
          BlocProvider(create: (context) => MovietapBloc(SearchingMovie())),
          BlocProvider(create: (context) => SideNavigationBloc()),
          BlocProvider(create: (context) => InternetBloc()),
          BlocProvider(create: (context) => ListSectionMovieBloc()),
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
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';
  @override
  void initState() {
    super.initState();
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      debugPrint('sourceee ${_source.keys.toList()}');
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
              _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
          break;
        case ConnectivityResult.wifi:
          string =
              _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
          break;
        case ConnectivityResult.none:
          string = 'Offline';
          break;
        default:
          string = 'Offline';
      }
      if (string != "Offline") {
        BlocProvider.of<InternetBloc>(context).add(InternetOn());
        var currNavigationState = context.read<NavigationBloc>().state;
        if (currNavigationState is NavigationHome) {
          BlocProvider.of<NavigationBloc>(context).add(HomeClicked());
          var currSideNavigationState =
              context.read<SideNavigationBloc>().state;
          if (currSideNavigationState is SideNavigationPopular) {
            BlocProvider.of<SideNavigationBloc>(context).add(PopularPressed());
          } else if (currSideNavigationState is SideNavigationSearch) {
            BlocProvider.of<SideNavigationBloc>(context).add(SearchPressed());
          } else if (currSideNavigationState is SideNavigationUpcoming) {
            BlocProvider.of<SideNavigationBloc>(context).add(UpcomingPressed());
          } else if (currSideNavigationState is SideNavigationTopRated) {
            BlocProvider.of<SideNavigationBloc>(context).add(TopRatedPressed());
          } else if (currSideNavigationState is SideNavigationInitialHome) {
            BlocProvider.of<SideNavigationBloc>(context).add(HomePressed());
          }
        } else if (currNavigationState is NavigationMovies) {
          BlocProvider.of<NavigationBloc>(context).add(MoviesClicked());
        } else if (currNavigationState is NavigationAccount) {
          BlocProvider.of<NavigationBloc>(context).add(AccountClicked());
        }
      } else {
        BlocProvider.of<InternetBloc>(context)
            .add(InternetOff(timeStamp: DateTime.now().minute));
        WriteCache.setInt(key: "NoInternet", value: DateTime.now().minute);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            string,
            style: const TextStyle(fontSize: 30),
          ),
        ),
      );
    });
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 4), (Timer t) async {
      var internetStatus = context.read<InternetBloc>().state;
      int currTime = DateTime.now().minute;
      if (internetStatus is NoInternet) {
        int lastInternetOff = await ReadCache.getInt(key: "NoInternet");
        if (currTime - lastInternetOff > 2) {
          FirebaseAuth.instance.signOut();
        }
      }
    });

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
