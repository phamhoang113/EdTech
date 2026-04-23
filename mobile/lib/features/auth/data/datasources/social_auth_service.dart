import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/config/app_config.dart';

/// Service wrapper cho Google Sign-In và Facebook Login.
/// Trả về Firebase-compatible mock token (dev) hoặc real idToken (production).
@injectable
class SocialAuthService {
  /// Sign in with Google → return mock token hoặc real idToken
  Future<String?> signInWithGoogle() async {
    if (!AppConfig.isProduction) {
      // Dev mode: trả mock token để bypass Firebase
      return 'MOCK_TOKEN_GOOGLE_testuser@gmail.com';
    }

    try {
      final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      final account = await googleSignIn.signIn();
      if (account == null) return null; // User cancelled

      final googleAuth = await account.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        debugPrint('[SocialAuth] Google Sign-In: idToken is null');
        return null;
      }

      // Trong production, cần Firebase Auth để exchange Google credential → Firebase idToken
      // Tạm thời trả raw Google idToken (backend sẽ verify qua Firebase)
      return idToken;
    } catch (e) {
      debugPrint('[SocialAuth] Google Sign-In failed: $e');
      return null;
    }
  }

  /// Sign in with Facebook → return mock token hoặc real idToken
  Future<String?> signInWithFacebook() async {
    if (!AppConfig.isProduction) {
      return 'MOCK_TOKEN_FACEBOOK_testuser@facebook.com';
    }

    try {
      final result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status != LoginStatus.success) {
        debugPrint('[SocialAuth] Facebook Login cancelled or failed: ${result.status}');
        return null;
      }

      final accessToken = result.accessToken?.tokenString;
      if (accessToken == null) {
        debugPrint('[SocialAuth] Facebook Login: accessToken is null');
        return null;
      }

      // Trong production, cần Firebase Auth để exchange Facebook credential → Firebase idToken
      return accessToken;
    } catch (e) {
      debugPrint('[SocialAuth] Facebook Login failed: $e');
      return null;
    }
  }
}
