
const String kBaseUrl = 'https://faceauth-server.onrender.com/api'; //'http://192.168.1.6:3006/api';


const String kAppName = 'UTS Recognition App';
const int kDefaultTimeoutSeconds = 30;


class ApiEndpoints {
  static const String login = '$kBaseUrl/sign-in';
  static const String locationById = '$kBaseUrl/get-location-by-id';
  static const String locations = '$kBaseUrl/all-locations';
  static const String validateFace = '$kBaseUrl/validate-access';
  static const String addLocation = '$kBaseUrl/create-location';
  static const String users = '$kBaseUrl/users';
  static const String updateUser = '$kBaseUrl/update-user';
  static const String deleteUser = '$kBaseUrl/delete-user';
  static const String myLocations = '$kBaseUrl/my-locations';
  static const String access = '$kBaseUrl/access-list';
  static const String myAccess = '$kBaseUrl/access-user';
}