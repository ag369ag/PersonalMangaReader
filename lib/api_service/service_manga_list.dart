import 'dart:convert';

import 'package:personal_manga_reader/model/model_manga_item.dart';
import 'package:http/http.dart' as http;


class MangaListService{

  Future<List<MangaItem>> loadManga(int limit, int offset, String searchedItem) async{
    List<MangaItem> mangalist = [];

    Map<String, String> params = Map<String, String>();

    params = { "limit" : limit.toString() ,"offset" : offset.toString()};
    if(searchedItem != ""){
      params = {"title" : searchedItem};
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

      MangaItem manga = MangaItem();
      manga.setInitialValue(title, type, description, status, tags, id, coverID);  
      mangalist.add(manga);
    }



    return mangalist;
  }

}