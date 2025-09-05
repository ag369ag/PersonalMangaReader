// ignore_for_file: must_call_super, must_be_immutable

import 'package:flutter/material.dart';
import 'package:personal_manga_reader/model/model_manga_item.dart';
import 'package:personal_manga_reader/page_reader.dart';
import 'package:personal_manga_reader/view_model/view_model_chapter_list.dart';

//======================================================
// Variables
ViewModel_ChapterList _viewModelChapterList = ViewModel_ChapterList();
//======================================================

class PageMangaChapter extends StatefulWidget {
  MangaItem manga;
  PageMangaChapter({super.key, required this.manga});

  @override
  State<PageMangaChapter> createState() => _PageMangaChapterState();
}

class _PageMangaChapterState extends State<PageMangaChapter> {
  @override
  void initState() {
    _viewModelChapterList.loadChapters(widget.manga.id);
  }

  @override
  Widget build(BuildContext context) {
    _viewModelChapterList.addListener(() => chapterViewModelListener());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.manga.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Flex(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          direction: Axis.vertical,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: _viewModelChapterList.chapterList.map((chapter) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          shouldContinueLoading = true;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PageReader(chapterID: chapter.chapterID),
                          ),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: Text(
                                  "${chapter.chapterNumber} ${chapter.chapterTitle}",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  chapterViewModelListener() {
    setState(() {});
  }
}
