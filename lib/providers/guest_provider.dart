import 'package:even_hub/models/speaker_model.dart';
import 'package:flutter/foundation.dart';

class GuestProvider extends ChangeNotifier {
  List<SpeakerModel> _guestList = [];

  //getter
  List<SpeakerModel> get getGuestList => _guestList;

  //setter
  void addNewGuest({required SpeakerModel guestData}) {
    _guestList.add(guestData);
    notifyListeners();
  }

  //delete data
  void deleteGuestData({required SpeakerModel deleteData}) {
    _guestList.remove(deleteData);
    notifyListeners();
  }
}
