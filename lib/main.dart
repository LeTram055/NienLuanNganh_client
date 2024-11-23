import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hotelmanagement/ui/customer/login_screen.dart';
import 'package:hotelmanagement/ui/customer/register_screen.dart';
import 'package:provider/provider.dart';

import 'ui/screens.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 76, 168, 175),
      secondary: Colors.red,
      surface: Colors.white,
      surfaceTint: Colors.green[200],
      primary: const Color(0xFF026269),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      shadow: const Color.fromARGB(255, 76, 175, 172).withOpacity(0.5),
    );

    final themeData = ThemeData(
      fontFamily: 'Roboto',
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shadowColor: colorScheme.shadow,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: colorScheme.primary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.15,
        ),
        labelMedium: TextStyle(
          color: colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.15,
        ),
        labelSmall: TextStyle(
          color: colorScheme.secondary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.15,
        ),
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
        ),
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => TypeManager()),
        ChangeNotifierProvider(create: (ctx) => CustomerManager()),
        //ChangeNotifierProvider(create: (ctx) => RoomManager()),
        ChangeNotifierProvider(create: (ctx) => ReservationManager()),
      ],
      child: Consumer<CustomerManager>(
        builder: (ctx, customerManager, child) {
          return MaterialApp(
            title: 'Ánh Dương Hotel',
            theme: themeData,
            debugShowCheckedModeBanner: false,
            home: customerManager.isAuth ? const Home() : LoginScreen(),
            routes: {
              LoginScreen.routeName: (ctx) => LoginScreen(),
              RegisterScreen.routeName: (ctx) => RegisterScreen(),
              CustomerInfoScreen.routeName: (ctx) => CustomerInfoScreen(),
              RoomReservationScreen.routeName: (ctx) =>
                  const RoomReservationScreen(),
              ReservationsScreen.routeName: (ctx) => ReservationsScreen(),
            },
          );
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  static const routeName = '/home';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0; // Index của mục bottombar đã chọn

  final List<Widget> _pages = [
    HomeScreen(),
    Container(), // Trang Home
    ReservationsScreen(),

    CustomerInfoScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ mục đã chọn
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Hiển thị trang dựa trên chỉ mục đã chọn
      bottomNavigationBar: BottomBar(
        // Sử dụng BottomBar
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
