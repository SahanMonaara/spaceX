// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'package:spacex_launch/models/launch.dart';

import '../helpers/app_logger.dart';
import '../network/net_exception.dart';
import '../network/net.dart';
import '../network/net_result.dart';
import '../network/net_url.dart';

class LaunchService {
  static final LaunchService _singleton = LaunchService._internal();
  static const String MAX_RESULTS_PER_PAGE = "20";

  factory LaunchService() {
    return _singleton;
  }

  LaunchService._internal();

  /// It fetches the list of launches from the SpaceX API.
  ///
  /// Returns:
  ///   Result object
  Future<Result> fetchLaunchesList() async {
    Result result = Result();
    try {
      var net = Net(
        url: URL.GET_LAUNCH_LIST,
        method: NetMethod.GET,
      );

      result = await net.perform();
      Log.debug("result is **** ${result.result}");

      if (result.exception == null && result.result != "") {
        result.result = launchFromJson(result.result);
      }
      return result;
    } catch (err) {
      Log.err("$err");
      result.exception = NetException(
          message: CommonMessages.ENDPOINT_NOT_FOUND,
          messageId: CommonMessageId.UNAUTHORIZED,
          code: ExceptionCode.CODE_000);
      return result;
    }
  }

  /// It fetches the launch details from the server.
  ///
  /// Args:
  ///   id (String): The id of the launch you want to fetch details for.
  ///
  /// Returns:
  ///   Result object
  Future<Result> fetchLaunchDetails(String id) async {
    Result result = Result();
    try {
      var net = Net(
          url: URL.GET_LAUNCH_DETAILS,
          method: NetMethod.GET,
          pathParam: {'{id}': id});

      result = await net.perform();
      Log.debug("result is **** ${result.result}");

      if (result.exception == null && result.result != "") {
        var data = json.decode(result.result);
        result.result = Launch.fromJson(data);
      }
      return result;
    } catch (err) {
      Log.err("$err");
      result.exception = NetException(
          message: CommonMessages.ENDPOINT_NOT_FOUND,
          messageId: CommonMessageId.UNAUTHORIZED,
          code: ExceptionCode.CODE_000);
      return result;
    }
  }
}
