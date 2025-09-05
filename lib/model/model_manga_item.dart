import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MangaItem extends ChangeNotifier{
  String _title = "";
  String _type = "";
  String _description = "";
  String _status = "";
  String _tags = "";
  String _id = "";
  String _coverID = "";
  String _coverImage = "";

  String get title => _title;
  String get type => _type;
  String get description => _description;
  String get status => _status;
  String get tags => _tags;
  String get id => _id;
  String get coverID => _coverID;
  String get coverImage => _coverImage;

  void setCoverImage(String val){
    _coverImage = val;
  }

  void setInitialValue(String mangaTitle, String mangaType, String mangaDescription, String mangaStatus, String mangaTags, String mangaID, String mangaCoverID){
      _title = mangaTitle;
      _type = mangaType;
      _description = mangaDescription;
      _status = mangaStatus;
      _tags = mangaTags;
      _id = mangaID;
      _coverID = mangaCoverID;
      setCoverImage("");
  }

  Future<bool> getMangaImage()async{
    try{
      if (_coverID == "" || _coverImage != "") {
          return true;
        }
        var getMangaCoverID =
            await http.get(Uri.https("api.mangadex.org", '/cover/$_coverID'));
        var getMangaCoverJson = jsonDecode(getMangaCoverID.body);
        var coverFileName = getMangaCoverJson["data"]["attributes"]["fileName"];
        //print(coverFileName);
        var getMangaCoverImage = await http.get(Uri.parse(
            'http://uploads.mangadex.org/covers/$id/$coverFileName.256.jpg'));
        print('http://uploads.mangadex.org/covers/$id/$coverFileName.256.jpg');
        var mangaCoverImage = getMangaCoverImage.bodyBytes;

        setCoverImage(base64Encode(mangaCoverImage));
       notifyListeners();
    return true;

    } catch(e){
      return false;
    }
  }
}