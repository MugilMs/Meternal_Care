import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:womb_wisdom_flutter/providers/user_provider.dart';
import 'package:womb_wisdom_flutter/services/supabase_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/appointments_screen.dart';
import 'screens/community_screen.dart';
import 'screens/hospitals_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notifications_screen.dart';
import 'widgets/app_bottom_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize Supabase
  final supabaseService = SupabaseService();
  await supabaseService.initialize();
  
  // Ensure database tables are created if user is authenticated
  if (supabaseService.isAuthenticated) {
    try {
      await supabaseService.ensureDatabaseSetup();
      print('Database tables initialized successfully');
    } catch (e) {
      print('Error setting up database tables: $e');
    }
  }
  
  runApp(const WombWisdomApp());
}

class WombWisdomApp extends StatelessWidget {
  const WombWisdomApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Womb Wisdom Wellbeing',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getTheme(),
        initialRoute: '/',
        routes: {
          '/': (context) => const MainScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/login': (context) => const LoginScreen(),
          '/appointments': (context) => const AppointmentsScreen(),
          '/notifications': (context) => const NotificationsScreen(),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const DashboardScreen(),
    const AppointmentsScreen(),
    const CommunityScreen(),
    const HospitalsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Check authentication status when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }
  
  Future<void> _checkAuthStatus() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          // Remove the duplicate AppHeader here since each screen has its own header
          body: _screens[_currentIndex],
          bottomNavigationBar: AppBottomNavigation(
            currentIndex: _currentIndex,
            onTap: (index) {
              // No need to check for profile screen as it's now in the app bar
              
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        );
      },
    );
  }
  
  // Navigate to login screen
  void _navigateToLogin() {
    Navigator.pushNamed(context, '/login');
  }
  
  void _navigateToProfile(UserProvider userProvider) {
    if (!userProvider.isAuthenticated) {
      _navigateToLogin();
      return;
    }
    
    Navigator.pushNamed(context, '/profile');
  }
  
  Widget _getScreenTitle() {
    switch (_currentIndex) {
      case 0:
        return const Text('Home');
      case 1:
        return const Text('Dashboard');
      case 2:
        return const Text('Appointments');
      case 3:
        return const Text('Community');
      default:
        return const Text('MaternalCare');
    }
  }
  
  String _getScreenTitleString() {
    switch (_currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Dashboard';
      case 2:
        return 'Appointments';
      case 3:
        return 'Community';
      default:
        return 'MaternalCare';
    }
  }
  
  String _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return 'home';
      case 1:
        return 'dashboard';
      case 2:
        return 'appointments';
      case 3:
        return 'community';
      default:
        return 'home';
    }
  }
}
