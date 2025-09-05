import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personal_manga_reader/components/custom_elevated_button.dart';
import 'package:personal_manga_reader/controller/controller_manga_list.dart';
import 'package:personal_manga_reader/manga_item_view.dart';
import 'package:personal_manga_reader/model/model_manga_item.dart';
import 'package:personal_manga_reader/page_manga_chapters.dart';
import 'package:personal_manga_reader/view_model/view_model_manga_list.dart';
import 'package:provider/provider.dart';

//============================  Variables  =============================
bool _isLoading = false;
bool _leftButtonIsPressed = false;
bool _rightButtonIsPressed = false;
int _pageNumber = 1;
String _searchedTitle = "";
//bool _isGridView = false;
late List<MangaItem> _mangaList;
late MangaListController _mangaController;
ViewModel_MangaList _viewModelMangaList = ViewModel_MangaList();
double _screenWidth = 0;
double _screenHeight = 0;
TextEditingController _searchFieldController = TextEditingController();
//=======================================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainPage());
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: MangaListUIStateLess(),
        ),
      ),
    );
  }
}

class MangaListUIStateLess extends StatefulWidget {
  const MangaListUIStateLess({super.key});

  @override
  State<MangaListUIStateLess> createState() => _MangaListUIStateLessState();
}

class _MangaListUIStateLessState extends State<MangaListUIStateLess> {
  @override
  void initState() {
    super.initState();
    _viewModelMangaList.getMangaList(_searchedTitle, (_pageNumber - 1) * 10);
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    _viewModelMangaList.addListener(() {
      setState(() {});
    });

    // Future.delayed(Duration(seconds: 2), (){
    //   _viewModelMangaList.getMangaList(
    //                   "",
    //                   (_pageNumber - 1) * 10,
    //                 );
    // });

    return Flex(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      direction: Axis.vertical,
      children: [
        Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              child: TextField(
                controller: _searchFieldController,
                maxLines: 1,
                onChanged: (value) {
                  _searchedTitle = value;
                },
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {});
                _viewModelMangaList.getMangaList(_searchedTitle, (_pageNumber - 1) * 10);
              },
              icon: Icon(Icons.search),
            ),
          ],
        ),
        Flexible(
          child:
              _viewModelMangaList.mangaList!.isEmpty ||
                  _viewModelMangaList.mangaList == null
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _viewModelMangaList.mangaList!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showDialogForManga(
                        _viewModelMangaList.mangaList![index],
                        context,
                      ),
                      child: MangaItemView(
                        manga: _viewModelMangaList.mangaList![index],
                      ),
                    );
                  },
                ),
        ),
        Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomElevatedButton(
              buttonFunction: () => _backButtonPressed(),
              buttonText: "Back",
              isPressed: _leftButtonIsPressed,
              isLoading: _isLoading,
              pageNumber: _pageNumber,
            ),
            Text(_pageNumber.toString()),
            CustomElevatedButton(
              buttonFunction: () => _nextButtonPressed(),
              buttonText: "Next",
              isPressed: _rightButtonIsPressed,
              isLoading: _isLoading,
              pageNumber: _pageNumber,
            ),
          ],
        ),
      ],
    );
  }

  _showDialogForManga(MangaItem manga, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Card(
          child: Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: _screenWidth * 0.4,
                      height: _screenHeight * 0.3,
                      child: Image.memory(
                        base64Decode(manga.coverImage),
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            manga.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 3,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(manga.status, style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text("Description"),
                Flexible(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Text(manga.description, softWrap: true),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PageMangaChapter(manga: manga),
                        ),
                      ),
                      child: Text("Read"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Close"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _backButtonPressed() async {
    if (_pageNumber <= 1 || _searchedTitle.isEmpty) {
      return;
    }
    _pageNumber--;
    _leftButtonIsPressed == true;

    Future.delayed(Duration(seconds: 2), () {
      _loadingFinished();
    });
  }

  _loadingFinished() {
    if(_searchedTitle.isEmpty){
      _leftButtonIsPressed = false;
      _rightButtonIsPressed = false;
      _isLoading = false;
    }
    _viewModelMangaList.getMangaList(_searchedTitle, (_pageNumber - 1) * 10);
  }

  _nextButtonPressed() {
    if(_searchedTitle.isEmpty){
      _pageNumber++;
      _rightButtonIsPressed = true;
    }

    Future.delayed(Duration(seconds: 2), () {
      _loadingFinished();
    });
  }
}

/*
class MangaListUI extends StatefulWidget {
  const MangaListUI({super.key});

  @override
  State<MangaListUI> createState() => _MangaListUIState();
}

class _MangaListUIState extends State<MangaListUI> {
  final ValueNotifier<bool> _doneLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Flex(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      direction: Axis.vertical,
      children: [
        Flexible(
          child: FutureBuilder<Widget>(
            future: getManga(),
            builder: (context, AsyncSnapshot<Widget> asyncSnasphot) {
              if (asyncSnasphot.hasData) {
                return asyncSnasphot.data!;
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomElevatedButton(
              buttonFunction: () => _backButtonPressed(),
              buttonText: "Back",
              isPressed: _leftButtonIsPressed,
              isLoading: _isLoading,
              pageNumber: _pageNumber,
            ),
            Text(_pageNumber.toString()),
            CustomElevatedButton(
              buttonFunction: () => _nextButtonPressed(),
              buttonText: "Next",
              isPressed: _rightButtonIsPressed,
              isLoading: _isLoading,
              pageNumber: _pageNumber,
            ),
          ],
        ),
      ],
    );
  }

  _backButtonPressed() async {
    if (_pageNumber <= 1) {
      return;
    }
    _pageNumber--;
    _leftButtonIsPressed == true;
    setState(() {});

    Future.delayed(Duration(seconds: 2), () {
      _loadingFinished();
    });
  }

  _loadingFinished() {
    _leftButtonIsPressed = false;
    _rightButtonIsPressed = false;
    _isLoading = false;
    setState(() {});
  }

  _nextButtonPressed() {
    _pageNumber++;
    _rightButtonIsPressed = true;
    setState(() {});

    Future.delayed(Duration(seconds: 2), () {
      _loadingFinished();
    });
  }

  Future<Widget> getManga() async {
    _mangaController = MangaListController(
      offset: (_pageNumber - 1) * 10,
      searchedTitle: "",
    );
    _mangaList = await _mangaController.loadManga();

    var res = ListView.builder(
      itemCount: _mangaList.length,
      itemBuilder: (context, index) {
        _mangaList[index].getMangaImage();

        return MangaItemView(
          coverImage: _mangaList[index].coverImage,
          title: _mangaList[index].title,
          status: _mangaList[index].status,
          tags: _mangaList[index].tags,
        );
      },
    );
    _doneLoading.value = true;
    return res;
  }
}

*/


// public function asd(){
//   try{


//   } catch (Exception e){

//       return response(array("result" => e.message), 500);
//   }

//   return response(array("result" => "Success"), 200);

// }