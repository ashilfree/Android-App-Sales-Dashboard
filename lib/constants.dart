class Constants {
  static const String appLink =
      'https://client.aqs.dz/api/'; //production by HTTPS
        //'http://client.aqs.dz:8084/api/'; //production without HTTPS
      //'http://10.1.10.128:8082/api/'; //developpement without HTTPS
  static const int timeOut = 15;
}

enum Status { USER, ADMIN, SUPERADMIN }
