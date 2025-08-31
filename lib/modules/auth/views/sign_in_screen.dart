import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:overwin_mobile/modules/auth/providers/auth_provider.dart';
import 'package:overwin_mobile/modules/auth/views/sign_up_screen.dart';
import 'package:overwin_mobile/modules/auth/views/verification_code_screen.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';
import 'package:overwin_mobile/shared/services/error_handler.dart';
import 'package:overwin_mobile/shared/widgets/loading_overlay.dart';
import 'package:overwin_mobile/shared/theme/app_modal_bottom_sheet.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
  
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      sheetAnimationStyle: AnimationStyle(
        duration: Duration(milliseconds: AppModalBottomSheet.bottomSheetDuration)
      ),
      builder: (context) => const SignInScreen(),
    );
  }
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        await ref.read(authProvider.notifier).signIn(
          _emailController.text,
          _passwordController.text,
        );
        if (mounted) {
          Navigator.pop(context); // Close the bottom sheet
        }
      } catch (e) {
        if (mounted) {
          // Log error để debug
          print('SignIn Error in SignInScreen: $e');
          
          // Kiểm tra nếu là EmailNotVerifiedException
          if (e is EmailNotVerifiedException) {
            _showVerificationCodeDialog(e.email);
          } else {
            final errorMessage = ErrorHandler.getErrorMessage(e);
            
            // Hiển thị thông báo lỗi với màu sắc phù hợp
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showVerificationCodeDialog(String email) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationCodeScreen(
          email: email,
          isFromLogin: true,
        ),
      ),
    );
  }
  


  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    
    return LoadingOverlay(
      isLoading: _isLoading,
      message: 'Connexion en cours...',
      child: FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: AppModalBottomSheet.modalBottomSheetHeightFactor,
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF0E0F0A),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppModalBottomSheet.modalBottomSheetRadius),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Column(
              children: [
                // Header with logo and close button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                  child: Row(
                    children: [
                      // Close button
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const Spacer(),
                      // Logo
                      Image.asset(
                        'assets/icons/overwin.png',
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                      const Spacer(),
                      // Empty space to balance the close button
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                
                const SizedBox(height: 2),
                
                // Login form container với sign up link bên trong
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Color(0xFF141b2e),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Title
                                    const Text(
                                      'Connexion',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),

                                    // Email field
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextFormField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        style: const TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          labelText: 'Email',
                                          labelStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Veuillez entrer votre email';
                                          }
                                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                            return 'Veuillez entrer un email valide';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // Password field
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        style: const TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          labelText: 'Mot de passe',
                                          labelStyle: const TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword = !_obscurePassword;
                                              });
                                            },
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Veuillez entrer votre mot de passe';
                                          }
                                          if (value.length < 6) {
                                            return 'Le mot de passe doit contenir au moins 6 caractères';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // Sign in button
                                    Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextButton(
                                        onPressed: _signIn,
                                        child: const Text(
                                          'Se connecter',
                                          style: TextStyle(
                                            color: AppColors.tertiary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          
                          // Sign up link ngay dưới container
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Tu n\'as pas de compte ? ',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    context.push('/signup');
                                  },
                                  child: const Text(
                                    'Inscris-toi',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
