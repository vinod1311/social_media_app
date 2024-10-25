
class ApiResponse<T> {
  final T? data;
  final Exception? error;

  ApiResponse._({this.data, this.error});

  // Factory constructor for a successful response
  factory ApiResponse.success(T data) {
    return ApiResponse._(data: data);
  }

  // Factory constructor for an error response
  factory ApiResponse.error(Exception error) {
    return ApiResponse._(
      error: error
    );
  }

}
