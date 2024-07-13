import 'package:dio/dio.dart' as d;

ErrorResponse handleError(d.DioError error) {
  if ((error.response!.statusCode == 401 ||
      error.response!.statusCode == 403)) {
    if (error.response!.data.containsKey("message")) {
      return ErrorResponse(
        errors: [Error(detail: error.response!.data['message'])],
      );
    }
    return ErrorResponse(
      errors: [Error(detail: error.response!.data['error'])],
    );
  }

  ErrorResponse errorResponse = ErrorResponse();

  switch (error.type) {
    case d.DioErrorType.cancel:

    case d.DioErrorType.connectionError:
      break;
    case d.DioErrorType.connectionTimeout:
      errorResponse = ErrorResponse(errors: [Error(detail: 'Server timeout')]);
      break;
    case d.DioErrorType.receiveTimeout:
      errorResponse = ErrorResponse(errors: [Error(detail: 'Server timeout')]);
      break;
    case d.DioErrorType.sendTimeout:
      errorResponse = ErrorResponse(errors: [Error(detail: 'Server timeout')]);
      break;
    case d.DioErrorType.badCertificate:
      errorResponse =
          ErrorResponse(errors: [Error(detail: 'Something went wrong!')]);
      break;

    case d.DioErrorType.badResponse:
      errorResponse = ErrorResponse(errors: [Error(detail: 'Bad Response')]);
      break;
    case d.DioErrorType.cancel:
      errorResponse = ErrorResponse(
        errors: [Error(detail: 'Request cancelled!')],
      );
      break;
    case d.DioErrorType.connectionError:
      if (error.response != null && error.response!.data != null) {
        try {
          errorResponse = ErrorResponse.fromJson(error.response!.data);
        } catch (e) {
          errorResponse = ErrorResponse(errors: [
            Error(detail: 'Something went wrong! Please try again')
          ]);
        }
      } else {
        errorResponse = ErrorResponse(
            errors: [Error(detail: 'Something went wrong! Please try again')]);
      }

      break;
    case d.DioExceptionType.unknown:
      errorResponse =
          ErrorResponse(errors: [Error(detail: 'Something went wrong!')]);
      break;
  }
  return errorResponse;
}

class ErrorResponse {
  ErrorResponse({
    this.errors,
  });

  final List<Error>? errors;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        errors: List<Error>.from(json["errors"].map((x) => Error.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "errors": List<dynamic>.from(errors!.map((x) => x.toJson())),
      };

  Map<String, String> simplify() {
    Map<String, String> errorsMap = Map();
    errors!.forEach((e) {
      if (e.source != null && e.source!.pointer!.isNotEmpty) {
        errorsMap[e.source!.pointer!] = e.detail!;
      }
    });
    if (errorsMap.isEmpty) {
      String detail = errors!.first.detail!;
      String status = errors!.first.status!;
      if (detail.toLowerCase().contains('sqlstate') ||
          errors!.first.status == '500') {
        errorsMap = {'general': 'Something went wrong!', 'code': status};
      } else {
        errorsMap = {'general': detail, 'code': status};
      }
    }
    return errorsMap;
  }

  String? get generalError => simplify()['general'];
}

class Error {
  Error({
    this.status,
    this.code,
    this.title,
    this.detail,
    this.source,
  });

  final String? status;
  final String? code;
  final String? title;
  final String? detail;
  final Source? source;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        status: json["status"],
        code: json["code"],
        title: json["title"],
        detail: json["detail"],
        source: Source.fromJson(json["source"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "title": title,
        "detail": detail,
        "source": source!.toJson(),
      };
}

class Source {
  Source({
    this.pointer,
  });

  final String? pointer;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        pointer: json["pointer"],
      );

  Map<String, dynamic> toJson() => {
        "pointer": pointer,
      };
}
