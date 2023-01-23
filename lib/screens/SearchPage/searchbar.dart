import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/MovieSearchBloc/moviesearch_bloc.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: "Search Movies"),
          controller: _textEditingController,
          onChanged: (value) {
            Future.delayed(const Duration(seconds: 0), () {
              if (value != "") {
                BlocProvider.of<MoviesearchBloc>(context)
                    .add(SearchClicked(movieName: _textEditingController.text));
              } else {
                BlocProvider.of<MoviesearchBloc>(context)
                    .add(SearchClicked(movieName: _textEditingController.text));
              }
            });
          },
        )
      ],
    );
  }
}
