// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:personal_manga_reader/controller/controller_manga_list.dart';
import 'package:personal_manga_reader/manga_item_view.dart';

late MangaListController _mangaController;

class MangaListView extends StatefulWidget {
  bool isGridView;
  int offset;
  String search;
  MangaListView({
    super.key,
    required this.isGridView,
    required this.offset,
    required this.search,
  });

  @override
  State<MangaListView> createState() => _MangaListViewState();
}

class _MangaListViewState extends State<MangaListView> {
  @override
  Widget build(BuildContext context) {
    //mangaController.loadManga();

    return FutureBuilder<Widget>(
      future: getManga(),
      builder: (context, AsyncSnapshot<Widget> asyncSnasphot) {
        if (asyncSnasphot.hasData) {
          return asyncSnasphot.data!;
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<Widget> getManga() async {
    _mangaController = MangaListController(
      offset: widget.offset * 10,
      searchedTitle: widget.search,
    );

    var mangaList = await _mangaController.loadManga();

    var result = widget.isGridView
        ? GridView.count(
            crossAxisCount: 2,
            children: mangaList.map((e) {
              return MangaItemView(manga: e);
            }).toList(),
          )
        : ListView.builder(
            itemCount: mangaList.length,
            itemBuilder: (context, index) {
              return MangaItemView(manga: mangaList[index]);
            },
          );

    _mangaController.loadMangaImage();

    return result;
  }
}
