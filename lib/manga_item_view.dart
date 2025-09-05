// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:personal_manga_reader/model/model_manga_item.dart';

class MangaItemView extends StatefulWidget {
  MangaItem manga;
  MangaItemView({super.key, required this.manga});

  @override
  State<MangaItemView> createState() => _MangaItemViewState();
}

class _MangaItemViewState extends State<MangaItemView> {
  @override
  Widget build(BuildContext context) {
    widget.manga.addListener(() => mangaListener());
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: widget.manga.coverImage.isEmpty
                  ? CircularProgressIndicator()
                  : Image.memory(base64Decode(widget.manga.coverImage)),
            ),
            SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.manga.title,
                    maxLines: 2,
                    softWrap: true,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(widget.manga.status, style: TextStyle(fontSize: 17)),
                  Text(widget.manga.tags),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void mangaListener() {
    setState(() {});
  }
}
