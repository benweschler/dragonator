//TODO: change to shared enum for all firebase errors and convert to switch statement from error codes
abstract class LoginErrors {
  static const String networkError =
      "Hmm, we can't seem to connect to the internet. Please check your network connection and try again.";
  static const String invalidLogin =
      "We couldn't find an account with that information. Please check your email and password and try again.";
}
