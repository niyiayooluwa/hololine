import 'package:hololine_server/src/services/email_service.dart';
import 'package:serverpod/serverpod.dart';

import 'package:hololine_server/src/web/routes/root.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  var pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    authenticationHandler: auth.authenticationHandler,
  );

  // Setup a default page at the web root.
  pod.webServer.addRoute(RouteRoot(), '/');
  pod.webServer.addRoute(RouteRoot(), '/index.html');
  // Serve all files in the /static directory.
  pod.webServer.addRoute(
    RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
    '/*',
  );

  // Configure Auth with Email
  auth.AuthConfig.set(auth.AuthConfig(
      sendValidationEmail: (session, email, validationCode) async {
        final emailHandler = EmailHandler(session);
        return await emailHandler.sendVerificationEmail(
          email: email,
          verificationCode: validationCode,
          userName: email.split('@')[0],
        );
      },
      sendPasswordResetEmail: (session, userInfo, validationCode) async {
        final emailHandler = EmailHandler(session);
        return await emailHandler.sendPasswordResetEmail(
          email: userInfo.email!,
          resetCode: validationCode,
          userName: userInfo.userName ?? userInfo.email!.split('@')[0],
        );
      },
      maxAllowedEmailSignInAttempts: 5, // More generous for development
      validationCodeLength: 6,
      passwordResetExpirationTime: Duration(hours: 1)
      // emailValidationCodeExpiration: Duration(hours: 24), // This parameter is not available in AuthConfig
      ));

  // Start the server.
  await pod.start();
}
