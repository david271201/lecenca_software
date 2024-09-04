import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  // Atributos privados para chave e IV com valores padrão
  final String _defaultKeyString = '32charlongsecretkey1234567890212'; // Deve ter 32 caracteres
  final String _defaultIvString = '16charsiv123456'; // Deve ter 16 caracteres

  // Atributos privados para a chave e o IV
  late final encrypt.Key _key;
  late final encrypt.IV _iv;

  // Construtor da classe inicializa a chave e o IV com valores padrão
  EncryptionService() {
    _key = encrypt.Key.fromUtf8(_defaultKeyString);
    _iv = encrypt.IV.fromUtf8(_defaultIvString);
  }

  // Função para criptografar um texto
  String encryptText(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  // Função para descriptografar um texto
  String decryptText(String encryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}

void main() {
  final encryptionService = EncryptionService();

  final originalText = 'MinhaLicencaDeSoftware';
  print('Original: $originalText');

  final encryptedText = encryptionService.encryptText(originalText);
  print('Criptografado: $encryptedText');

  final decryptedText = encryptionService.decryptText(encryptedText);
  print('Descriptografado: $decryptedText');
}
