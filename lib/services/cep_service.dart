import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:feiragreen_flutter/models/cep_model.dart';

class CepService {
  static const String _baseUrl = 'https://viacep.com.br/ws';

  /// Consulta um CEP na API do ViaCEP
  static Future<CepModel?> consultarCep(String cep) async {
    try {
      // Remove caracteres não numéricos do CEP
      final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');

      // Valida se o CEP tem 8 dígitos
      if (cepLimpo.length != 8) {
        throw Exception('CEP deve conter 8 dígitos');
      }

      final url = Uri.parse('$_baseUrl/$cepLimpo/json/');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Verifica se a API retornou erro
        if (data['erro'] == true) {
          throw Exception('CEP não encontrado');
        }

        return CepModel.fromJson(data);
      } else {
        throw Exception('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erro de conexão. Verifique sua internet.');
      }
      rethrow;
    }
  }

  /// Formata um CEP para exibição
  static String formatarCep(String cep) {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cepLimpo.length == 8) {
      return '${cepLimpo.substring(0, 5)}-${cepLimpo.substring(5)}';
    }
    return cep;
  }

  /// Valida se um CEP é válido
  static bool validarCep(String cep) {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
    return cepLimpo.length == 8;
  }
}
