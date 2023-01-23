import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:watchlist/screens/HomePage/AllListDisplay.dart';

import '../model/movie_response.dart';

class ListDisplayPage extends StatefulWidget {
  const ListDisplayPage({super.key, required this.listName, required this.ms});
  final String listName;
  final MovieResponse ms;
  @override
  State<ListDisplayPage> createState() => _ListDisplayPageState();
}

class _ListDisplayPageState extends State<ListDisplayPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        width: 500,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Color.fromARGB(255, 46, 15, 56)),
        child: SingleChildScrollView(
            child: SizedBox(
          width: 500,
          height: MediaQuery.of(context).size.height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: GridView.count(
                    childAspectRatio: 0.57,
                    mainAxisSpacing: 12,
                    crossAxisCount: 2,
                    scrollDirection: Axis.vertical,
                    children: [
                      ...?widget.ms.results
                          ?.map((e) => MovieSingleCard(movie: e ?? Result()))
                    ],
                  ),
                )
              ]),
        )));
  }
}
