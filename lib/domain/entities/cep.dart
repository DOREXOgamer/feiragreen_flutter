/**
 * Entidade CEP que representa um endereço baseado no CEP brasileiro.
 * 
 * Esta classe segue o padrão DDD (Domain-Driven Design) e representa
 * uma entidade de domínio que contém os atributos e comportamentos
 * essenciais de um endereço no contexto da aplicação.
 */
class Cep {
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String ibge;
  final String gia;
  final String ddd;
  final String siafi;

  /**
   * Construtor da entidade Cep.
   * 
   * @param cep Código de Endereçamento Postal
   * @param logradouro Nome da rua, avenida, etc.
   * @param complemento Informações adicionais sobre o endereço
   * @param bairro Nome do bairro
   * @param localidade Nome da cidade
   * @param uf Sigla do estado
   * @param ibge Código IBGE da localidade
   * @param gia Código GIA (quando disponível)
   * @param ddd Código DDD da localidade
   * @param siafi Código SIAFI da localidade
   */
  Cep({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.ibge,
    required this.gia,
    required this.ddd,
    required this.siafi,
  });

  /**
   * Cria uma instância de Cep a partir de um mapa de dados JSON.
   * 
   * Este método é utilizado para desserialização de dados,
   * convertendo dados de APIs em entidades do domínio.
   * 
   * @param json Mapa contendo os atributos da entidade
   * @return Nova instância de Cep
   */
  factory Cep.fromJson(Map<String, dynamic> json) {
    return Cep(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      complemento: json['complemento'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
      ibge: json['ibge'] ?? '',
      gia: json['gia'] ?? '',
      ddd: json['ddd'] ?? '',
      siafi: json['siafi'] ?? '',
    );
  }

  /**
   * Converte a entidade para um mapa de dados JSON.
   * 
   * Este método é utilizado para serialização da entidade,
   * facilitando o envio para APIs ou armazenamento.
   * 
   * @return Mapa contendo os atributos da entidade
   */
  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
      'bairro': bairro,
      'localidade': localidade,
      'uf': uf,
      'ibge': ibge,
      'gia': gia,
      'ddd': ddd,
      'siafi': siafi,
    };
  }
}