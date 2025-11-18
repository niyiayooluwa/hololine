import 'package:dart_either/dart_either.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/domain/models/example.dart';

abstract class ExampleRepository {
  Future<Either<Failure, List<Example>>> getExamples();
}
