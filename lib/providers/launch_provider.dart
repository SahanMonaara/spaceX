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

  /// It changes the value of isDataLoading to the value of the parameter status and
  /// then notifies all the listeners.
  ///
  /// Args:
  ///   status (bool): The status of the data loading.
  changeDataLoadingStatus(bool status) {
    isDataLoading = status;
    notifyListeners();
  }

  /// It changes the loading status of the detail data.
  ///
  /// Args:
  ///   status (bool): The status of the loading.
  changeDetailDataLoadingStatus(bool status) {
    isDetailDataLoading = status;
    notifyListeners();
  }

  /// It fetches the list of launches from the API and stores it in the launchesList
  /// variable.
  ///
  /// Returns:
  ///   A Future<Result> is being returned.
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

  /// It fetches the launch details from the LaunchService and sets the
  /// currentLaunch variable to the result
  ///
  /// Args:
  ///   id (String): The id of the launch you want to fetch details for.
  ///
  /// Returns:
  ///   A Future<Result> object.
  Future<Result> getLaunchDetails(String id) async {
    Result result = await LaunchService().fetchLaunchDetails(id);
    if (result.exception == null) {
      isDetailDataLoading = false;
    }
    currentLaunch = result.result;
    notifyListeners();
    return result;
  }

  /// If the id is already in the favouriteList, remove it. Otherwise, add it
  ///
  /// Args:
  ///   id (String): The id of the product that is being tapped.
  tapOnFavourite(String id) {
    bool isAlreadyFavourite = favouriteList.any((element) => element == id);
    if (isAlreadyFavourite) {
      favouriteList.remove(id);
    } else {
      favouriteList.add(id);
    }
    saveFavouriteListInLocal();
    Log.debug('--favourite list--$favouriteList');
    notifyListeners();
  }

  /// It checks if the id of the current item is present in the list of favourite
  /// items
  ///
  /// Args:
  ///   id (String): The id of the product.
  ///
  /// Returns:
  ///   A boolean value.
  bool checkFavouriteStatus(String id) {
    bool isAlreadyfavourite = favouriteList.any((element) => element == id);
    if (isAlreadyfavourite) {
      return true;
    } else {
      return false;
    }
  }

  /// It takes the favouriteList and converts it to a json string and saves it in
  /// the local storage
  saveFavouriteListInLocal() {
    String jsonList = json.encode({AppConst.FAVOURITE_LIST: favouriteList});
    Log.debug("saved favourite list--$jsonList");
    LocalStorage().saveFavouriteList(jsonList);
  }

  /// It fetches the favourite list from the local storage and updates the favourite
  /// list in the model
  fetchFavouriteListInLocal() async {
    String? jsonList = await LocalStorage().getFavouriteList();

    if (jsonList != null) {
      var data = json.decode(jsonList);
      Log.debug(" fetched from local--${data[AppConst.FAVOURITE_LIST]}");
      for (var element in (data[AppConst.FAVOURITE_LIST] as List)) {
        favouriteList.add('$element');
      }
      Log.debug("initial favourite list fetched from local--$favouriteList");
      notifyListeners();
    }
  }
}
