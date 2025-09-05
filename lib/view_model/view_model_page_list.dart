// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personal_manga_reader/model/model_page_item.dart';
import 'package:http/http.dart' as http;
import 'package:personal_manga_reader/page_reader.dart';

class ViewModel_PageList extends ChangeNotifier{

  List<ModelPageItem> _pageList = [];

  List<ModelPageItem> get pageList => _pageList;

  String _hashString = "";

  List<dynamic> _dataSaverPhoto = [];

  void loadPage(String chapterID)async{
    _pageList.clear();

    var getDataResponse = await http.get(Uri.parse(
        "http://api.mangadex.org/at-home/server/$chapterID"));
    var responseDecoded = jsonDecode(getDataResponse.body);
    _hashString = responseDecoded['chapter']['hash'];
    _dataSaverPhoto = responseDecoded['chapter']['dataSaver'];


    for(var a in _dataSaverPhoto){
      ModelPageItem page = ModelPageItem();
      page.setInitialValue("", "", _hashString, a);
      _pageList.add(page);
    }
    notifyListeners();
    
    updateImage();

  }

  void updateImage()async{
    for(ModelPageItem page in _pageList){
      if(!shouldContinueLoading){
        break;
      }
      bool loaded = await page.updateImageValue();
      while(!loaded){

      }
    }

    /*

    for (var a in _dataSaverPhoto) {
      var photo = http.get(
          Uri.parse("https://uploads.mangadex.org/data-saver/$_hashString/$a"));
      var getPhotos = await http.get(
          Uri.parse("https://uploads.mangadex.org/data-saver/$_hashString/$a"));
      var pageImage = getPhotos.bodyBytes;
      var pageImage1 = photo;
      
      print(a);
      
       pages.add(ReaderItem(data: "", image: base64Encode(pageImage)));
       pages.add(ReaderItem(data: "", image: base64Encode(pageImage)));
      
    }

    */
  } 
}