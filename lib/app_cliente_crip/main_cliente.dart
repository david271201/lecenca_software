import 'package:flutter/material.dart';
import 'components/CriptografiaClasse.dart';
import 'components/extrair_id.dart';
import 'components/login_information.dart'; // Substitua pelo caminho correto para a classe AuthService

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final EncryptionService _encryptionService = EncryptionService();
  String? _deviceUniqueId;
  String? _platform;

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    final deviceInfo = await DeviceUtils.getDeviceInfo();
    setState(() {
      _platform = deviceInfo['platform'];
      _deviceUniqueId = deviceInfo['uniqueId'];
    });
  }

  void _goToHomePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    print('Tentando fazer login...');

    if (_deviceUniqueId == null) {
      _showError('Erro ao obter ID único do dispositivo.');
      return;
    }

    try {
      // Criptografa a senha digitada pelo usuário

      String descryptedPassword = _encryptionService.decryptText(password);
      // print('Senha descriptografada: $descryptedPassword');

      if (descryptedPassword == _deviceUniqueId) {
        // Se a senha criptografada bate com o ID do dispositivo criptografado, faça o login
        // print('Entreii no if de descriptografia');
        await AuthService.login(username, password);
        _goToHomePage();
      } else {
        // print('Aqui meu mano deu erro de senha');
        // Se a senha não bater, mostre um erro
        _showError('Senha incorreta.');
      }
    } catch (e) {
      // Trata erros de criptografia ou outros problemas
      print('Erro durante o login: $e');
      _showError('Erro ao processar a senha. Verifique e tente novamente.');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_platform != null && _deviceUniqueId != null) ...[
              Text('Plataforma: $_platform'),
              Text('ID do Dispositivo: $_deviceUniqueId'),
              SizedBox(height: 20),
            ],
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Bem-vindo à página inicial!'),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool loggedIn = await AuthService.isLoggedIn();
  runApp(MaterialApp(
    home: loggedIn ? HomePage() : LoginPage(),
  ));
}

// rEL8XyAgmlUka0+EHCwwWIgMQsdiCJUVJqeSZjj7OIg=
