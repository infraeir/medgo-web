abstract class API {
  static const String contentTypeHeader = 'application/json; charset=UTF-8';

  // SignIn
  static const String login = 'auth/doctors/login';
  static const String recoverPassword = 'auth/recover-password';
  static const String resetPassword = 'auth/reset-password';

  // Logout
  static const String logout = 'auth/doctors/logout';
  static const String emailHeaderName = 'email';
  static const String passwordHeaderName = 'password';
  //Jwt Token
  static const String applicationJson = "application/json";
  static const String token =
      "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NDlhMDQ3MjJiM2EzYTgyYjk0NTM3ODEiLCJ1c2VybmFtZSI6InBlZHJvZmVsaXBlLmVpckBnbWFpbC5jb20iLCJyb2xlIjoiZG9jdG9yIiwiaWF0IjoxNjkwMTQwODE4LCJleHAiOjE2OTAyMjcyMTh9.Ig8fgzdD8ubG4bCUDGyc36TtM5AdYusITodvZSG0vjs";
}
