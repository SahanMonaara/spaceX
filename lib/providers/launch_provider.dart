import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:spacex_launch/common/app_const.dart';
import 'package:spacex_launch/helpers/local_storage.dart';
import 'package:spacex_launch/models/launch.dart';
import 'package:spacex_launch/network/net_result.dart';
import 'package:spacex_launch/services/launch_service.dart';
import '../helpers/app_logger.dart';

class LaunchProvider with ChangeNotifier {
  bool isDataLoading = false;
  bool isDetailDataLoading = false;
  List<Launch> launchesList = [];
  Launch? currentLaunch;
  List<String> favouriteList = [];
  
  changeDataLoadingStatus(bool status) {
    isDataLoading = status;
    notifyListeners();
  }

  changeDetailDataLoadingStatus(bool status) {
    isDetailDataLoading = status;
    notifyListeners();
  }

  Future<Result> getLaunchesList() async {
    Result result = await LaunchService().fetchLaunchesList();
    if (result.exception == null) {
      launchesList.clear();
      launchesList.addAll(result.result);
      launchesList.sort((a, b) => a.dateUnix.compareTo(b.dateUnix));
      Log.debug("------launchList length--${launchesList.length}");
      isDataLoading = false;
    }
    notifyListeners();
    return result;
  }

  Future<Result> getLaunchDetails(String id) async {
    Result result = await LaunchService().fetchLaunchDetails(id);
    if (result.exception == null) {
      isDetailDataLoading = false;
    }
    currentLaunch = result.result;
    notifyListeners();
    return result;
  }

  tapOnFavourite(String id) {
    bool isAlreadyfavourite = favouriteList.any((element) => element == id);
    if (isAlreadyfavourite) {
      favouriteList.remove(id);
    } else {
      favouriteList.add(id);
    }
    saveFavouriteListInLocal();
    Log.debug('--favourite list--${favouriteList}');
    notifyListeners();
  }

  bool checkFavouriteStatus(String id) {
    bool isAlreadyfavourite = favouriteList.any((element) => element == id);
    if (isAlreadyfavourite) {
      return true;
    } else {
      return false;
    }
  }

  saveFavouriteListInLocal() {
    String jsonList = json.encode({AppConst.FAVOURITE_LIST: favouriteList});
    Log.debug("saved favourite list--$jsonList");
    LocalStorage().saveFavouriteList(jsonList);
  }

  fetchFavouriteListInLocal() async {
    String? jsonList = await LocalStorage().getFavouriteList();

    if (jsonList != null) {
      var data = json.decode(jsonList);
      Log.debug(" fetched from local--${data[AppConst.FAVOURITE_LIST]}");
      (data[AppConst.FAVOURITE_LIST] as List).forEach((element) {
        favouriteList.add('$element');
      });
      Log.debug("initial favourite list fetched from local--$favouriteList");
      notifyListeners();
    }
  }
}
