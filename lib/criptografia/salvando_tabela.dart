import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Licenciamento App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();
  Database? _database;

  @override
  void initState() {
    super.initState();
    _openDatabase();
  }

  Future<void> _openDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'license.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE License (
            id INTEGER PRIMARY KEY,
            android_id TEXT NOT NULL,
            expiration_date TEXT NOT NULL
          )
        ''');
      },
    );

    _removeExpiredLicenses();
  }

  Future<void> _removeExpiredLicenses() async {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedDate = formatter.format(now);

    await _database?.delete(
      'License',
      where: 'expiration_date < ?',
      whereArgs: [formattedDate],
    );
  }

  Future<String?> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  }

  Future<void> _validateLicense(BuildContext context) async {
    final deviceId = await _getDeviceId();
    final inputId = _controller.text.trim();

    if (deviceId == inputId) {
      final expirationDate = DateTime.now().add(Duration(days: 1));
      final formatter = DateFormat('yyyy-MM-dd');
      final formattedDate = formatter.format(expirationDate);

      await _database?.insert(
        'License',
        {'android_id': deviceId, 'expiration_date': formattedDate},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(builder: (context) => SuccessScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Senha inválida')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Android ID'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _validateLicense(context),
              child: Text('Validar'),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Licença Validada'),
      ),
      body: Center(
        child: Text(
          'OK',
          style: TextStyle(fontSize: 24, color: Colors.green),
        ),
      ),
    );
  }
}

// SE1A.211212.001.B1
