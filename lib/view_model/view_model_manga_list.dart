// ignore_for_file: camel_case_types

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:personal_manga_reader/model/model_manga_item.dart';
import 'package:http/http.dart' as http;

class ViewModel_MangaList extends ChangeNotifier {
  List<MangaItem>? _mangaList = [];

  List<MangaItem>? get mangaList => _mangaList;

  void getMangaList(String searchedTitle, int offset) async {

    if(_mangaList!.isNotEmpty){
      _mangaList!.clear();
    }else{
      _mangaList = [];
    }
    

    Map<String, String> params = Map<String, String>();

    params = {"limit": "10", "offset": offset.toString()};
    if (searchedTitle != "") {
      params = {"title": searchedTitle};
    }
    Uri mangaLink = Uri.https("api.mangadex.org", "/manga", params);
    print(mangaLink);
    var response = await http.get(mangaLink);
    var responseJson = jsonDecode(response.body);
    for (var item in responseJson["data"]) {
      String tags = "";
      String title = item['attributes']['title']['en'] ?? "";
      String id = item['id'];
      String type = item['type'];
      String description = item['attributes']['description']['en'] ?? "";
      String status = item['attributes']['status'];
      String coverID = "";

      var relationships = item['relationships'];
      for (var data in relationships) {
        if (data['type'] != "cover_art") {
          continue;
        } else {
          coverID = data['id'] ?? "";
        }
      }
      MangaItem manga = MangaItem();
      manga.setInitialValue(title, type, description, status, tags, id, coverID);      
      _mangaList?.add(manga);
      
    }
      notifyListeners();

      loadMangaImage();
  }

  void loadMangaImage() async {
    for (MangaItem manga in _mangaList!) {
       await manga.getMangaImage();
    }
  }
}
