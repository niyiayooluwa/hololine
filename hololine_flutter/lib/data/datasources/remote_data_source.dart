import 'package:hololine_flutter/domain/models/example.dart';

abstract class RemoteDataSource {
  Future<List<Example>> getExamples();
}
