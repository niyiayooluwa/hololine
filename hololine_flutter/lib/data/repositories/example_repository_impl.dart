import 'package:dart_either/dart_either.dart';
import 'package:hololine_flutter/data/datasources/remote_data_source.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/domain/models/example.dart';
import 'package:hololine_flutter/domain/repository/example_repository.dart';

class ExampleRepositoryImpl implements ExampleRepository {
  final RemoteDataSource remoteDataSource;
  // final LocalDataSource localDataSource; // Optional for caching

  ExampleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Example>>> getExamples() async {
    try {
      final remoteExamples = await remoteDataSource.getExamples();
      return Right(remoteExamples);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
