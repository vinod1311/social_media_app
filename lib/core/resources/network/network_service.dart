import 'package:dio/dio.dart';
import 'dart:io';

import 'api_response.dart';
import 'error_interceptors.dart';


class NetworkService {
  final Dio _dio;
  CancelToken _cancelToken = CancelToken();

  NetworkService(this._dio) {
    _dio.interceptors.add(ErrorInterceptors(_dio));
  }

  Future<ApiResponse<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, Duration? timeout}) async {
    try {
      Response response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          sendTimeout: timeout,
          receiveTimeout: timeout,

        ),
        cancelToken: _cancelToken,
      );
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error(e as Exception);
    }
  }

  Future<ApiResponse<T>> post<T>(String path, {dynamic data, Duration? timeout}) async {
    try {
      Response response = await _dio.post(
        path,
        data: data,
        options: Options(
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
        cancelToken: _cancelToken,
      );
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error(e as Exception);
    }
  }

  Future<ApiResponse<T>> put<T>(String path, {dynamic data, Duration? timeout}) async {
    try {
      Response response = await _dio.put(
        path,
        data: data,
        options: Options(
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
        cancelToken: _cancelToken,
      );
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error(e as Exception);
    }
  }

  Future<ApiResponse<T>> delete<T>(String path, {dynamic data, Duration? timeout}) async {
    try {
      Response response = await _dio.delete(
        path,
        data: data,
        options: Options(
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
        cancelToken: _cancelToken,
      );
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error(e as Exception);
    }
  }

  Future<ApiResponse<T>> postForm<T>(String path, {required FormData data, Duration? timeout}) async {
    try {
      Response response = await _dio.post(
        path,
        data: data,
        options: Options(
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
        cancelToken: _cancelToken,
      );
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error(e as Exception);
    }
  }

  Future<ApiResponse<void>> downloadFile(String urlPath, String savePath, {Duration? timeout}) async {
    try {
      await _dio.download(
        urlPath,
        savePath,
        options: Options(
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
        cancelToken: _cancelToken,
      );
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error(e as Exception);
    }
  }

  Future<ApiResponse<T>> uploadFile<T>(String path, File file, {Duration? timeout}) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });
      Response response = await _dio.post(
        path,
        data: formData,
        options: Options(
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
        cancelToken: _cancelToken,
      );
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error(e as Exception);
    }
  }

  void cancelRequests() {
    _cancelToken.cancel("Cancelled by user");
    _cancelToken = CancelToken(); // Create a new token for future requests
  }
}