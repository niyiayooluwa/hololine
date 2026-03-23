import 'package:serverpod/serverpod.dart';

class CronEndpoint extends Endpoint {
  Future<void> executeJob(Session session) async {
    session.log('Server kept alive.', level: LogLevel.info);
  }
}
