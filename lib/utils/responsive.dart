import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class Responsive {
  // MÉTODOS DE DETECÇÃO SIMPLIFICADOS
  static bool isPhone(BuildContext context) => 
      MediaQuery.of(context).size.width < 600;
  
  static bool isTablet(BuildContext context) => 
      MediaQuery.of(context).size.width >= 600 && 
      MediaQuery.of(context).size.width < 1024;
  
  static bool isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= 1024;

  static double width(BuildContext context) => 
      MediaQuery.of(context).size.width;
  
  static double height(BuildContext context) => 
      MediaQuery.of(context).size.height;

  // ESCALA SIMPLIFICADA - FUNCIONA MELHOR
  static double scale(BuildContext context, double value) {
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = width / 375.0; // iPhone 6/7/8 como base
    
    if (isTablet(context)) {
      return value * scaleFactor * 0.9; // Tablet reduz um pouco
    } else if (isDesktop(context)) {
      return value * scaleFactor * 0.8; // Desktop reduz mais
    }
    
    // Para celular, usa fator normal
    return value * scaleFactor;
  }

  // TAMANHO DE FONTE RESPONSIVO
  static double fontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    double scaleFactor;
    
    if (width < 375) {
      scaleFactor = 0.9; // Celulares muito pequenos
    } else if (width < 600) {
      scaleFactor = 1.0; // Celulares normais
    } else if (width < 1024) {
      scaleFactor = 1.1; // Tablets
    } else {
      scaleFactor = 1.2; // Desktop
    }
    
    // Respeita configuração do usuário
    final textScale = MediaQuery.textScaleFactorOf(context);
    return baseSize * scaleFactor * textScale.clamp(0.8, 1.5);
  }

  // PADDING RESPONSIVO
  static EdgeInsets paddingAll(BuildContext context, double value) => 
      EdgeInsets.all(scale(context, value));
  
  static EdgeInsets paddingHorizontal(BuildContext context, double value) => 
      EdgeInsets.symmetric(horizontal: scale(context, value));
  
  static EdgeInsets paddingVertical(BuildContext context, double value) => 
      EdgeInsets.symmetric(vertical: scale(context, value));
  
  static EdgeInsets paddingSymmetric({
    required BuildContext context,
    double horizontal = 0,
    double vertical = 0,
  }) => EdgeInsets.symmetric(
    horizontal: scale(context, horizontal),
    vertical: scale(context, vertical),
  );

  // GAPS RESPONSIVOS
  static SizedBox vGap(BuildContext context, double height) => 
      SizedBox(height: scale(context, height));
  
  static SizedBox hGap(BuildContext context, double width) => 
      SizedBox(width: scale(context, width));

  // LARGURA RESPONSIVA (percentual)
  static double widthPercent(BuildContext context, double percent) => 
      width(context) * percent;

  // ADICIONE ESTE MÉTODO - CALCULA LARGURA DE ITEM EM GRID
  static double gridItemWidth(
    double totalWidth, 
    int columns, 
    double spacing, 
    double horizontalPadding
  ) {
    if (columns <= 0) return 0;
    
    // Calcula largura disponível
    final usableWidth = totalWidth - (horizontalPadding * 2);
    
    // Calcula total de espaçamento entre colunas
    final totalSpacing = spacing * (columns - 1);
    
    // Calcula largura de cada item
    final itemWidth = (usableWidth - totalSpacing) / columns;
    
    // Retorna 0 se o cálculo der negativo
    return math.max(0.0, itemWidth);
  }
}