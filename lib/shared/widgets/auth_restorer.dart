import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/auth/providers/auth_provider.dart';

class AuthRestorer extends ConsumerStatefulWidget {
  final Widget child;
  
  const AuthRestorer({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AuthRestorer> createState() => _AuthRestorerState();
}

class _AuthRestorerState extends ConsumerState<AuthRestorer> {
  bool _isRestoring = true;

  @override
  void initState() {
    super.initState();
    _restoreAuthState();
  }

  Future<void> _restoreAuthState() async {
    try {
      await ref.read(authProvider.notifier).restoreAuthState();
    } catch (e) {
      // Handle error silently
    } finally {
      if (mounted) {
        setState(() {
          _isRestoring = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isRestoring) {
      return Material(
        color: Colors.black,
        child: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    
    return widget.child;
  }
}
