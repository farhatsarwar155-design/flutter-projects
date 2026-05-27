import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const WeatherApp());
}

// ─── Colors ──────────────────────────────────────────────────────────────────

class AppColors {
  static const skyBlue = Color(0xFF87CEEB);
  static const deepBlue = Color(0xFF1A6B9A);
  static const midBlue = Color(0xFF2E86C1);
  static const lightBlue = Color(0xFFADD8E6);
  static const white = Colors.white;
  static const cardBg = Color(0x33FFFFFF);
  static const white10 = Color(0x1AFFFFFF);
  static const white15 = Color(0x26FFFFFF);
  static const white20 = Color(0x33FFFFFF);
  static const white24 = Color(0x3DFFFFFF);
  static const white30 = Color(0x4DFFFFFF);
  static const white54 = Color(0x8AFFFFFF);
  static const white60 = Color(0x99FFFFFF);
  static const white70 = Color(0xB3FFFFFF);
  static const warningOrange = Color(0xFFFF9F43);
  static const dangerRed = Color(0xFFFF6B6B);
  static const goodGreen = Color(0xFF55EFC4);
  static const aqiGood = Color(0xFF6BCB77);
  static const aqiModerate = Color(0xFFFFD93D);
  static const aqiBad = Color(0xFFFF6B6B);
}

// ─── Gradient Helper ──────────────────────────────────────────────────────────

const kBgGradient = LinearGradient(
  colors: [Color(0xFF87CEEB), Color(0xFF2E86C1), Color(0xFF1A6B9A)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// ─── Models ───────────────────────────────────────────────────────────────────

class WeatherData {
  final String city;
  final String country;
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int windDeg;
  final int pressure;
  final int visibility;
  final int sunrise;
  final int sunset;
  final double uvIndex;
  final int aqi;
  final bool isRealData;

  const WeatherData({
    required this.city,
    required this.country,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.pressure,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    this.uvIndex = 0,
    this.aqi = 50,
    this.isRealData = true,
  });

  factory WeatherData.fromJson(Map<String, dynamic> j) => WeatherData(
    city: j['name'] ?? '',
    country: j['sys']?['country'] ?? '',
    temp: (j['main']?['temp'] ?? 0).toDouble(),
    feelsLike: (j['main']?['feels_like'] ?? 0).toDouble(),
    tempMin: (j['main']?['temp_min'] ?? 0).toDouble(),
    tempMax: (j['main']?['temp_max'] ?? 0).toDouble(),
    description: j['weather']?[0]?['description'] ?? '',
    icon: j['weather']?[0]?['icon'] ?? '01d',
    humidity: j['main']?['humidity'] ?? 0,
    windSpeed: (j['wind']?['speed'] ?? 0).toDouble(),
    windDeg: j['wind']?['deg'] ?? 0,
    pressure: j['main']?['pressure'] ?? 0,
    visibility: j['visibility'] ?? 10000,
    sunrise: j['sys']?['sunrise'] ?? 0,
    sunset: j['sys']?['sunset'] ?? 0,
    isRealData: true,
  );

  factory WeatherData.demoForCity(String cityName) {
    final now = DateTime.now();
    final sunrise =
        DateTime(now.year, now.month, now.day, 6, 14).millisecondsSinceEpoch ~/
            1000;
    final sunset =
        DateTime(now.year, now.month, now.day, 18, 42).millisecondsSinceEpoch ~/
            1000;
    final hash = cityName.hashCode.abs();
    final baseTemp = 18.0 + (hash % 22);
    return WeatherData(
      city: cityName,
      country: '',
      temp: baseTemp,
      feelsLike: baseTemp + 2,
      tempMin: baseTemp - 6,
      tempMax: baseTemp + 8,
      description: hash % 4 == 0
          ? 'light rain'
          : hash % 3 == 0
          ? 'few clouds'
          : 'clear sky',
      icon: hash % 4 == 0
          ? '10d'
          : hash % 3 == 0
          ? '02d'
          : '01d',
      humidity: 40 + (hash % 45),
      windSpeed: 2.0 + (hash % 14),
      windDeg: (hash * 47) % 360,
      pressure: 1005 + (hash % 25),
      visibility: 7000 + (hash % 5000),
      sunrise: sunrise,
      sunset: sunset,
      uvIndex: 1.0 + (hash % 10),
      aqi: 20 + (hash % 130),
      isRealData: false,
    );
  }

  double get dewPoint => temp - ((100 - humidity) / 5.0);
  double get heatIndex => feelsLike;

  String get windDirectionLabel {
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return dirs[((windDeg + 22) ~/ 45) % 8];
  }

  String get windDirectionFull {
    const dirs = [
      'North', 'Northeast', 'East', 'Southeast',
      'South', 'Southwest', 'West', 'Northwest'
    ];
    return dirs[((windDeg + 22) ~/ 45) % 8];
  }

  int get beaufortScale {
    final thresholds = [0.5,1.6,3.4,5.5,8.0,10.8,13.9,17.2,20.8,24.5,28.5,32.6];
    for (int i = 0; i < thresholds.length; i++) {
      if (windSpeed < thresholds[i]) return i;
    }
    return 12;
  }

  String get beaufortDesc {
    const descs = [
      'Calm', 'Light air', 'Light breeze', 'Gentle breeze',
      'Moderate breeze', 'Fresh breeze', 'Strong breeze',
      'Near gale', 'Gale', 'Severe gale', 'Storm', 'Violent storm', 'Hurricane'
    ];
    return descs[beaufortScale.clamp(0, 12)];
  }

  String? get weatherAlert {
    if (temp > 40) return 'Extreme Heat Warning';
    if (windSpeed > 15) return 'Strong Wind Advisory';
    if (description.contains('storm') || description.contains('thunder')) return 'Storm Warning';
    if (description.contains('heavy')) return 'Heavy Rain Warning';
    return null;
  }

  String get comfortLevel {
    if (feelsLike < 16) return 'Cold';
    if (feelsLike < 21) return 'Cool';
    if (feelsLike < 27) return 'Comfortable';
    if (feelsLike < 35) return 'Warm';
    return 'Uncomfortable';
  }

  Color get comfortColor {
    switch (comfortLevel) {
      case 'Cold': return AppColors.skyBlue;
      case 'Cool': return AppColors.goodGreen;
      case 'Comfortable': return const Color(0xFF6BCB77);
      case 'Warm': return AppColors.aqiModerate;
      default: return AppColors.warningOrange;
    }
  }

  String get aqiStatus {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive';
    if (aqi <= 200) return 'Unhealthy';
    return 'Very Unhealthy';
  }

  Color get aqiColor {
    if (aqi <= 50) return AppColors.aqiGood;
    if (aqi <= 100) return AppColors.aqiModerate;
    return AppColors.aqiBad;
  }

  String get uvLabel {
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }

  Color get uvColor {
    if (uvIndex <= 2) return const Color(0xFF6BCB77);
    if (uvIndex <= 5) return AppColors.aqiModerate;
    if (uvIndex <= 7) return AppColors.warningOrange;
    return AppColors.dangerRed;
  }

  String get uvAdvice {
    if (uvIndex <= 2) return 'No protection needed';
    if (uvIndex <= 5) return 'Wear sunscreen SPF 30+';
    if (uvIndex <= 7) return 'SPF 50+, hat and sunglasses';
    if (uvIndex <= 10) return 'Avoid outdoor exposure';
    return 'Stay indoors if possible';
  }

  List<Map<String, String>> get clothingSuggestions {
    final items = <Map<String, String>>[];
    if (temp > 35) {
      items.addAll([
        {'emoji': '👕', 'label': 'Light t-shirt'},
        {'emoji': '🧢', 'label': 'Cap / hat'},
        {'emoji': '🕶️', 'label': 'Sunglasses'},
      ]);
    } else if (temp > 25) {
      items.addAll([
        {'emoji': '👚', 'label': 'Light shirt'},
        {'emoji': '🧴', 'label': 'Sunscreen'},
      ]);
    } else if (temp > 15) {
      items.addAll([
        {'emoji': '👔', 'label': 'Long sleeve'},
        {'emoji': '🧥', 'label': 'Light jacket'},
      ]);
    } else if (temp > 5) {
      items.addAll([
        {'emoji': '🧥', 'label': 'Warm jacket'},
        {'emoji': '🧣', 'label': 'Scarf'},
      ]);
    } else {
      items.addAll([
        {'emoji': '🧥', 'label': 'Heavy coat'},
        {'emoji': '🧣', 'label': 'Scarf'},
        {'emoji': '🧤', 'label': 'Gloves'},
      ]);
    }
    if (description.contains('rain') || description.contains('drizzle')) {
      items.add({'emoji': '☂️', 'label': 'Umbrella'});
    }
    if (windSpeed > 10) {
      items.add({'emoji': '🧥', 'label': 'Windbreaker'});
    }
    return items;
  }
}

class HourlyForecast {
  final DateTime time;
  final double temp;
  final String icon;
  final String desc;
  final int rainChance;

  const HourlyForecast({
    required this.time,
    required this.temp,
    required this.icon,
    required this.desc,
    this.rainChance = 0,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> j) => HourlyForecast(
    time: DateTime.fromMillisecondsSinceEpoch(j['dt'] * 1000),
    temp: (j['main']?['temp'] ?? 0).toDouble(),
    icon: j['weather']?[0]?['icon'] ?? '01d',
    desc: j['weather']?[0]?['description'] ?? '',
    rainChance: ((j['pop'] ?? 0) * 100).toInt(),
  );

  static HourlyForecast demo(DateTime time, double temp, String icon,
      {int rain = 0}) =>
      HourlyForecast(
          time: time, temp: temp, icon: icon, desc: 'clear sky', rainChance: rain);
}

class DailyForecast {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final String icon;
  final String desc;

  const DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.icon,
    required this.desc,
  });
}

// ─── Moon Phase Helper ────────────────────────────────────────────────────────

class MoonPhase {
  static String emoji() {
    const phases = ['🌑', '🌒', '🌓', '🌔', '🌕', '🌖', '🌗', '🌘'];
    final d = DateTime.now().millisecondsSinceEpoch / 86400000 - 10957;
    final phase = ((d % 29.53) / 29.53 * 8).floor() % 8;
    return phases[phase];
  }

  static String name() {
    const names = [
      'New Moon', 'Waxing Crescent', 'First Quarter', 'Waxing Gibbous',
      'Full Moon', 'Waning Gibbous', 'Last Quarter', 'Waning Crescent'
    ];
    final d = DateTime.now().millisecondsSinceEpoch / 86400000 - 10957;
    final phase = ((d % 29.53) / 29.53 * 8).floor() % 8;
    return names[phase];
  }
}

// ─── Weather Emoji Helper ─────────────────────────────────────────────────────

String weatherEmoji(String icon) {
  if (icon.startsWith('01')) return icon.endsWith('d') ? '☀️' : '🌙';
  if (icon.startsWith('02')) return icon.endsWith('d') ? '⛅' : '🌙';
  if (icon.startsWith('03') || icon.startsWith('04')) return '☁️';
  if (icon.startsWith('09') || icon.startsWith('10')) return '🌧️';
  if (icon.startsWith('11')) return '⛈️';
  if (icon.startsWith('13')) return '❄️';
  if (icon.startsWith('50')) return '🌫️';
  return '🌤️';
}

// ─── App Root ─────────────────────────────────────────────────────────────────

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _useCelsius = true;
  bool _notifications = true;
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _themeMode =
      p.getBool('darkMode') == true ? ThemeMode.dark : ThemeMode.light;
      _useCelsius = p.getBool('celsius') ?? true;
      _notifications = p.getBool('notifications') ?? true;
      _isLoggedIn = p.getBool('loggedIn') ?? false;
      _userName = p.getString('userName') ?? '';
      _userEmail = p.getString('userEmail') ?? '';
    });
  }

  Future<void> _savePrefs() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('darkMode', _themeMode == ThemeMode.dark);
    await p.setBool('celsius', _useCelsius);
    await p.setBool('notifications', _notifications);
    await p.setBool('loggedIn', _isLoggedIn);
    await p.setString('userName', _userName);
    await p.setString('userEmail', _userEmail);
  }

  void toggleTheme() {
    setState(() => _themeMode =
    _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
    _savePrefs();
  }

  void toggleUnit() {
    setState(() => _useCelsius = !_useCelsius);
    _savePrefs();
  }

  void login(String name, String email) {
    setState(() {
      _isLoggedIn = true;
      _userName = name;
      _userEmail = email;
    });
    _savePrefs();
  }

  void logout() {
    setState(() {
      _isLoggedIn = false;
      _userName = '';
      _userEmail = '';
    });
    _savePrefs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyWatch Pro',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.midBlue, brightness: Brightness.light),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.midBlue, brightness: Brightness.dark),
        fontFamily: 'Roboto',
      ),
      home: _isLoggedIn
          ? MainScreen(
        useCelsius: _useCelsius,
        themeMode: _themeMode,
        onToggleTheme: toggleTheme,
        onToggleUnit: toggleUnit,
        userName: _userName,
        userEmail: _userEmail,
        onLogout: logout,
        notifications: _notifications,
        onToggleNotifications: (v) =>
            setState(() => _notifications = v),
      )
          : LoginScreen(onLogin: login),
    );
  }
}

// ─── Login Screen ─────────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  final Function(String, String) onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isSignUp = false;
  bool _obscure = true;
  bool _loading = false;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
    widget.onLogin(
      _isSignUp ? _nameCtrl.text : _emailCtrl.text.split('@')[0],
      _emailCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF87CEEB), Color(0xFF1A6B9A), Color(0xFF0D3B5E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildLogo(),
                  const SizedBox(height: 40),
                  _buildCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() => Column(
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white24,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 20, spreadRadius: 5)
          ],
        ),
        child: const Icon(Icons.cloud, size: 70, color: Colors.white),
      ),
      const SizedBox(height: 16),
      const Text('SkyWatch Pro',
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2)),
      const Text('Your Smart Weather Companion',
          style: TextStyle(fontSize: 14, color: Colors.white70)),
    ],
  );

  Widget _buildCard() => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: const [
        BoxShadow(
            color: Colors.black26,
            blurRadius: 30,
            offset: Offset(0, 10))
      ],
    ),
    padding: const EdgeInsets.all(28),
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _tabBtn('Login', !_isSignUp,
                      () => setState(() => _isSignUp = false)),
              const SizedBox(width: 8),
              _tabBtn('Sign Up', _isSignUp,
                      () => setState(() => _isSignUp = true)),
            ],
          ),
          const SizedBox(height: 24),
          if (_isSignUp) ...[
            _field(
              controller: _nameCtrl,
              label: 'Full Name',
              icon: Icons.person_outline,
              validator: (v) => v!.isEmpty ? 'Enter your name' : null,
            ),
            const SizedBox(height: 16),
          ],
          _field(
            controller: _emailCtrl,
            label: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
            !v!.contains('@') ? 'Enter valid email' : null,
          ),
          const SizedBox(height: 16),
          _field(
            controller: _passCtrl,
            label: 'Password',
            icon: Icons.lock_outline,
            obscure: _obscure,
            suffix: IconButton(
              icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.midBlue),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
            validator: (v) =>
            v!.length < 6 ? 'Minimum 6 characters' : null,
          ),
          if (!_isSignUp)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Forgot Password?',
                    style: TextStyle(color: AppColors.midBlue)),
              ),
            ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.midBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 4,
            ),
            child: _loading
                ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
                : Text(_isSignUp ? 'Create Account' : 'Sign In',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          const Row(children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('OR', style: TextStyle(color: Colors.grey)),
            ),
            Expanded(child: Divider()),
          ]),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () =>
                widget.onLogin('Guest User', 'guest@skywatch.com'),
            icon: const Icon(Icons.person, color: AppColors.midBlue),
            label: const Text('Continue as Guest',
                style: TextStyle(color: AppColors.midBlue)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.midBlue),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _tabBtn(String label, bool active, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
          const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.midBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.midBlue),
          ),
          child: Text(label,
              style: TextStyle(
                  color: active ? Colors.white : AppColors.midBlue,
                  fontWeight: FontWeight.bold)),
        ),
      );

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.midBlue),
          suffixIcon: suffix,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.midBlue, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      );
}

// ─── Main Screen ──────────────────────────────────────────────────────────────

class MainScreen extends StatefulWidget {
  final bool useCelsius;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleUnit;
  final String userName;
  final String userEmail;
  final VoidCallback onLogout;
  final bool notifications;
  final Function(bool) onToggleNotifications;

  const MainScreen({
    super.key,
    required this.useCelsius,
    required this.themeMode,
    required this.onToggleTheme,
    required this.onToggleUnit,
    required this.userName,
    required this.userEmail,
    required this.onLogout,
    required this.notifications,
    required this.onToggleNotifications,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  WeatherData? _weather;
  List<HourlyForecast> _hourly = [];
  List<DailyForecast> _daily = [];
  bool _loading = false;
  String _error = '';
  final _searchCtrl = TextEditingController();
  String _currentCity = 'Karachi';
  final List<String> _savedCities = ['Karachi', 'Lahore', 'Islamabad'];
  bool _usingDemoData = false;

  static const _apiKey = 'd68e145e10fe6d4dbf628cc645935d74';

  @override
  void initState() {
    super.initState();
    _fetchWeather(_currentCity);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  double _convertTemp(double celsius) =>
      widget.useCelsius ? celsius : (celsius * 9 / 5) + 32;

  String _tempUnit() => widget.useCelsius ? '°C' : '°F';

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _loading = true;
      _error = '';
      _usingDemoData = false;
      _currentCity = city;
    });

    try {
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric'));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final weather = WeatherData.fromJson(data);

        final fRes = await http.get(Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$_apiKey&units=metric'));

        List<HourlyForecast> hourly = [];
        List<DailyForecast> daily = [];

        if (fRes.statusCode == 200) {
          final fData = json.decode(fRes.body);
          final list = fData['list'] as List;

          hourly = list
              .take(24)
              .map((e) => HourlyForecast.fromJson(e))
              .toList();

          final Map<String, List<dynamic>> grouped = {};
          for (var item in list) {
            final date =
            DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
            final key =
                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            grouped[key] = (grouped[key] ?? [])..add(item);
          }

          daily = grouped.entries.take(7).map((e) {
            final temps = e.value
                .map((v) => (v['main']['temp'] as num).toDouble())
                .toList();
            return DailyForecast(
              date: DateTime.parse(e.key),
              tempMax: temps.reduce(max),
              tempMin: temps.reduce(min),
              icon: e.value[0]['weather'][0]['icon'],
              desc: e.value[0]['weather'][0]['description'],
            );
          }).toList();
        }

        setState(() {
          _weather = weather;
          _hourly = hourly;
          _daily = daily;
          _loading = false;
          _usingDemoData = false;
        });
      } else if (res.statusCode == 401 || res.statusCode == 404) {
        if (res.statusCode == 401) {
          setState(() => _error =
          'API key not activated yet. Showing demo data.');
        } else {
          setState(() =>
          _error = 'City "$city" not found. Showing demo data.');
        }
        _showDemoData(city);
      } else {
        _showDemoData(city);
      }
    } catch (e) {
      _showDemoData(city);
    }
  }

  void _showDemoData(String city) {
    final now = DateTime.now();
    final weather = WeatherData.demoForCity(city);
    final hash = city.hashCode.abs();
    final baseTemp = weather.temp;

    final hourly = List.generate(
      24,
          (i) => HourlyForecast.demo(
        now.add(Duration(hours: i)),
        baseTemp + sin(i / 4.0) * 5,
        i < 6 || i > 20 ? '01n' : '01d',
        rain: (i > 14 && i < 18) ? 20 + (hash % 40) : 0,
      ),
    );

    final daily = List.generate(
      7,
          (i) => DailyForecast(
        date: now.add(Duration(days: i)),
        tempMax: baseTemp + 5 + (i % 4),
        tempMin: baseTemp - 5 + (i % 3),
        icon: i == 2 || i == 5 ? '10d' : '01d',
        desc: i == 2 || i == 5 ? 'light rain' : 'clear sky',
      ),
    );

    setState(() {
      _weather = weather;
      _hourly = hourly;
      _daily = daily;
      _currentCity = city;
      _loading = false;
      _usingDemoData = true;
    });
  }

  Future<void> _getLocation() async {
    setState(() => _loading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = 'Location service is disabled.';
          _loading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'Location permission denied.';
            _loading = false;
          });
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric'));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final cityName = data['name'] ?? 'Unknown';
        setState(() => _currentCity = cityName);
        await _fetchWeather(cityName);
      } else {
        _showDemoData('My Location');
      }
    } catch (e) {
      setState(() {
        _error = 'Could not get location.';
        _loading = false;
      });
    }
  }

  List<Widget> get _pages => [
    _HomeTab(
      weather: _weather,
      hourly: _hourly,
      daily: _daily,
      loading: _loading,
      error: _error,
      useCelsius: widget.useCelsius,
      convertTemp: _convertTemp,
      tempUnit: _tempUnit,
      onRefresh: () => _fetchWeather(_currentCity),
      onSearch: (c) => _fetchWeather(c),
      onLocation: _getLocation,
      searchCtrl: _searchCtrl,
      currentCity: _currentCity,
      usingDemoData: _usingDemoData,
    ),
    _ForecastTab(
      daily: _daily,
      convertTemp: _convertTemp,
      tempUnit: _tempUnit,
    ),
    _DetailsTab(
      weather: _weather,
      hourly: _hourly,
      convertTemp: _convertTemp,
      tempUnit: _tempUnit,
    ),
    _CitiesTab(
      savedCities: _savedCities,
      currentCity: _currentCity,
      onCityTap: (c) {
        setState(() => _selectedIndex = 0);
        _fetchWeather(c);
      },
      onAddCity: (c) {
        if (!_savedCities.contains(c)) {
          setState(() => _savedCities.add(c));
        }
        setState(() => _selectedIndex = 0);
        _fetchWeather(c);
      },
      onRemoveCity: (c) => setState(() => _savedCities.remove(c)),
    ),
    SettingsScreen(
      useCelsius: widget.useCelsius,
      themeMode: widget.themeMode,
      onToggleTheme: widget.onToggleTheme,
      onToggleUnit: widget.onToggleUnit,
      userName: widget.userName,
      userEmail: widget.userEmail,
      onLogout: widget.onLogout,
      notifications: widget.notifications,
      onToggleNotifications: widget.onToggleNotifications,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A6B9A), Color(0xFF0D3B5E)],
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black38,
                blurRadius: 20,
                offset: Offset(0, -4))
          ],
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (i) => setState(() => _selectedIndex = i),
          indicatorColor: AppColors.white24,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined, color: Colors.white70),
                selectedIcon: Icon(Icons.home, color: Colors.white),
                label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined,
                    color: Colors.white70),
                selectedIcon:
                Icon(Icons.calendar_month, color: Colors.white),
                label: 'Forecast'),
            NavigationDestination(
                icon:
                Icon(Icons.analytics_outlined, color: Colors.white70),
                selectedIcon: Icon(Icons.analytics, color: Colors.white),
                label: 'Details'),
            NavigationDestination(
                icon: Icon(Icons.location_on_outlined, color: Colors.white70),
                selectedIcon: Icon(Icons.location_on, color: Colors.white),
                label: 'Cities'),
            NavigationDestination(
                icon: Icon(Icons.settings_outlined, color: Colors.white70),
                selectedIcon: Icon(Icons.settings, color: Colors.white),
                label: 'Settings'),
          ],
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
    );
  }
}

// ─── Shared Card Widget ───────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;

  const _GlassCard({
    required this.child,
    this.padding,
    this.margin,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white20,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.white15),
      ),
      child: child,
    );
  }
}

// ─── Section Title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ─── Home Tab ─────────────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  final WeatherData? weather;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final bool loading;
  final String error;
  final bool useCelsius;
  final double Function(double) convertTemp;
  final String Function() tempUnit;
  final VoidCallback onRefresh;
  final Function(String) onSearch;
  final VoidCallback onLocation;
  final TextEditingController searchCtrl;
  final String currentCity;
  final bool usingDemoData;

  const _HomeTab({
    required this.weather,
    required this.hourly,
    required this.daily,
    required this.loading,
    required this.error,
    required this.useCelsius,
    required this.convertTemp,
    required this.tempUnit,
    required this.onRefresh,
    required this.onSearch,
    required this.onLocation,
    required this.searchCtrl,
    required this.currentCity,
    required this.usingDemoData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: kBgGradient),
      child: SafeArea(
        child: loading
            ? const Center(
            child:
            CircularProgressIndicator(color: Colors.white))
            : RefreshIndicator(
          onRefresh: () async => onRefresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                if (usingDemoData) _buildDemoBanner(),
                if (error.isNotEmpty) _buildErrorBanner(),
                if (weather != null) ...[
                  _buildMainWeather(),
                  const SizedBox(height: 12),
                  _buildDetailsRow(),
                  const SizedBox(height: 12),
                  _buildSunriseSunset(),
                  const _SectionTitle(
                      title: 'Hourly Forecast',
                      icon: Icons.schedule),
                  _buildHourlyForecast(),
                  const _SectionTitle(
                      title: 'What to Wear',
                      icon: Icons.checkroom),
                  _buildClothingSuggestions(),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoBanner() => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.warningOrange.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
          color: AppColors.warningOrange.withOpacity(0.4)),
    ),
    child: const Row(
      children: [
        Icon(Icons.info_outline,
            color: AppColors.warningOrange, size: 18),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Demo Mode — Connect to OpenWeatherMap for live data',
            style: TextStyle(
                color: AppColors.warningOrange, fontSize: 12),
          ),
        ),
      ],
    ),
  );

  Widget _buildErrorBanner() => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.orange.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.orange.withOpacity(0.4)),
    ),
    child: Row(
      children: [
        const Icon(Icons.warning_amber_rounded,
            color: Colors.orange, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(error,
              style: const TextStyle(
                  color: Colors.white, fontSize: 13)),
        ),
      ],
    ),
  );

  Widget _buildSearchBar() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search city...',
              hintStyle: const TextStyle(color: Colors.white60),
              prefixIcon:
              const Icon(Icons.search, color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.white24,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onSubmitted: (v) {
              if (v.isNotEmpty) onSearch(v.trim());
            },
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white24,
            borderRadius: BorderRadius.circular(30),
          ),
          child: IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: onLocation,
            tooltip: 'Current Location',
          ),
        ),
      ],
    ),
  );

  Widget _buildMainWeather() {
    final w = weather!;
    return _GlassCard(
      child: Column(
        children: [
          if (w.weatherAlert != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.warningOrange.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.warningOrange.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppColors.warningOrange, size: 16),
                  const SizedBox(width: 6),
                  Text(w.weatherAlert!,
                      style: const TextStyle(
                          color: AppColors.warningOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on,
                  color: Colors.white70, size: 18),
              const SizedBox(width: 4),
              Text(
                w.city.isNotEmpty
                    ? '${w.city}${w.country.isNotEmpty ? ', ${w.country}' : ''}'
                    : currentCity,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(weatherEmoji(w.icon),
              style: const TextStyle(fontSize: 80)),
          Text(
            '${convertTemp(w.temp).toStringAsFixed(1)}${tempUnit()}',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 72,
                fontWeight: FontWeight.w200),
          ),
          Text(
            w.description.toUpperCase(),
            style: const TextStyle(
                color: Colors.white70, fontSize: 14, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            'H: ${convertTemp(w.tempMax).toStringAsFixed(1)}${tempUnit()}  |  L: ${convertTemp(w.tempMin).toStringAsFixed(1)}${tempUnit()}',
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Feels like ${convertTemp(w.feelsLike).toStringAsFixed(1)}${tempUnit()}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow() {
    final w = weather!;
    return _GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _detailItem(Icons.water_drop, '${w.humidity}%', 'Humidity'),
          _vDivider(),
          _detailItem(Icons.air, '${w.windSpeed.toStringAsFixed(1)} m/s', 'Wind'),
          _vDivider(),
          _detailItem(Icons.compress, '${w.pressure} hPa', 'Pressure'),
          _vDivider(),
          _detailItem(
              Icons.visibility,
              '${(w.visibility / 1000).toStringAsFixed(1)} km',
              'Visibility'),
        ],
      ),
    );
  }

  Widget _vDivider() =>
      Container(height: 40, width: 1, color: AppColors.white30);

  Widget _detailItem(IconData icon, String value, String label) => Column(
    children: [
      Icon(icon, color: Colors.white, size: 22),
      const SizedBox(height: 4),
      Text(value,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold)),
      Text(label,
          style:
          const TextStyle(color: Colors.white70, fontSize: 11)),
    ],
  );

  Widget _buildSunriseSunset() {
    final w = weather!;
    final sunrise =
    DateTime.fromMillisecondsSinceEpoch(w.sunrise * 1000);
    final sunset = DateTime.fromMillisecondsSinceEpoch(w.sunset * 1000);
    final now = DateTime.now().millisecondsSinceEpoch / 1000;
    final dayLen = w.sunset - w.sunrise;
    final elapsed = now - w.sunrise;
    final progress = (elapsed / dayLen).clamp(0.0, 1.0);

    return _GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              const Text('Sun & Moon',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(children: [
                const Text('🌅', style: TextStyle(fontSize: 28)),
                const SizedBox(height: 4),
                Text(
                  '${_fmt2(sunrise.hour)}:${_fmt2(sunrise.minute)}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                const Text('Sunrise',
                    style:
                    TextStyle(color: Colors.white60, fontSize: 11)),
              ]),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.white15,
                            borderRadius: BorderRadius.circular(2),
                          )),
                      Align(
                        alignment:
                        Alignment(-1 + progress * 2, 0),
                        child: const Text('☀️',
                            style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ),
              Column(children: [
                const Text('🌇', style: TextStyle(fontSize: 28)),
                const SizedBox(height: 4),
                Text(
                  '${_fmt2(sunset.hour)}:${_fmt2(sunset.minute)}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                const Text('Sunset',
                    style:
                    TextStyle(color: Colors.white60, fontSize: 11)),
              ]),
              Container(
                  width: 1, height: 50, color: AppColors.white30),
              const SizedBox(width: 12),
              Column(children: [
                Text(MoonPhase.emoji(),
                    style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 4),
                Text(
                  MoonPhase.name(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11),
                  textAlign: TextAlign.center,
                ),
                const Text('Moon Phase',
                    style:
                    TextStyle(color: Colors.white60, fontSize: 10)),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast() {
    if (hourly.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourly.length.clamp(0, 12),
        itemBuilder: (_, i) {
          final h = hourly[i];
          return Container(
            width: 76,
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: i == 0 ? AppColors.white30 : AppColors.white15,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: i == 0
                      ? AppColors.white54
                      : AppColors.white15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  i == 0
                      ? 'Now'
                      : '${_fmt2(h.time.hour)}:00',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Text(weatherEmoji(h.icon),
                    style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                Text(
                  '${convertTemp(h.temp).toStringAsFixed(0)}${tempUnit()}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                if (h.rainChance > 0)
                  Text('${h.rainChance}%',
                      style: const TextStyle(
                          color: AppColors.skyBlue, fontSize: 10)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildClothingSuggestions() {
    final items = weather!.clothingSuggestions;
    return _GlassCard(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items
            .map((item) => Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.white15,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.white20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item['emoji']!,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(item['label']!,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 13)),
            ],
          ),
        ))
            .toList(),
      ),
    );
  }

  String _fmt2(int n) => n.toString().padLeft(2, '0');
}

// ─── Forecast Tab ─────────────────────────────────────────────────────────────

class _ForecastTab extends StatelessWidget {
  final List<DailyForecast> daily;
  final double Function(double) convertTemp;
  final String Function() tempUnit;

  const _ForecastTab(
      {required this.daily,
        required this.convertTemp,
        required this.tempUnit});

  String _emoji(String icon) => weatherEmoji(icon);

  String _dayName(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final today = DateTime.now();
    if (d.day == today.day && d.month == today.month) return 'Today';
    final tomorrow = today.add(const Duration(days: 1));
    if (d.day == tomorrow.day && d.month == tomorrow.month) {
      return 'Tomorrow';
    }
    return days[d.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final allMax =
    daily.isEmpty ? 1.0 : daily.map((d) => d.tempMax).reduce(max);
    final allMin =
    daily.isEmpty ? 0.0 : daily.map((d) => d.tempMin).reduce(min);
    final range = (allMax - allMin).abs().clamp(1.0, double.infinity);

    return Container(
      decoration: const BoxDecoration(gradient: kBgGradient),
      child: SafeArea(
        child: daily.isEmpty
            ? const Center(
            child: Text('No forecast data',
                style: TextStyle(color: Colors.white)))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text('7-Day Forecast',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: daily.length,
                itemBuilder: (_, i) {
                  final d = daily[i];
                  final leftFraction =
                      (d.tempMin - allMin) / range;
                  final widthFraction =
                      (d.tempMax - d.tempMin) / range;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.white20,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(_dayName(d.date),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15)),
                        ),
                        Text(_emoji(d.icon),
                            style: const TextStyle(fontSize: 26)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                d.desc.toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 10,
                                    letterSpacing: .5),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              LayoutBuilder(
                                builder: (ctx, constraints) {
                                  final totalW =
                                      constraints.maxWidth;
                                  return Row(
                                    children: [
                                      Text(
                                        '${convertTemp(d.tempMin).toStringAsFixed(0)}°',
                                        style: const TextStyle(
                                            color:
                                            Colors.white60,
                                            fontSize: 12),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 4,
                                              decoration:
                                              BoxDecoration(
                                                color: AppColors
                                                    .white15,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(2),
                                              ),
                                            ),
                                            Positioned(
                                              left: leftFraction *
                                                  (totalW - 40),
                                              child: Container(
                                                width: widthFraction *
                                                    (totalW - 40),
                                                height: 4,
                                                decoration:
                                                BoxDecoration(
                                                  gradient:
                                                  const LinearGradient(
                                                    colors: [
                                                      Color(0xFF87CEEB),
                                                      Color(0xFFFF9F43)
                                                    ],
                                                  ),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(2),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${convertTemp(d.tempMax).toStringAsFixed(0)}°',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Details Tab ──────────────────────────────────────────────────────────────

class _DetailsTab extends StatelessWidget {
  final WeatherData? weather;
  final List<HourlyForecast> hourly;
  final double Function(double) convertTemp;
  final String Function() tempUnit;

  const _DetailsTab({
    required this.weather,
    required this.hourly,
    required this.convertTemp,
    required this.tempUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: kBgGradient),
      child: SafeArea(
        child: weather == null
            ? const Center(
            child: CircularProgressIndicator(color: Colors.white))
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Details',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  Expanded(child: _buildAQICard()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildUVCard()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildWindCompass()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildComfortCard()),
                ],
              ),
              const _SectionTitle(
                  title: '24h Temperature Trend',
                  icon: Icons.show_chart),
              _buildTempTrendCard(),
              const _SectionTitle(
                  title: 'Precipitation Forecast',
                  icon: Icons.water_drop),
              _buildRainCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAQICard() {
    final w = weather!;
    final pct = (w.aqi / 300.0).clamp(0.0, 1.0);
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.air, color: Colors.white70, size: 16),
            const SizedBox(width: 6),
            const Text('Air Quality',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ]),
          const SizedBox(height: 12),
          Text('${w.aqi}',
              style: TextStyle(
                  color: w.aqiColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w300)),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: w.aqiColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(w.aqiStatus,
                style: TextStyle(
                    color: w.aqiColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(colors: [
                    Color(0xFF6BCB77),
                    Color(0xFFFFD93D),
                    Color(0xFFFF9F43),
                    Color(0xFFFF6B6B),
                    Color(0xFFC44569),
                  ]),
                ),
              ),
              Positioned(
                left: (pct * 100)
                    .clamp(0, 100)
                    .toDouble(),
                top: -3,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.black26, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('0',
                  style:
                  TextStyle(color: Colors.white54, fontSize: 10)),
              Text('150',
                  style:
                  TextStyle(color: Colors.white54, fontSize: 10)),
              Text('300+',
                  style:
                  TextStyle(color: Colors.white54, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            w.aqi <= 50
                ? 'Air quality is satisfactory'
                : w.aqi <= 100
                ? 'Acceptable — sensitive groups take care'
                : 'Unhealthy — reduce outdoor activity',
            style:
            const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildUVCard() {
    final w = weather!;
    final uvFraction = (w.uvIndex / 11.0).clamp(0.0, 1.0);
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.wb_sunny_outlined,
                color: Colors.white70, size: 16),
            const SizedBox(width: 6),
            const Text('UV Index',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ]),
          const SizedBox(height: 12),
          Center(
            child: CustomPaint(
              size: const Size(110, 65),
              painter:
              _UVArcPainter(fraction: uvFraction, color: w.uvColor),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              w.uvIndex.toStringAsFixed(1),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Center(
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: w.uvColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(w.uvLabel,
                  style: TextStyle(
                      color: w.uvColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            w.uvAdvice,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWindCompass() {
    final w = weather!;
    return _GlassCard(
      child: Column(
        children: [
          Row(children: [
            const Icon(Icons.explore, color: Colors.white70, size: 16),
            const SizedBox(width: 6),
            const Text('Wind',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ]),
          const SizedBox(height: 8),
          Center(
            child: CustomPaint(
              size: const Size(120, 120),
              painter: _CompassPainter(deg: w.windDeg.toDouble()),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${w.windSpeed.toStringAsFixed(1)} m/s',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          Text(
            w.windDirectionFull,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'Beaufort ${w.beaufortScale} — ${w.beaufortDesc}',
            style: const TextStyle(color: Colors.white54, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildComfortCard() {
    final w = weather!;
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.thermostat_outlined,
                color: Colors.white70, size: 16),
            const SizedBox(width: 6),
            const Text('Comfort',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ]),
          const SizedBox(height: 14),
          _comfortRow('Dew Point',
              '${convertTemp(w.dewPoint).toStringAsFixed(1)}${tempUnit()}'),
          const SizedBox(height: 10),
          _comfortRow('Heat Index',
              '${convertTemp(w.heatIndex).toStringAsFixed(1)}${tempUnit()}'),
          const SizedBox(height: 10),
          _comfortRow('Humidity', '${w.humidity}%'),
          const SizedBox(height: 10),
          const Text('Comfort Level',
              style: TextStyle(color: Colors.white54, fontSize: 11)),
          const SizedBox(height: 4),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: w.comfortColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              w.comfortLevel,
              style: TextStyle(
                  color: w.comfortColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _comfortRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label,
          style: const TextStyle(
              color: Colors.white60, fontSize: 12)),
      Text(value,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600)),
    ],
  );

  Widget _buildTempTrendCard() {
    if (hourly.isEmpty) return const SizedBox.shrink();
    return _GlassCard(
      child: SizedBox(
        height: 160,
        child: CustomPaint(
          painter: _TempChartPainter(
            hourly: hourly.take(24).toList(),
            convertTemp: convertTemp,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }

  Widget _buildRainCard() {
    if (hourly.isEmpty) return const SizedBox.shrink();
    return _GlassCard(
      child: SizedBox(
        height: 130,
        child: CustomPaint(
          painter:
          _RainChartPainter(hourly: hourly.take(12).toList()),
          size: Size.infinite,
        ),
      ),
    );
  }
}

// ─── UV Arc Painter ───────────────────────────────────────────────────────────

class _UVArcPainter extends CustomPainter {
  final double fraction;
  final Color color;

  _UVArcPainter({required this.fraction, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height;
    final r = size.width / 2 - 5;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, pi, pi, false, bgPaint);

    // Foreground arc
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, pi, fraction * pi, false, fgPaint);
  }

  @override
  bool shouldRepaint(_UVArcPainter old) =>
      old.fraction != fraction || old.color != color;
}

// ─── Compass Painter ──────────────────────────────────────────────────────────

class _CompassPainter extends CustomPainter {
  final double deg;

  _CompassPainter({required this.deg});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 4;

    // Outer ring
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Inner fill
    canvas.drawCircle(
      Offset(cx, cy),
      r - 2,
      Paint()..color = Colors.white.withOpacity(0.05),
    );

    // Cardinal letters
    final tp = TextPainter(textDirection: TextDirection.ltr);
    final cardinals = {
      0.0: 'N',
      pi / 2: 'E',
      pi: 'S',
      3 * pi / 2: 'W',
    };
    for (final entry in cardinals.entries) {
      final angle = entry.key;
      final label = entry.value;
      final x = cx + (r - 14) * sin(angle);
      final y = cy - (r - 14) * cos(angle);
      tp.text = TextSpan(
        text: label,
        style: TextStyle(
            color: label == 'N'
                ? Colors.white.withOpacity(0.9)
                : Colors.white.withOpacity(0.5),
            fontSize: 11,
            fontWeight: FontWeight.bold),
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
    }

    // Needle (pointing to wind direction)
    final angleRad = (deg - 180) * pi / 180;
    final tipX = cx + (r - 22) * sin(angleRad);
    final tipY = cy - (r - 22) * cos(angleRad);
    final baseX = cx - (r - 38) * sin(angleRad);
    final baseY = cy + (r - 38) * cos(angleRad);
    final perpX = cos(angleRad) * 5;
    final perpY = sin(angleRad) * 5;

    final northPath = Path()
      ..moveTo(tipX, tipY)
      ..lineTo(cx + perpX, cy + perpY)
      ..lineTo(baseX, baseY)
      ..lineTo(cx - perpX, cy - perpY)
      ..close();
    canvas.drawPath(
        northPath,
        Paint()
          ..color = const Color(0xFFFF6B6B)
          ..style = PaintingStyle.fill);

    // South tip
    final stX = cx - (r - 22) * sin(angleRad);
    final stY = cy + (r - 22) * cos(angleRad);
    final sbX = cx + (r - 38) * sin(angleRad);
    final sbY = cy - (r - 38) * cos(angleRad);
    final southPath = Path()
      ..moveTo(stX, stY)
      ..lineTo(cx + perpX, cy + perpY)
      ..lineTo(sbX, sbY)
      ..lineTo(cx - perpX, cy - perpY)
      ..close();
    canvas.drawPath(
        southPath,
        Paint()
          ..color = Colors.white.withOpacity(0.4)
          ..style = PaintingStyle.fill);

    // Center dot
    canvas.drawCircle(
        Offset(cx, cy),
        5,
        Paint()..color = Colors.white.withOpacity(0.9));
  }

  @override
  bool shouldRepaint(_CompassPainter old) => old.deg != deg;
}

// ─── Temperature Chart Painter ────────────────────────────────────────────────

class _TempChartPainter extends CustomPainter {
  final List<HourlyForecast> hourly;
  final double Function(double) convertTemp;

  _TempChartPainter({required this.hourly, required this.convertTemp});

  @override
  void paint(Canvas canvas, Size size) {
    if (hourly.isEmpty) return;

    final temps = hourly.map((h) => convertTemp(h.temp)).toList();
    final minT = temps.reduce(min);
    final maxT = temps.reduce(max);
    final range = (maxT - minT).abs().clamp(1.0, double.infinity);

    final w = size.width;
    final h = size.height;
    final padL = 36.0;
    final padR = 8.0;
    final padT = 16.0;
    final padB = 28.0;
    final chartW = w - padL - padR;
    final chartH = h - padT - padB;

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 0.5;
    for (int i = 0; i <= 4; i++) {
      final y = padT + chartH * i / 4;
      canvas.drawLine(
          Offset(padL, y), Offset(w - padR, y), gridPaint);
      final val = maxT - (range * i / 4);
      final tp = TextPainter(
        text: TextSpan(
          text: '${val.toStringAsFixed(0)}°',
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(0, y - 6));
    }

    // X labels
    for (int i = 0; i < hourly.length; i += 4) {
      final x = padL + chartW * i / (hourly.length - 1);
      final tp = TextPainter(
        text: TextSpan(
          text: '${hourly[i].time.hour.toString().padLeft(2, '0')}h',
          style: const TextStyle(color: Colors.white38, fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, h - 18));
    }

    // Fill gradient
    final path = Path();
    for (int i = 0; i < temps.length; i++) {
      final x = padL + chartW * i / (temps.length - 1);
      final y = padT + chartH * (1 - (temps[i] - minT) / range);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = padL + chartW * (i - 1) / (temps.length - 1);
        final prevY = padT + chartH * (1 - (temps[i - 1] - minT) / range);
        final cp1x = prevX + (x - prevX) / 2;
        path.cubicTo(cp1x, prevY, cp1x, y, x, y);
      }
    }
    final fillPath = Path.from(path)
      ..lineTo(padL + chartW, padT + chartH)
      ..lineTo(padL, padT + chartH)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFF87CEEB).withOpacity(0.35),
            const Color(0xFF87CEEB).withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, padT, w, chartH)),
    );

    // Line
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF87CEEB).withOpacity(0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Dots at every 4 points
    for (int i = 0; i < temps.length; i += 4) {
      final x = padL + chartW * i / (temps.length - 1);
      final y = padT + chartH * (1 - (temps[i] - minT) / range);
      canvas.drawCircle(Offset(x, y), 3.5, Paint()..color = Colors.white);
      canvas.drawCircle(
          Offset(x, y),
          2,
          Paint()..color = const Color(0xFF2E86C1));
    }
  }

  @override
  bool shouldRepaint(_TempChartPainter old) => old.hourly != hourly;
}

// ─── Rain Chart Painter ───────────────────────────────────────────────────────

class _RainChartPainter extends CustomPainter {
  final List<HourlyForecast> hourly;

  _RainChartPainter({required this.hourly});

  @override
  void paint(Canvas canvas, Size size) {
    if (hourly.isEmpty) return;

    final w = size.width;
    final h = size.height;
    const padL = 36.0;
    const padR = 8.0;
    const padT = 12.0;
    const padB = 28.0;
    final chartW = w - padL - padR;
    final chartH = h - padT - padB;
    final barW = chartW / hourly.length - 3;

    // Y axis labels
    for (int i = 0; i <= 4; i++) {
      final y = padT + chartH * i / 4;
      final tp = TextPainter(
        text: TextSpan(
          text: '${(100 - 25 * i).toInt()}%',
          style: const TextStyle(color: Colors.white38, fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(0, y - 6));
      canvas.drawLine(
          Offset(padL, y),
          Offset(w - padR, y),
          Paint()
            ..color = Colors.white.withOpacity(0.08)
            ..strokeWidth = 0.5);
    }

    for (int i = 0; i < hourly.length; i++) {
      final rain = hourly[i].rainChance / 100.0;
      final x = padL + i * (barW + 3);
      final barH = chartH * rain;
      final y = padT + chartH - barH;

      final rrect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barW, barH),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );

      canvas.drawRRect(
        rrect,
        Paint()
          ..color = rain > 0.3
              ? const Color(0xFF87CEEB).withOpacity(0.8)
              : const Color(0xFF87CEEB).withOpacity(0.3),
      );

      // X label
      if (i % 2 == 0) {
        final tp = TextPainter(
          text: TextSpan(
            text: '${hourly[i].time.hour.toString().padLeft(2, '0')}h',
            style: const TextStyle(color: Colors.white38, fontSize: 9),
          ),
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas,
            Offset(x + barW / 2 - tp.width / 2, h - 18));
      }
    }
  }

  @override
  bool shouldRepaint(_RainChartPainter old) => old.hourly != hourly;
}

// ─── Cities Tab ───────────────────────────────────────────────────────────────

class _CitiesTab extends StatefulWidget {
  final List<String> savedCities;
  final String currentCity;
  final Function(String) onCityTap;
  final Function(String) onAddCity;
  final Function(String) onRemoveCity;

  const _CitiesTab({
    required this.savedCities,
    required this.currentCity,
    required this.onCityTap,
    required this.onAddCity,
    required this.onRemoveCity,
  });

  @override
  State<_CitiesTab> createState() => _CitiesTabState();
}

class _CitiesTabState extends State<_CitiesTab> {
  final _addCityCtrl = TextEditingController();

  @override
  void dispose() {
    _addCityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: kBgGradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text('Saved Cities',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addCityCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Add city...',
                        hintStyle:
                        const TextStyle(color: Colors.white60),
                        prefixIcon: const Icon(Icons.add_location,
                            color: Colors.white70),
                        filled: true,
                        fillColor: AppColors.white20,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 0),
                      ),
                      onSubmitted: (v) {
                        if (v.trim().isNotEmpty) {
                          widget.onAddCity(v.trim());
                          _addCityCtrl.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_addCityCtrl.text.trim().isNotEmpty) {
                        widget.onAddCity(_addCityCtrl.text.trim());
                        _addCityCtrl.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.midBlue,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(14),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding:
                const EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.savedCities.length,
                itemBuilder: (_, i) {
                  final city = widget.savedCities[i];
                  final isCurrent = city.toLowerCase() ==
                      widget.currentCity.toLowerCase();
                  final demo = WeatherData.demoForCity(city);
                  return GestureDetector(
                    onTap: () => widget.onCityTap(city),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.white30
                            : AppColors.white15,
                        borderRadius: BorderRadius.circular(18),
                        border: isCurrent
                            ? Border.all(
                            color: AppColors.white54, width: 1.5)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Text(weatherEmoji(demo.icon),
                              style: const TextStyle(fontSize: 32)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(city,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: isCurrent
                                            ? FontWeight.bold
                                            : FontWeight.normal)),
                                Text(
                                  demo.description,
                                  style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          if (isCurrent)
                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.goodGreen
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('Current',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.goodGreen,
                                      fontWeight: FontWeight.bold)),
                            )
                          else
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.white54),
                              onPressed: () =>
                                  widget.onRemoveCity(city),
                            ),
                          const SizedBox(width: 4),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${demo.temp.toStringAsFixed(0)}°',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Settings Screen ──────────────────────────────────────────────────────────

class SettingsScreen extends StatelessWidget {
  final bool useCelsius;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleUnit;
  final String userName;
  final String userEmail;
  final VoidCallback onLogout;
  final bool notifications;
  final Function(bool) onToggleNotifications;

  const SettingsScreen({
    super.key,
    required this.useCelsius,
    required this.themeMode,
    required this.onToggleTheme,
    required this.onToggleUnit,
    required this.userName,
    required this.userEmail,
    required this.onLogout,
    required this.notifications,
    required this.onToggleNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = themeMode == ThemeMode.dark;
    return Container(
      decoration: const BoxDecoration(gradient: kBgGradient),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Text('Settings',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
              ),
              // Profile Card
              _card(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.white30,
                      child: Text(
                        userName.isNotEmpty
                            ? userName[0].toUpperCase()
                            : 'G',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName.isNotEmpty ? userName : 'Guest User',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            userEmail.isNotEmpty
                                ? userEmail
                                : 'guest@skywatch.com',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                          const Text(
                            'Member since 2024',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit,
                          color: Colors.white70),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionHeader('Preferences'),
              _card(
                child: Column(
                  children: [
                    _switchTile(
                      icon: Icons.dark_mode,
                      iconColor: const Color(0xFFFFD93D),
                      label: 'Dark Mode',
                      subtitle: isDark ? 'Dark theme on' : 'Light theme on',
                      value: isDark,
                      onChanged: (_) => onToggleTheme(),
                    ),
                    const Divider(color: Colors.white30, height: 1),
                    _switchTile(
                      icon: Icons.thermostat,
                      iconColor: const Color(0xFFFF9F43),
                      label: 'Celsius (°C)',
                      subtitle: useCelsius
                          ? 'Currently Celsius'
                          : 'Currently Fahrenheit',
                      value: useCelsius,
                      onChanged: (_) => onToggleUnit(),
                    ),
                    const Divider(color: Colors.white30, height: 1),
                    _switchTile(
                      icon: Icons.notifications_active,
                      iconColor: const Color(0xFF55EFC4),
                      label: 'Weather Alerts',
                      subtitle: 'Severe weather notifications',
                      value: notifications,
                      onChanged: onToggleNotifications,
                    ),
                    const Divider(color: Colors.white30, height: 1),
                    _switchTile(
                      icon: Icons.my_location,
                      iconColor: const Color(0xFF87CEEB),
                      label: 'Auto Location',
                      subtitle: 'Update on app open',
                      value: true,
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionHeader('Display'),
              _card(
                child: Column(
                  children: [
                    _infoTile(Icons.speed, 'Wind Unit', 'm/s'),
                    const Divider(color: Colors.white30, height: 1),
                    _infoTile(
                        Icons.refresh, 'Refresh Interval', '15 min'),
                    const Divider(color: Colors.white30, height: 1),
                    _infoTile(Icons.map, 'Map Style', 'Satellite'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionHeader('App Info'),
              _card(
                child: Column(
                  children: [
                    _infoTile(
                        Icons.info_outline, 'Version', '2.0.0'),
                    const Divider(color: Colors.white30, height: 1),
                    _infoTile(
                        Icons.cloud, 'Data Source', 'OpenWeatherMap'),
                    const Divider(color: Colors.white30, height: 1),
                    _infoTile(Icons.update, 'Last Updated', 'Just now'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionHeader('Support'),
              _card(
                child: Column(
                  children: [
                    _actionTile(
                        context, Icons.star_rate, 'Rate App', () {}),
                    const Divider(color: Colors.white30, height: 1),
                    _actionTile(context, Icons.privacy_tip,
                        'Privacy Policy', () {}),
                    const Divider(color: Colors.white30, height: 1),
                    _actionTile(context, Icons.description,
                        'Terms of Service', () {}),
                    const Divider(color: Colors.white30, height: 1),
                    _actionTile(
                        context, Icons.help_outline, 'Help & FAQ', () {}),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout,
                        color: Colors.white),
                    label: const Text('Logout',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                              'Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: const Text('Cancel')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                Navigator.pop(context);
                                onLogout();
                              },
                              child: const Text('Logout',
                                  style: TextStyle(
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AppColors.white20,
      borderRadius: BorderRadius.circular(18),
    ),
    child: child,
  );

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
    child: Text(title.toUpperCase(),
        style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5)),
  );

  Widget _switchTile({
    required IconData icon,
    Color iconColor = Colors.white,
    required String label,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) =>
      ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 15)),
        subtitle: subtitle != null
            ? Text(subtitle,
            style:
            const TextStyle(color: Colors.white60, fontSize: 12))
            : null,
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.skyBlue,
          activeTrackColor: AppColors.white30,
          inactiveTrackColor: AppColors.white15,
          inactiveThumbColor: Colors.white60,
        ),
      );

  Widget _infoTile(IconData icon, String label, String value) =>
      ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 15)),
        trailing: Text(value,
            style: const TextStyle(
                color: Colors.white60, fontSize: 14)),
      );

  Widget _actionTile(BuildContext context, IconData icon, String label,
      VoidCallback onTap) =>
      ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 15)),
        trailing: const Icon(Icons.chevron_right,
            color: Colors.white54),
        onTap: onTap,
      );
}