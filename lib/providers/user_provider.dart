
import 'package:flutter/material.dart';
import '../models/user_data.dart';
import '../models/admin_access_entry.dart';

class UserProvider with ChangeNotifier {
  UserData? _currentUser;
  //List<AccessEntry>? _currentAccessInfo;

  UserData? get currentUser => _currentUser;
  //List<AccessEntry>? get currentAccessInfo => _currentAccessInfo;

  bool get currentUserLoaded => _currentUser != null;

  void setUser(Map<String, dynamic> userDataMap) {
    _currentUser = UserData.fromJson(userDataMap);
    notifyListeners();
  }

  void setAccessInfo(List<dynamic> accessInfoList) {
    //_currentAccessInfo = accessInfoList.map((item) => AccessEntry.fromJson(item)).toList();
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    //_currentAccessInfo = null;
    notifyListeners();
  }
}