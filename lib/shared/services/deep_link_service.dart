import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';
import 'package:overwin_mobile/app/app_router.dart';
import 'dart:async';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  StreamSubscription<Uri?>? _uriSubscription;
  GoRouter? _router;
  final AppLinks _appLinks = AppLinks();

  void initialize() {
    _uriSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleDeepLink(uri);
      }
    }, onError: (err) {
      print('Deep link error: $err');
    });
  }
  
  void setRouter(GoRouter router) {
    _router = router;
  }

  void dispose() {
    _uriSubscription?.cancel();
  }

  void handleDeepLink(Uri uri) {
    print('Deep link received: $uri');
    
    if (uri.scheme == 'overwin' && uri.host == 'verify-email') {
      final token = uri.queryParameters['token'];
      if (token != null) {
        print('Email verification token: $token');
        navigateToEmailVerification(token);
      }
    }
  }

  void navigateToEmailVerification(String token) {
    if (_router != null) {
      try {
        _router!.go('/verify-email?token=$token');
        print('Navigated to email verification with token: $token');
      } catch (e) {
        print('Failed to navigate with GoRouter: $e');
      }
    } else {
      print('Router not available for navigation');
    }
  }

  Future<void> handleInitialLink() async {
    try {
      final initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null) {
        handleDeepLink(initialUri);
      }
    } catch (e) {
      print('Failed to get initial URI: $e');
    }
  }
}

final deepLinkService = DeepLinkService();
