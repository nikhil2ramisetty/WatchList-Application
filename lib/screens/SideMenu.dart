import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/bloc/NavigationBloc/navigation_bloc.dart';
import 'package:watchlist/bloc/SideNavigation/sidenavigation_bloc.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 38, 25, 43),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          const DrawerHeader(
              margin: EdgeInsets.only(bottom: 70),
              decoration: BoxDecoration(color: Colors.purple),
              child: Text("My WatchList Application",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.white70))),
          // hoverColor: Color.fromARGB(255, 196, 111, 178),
          ListTile(
            title: RichText(
              text: TextSpan(
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 221, 194, 235),
                  ),
                  children: [
                    WidgetSpan(
                        child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: const Icon(
                          color: Color.fromARGB(255, 221, 194, 235),
                          Icons.home),
                    )),
                    const TextSpan(text: "Home"),
                  ]

                  // textAlign: TextAlign.center,
                  ),
            ),
            onTap: () {
              BlocProvider.of<SideNavigationBloc>(context).add(HomePressed());
              BlocProvider.of<NavigationBloc>(context).add(HomeClicked());
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: RichText(
              text: TextSpan(
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 221, 194, 235),
                  ),
                  children: [
                    WidgetSpan(
                        child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: const Icon(
                          color: Color.fromARGB(255, 221, 194, 235),
                          Icons.search),
                    )),
                    const TextSpan(text: "Search"),
                  ]

                  // textAlign: TextAlign.center,
                  ),
            ),
            onTap: () {
              BlocProvider.of<SideNavigationBloc>(context).add(SearchPressed());
              BlocProvider.of<NavigationBloc>(context).add(HomeClicked());
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: RichText(
              text: TextSpan(
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 221, 194, 235),
                  ),
                  children: [
                    WidgetSpan(
                        child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: const Icon(
                          color: Color.fromARGB(255, 221, 194, 235),
                          Icons.trending_up_outlined),
                    )),
                    const TextSpan(text: "Popular"),
                  ]

                  // textAlign: TextAlign.center,
                  ),
            ),
            onTap: () {
              BlocProvider.of<SideNavigationBloc>(context)
                  .add(PopularPressed());
              BlocProvider.of<NavigationBloc>(context).add(HomeClicked());
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: RichText(
              text: TextSpan(
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 221, 194, 235),
                  ),
                  children: [
                    WidgetSpan(
                        child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: const Icon(
                          color: Color.fromARGB(255, 221, 194, 235),
                          Icons.upcoming),
                    )),
                    const TextSpan(text: "Upcoming"),
                  ]

                  // textAlign: TextAlign.center,
                  ),
            ),
            onTap: () {
              BlocProvider.of<SideNavigationBloc>(context)
                  .add(UpcomingPressed());
              BlocProvider.of<NavigationBloc>(context).add(HomeClicked());
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: RichText(
              text: TextSpan(
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 221, 194, 235),
                  ),
                  children: [
                    WidgetSpan(
                        child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: const Icon(
                          color: Color.fromARGB(255, 221, 194, 235),
                          Icons.movie),
                    )),
                    const TextSpan(text: "Top Rated"),
                  ]

                  // textAlign: TextAlign.center,
                  ),
            ),
            onTap: () {
              BlocProvider.of<SideNavigationBloc>(context)
                  .add(TopRatedPressed());
              BlocProvider.of<NavigationBloc>(context).add(HomeClicked());
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
