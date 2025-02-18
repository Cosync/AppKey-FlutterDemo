class AppkeyError {

  final int code;
  final String message;

  const AppkeyError({
    required this.code,
    required this.message
  });


  factory AppkeyError.fromJson(Map<String, dynamic> json) {
    return AppkeyError(
      code: json['code'],
      message: json['message'],
    );
  }

  factory AppkeyError.defaultError() {
    return AppkeyError(
      code: 404,
      message: "Something went wrong.",
    );
  }

}