import 'package:dio/dio.dart';

abstract class CustomHttpClient {
  Future<Response> post(String path, {dynamic data});
  Future<Response> get(String path);
  Future<Response> put(String path, {dynamic data});
  Future<Response> delete(String path);
}
