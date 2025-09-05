import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personal_manga_reader/api_service/service_manga_list.dart';
import 'package:personal_manga_reader/model/model_manga_item.dart';
import 'package:http/http.dart' as http;

class MangaListController extends ChangeNotifier{
  
  int offset;
  String searchedTitle;
  
  MangaListController({required this.offset, required this.searchedTitle});
  
  MangaListService mangaService = MangaListService();

  List<MangaItem> _mangaList = [];

  List<MangaItem> getMangaList(){
    return _mangaList;
  }

  void loadMangaImage()async{
    for(MangaItem manga in _mangaList){

    //   try{
    //   manga.coverImage = "";
    //   if (manga.coverID == "" || manga.coverImage != "") {
    //       return;
    //     }
    //     var getMangaCoverID =
    //         await http.get(Uri.https("api.mangadex.org", '/cover/${manga.coverID}'));
    //     var getMangaCoverJson = jsonDecode(getMangaCoverID.body);
    //     var coverFileName = getMangaCoverJson["data"]["attributes"]["fileName"];
    //     var getMangaCoverImage = await http.get(Uri.parse(
    //         'http://uploads.mangadex.org/covers/${manga.id}/$coverFileName.256.jpg'));
    //     var mangaCoverImage = getMangaCoverImage.bodyBytes;

    //     manga.coverImage = base64Encode(mangaCoverImage);

    //     print('http://uploads.mangadex.org/covers/${manga.id}/$coverFileName.256.jpg');


    // } catch(_){
    // }

    manga.getMangaImage();
    notifyListeners();
    }
  }



  Future<List<MangaItem>> loadManga() async{
    //List<MangaItem> mangalist = [];

    Map<String, String> params = Map<String, String>();

    params = { "limit" : "10" ,"offset" : offset.toString()};
    if(searchedTitle != ""){
      params = {"title" : searchedTitle};
    }
    Uri mangaLink = Uri.https("api.mangadex.org", "/manga" ,params);
    print(mangaLink);
    var response = await http.get(mangaLink);
    var responseJson = jsonDecode(response.body);
    for(var item in responseJson["data"]){
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

      //MangaItem manga = MangaItem(title: title, type: type, description: description, status: status, tags: tags, id: id, coverID: coverID, coverImage: "");
      MangaItem manga = MangaItem();
      manga.setInitialValue(title, type, description, status, tags, id, coverID);  
      _mangaList.add(manga);
      //mangalist.add(manga);
    }

    

    return _mangaList;

    //return mangalist;
  }

}