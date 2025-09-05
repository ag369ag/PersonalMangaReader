// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personal_manga_reader/model/model_chapter_item.dart';
import 'package:http/http.dart' as http;

class ViewModel_ChapterList extends ChangeNotifier{

  List<Chapters> _chapterList = [];

  List<Chapters> get chapterList => _chapterList;

  void loadChapters(mangaID)async{
    _chapterList.clear();
    var getChapterResponse = await http
        .get(Uri.parse("http://api.mangadex.org/manga/$mangaID/feed"));
    var responseDecoded = jsonDecode(getChapterResponse.body);
    var chapters = responseDecoded['data'];
    for (var item in chapters) {
      var language = item['attributes']['translatedLanguage'];
      if (language == "en") {
        Chapters chapter = Chapters();
        chapter.setInitialValue(item['id'], double.parse(item['attributes']['chapter'].toString()), (item['attributes']['title']).toString() ?? "");
        _chapterList.add(chapter);
      } else {
        continue;
      }
    }
    _chapterList.sort(((a, b) => a.chapterNumber.compareTo(b.chapterNumber)));
    notifyListeners();
  }
  
}