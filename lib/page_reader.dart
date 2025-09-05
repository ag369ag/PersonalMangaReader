// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personal_manga_reader/model/model_page_item.dart';
import 'package:personal_manga_reader/view_model/view_model_page_list.dart';

//=====================================================================
// Variable
ViewModel_PageList _viewModel_PageList = ViewModel_PageList();
double _screenWidth = 0;
double _screenHeight = 0;
bool shouldContinueLoading = true;
//=====================================================================

class PageReader extends StatefulWidget {
  String chapterID;
  PageReader({super.key, required this.chapterID});

  @override
  State<PageReader> createState() => _PageReaderState();
}

class _PageReaderState extends State<PageReader> {
  @override
  void initState() {
    super.initState();
    _viewModel_PageList.loadPage(widget.chapterID);
  }

  @override
  Widget build(BuildContext context) {
    _viewModel_PageList.addListener(() {
      setState(() {});
    });

    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      onPopInvoked: (didPop) {
        setState(() {
          shouldContinueLoading = false;
        });
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: _viewModel_PageList.pageList.map((page) {
                return PageWidget(pageItem: page);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class PageWidget extends StatefulWidget {
  ModelPageItem pageItem;
  PageWidget({super.key, required this.pageItem});

  @override
  State<PageWidget> createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  @override
  Widget build(BuildContext context) {
    widget.pageItem.addListener(() {
      setState(() {});
    });

    return widget.pageItem.image == ""
        ? SizedBox(
            width: _screenWidth,
            height: _screenHeight,
            child: Center(child: CircularProgressIndicator()),
          )
        : Image.memory(base64Decode(widget.pageItem.image));
  }
}
