import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:overwin_mobile/modules/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/app/splash/splash_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _loaderController;
  late Animation<double> _logoAnimation;
  late Animation<double> _loaderAnimation;

  @override
  void initState() {
    super.initState();
    
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Loader animation controller
    _loaderController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Logo fade in and scale animation
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));
    
    // Loader progress animation
    _loaderAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loaderController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Start logo animation
    _logoController.forward();
    
    // Wait a bit then start loader
    await Future.delayed(const Duration(milliseconds: 800));
    _loaderController.forward();
    
    // Preload data and images
    await SplashService.preloadData(ref, context);
    
    // Wait for animations to complete
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Navigate to appropriate screen
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    final isLoggedIn = ref.read(isLoggedInProvider);
    
    if (isLoggedIn) {
      context.go('/paris');
    } else {
      context.go('/paris');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0A),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0E0F0A),
              Color(0xFF1A1B1A),
              Color(0xFF0E0F0A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Logo with animation - larger and centered like Flutter's loading screen
              AnimatedBuilder(
                animation: _logoAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.8 + (_logoAnimation.value * 0.2),
                    child: Opacity(
                      opacity: _logoAnimation.value,
                      child: Image.asset(
                        'assets/icons/overwin.png',
                        height: 200, // Larger logo
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 60), // More space between logo and loading bar
              
              // Loading bar - positioned right below the logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Column(
                  children: [
                    // Progress bar
                    AnimatedBuilder(
                      animation: _loaderAnimation,
                      builder: (context, child) {
                        return Container(
                          width: double.infinity,
                          height: 6, // Slightly thicker loading bar
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _loaderAnimation.value,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1C67FF),
                                    Color(0xFF4A90E2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Loading text
                    AnimatedBuilder(
                      animation: _loaderAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _loaderAnimation.value,
                          child: const Text(
                            'Chargement...',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14, // Slightly larger text
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // X Logo and Twitter handle
                    AnimatedBuilder(
                      animation: _loaderAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _loaderAnimation.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/X-Logo.png',
                                height: 20,
                                width: 20,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '@overwin_off',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
