import 'package:flutter/material.dart';

/// Um componente atômico que representa um campo de entrada de texto personalizado.
/// 
/// Este componente encapsula a widget TextFormField do Flutter e adiciona funcionalidades como:
/// - Estilização consistente com o tema da aplicação
/// - Suporte para validação de entrada
/// - Configurações para prefixo, sufixo, rótulo e texto de dica
/// - Comportamento de obscurecer texto para campos de senha
/// 
/// É recomendado usar este componente em vez de TextFormField diretamente para manter
/// consistência visual em toda a aplicação.
class CustomInput extends StatelessWidget {
  /// O controlador para o campo de texto.
  final TextEditingController? controller;
  
  /// Rótulo exibido acima do campo quando está em foco ou tem conteúdo.
  final String? labelText;
  
  /// Texto de dica exibido dentro do campo quando está vazio.
  final String? hintText;
  
  /// Ícone exibido no início do campo.
  final Widget? prefixIcon;
  
  /// Widget exibido no final do campo (útil para botões de visibilidade de senha).
  final Widget? suffixIcon;
  
  /// Função de validação que retorna uma mensagem de erro ou null se válido.
  final String? Function(String?)? validator;
  
  /// Se o texto deve ser obscurecido (útil para campos de senha).
  final bool obscureText;
  
  /// Tipo de teclado a ser exibido (email, número, etc.).
  final TextInputType? keyboardType;
  
  /// Função chamada quando o valor do campo muda.
  final void Function(String)? onChanged;
  
  /// Função chamada quando o campo é submetido.
  final void Function(String)? onFieldSubmitted;
  
  /// Função chamada quando o campo recebe foco.
  final void Function()? onTap;
  
  /// Se o campo está habilitado para interação.
  final bool enabled;
  
  /// Número máximo de linhas para exibir.
  final int? maxLines;
  
  /// Número mínimo de linhas para exibir.
  final int? minLines;
  
  /// Espaçamento interno do campo.
  final EdgeInsetsGeometry? contentPadding;
  
  /// Raio da borda do campo.
  final BorderRadius? borderRadius;
  
  /// Cor de preenchimento do campo.
  final Color? fillColor;

  /// Construtor do componente CustomInput.
  const CustomInput({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    // Obtém o tema atual e verifica se é modo escuro
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Define o raio da borda padrão ou usa o personalizado
    final radius = borderRadius ?? BorderRadius.circular(12);
    
    // Define o espaçamento interno padrão ou usa o personalizado
    final padding = contentPadding ?? 
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    
    // Define a cor de preenchimento baseada no tema ou usa a personalizada
    final bgColor = fillColor ?? 
        (isDarkMode ? Colors.grey[800] : Colors.white);
    
    // Cria uma sombra sutil para dar profundidade ao campo
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        onTap: onTap,
        enabled: enabled,
        maxLines: obscureText ? 1 : maxLines, // Campos de senha sempre têm 1 linha
        minLines: minLines,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: bgColor,
          contentPadding: padding,
          // Aplica estilo consistente para os estados focado e habilitado
          focusedBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          // Estilo para quando o campo tem erro de validação
          errorBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: theme.colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
          ),
        ),
      ),
    );
  }
}
