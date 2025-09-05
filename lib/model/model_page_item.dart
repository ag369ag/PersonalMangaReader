import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ModelPageItem extends ChangeNotifier{
  String _data = "";
  String _image = "";
  String _hash = "";
  String _a = "";

  String get data => _data;
  String get image => _image;

  void setInitialValue(String pageData, String pageImage, String hash, String a){
    _data = pageData;
    _image = pageImage;
    _hash = hash;
    _a = a;
    notifyListeners();
  }

  Future<bool> updateImageValue()async{
      var getPhotos = await http.get(
          Uri.parse("https://uploads.mangadex.org/data-saver/$_hash/$_a"));
      var pageImage = getPhotos.bodyBytes;
    _image = base64Encode(pageImage);
    print(_image);
    notifyListeners();

    return true;
  }
}