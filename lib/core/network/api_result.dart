/// Generic wrapper untuk hasil pemanggilan API / Service
/// Memisahkan state Success dan Failure secara type-safe
sealed class ApiResult<T> {
  const ApiResult();

  bool get isSuccess => this is ApiSuccess<T>;
  bool get isFailure => this is ApiFailure<T>;

  T? get dataOrNull {
    final self = this;
    return self is ApiSuccess<T> ? self.data : null;
  }

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, int? statusCode) failure,
  }) {
    final self = this;
    if (self is ApiSuccess<T>) {
      return success(self.data);
    } else if (self is ApiFailure<T>) {
      return failure(self.message, self.statusCode);
    }
    throw StateError('Unhandled ApiResult state: $self');
  }
}

/// Representasi respon sukses
class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

/// Representasi respon gagal / error dari backend NestJS atau koneksi
class ApiFailure<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  final dynamic errorDetails;

  const ApiFailure({
    required this.message,
    this.statusCode,
    this.errorDetails,
  });
}
