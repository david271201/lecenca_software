import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para usar Clipboard
import '../../criptografia/criptografar.dart';

class EncryptionScreen extends StatefulWidget {
  @override
  _EncryptionScreenState createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {
  final _controller = TextEditingController();
  final EncryptionService _encryptionService = EncryptionService();
  String _encryptedText = '';
  bool _isCopying = false;

  void _encryptText() {
    final plainText = _controller.text;
    setState(() {
      _encryptedText = _encryptionService.encryptText(plainText);
      _isCopying = false; // Resetando o status de cópia
    });
  }

  void _copyToClipboard() {
    if (_encryptedText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _encryptedText));
      setState(() {
        _isCopying = true; // Atualiza o status de cópia
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800], // Cor militar para a AppBar
        title: Text(
          'Criptografia de Texto',
          style: TextStyle(
            color: Colors.white.withOpacity(0.85), // Tom de branco mais suave
            fontWeight: FontWeight.bold, // Negrito
          ),
        ),
      ),
      body: Container(
        color: Colors.green[50], // Cor de fundo suave para a tela
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Digite o texto a ser criptografado:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: 'Texto',
                    labelStyle: TextStyle(color: Colors.green[900]),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[900]!, width: 2.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[300]!, width: 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: TextStyle(color: Colors.green[900]),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _encryptText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600], // Tom de verde mais claro para o botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Criptografar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      )
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Texto Criptografado:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _encryptedText.isEmpty
                            ? 'Nenhum texto criptografado ainda'
                            : _encryptedText,
                        style: TextStyle(
                          color: Colors.green[900],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      if (_encryptedText.isNotEmpty)
                        ElevatedButton(
                          onPressed: _copyToClipboard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[500], // Tom de verde para o botão de cópia
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            _isCopying ? 'Copiado!' : 'Copiar para área de transferência',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
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
    );
  }
}
