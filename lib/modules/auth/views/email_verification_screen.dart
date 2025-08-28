import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:overwin_mobile/shared/services/api_service.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  final String? token;
  
  const EmailVerificationScreen({super.key, this.token});

  @override
  ConsumerState<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends ConsumerState<EmailVerificationScreen> {
  bool _isVerifying = false;
  bool _isVerified = false;
  String _message = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.token != null) {
      _verifyEmail(widget.token!);
    }
  }

  Future<void> _verifyEmail(String token) async {
    setState(() {
      _isVerifying = true;
      _errorMessage = '';
    });

    try {
      final response = await ApiService.post('/auth/verify-email', {
        'token': token,
      });

      if (response['success'] == true) {
        setState(() {
          _isVerified = true;
          _message = response['message'] ?? 'Email vérifié avec succès !';
        });
        
        // Chuyển hướng đến trang đăng nhập sau 3 giây
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            context.go('/signin');
          }
        });
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Erreur lors de la vérification';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de connexion. Veuillez réessayer.';
      });
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Vérification Email'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              _isVerified ? Icons.verified : Icons.email,
              size: 80,
              color: _isVerified ? Colors.green : AppColors.primary,
            ),
            
            const SizedBox(height: 32),
            
            // Title
            Text(
              _isVerified ? 'Email Vérifié !' : 'Vérification Email',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Message
            if (_message.isNotEmpty)
              Text(
                _message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
            const SizedBox(height: 32),
            
            // Loading indicator
            if (_isVerifying)
              const CircularProgressIndicator(
                color: AppColors.primary,
              ),
            
            // Action buttons
            if (!_isVerified && !_isVerifying)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (widget.token != null) {
                        _verifyEmail(widget.token!);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Vérifier'),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  TextButton(
                    onPressed: () => context.go('/signin'),
                    child: const Text(
                      'Retour à la connexion',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            
            if (_isVerified)
              ElevatedButton(
                onPressed: () => context.go('/signin'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Se connecter'),
              ),
          ],
        ),
      ),
    );
  }
}
