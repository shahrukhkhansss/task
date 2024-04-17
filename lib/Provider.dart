import 'package:flutter/cupertino.dart';

import 'model.dart';

class menuDataProvider extends ChangeNotifier {

  Articles? Details;

  Articles? get getDetails => Details;

  Detailspage(Articles? data) {
   Details = data;
    notifyListeners();
  }

}
