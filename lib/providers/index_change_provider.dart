import 'package:flutter/material.dart';

class IndexChangeProvider extends ChangeNotifier {
  int _pageindex = 0;

  //setter
  void changePageIndex({required int index}) {
    _pageindex = index;
    notifyListeners();
  }

  //getter
  int get getCurruentIndex => _pageindex;
}
