import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:overwin_mobile/app/app.dart';
import 'package:overwin_mobile/shared/widgets/auth_restorer.dart';
import 'package:overwin_mobile/shared/services/deep_link_service.dart';
import 'package:overwin_mobile/app/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr');
  
  // Initialize deep link handling
  deepLinkService.initialize();
  
  runApp(
    const ProviderScope(
      child: AuthRestorer(
        child: MyApp(),
      ),
    ),
  );
  
  // Handle initial deep link after app is built
  await Future.delayed(const Duration(milliseconds: 100));
  await deepLinkService.handleInitialLink();
}
