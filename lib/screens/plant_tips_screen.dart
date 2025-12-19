import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../utils/responsive.dart';

class PlantTipsScreen extends StatefulWidget {
  const PlantTipsScreen({super.key});

  @override
  PlantTipsScreenState createState() => PlantTipsScreenState();
}

class PlantTipsScreenState extends State<PlantTipsScreen> {
  final _searchController = TextEditingController();
  Plant? _selectedPlant;
  bool _isLoading = false;
  
  // Lista de PANC predefinidas
  final List<Plant> _pancPlants = [
    Plant(
      name: 'Taioba',
      scientificName: 'Xanthosoma sagittifolium',
      description: 'Planta de folhas grandes, comestíveis quando cozidas. Rica em ferro, cálcio e vitamina A.',
      careInstructions: {
        'watering': 'Regar regularmente, mantendo o solo úmido mas não encharcado',
        'sunlight': 'Meia-sombra a sol pleno',
        'temperature': '20-30°C (tropical)',
        'soil': 'Solo fértil, bem drenado e rico em matéria orgânica',
        'fertilization': 'Adubação orgânica a cada 2-3 meses',
      },
    ),
    Plant(
      name: 'Beldroega',
      scientificName: 'Portulaca oleracea',
      description: 'Planta rasteira suculenta, rica em ômega-3, antioxidantes e minerais.',
      careInstructions: {
        'watering': 'Pouca água, resistente à seca',
        'sunlight': 'Sol pleno',
        'temperature': '15-30°C',
        'soil': 'Solo bem drenado, até mesmo pobre',
        'fertilization': 'Pouca ou nenhuma adubação necessária',
      },
    ),
    Plant(
      name: 'Ora-pro-nóbis',
      scientificName: 'Pereskia aculeata',
      description: 'Planta trepadeira com folhas ricas em proteínas (até 25%), ferro e fibras.',
      careInstructions: {
        'watering': 'Regas espaçadas, resistente à seca',
        'sunlight': 'Sol pleno ou meia-sombra',
        'temperature': '18-35°C',
        'soil': 'Qualquer tipo de solo, bem drenado',
        'fertilization': 'Adubação orgânica moderada',
      },
    ),
    Plant(
      name: 'Serralha',
      scientificName: 'Sonchus oleraceus',
      description: 'Planta silvestre com folhas dentadas, rica em vitaminas A e C.',
      careInstructions: {
        'watering': 'Regas moderadas',
        'sunlight': 'Sol pleno ou meia-sombra',
        'temperature': '10-30°C',
        'soil': 'Solo fértil e bem drenado',
        'fertilization': 'Adubação leve com composto orgânico',
      },
    ),
    Plant(
      name: 'Capuchinha',
      scientificName: 'Tropaeolum majus',
      description: 'Planta ornamental comestível, flores e folhas picantes, ricas em vitamina C.',
      careInstructions: {
        'watering': 'Regas regulares, sem encharcar',
        'sunlight': 'Sol pleno ou meia-sombra',
        'temperature': '15-25°C',
        'soil': 'Solo fértil e bem drenado',
        'fertilization': 'Adubação orgânica mensal',
      },
    ),
    Plant(
      name: 'Azedinha',
      scientificName: 'Rumex acetosa',
      description: 'Folhas com sabor ácido, ricas em vitamina C e oxalatos.',
      careInstructions: {
        'watering': 'Regas frequentes, mantendo solo úmido',
        'sunlight': 'Meia-sombra',
        'temperature': '10-25°C',
        'soil': 'Solo ácido, rico em matéria orgânica',
        'fertilization': 'Adubação com composto orgânico',
      },
    ),
    Plant(
      name: 'Bertalha',
      scientificName: 'Basella alba',
      description: 'Trepadeira de folhas suculentas, rica em mucilagem e nutrientes.',
      careInstructions: {
        'watering': 'Regas abundantes',
        'sunlight': 'Sol pleno ou meia-sombra',
        'temperature': '20-35°C',
        'soil': 'Solo fértil e úmido',
        'fertilization': 'Adubação orgânica regular',
      },
    ),
    Plant(
      name: 'Picão',
      scientificName: 'Bidens pilosa',
      description: 'Planta medicinal e alimentícia, rica em flavonoides e antioxidantes.',
      careInstructions: {
        'watering': 'Regas moderadas',
        'sunlight': 'Sol pleno',
        'temperature': '15-35°C',
        'soil': 'Adapta-se a vários tipos de solo',
        'fertilization': 'Pouca adubação necessária',
      },
    ),
    Plant(
      name: 'Caruru',
      scientificName: 'Amaranthus spp',
      description: 'Planta de folhas verdes escuras, rica em proteínas, cálcio e ferro.',
      careInstructions: {
        'watering': 'Regas moderadas',
        'sunlight': 'Sol pleno',
        'temperature': '18-30°C',
        'soil': 'Solo fértil e bem drenado',
        'fertilization': 'Adubação orgânica a cada 2 meses',
      },
    ),
    Plant(
      name: 'Língua de Vaca',
      scientificName: 'Rumex crispus',
      description: 'Planta de folhas grandes, rica em vitaminas e minerais.',
      careInstructions: {
        'watering': 'Regas regulares',
        'sunlight': 'Meia-sombra',
        'temperature': '10-28°C',
        'soil': 'Solo úmido e rico em matéria orgânica',
        'fertilization': 'Adubação com composto orgânico',
      },
    ),
    Plant(
      name: 'Peixinho',
      scientificName: 'Stachys byzantina',
      description: 'Planta com folhas aveludadas, ricas em fibras e antioxidantes.',
      careInstructions: {
        'watering': 'Regas moderadas',
        'sunlight': 'Sol pleno',
        'temperature': '15-28°C',
        'soil': 'Solo bem drenado',
        'fertilization': 'Adubação orgânica leve',
      },
    ),
    Plant(
      name: 'Vinagreira',
      scientificName: 'Hibiscus sabdariffa',
      description: 'Planta com flores comestíveis, rica em vitamina C e antioxidantes.',
      careInstructions: {
        'watering': 'Regas regulares',
        'sunlight': 'Sol pleno',
        'temperature': '20-35°C',
        'soil': 'Solo fértil e bem drenado',
        'fertilization': 'Adubação orgânica mensal',
      },
    ),
  ];

  // MÉTODO DE BUSCA - ADICIONADO
  void _searchPlant() {
    final searchTerm = _searchController.text.trim();
    if (searchTerm.isEmpty) {
      _showSnackBar('Digite o nome de uma PANC', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    // Pequeno delay para simular busca
    Future.delayed(const Duration(milliseconds: 300), () {
      final matchedPlant = _findPancPlant(searchTerm.toLowerCase());

      setState(() {
        _selectedPlant = matchedPlant;
        _isLoading = false;
      });

      if (matchedPlant == null) {
        _showSnackBar(
          '"$searchTerm" não é uma PANC conhecida. Tente outro nome.',
          Colors.orange,
        );
      }
    });
  }

  // MÉTODO PARA ENCONTRAR PANC - ADICIONADO
  Plant? _findPancPlant(String searchTerm) {
    // Busca exata pelo nome
    for (final plant in _pancPlants) {
      if (plant.name.toLowerCase() == searchTerm) {
        return plant;
      }
    }
    
    // Busca parcial pelo nome
    for (final plant in _pancPlants) {
      if (plant.name.toLowerCase().contains(searchTerm)) {
        return plant;
      }
    }
    
    // Busca pelo nome científico
    for (final plant in _pancPlants) {
      if (plant.scientificName.toLowerCase().contains(searchTerm)) {
        return plant;
      }
    }
    
    // Busca pelas primeiras letras
    if (searchTerm.length >= 3) {
      for (final plant in _pancPlants) {
        if (plant.name.toLowerCase().startsWith(searchTerm)) {
          return plant;
        }
      }
    }
    
    return null;
  }

  // MÉTODO SNACKBAR - ADICIONADO
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dicas para PANC',
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 18),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Plantas Alimentícias Não Convencionais',
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 12),
                fontWeight: FontWeight.normal,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(Responsive.scale(context, 16)),
        child: Column(
          children: [
            // BARRA DE BUSCA
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green[100]!),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar PANC...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: Responsive.scale(context, 16),
                          vertical: Responsive.scale(context, 14),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.green[800]!.withOpacity(0.6),
                          fontSize: Responsive.fontSize(context, 16),
                        ),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.green[700],
                        ),
                      ),
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 16),
                        color: Colors.green[900],
                      ),
                      onSubmitted: (_) => _searchPlant(),
                    ),
                  ),
                ),
                SizedBox(width: Responsive.scale(context, 12)),
                _isLoading
                    ? Container(
                        width: Responsive.scale(context, 50),
                        height: Responsive.scale(context, 50),
                        padding: EdgeInsets.all(Responsive.scale(context, 10)),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.green[700],
                        ),
                      )
                    : InkWell(
                        onTap: _searchPlant,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: Responsive.scale(context, 50),
                          height: Responsive.scale(context, 50),
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green[800]!.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: Responsive.fontSize(context, 24),
                          ),
                        ),
                      ),
              ],
            ),
            
            SizedBox(height: Responsive.scale(context, 24)),
            
            // ÁREA DE INFORMAÇÕES OU MENSAGEM INICIAL
            Expanded(
              child: _selectedPlant != null 
                  ? _buildPlantInfo() 
                  : _buildInitialMessage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialMessage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner informativo
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Responsive.scale(context, 16)),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[100]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.eco,
                  size: Responsive.scale(context, 48),
                  color: Colors.green[700],
                ),
                SizedBox(height: Responsive.scale(context, 12)),
                Text(
                  'O que são PANC?',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 18),
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                SizedBox(height: Responsive.scale(context, 8)),
                Text(
                  'Plantas Alimentícias Não Convencionais são espécies nutritivas, '
                  'adaptáveis e muitas vezes resistentes a pragas. '
                  'São excelentes para cultivo sustentável e diversificação alimentar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 14),
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: Responsive.scale(context, 24)),
          
          // Título da lista
          Text(
            'PANC Disponíveis',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 20),
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          
          SizedBox(height: Responsive.scale(context, 8)),
          
          Text(
            'Clique em qualquer PANC para ver detalhes de cultivo',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 14),
              color: Colors.grey[600],
            ),
          ),
          
          SizedBox(height: Responsive.scale(context, 16)),
          
          // Grid de PANC - CORRIGIDO PARA EVITAR OVERFLOW
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isPhone(context) ? 2 : 3,
              crossAxisSpacing: Responsive.scale(context, 10),
              mainAxisSpacing: Responsive.scale(context, 10),
              // AUMENTEI O ASPECT RATIO para dar mais altura
              childAspectRatio: Responsive.isPhone(context) ? 0.9 : 1.0,
            ),
            itemCount: _pancPlants.length,
            itemBuilder: (context, index) {
              final plant = _pancPlants[index];
              return _buildPancCard(plant);
            },
          ),
          
          SizedBox(height: Responsive.scale(context, 32)),
          
          // Dicas rápidas
          Container(
            padding: EdgeInsets.all(Responsive.scale(context, 16)),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber[100]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.amber[700],
                      size: Responsive.fontSize(context, 24),
                    ),
                    SizedBox(width: Responsive.scale(context, 8)),
                    Text(
                      'Dicas Rápidas',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[900],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.scale(context, 12)),
                ..._buildTipsList(),
              ],
            ),
          ),
          
          SizedBox(height: Responsive.scale(context, 20)),
        ],
      ),
    );
  }

  List<Widget> _buildTipsList() {
    return [
      _buildTipRow('🌱', 'Comece com solo bem drenado'),
      _buildTipRow('💧', 'Ajuste a rega conforme a espécie'),
      _buildTipRow('☀️', 'Observe as necessidades de luz solar'),
      _buildTipRow('🌿', 'Use preferencialmente adubos orgânicos'),
      _buildTipRow('🔄', 'Faça rotação de cultivos para melhor solo'),
      _buildTipRow('👀', 'Observe a planta regularmente'),
    ];
  }

  Widget _buildTipRow(String emoji, String text) {
  return Padding(
    padding: EdgeInsets.only(bottom: Responsive.scale(context, 8)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          emoji,
          style: TextStyle(fontSize: Responsive.fontSize(context, 18)),
        ),
        SizedBox(width: Responsive.scale(context, 12)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 14),
              color: Colors.amber[900],
            ),
          ),
        ),
      ],
    ),
  );
} 

  Widget _buildPancCard(Plant plant) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _selectedPlant = plant;
            _searchController.text = plant.name;
          });
        },
        child: Container(
          constraints: BoxConstraints(
            minHeight: Responsive.scale(context, 120), // Altura mínima
          ),
          child: Padding(
            padding: EdgeInsets.all(Responsive.scale(context, 10)), // REDUZI O PADDING
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: Responsive.scale(context, 40), // REDUZI O TAMANHO
                  height: Responsive.scale(context, 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green[300]!.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.eco,
                    color: Colors.green[700],
                    size: Responsive.fontSize(context, 20), // REDUZI O TAMANHO
                  ),
                ),
                SizedBox(height: Responsive.scale(context, 6)), // REDUZI O ESPAÇO
                
                // NOME DA PLANTA COM OVERFLOW CONTROLADO
                Container(
                  height: Responsive.scale(context, 36), // ALTURA FIXA
                  alignment: Alignment.center,
                  child: Text(
                    plant.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 13), // REDUZI A FONTE
                      fontWeight: FontWeight.w600,
                      color: Colors.green[900],
                      height: 1.2,
                    ),
                  ),
                ),
                
                SizedBox(height: Responsive.scale(context, 4)), // REDUZI O ESPAÇO
                
                // NOME CIENTÍFICO COM OVERFLOW CONTROLADO
                Text(
                  _getShortScientificName(plant.scientificName),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 10), // REDUZI A FONTE
                    fontStyle: FontStyle.italic,
                    color: Colors.green[700],
                  ),
                ),
                
                SizedBox(height: Responsive.scale(context, 6)), // REDUZI O ESPAÇO
                
                // BADGE PANC
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.scale(context, 8),
                    vertical: Responsive.scale(context, 2),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'PANC',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 9), // REDUZI A FONTE
                      color: Colors.green[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getShortScientificName(String fullName) {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0].substring(0, 1).toUpperCase()}. ${parts[1].toLowerCase()}';
    }
    return fullName;
  }

  // MÉTODO _buildPlantInfo COMPLETO - ADICIONADO
  Widget _buildPlantInfo() {
    final plant = _selectedPlant!;
    final care = plant.careInstructions;

    String getCareInfo(String key) {
      final value = care[key];
      if (value == null) return 'Informação não disponível';
      return value.toString();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CABEÇALHO DA PLANTA
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green[50]!,
                  Colors.green[100]!,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green[300]!.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(Responsive.scale(context, 20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Responsive.scale(context, 60),
                        height: Responsive.scale(context, 60),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green[300]!.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.eco,
                          size: Responsive.fontSize(context, 32),
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(width: Responsive.scale(context, 16)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plant.name,
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, 24),
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900],
                              ),
                            ),
                            SizedBox(height: Responsive.scale(context, 4)),
                            Text(
                              plant.scientificName,
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, 14),
                                fontStyle: FontStyle.italic,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.scale(context, 12),
                          vertical: Responsive.scale(context, 6),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'PANC',
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 12),
                            color: Colors.green[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.scale(context, 16)),
                  Text(
                    plant.description,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 16),
                      color: Colors.green[800],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: Responsive.scale(context, 24)),
          
          // INSTRUÇÕES DE CUIDADO
          Text(
            '📋 Instruções de Cultivo',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 20),
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          
          SizedBox(height: Responsive.scale(context, 16)),
          
          _buildCareItem(
            '💧 Rega', 
            getCareInfo('watering'),
            Icons.water_drop,
            Colors.blue,
          ),
          
          _buildCareItem(
            '☀️ Luz Solar', 
            getCareInfo('sunlight'),
            Icons.wb_sunny,
            Colors.orange,
          ),
          
          _buildCareItem(
            '🌡️ Temperatura', 
            getCareInfo('temperature'),
            Icons.thermostat,
            Colors.red,
          ),
          
          _buildCareItem(
            '🌱 Solo', 
            getCareInfo('soil'),
            Icons.landscape,
            Colors.brown,
          ),
          
          _buildCareItem(
            '🍃 Fertilização', 
            getCareInfo('fertilization'),
            Icons.eco,
            Colors.green,
          ),
          
          // BENEFÍCIOS
          SizedBox(height: Responsive.scale(context, 24)),
          
          Container(
            padding: EdgeInsets.all(Responsive.scale(context, 16)),
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.lightBlue[100]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🌿 Benefícios das PANC',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 16),
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                SizedBox(height: Responsive.scale(context, 8)),
                ..._buildBenefitsList(),
              ],
            ),
          ),
          
          SizedBox(height: Responsive.scale(context, 32)),
          
          // BOTÕES
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.arrow_back,
                    size: Responsive.fontSize(context, 18),
                  ),
                  label: Text(
                    'Voltar à lista',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 16),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedPlant = null;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: Responsive.scale(context, 14),
                    ),
                    side: BorderSide(color: Colors.green[700]!),
                    foregroundColor: Colors.green[700],
                  ),
                ),
              ),
              SizedBox(width: Responsive.scale(context, 12)),
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.search,
                    size: Responsive.fontSize(context, 18),
                  ),
                  label: Text(
                    'Nova busca',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 16),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedPlant = null;
                      _searchController.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: EdgeInsets.symmetric(
                      vertical: Responsive.scale(context, 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: Responsive.scale(context, 20)),
        ],
      ),
    );
  }

  List<Widget> _buildBenefitsList() {
    return [
      _buildBenefitItem('• Alta adaptabilidade ao clima local'),
      _buildBenefitItem('• Resistência natural a pragas'),
      _buildBenefitItem('• Rico valor nutricional'),
      _buildBenefitItem('• Baixa exigência de recursos'),
      _buildBenefitItem('• Promove biodiversidade'),
      _buildBenefitItem('• Cultivo sustentável'),
    ];
  }

  Widget _buildBenefitItem(String text) {
  return Padding(
    padding: EdgeInsets.only(bottom: Responsive.scale(context, 6)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✓',
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: Responsive.fontSize(context, 14),
          ),
        ),
        SizedBox(width: Responsive.scale(context, 8)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 14),
              color: Colors.blue[800],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildCareItem(String title, String description, IconData icon, Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: Responsive.scale(context, 12)),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(Responsive.scale(context, 16)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Responsive.scale(context, 40),
              height: Responsive.scale(context, 40),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: Responsive.fontSize(context, 20),
                color: color,
              ),
            ),
            SizedBox(width: Responsive.scale(context, 16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 16),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: Responsive.scale(context, 8)),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 14),
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}