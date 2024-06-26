import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskpagination/app/config/api_endpoints.dart';
import 'package:taskpagination/app/config/http_service.dart';
import 'package:taskpagination/core/failure/failure.dart';
import 'package:taskpagination/features/home/data/model/comments.dart';

final commentDataSourceProvider = Provider<CommentDataSource>((ref) {
  final dio = ref.read(httpServiceProvider);
  return CommentDataSource(dio);
});

class CommentDataSource {
  final Dio _dio;
  CommentDataSource(this._dio);

  // get data from post with pagination
  Future<Either<Failure, List<Comments>>> getComments(int page) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.comments,
        queryParameters: {
          '_page': page,
          '_limit': ApiEndpoints.limitPage,
        },
      );
      final data = response.data as List;
      final posts = data.map((e) => Comments.fromJson(e)).toList();
      return Right(posts);
    } on DioException catch (e) {
      return Left(Failure(message: e.message.toString()));
    }
  }
}
