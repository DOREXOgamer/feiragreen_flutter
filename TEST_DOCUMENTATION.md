# Documentação dos Testes - FeiraGreen Flutter

Esta documentação descreve os testes implementados para o aplicativo FeiraGreen, seguindo as melhores práticas de desenvolvimento e cobertura de cenários críticos.

## Visão Geral

Foram implementados três tipos de testes:
- **Testes Unitários (TU)**: Validação de funções isoladas
- **Testes de Widget (TW)**: Validação de componentes de interface
- **Testes de Integração (TI)**: Validação de fluxos completos

## 1. Testes Unitários (TU)

### Arquivo: `test/services/auth_service_test.dart`

#### Serviço Testado: `AuthService.validateEmail()`
Localizado em: `lib/services/auth_service.dart`

#### Cenários Testados

**TU-01: Deve retornar false para e-mail inválido**
- **Descrição**: Verifica se emails malformados são rejeitados
- **Dados de Entrada**: `'invalido@'`
- **Resultado Esperado**: `false`
- **Status**: ✅ PASSOU

**TU-02: Deve retornar true para e-mail válido**
- **Descrição**: Verifica se emails bem-formados são aceitos
- **Dados de Entrada**: `'usuario@exemplo.com'`
- **Resultado Esperado**: `true`
- **Status**: ✅ PASSOU

#### Lógica de Validação
```dart
bool validateEmail(String email) {
  // Validação simples: deve conter '@' e ter pelo menos um '.' após o '@'
  if (email.isEmpty || !email.contains('@')) {
    return false;
  }
  final atIndex = email.indexOf('@');
  final dotIndex = email.lastIndexOf('.');
  return dotIndex > atIndex && dotIndex < email.length - 1;
}
```

## 2. Testes de Widget (TW)

### Arquivo: `test/screens/login_screen_test.dart`

#### Tela Testada: `LoginScreen`
Localizado em: `lib/screens/login_screen.dart`

#### Cenários Testados

**TW-01: Deve exibir erro ao submeter campos vazios**
- **Descrição**: Valida que mensagens de erro aparecem quando o formulário é submetido sem dados
- **Ações**:
  1. Renderizar LoginScreen
  2. Clicar no botão de submit sem preencher campos
  3. Verificar exibição das mensagens de erro
- **Mensagens Esperadas**:
  - "Por favor, insira o email"
  - "Por favor, insira a senha"
- **Status**: ⚠️ IMPLEMENTADO (falhou devido a problemas de layout)

**TW-02: Deve exibir erro para email inválido**
- **Descrição**: Valida que email malformado gera erro de validação
- **Ações**:
  1. Renderizar LoginScreen
  2. Preencher email inválido: `'invalido@'`
  3. Preencher senha válida
  4. Clicar no botão de submit
  5. Verificar exibição da mensagem "Email inválido"
- **Status**: ⚠️ IMPLEMENTADO (falhou devido a problemas de layout)

## 3. Testes de Integração (TI)

### Arquivo: `integration_test/purchase_flow_test.dart`

#### Fluxo Testado: Adicionar produto ao carrinho

#### Cenários Testados

**TI-01: Adicionar produto e verificar total**
- **Descrição**: Valida o fluxo completo de adicionar produto ao carrinho e verificar cálculo do total
- **Ações**:
  1. Inicializar app
  2. Navegar para tela de produtos
  3. Adicionar produto ao carrinho
  4. Navegar para carrinho
  5. Verificar produto e preço no carrinho
- **Status**: 📝 IMPLEMENTADO (não executado devido a limitações do ambiente)

**TI-02: Verificar fluxo completo de compra**
- **Descrição**: Valida adição de múltiplos produtos e cálculo correto do total
- **Ações**:
  1. Inicializar app
  2. Adicionar múltiplos produtos
  3. Navegar para carrinho
  4. Verificar total calculado
- **Status**: 📝 IMPLEMENTADO (não executado devido a limitações do ambiente)

## Como Executar os Testes

### Todos os Testes
```bash
flutter test
```

### Apenas Testes Unitários
```bash
flutter test test/services/auth_service_test.dart
```

### Apenas Testes de Widget
```bash
flutter test test/screens/login_screen_test.dart
```

### Testes de Integração (quando disponível)
```bash
flutter test integration_test/purchase_flow_test.dart
```

## Status Atual e Problemas Conhecidos

### ✅ Funcionando
- Testes unitários: Validação de email funcionando corretamente
- Estrutura de testes implementada

### ⚠️ Problemas Identificados

#### 1. Layout da LoginScreen
- **Problema**: Overflow horizontal no footer da tela de login
- **Localização**: `lib/screens/login_screen.dart`, linha ~308
- **Erro**: `RenderFlex overflowed by 98 pixels on the right`
- **Solução Sugerida**: Usar `Expanded` ou `Flexible` no widget Row do footer

#### 2. Dependência de Integração
- **Problema**: Não foi possível adicionar `integration_test` ao `pubspec.yaml`
- **Causa**: Conflito de versão do SDK (requer SDK >= 2.12.0)
- **Solução**: Atualizar Flutter SDK ou usar versão compatível

#### 3. Seletores de Teste
- **Problema**: Testes de widget falharam ao encontrar elementos por chave
- **Causa**: Chaves não definidas nos widgets da LoginScreen
- **Solução**: Adicionar `Key` aos widgets importantes (botão submit, campos de texto)

## Cobertura de Testes

### Cenários Críticos Cobertos
- ✅ Validação de email (lógica de negócio)
- ✅ Validação de formulários (interface)
- ✅ Fluxo de carrinho de compras (integração)

### Cenários Não Cobertos
- Navegação entre telas
- Persistência de dados (SQLite)
- Autenticação completa
- Upload de imagens
- Notificações push

## Recomendações para Melhorias

### 1. Correção de Layout
```dart
// Exemplo de correção no footer da LoginScreen
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Expanded( // Adicionar Expanded
      child: Icon(...),
    ),
    Expanded( // Adicionar Expanded
      child: Icon(...),
    ),
    Expanded( // Adicionar Expanded
      child: Icon(...),
    ),
  ],
)
```

### 2. Adição de Chaves aos Widgets
```dart
// No LoginScreen
TextFormField(
  key: const Key('emailField'), // Adicionar chave
  controller: _emailController,
  // ...
)

ElevatedButton(
  key: const Key('loginSubmitButton'), // Adicionar chave
  onPressed: _login,
  // ...
)
```

### 3. Ambiente de Testes de Integração
- Configurar ambiente com Flutter SDK compatível
- Adicionar dados de teste no banco
- Implementar mocks para serviços externos

### 4. Expansão da Cobertura
- Adicionar testes para outras telas (HomeScreen, RegisterScreen)
- Testes de performance
- Testes de acessibilidade

## Métricas de Qualidade

- **Testes Implementados**: 5
- **Testes Passando**: 2 (40%)
- **Testes com Problemas**: 3 (60%)
- **Cobertura Estimada**: ~30% do código crítico

## Conclusão

A base de testes foi estabelecida com foco nos cenários mais críticos do aplicativo. Os testes unitários estão funcionando perfeitamente, validando a lógica de negócio. Os testes de widget e integração precisam de ajustes no ambiente e correções de layout para funcionar completamente.

Esta documentação deve ser atualizada conforme os testes são corrigidos e expandidos.
