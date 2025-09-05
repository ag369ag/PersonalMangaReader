class Chapters {
  String _chapterID = "";
  double _chapterNumber = 0;
  String _chapterTitle = "";

  String get chapterID => _chapterID;
  double get chapterNumber => _chapterNumber;
  String get chapterTitle => _chapterTitle;

  void setInitialValue(String chapID, double chapNum, String chapTitle){
      _chapterID = chapID;
      _chapterNumber = chapNum;
      _chapterTitle = chapTitle;
  }




  // factory Chapters.fromJson(Map<String, dynamic> json) {
  //   return Chapters(
  //       chapterID: json['chapterID'],
  //       chapterNumber: json['chapterNumber'],
  //       chapterTitle: json['chapterTitle']);
  // }

  
}
