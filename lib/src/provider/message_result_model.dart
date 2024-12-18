import 'package:http/http.dart';

class MessageResultModel {
  final bool success;
  final String? sessionId;
  final String message;
  final Response? response;
  final Map<String, dynamic>? data;

  MessageResultModel({
    required this.success,
    this.sessionId,
    required this.message,
    this.response,
    this.data,
  });
}
