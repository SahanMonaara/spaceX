// ignore_for_file: non_constant_identifier_names

/// It contains all the URLs that we will be using in our app
class URL {
  static String SERVER = "https://api.spacexdata.com/v5";

  static String SERVER2 = "https://api.spacexdata.com/v4";

  static String GET_LAUNCH_LIST = "$SERVER/launches";

  static String GET_LAUNCH_DETAILS = "$SERVER/launches/{id}";

  static String GET_ROCKET_DETAILS = "$SERVER2/rockets/{id}";

  static String COMPLETE_RIDE_BY_RIDE_ID = "$SERVER/ride/{rideId}/finish";
}
