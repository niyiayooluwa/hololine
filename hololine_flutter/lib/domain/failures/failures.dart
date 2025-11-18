abstract class Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class ServerException implements Exception {}

