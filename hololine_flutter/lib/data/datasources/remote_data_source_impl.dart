import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/data/datasources/remote_data_source.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/domain/models/example.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
// Import your serverpod client
// import 'package:hololine_client/hololine_client.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  final Client serverpodClient;

  RemoteDataSourceImpl({required this.serverpodClient});

  @override
  Future<List<Example>> getExamples() async {
    // Assuming your endpoint is called 'example'
    // and it has a method 'getExamples'
    // The result from serverpod will likely be List<hololine_client.Example>
    // You need to map it to your domain model List<Example>
    // For simplicity, we assume the models are identical.
    // In a real app, you'd have a mapper.
    try {
      // final result = await serverpodClient.example.getExamples();
      // return result.map((e) => Example.fromServerpod(e)).toList();
      // Mocking for demonstration:
      await Future.delayed(const Duration(seconds: 1));
      return [Example(name: 'From Serverpod', data: 1)];
    } catch (e) {
      throw ServerException();
    }
  }
}
