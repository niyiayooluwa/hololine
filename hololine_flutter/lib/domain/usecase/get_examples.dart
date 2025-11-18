import 'package:dart_either/dart_either.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/domain/models/example.dart';
import 'package:hololine_flutter/domain/repository/example_repository.dart';

class GetExamples {
  final ExampleRepository repository;

  GetExamples(this.repository);

  Future<Either<Failure, List<Example>>> call() async {
    return await repository.getExamples();
  }
}
