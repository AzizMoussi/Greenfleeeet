// In your state class (e.g. TabProvider)
import 'package:flutter/cupertino.dart';

class TabProvider with ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
