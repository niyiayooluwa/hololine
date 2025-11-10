import 'package:hololine_server/src/generated/workspace_role.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';

class EmailHandler {
  final Session session;

  EmailHandler(this.session);

  Future<bool> sendVerificationEmail({
    required String email,
    required String verificationCode,
    required String userName,
  }) async {
    try {
      final smtpServer = SmtpServer(
        'smtp.resend.com',
        username: 'resend',
        password: _getResendApiKey(),
        port: 465,
        ssl: true,
      );

      final message = Message()
        ..from = Address('onboarding@resend.dev', 'Hololine Team')
        ..recipients.add(email)
        ..subject = 'Verify your Hololine account'
        ..html = _sendVerificationEmail(userName, verificationCode);
      final sendReport = await send(message, smtpServer);
      session
          .log('Verification email sent to $email: ${sendReport.toString()}');
      return true;
    } catch (e, stackTrace) {
      session.log(
        'Failed to send verification email to $email',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail({
    required String email,
    required String resetCode,
    required String userName,
  }) async {
    try {
      final smtpServer = SmtpServer(
        'smtp.resend.com',
        username: 'resend',
        password: _getResendApiKey(),
        port: 465,
        ssl: true,
      );

      final message = Message()
        ..from = Address('onboarding@resend.dev', 'Hololine Team')
        ..recipients.add(email)
        ..subject = 'Reset your Hololine password'
        ..html = _passwordResetEmail(userName, resetCode);

      final sendReport = await send(message, smtpServer);
      session
          .log('Password reset email sent to $email: ${sendReport.toString()}');
      return true;
    } catch (e, stackTrace) {
      session.log(
        'Failed to send password reset email to $email',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> sendInvitation(
    String email,
    String token,
    String workspaceName,
    WorkspaceRole role,
  ) async {
    try {
      final smtpServer = SmtpServer(
        'smtp.resend.com',
        username: 'resend',
        password: _getResendApiKey(),
        port: 465,
        ssl: true,
      );

      final message = Message()
        ..from = Address('onboarding@resend.dev', 'Hololine Team')
        ..recipients.add(email)
        ..subject = 'Invitation to join $workspaceName'
        ..html = _workspaceInviteEmail(workspaceName, token, role.toString());

      final sendReport = await send(message, smtpServer);
      session.log('Invitation email sent to $email: ${sendReport.toString()}');
      return true;
    } catch (e, stackTrace) {
      session.log(
        'Failed to send invitation email to $email',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  String _getResendApiKey() {
    // Try environment variable first, then fallback to config
    return const String.fromEnvironment('RESEND_API_KEY');
  }

  String _sendVerificationEmail(String userName, String verificationCode) {
    final string = '''<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6; 
            color: #1f2937;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 20px;
            min-height: 100vh;
        }
        
        .container { 
            max-width: 600px; 
            margin: 0 auto; 
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }
        
        .header { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; 
            padding: 50px 40px;
            text-align: center;
            position: relative;
        }
        
        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="2" fill="white" opacity="0.1"/></svg>');
            background-size: 30px 30px;
        }
        
        .header h1 {
            font-size: 32px;
            font-weight: 700;
            margin: 0;
            position: relative;
            z-index: 1;
            letter-spacing: -0.5px;
        }
        
        .content {
            padding: 40px;
        }
        
        .greeting {
            font-size: 18px;
            color: #1f2937;
            margin-bottom: 20px;
        }
        
        .greeting strong {
            color: #667eea;
            font-weight: 600;
        }
        
        .message {
            color: #4b5563;
            margin-bottom: 30px;
            font-size: 16px;
        }
        
        .code-container {
            background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
            border-radius: 12px;
            padding: 30px;
            margin: 30px 0;
            text-align: center;
            border: 2px dashed #d1d5db;
        }
        
        .code-label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #6b7280;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .code { 
            font-size: 42px; 
            font-weight: 800; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: 8px;
            font-family: 'Courier New', monospace;
        }
        
        .warning {
            background: #fef3c7;
            border-left: 4px solid #f59e0b;
            padding: 15px 20px;
            margin: 25px 0;
            border-radius: 6px;
            font-size: 14px;
            color: #92400e;
        }
        
        .info {
            background: #e0e7ff;
            border-left: 4px solid #667eea;
            padding: 15px 20px;
            margin: 25px 0;
            border-radius: 6px;
            font-size: 14px;
            color: #3730a3;
        }
        
        .footer { 
            background: #f9fafb;
            padding: 30px 40px;
            text-align: center; 
            font-size: 13px; 
            color: #6b7280;
            border-top: 1px solid #e5e7eb;
        }
        
        .footer-logo {
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 18px;
            margin-bottom: 10px;
        }
        
        .social-links {
            margin-top: 15px;
        }
        
        .social-links a {
            display: inline-block;
            margin: 0 8px;
            color: #9ca3af;
            text-decoration: none;
            font-size: 12px;
            transition: color 0.3s;
        }
        
        .social-links a:hover {
            color: #667eea;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>✨ Welcome to Hololine!</h1>
        </div>
        
        <div class="content">
            <p class="greeting">Hello <strong>$userName</strong>,</p>
            
            <p class="message">We're thrilled to have you join our community! To get started, please verify your account using the code below:</p>
            
            <div class="code-container">
                <div class="code-label">Verification Code</div>
                <div class="code">$verificationCode</div>
            </div>
            
            <div class="warning">
                ⏱️ <strong>Time sensitive:</strong> This code will expire in 1 hour.
            </div>
            
            <div class="info">
                🛡️ If you didn't create an account with us, please disregard this email. Your security is our priority.
            </div>
        </div>
        
        <div class="footer">
            <div class="footer-logo">Hololine</div>
            <p>&copy; 2025 Hololine Team. All rights reserved.</p>
            <div class="social-links">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Support</a>
            </div>
        </div>
    </div>
</body>
</html>''';

    return string;
  }

  String _workspaceInviteEmail(String workspace, String token, String role) {
    final string = '''<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6; 
            color: #1f2937;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 20px;
            min-height: 100vh;
        }
        
        .container { 
            max-width: 600px; 
            margin: 0 auto; 
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }
        
        .header { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; 
            padding: 50px 40px;
            text-align: center;
            position: relative;
        }
        
        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="2" fill="white" opacity="0.1"/></svg>');
            background-size: 30px 30px;
        }
        
        .header h1 {
            font-size: 32px;
            font-weight: 700;
            margin: 0;
            position: relative;
            z-index: 1;
            letter-spacing: -0.5px;
        }
        
        .content {
            padding: 40px;
        }
        
        .greeting {
            font-size: 18px;
            color: #1f2937;
            margin-bottom: 20px;
        }
        
        .greeting strong {
            color: #667eea;
            font-weight: 600;
        }
        
        .message {
            color: #4b5563;
            margin-bottom: 30px;
            font-size: 16px;
        }
        
        .code-container {
            background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
            border-radius: 12px;
            padding: 30px;
            margin: 30px 0;
            text-align: center;
            border: 2px dashed #d1d5db;
        }
        
        .code-label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #6b7280;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .code { 
            font-size: 42px; 
            font-weight: 800; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: 8px;
            font-family: 'Courier New', monospace;
        }
        
        .warning {
            background: #fef3c7;
            border-left: 4px solid #f59e0b;
            padding: 15px 20px;
            margin: 25px 0;
            border-radius: 6px;
            font-size: 14px;
            color: #92400e;
        }
        
        .info {
            background: #e0e7ff;
            border-left: 4px solid #667eea;
            padding: 15px 20px;
            margin: 25px 0;
            border-radius: 6px;
            font-size: 14px;
            color: #3730a3;
        }
        
        .footer { 
            background: #f9fafb;
            padding: 30px 40px;
            text-align: center; 
            font-size: 13px; 
            color: #6b7280;
            border-top: 1px solid #e5e7eb;
        }
        
        .footer-logo {
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 18px;
            margin-bottom: 10px;
        }
        
        .social-links {
            margin-top: 15px;
        }
        
        .social-links a {
            display: inline-block;
            margin: 0 8px;
            color: #9ca3af;
            text-decoration: none;
            font-size: 12px;
            transition: color 0.3s;
        }
        
        .social-links a:hover {
            color: #667eea;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Invitation to Workspace</h1>
        </div>
        
        <div class="content">
            <p class="greeting">Hello,</p>
            
            <p class="message">A member of $workspace invited you to collaborate in their workspace as a <strong>$role</strong>! Join <strong>$workspace</strong> using the code below:</p>
            
            <div class="code-container">
                <div class="code-label">Invitation Code</div>
                <div class="code">$token</div>
            </div>
            
            <div class="warning">
                ⏱️ <strong>Time sensitive:</strong> This code will expire in 15 minutes.
            </div>
        </div>
        
        <div class="footer">
            <div class="footer-logo">Hololine</div>
            <p>&copy; 2025 Hololine Team. All rights reserved.</p>
            <div class="social-links">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Support</a>
            </div>
        </div>
    </div>
</body>
</html>''';
    return string;
  }

  String _passwordResetEmail(String userName, String resetCode) {
    final string = '''<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6; 
            color: #1f2937;
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 50%, #dc2626 100%);
            padding: 40px 20px;
            min-height: 100vh;
        }
        
        .container { 
            max-width: 600px; 
            margin: 0 auto; 
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(220, 38, 38, 0.2);
        }
        
        .header { 
            background: linear-gradient(135deg, #dc2626 0%, #991b1b 100%);
            color: white; 
            padding: 50px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 30px 30px;
            animation: drift 20s linear infinite;
        }
        
        @keyframes drift {
            0% { transform: translate(0, 0); }
            100% { transform: translate(30px, 30px); }
        }
        
        .icon {
            width: 60px;
            height: 60px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 30px;
            position: relative;
            z-index: 1;
            backdrop-filter: blur(10px);
        }
        
        .header h1 {
            font-size: 32px;
            font-weight: 700;
            margin: 0;
            position: relative;
            z-index: 1;
            letter-spacing: -0.5px;
        }
        
        .content {
            padding: 40px;
        }
        
        .greeting {
            font-size: 18px;
            color: #1f2937;
            margin-bottom: 20px;
        }
        
        .greeting strong {
            color: #dc2626;
            font-weight: 600;
        }
        
        .message {
            color: #4b5563;
            margin-bottom: 30px;
            font-size: 16px;
        }
        
        .code-container {
            background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
            border-radius: 12px;
            padding: 30px;
            margin: 30px 0;
            text-align: center;
            border: 2px dashed #fca5a5;
            position: relative;
        }
        
        .code-label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #991b1b;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .code { 
            font-size: 42px; 
            font-weight: 800; 
            background: linear-gradient(135deg, #dc2626 0%, #991b1b 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: 8px;
            font-family: 'Courier New', monospace;
        }
        
        .warning {
            background: #fef3c7;
            border-left: 4px solid #f59e0b;
            padding: 15px 20px;
            margin: 25px 0;
            border-radius: 6px;
            font-size: 14px;
            color: #92400e;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .security-notice {
            background: #fee2e2;
            border-left: 4px solid #dc2626;
            padding: 15px 20px;
            margin: 25px 0;
            border-radius: 6px;
            font-size: 14px;
            color: #991b1b;
        }
        
        .security-notice strong {
            display: block;
            margin-bottom: 5px;
            font-size: 15px;
        }
        
        .security-tips {
            background: #f9fafb;
            border-radius: 8px;
            padding: 20px;
            margin: 25px 0;
        }
        
        .security-tips h3 {
            font-size: 14px;
            color: #374151;
            margin-bottom: 12px;
            font-weight: 600;
        }
        
        .security-tips ul {
            list-style: none;
            padding: 0;
        }
        
        .security-tips li {
            color: #6b7280;
            font-size: 13px;
            padding: 6px 0;
            padding-left: 20px;
            position: relative;
        }
        
        .security-tips li::before {
            content: '✓';
            position: absolute;
            left: 0;
            color: #10b981;
            font-weight: bold;
        }
        
        .footer { 
            background: #f9fafb;
            padding: 30px 40px;
            text-align: center; 
            font-size: 13px; 
            color: #6b7280;
            border-top: 1px solid #e5e7eb;
        }
        
        .footer-logo {
            font-weight: 700;
            background: linear-gradient(135deg, #dc2626 0%, #991b1b 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 18px;
            margin-bottom: 5px;
        }
        
        .footer-tagline {
            color: #9ca3af;
            font-size: 12px;
            margin-bottom: 15px;
        }
        
        .social-links {
            margin-top: 15px;
        }
        
        .social-links a {
            display: inline-block;
            margin: 0 8px;
            color: #9ca3af;
            text-decoration: none;
            font-size: 12px;
            transition: color 0.3s;
        }
        
        .social-links a:hover {
            color: #dc2626;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="icon">🔒</div>
            <h1>Password Reset Request</h1>
        </div>
        
        <div class="content">
            <p class="greeting">Hello <strong>$userName</strong>,</p>
            
            <p class="message">We received a request to reset your password. To proceed with resetting your password, please use the verification code below:</p>
            
            <div class="code-container">
                <div class="code-label">Reset Verification Code</div>
                <div class="code">$resetCode</div>
            </div>
            
            <div class="warning">
                <span>⏱️</span>
                <div><strong>Time sensitive:</strong> This code will expire in 1 hour for your security.</div>
            </div>
            
            <div class="security-notice">
                <strong>🛡️ Didn't request this?</strong>
                If you didn't request a password reset, please ignore this email and consider changing your password immediately to secure your account.
            </div>
            
            <div class="security-tips">
                <h3>💡 Security Tips</h3>
                <ul>
                    <li>Never share your reset code with anyone</li>
                    <li>Use a strong, unique password</li>
                    <li>Enable two-factor authentication if available</li>
                    <li>Avoid using the same password across multiple sites</li>
                </ul>
            </div>
        </div>
        
        <div class="footer">
            <div class="footer-logo">Hololine</div>
            <p>&copy; 2025 Hololine Team. All rights reserved.</p>
            <div class="social-links">
                <a href="#">Privacy Policy</a>
                <a href="#">Security</a>
                <a href="#">Support</a>
            </div>
        </div>
    </div>
</body>
</html>''';
    return string;
  }
}
