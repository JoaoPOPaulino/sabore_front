// lib/providers/state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mock_recipe_service.dart';
import '../models/models.dart';

class StateData {
  final String name;
  final int recipesCount;
  final String emoji;
  final int color;
  final String region;

  StateData({
    required this.name,
    required this.recipesCount,
    required this.emoji,
    required this.color,
    required this.region,
  });
}

// Provider para contar receitas por estado
final stateRecipeCountsProvider = FutureProvider<Map<String, int>>((ref) async {
  final service = MockRecipeService();
  final allRecipes = await service.getAllRecipes();

  final Map<String, int> counts = {};
  for (final recipe in allRecipes) {
    if (recipe.state != null && recipe.state!.isNotEmpty && recipe.state != 'Nenhum') {
      counts[recipe.state!] = (counts[recipe.state!] ?? 0) + 1;
    }
  }

  print('📊 Contagem de receitas por estado:');
  counts.forEach((state, count) {
    print('   - $state: $count receitas');
  });

  return counts;
});

// Provider principal com contagem real
final brazilianStatesProvider = FutureProvider<List<StateData>>((ref) async {
  // Aguardar contagem de receitas
  final recipeCounts = await ref.watch(stateRecipeCountsProvider.future);

  // Mapear siglas para nomes completos
  final stateAbbreviations = {
    'AC': 'Acre',
    'AL': 'Alagoas',
    'AP': 'Amapá',
    'AM': 'Amazonas',
    'BA': 'Bahia',
    'CE': 'Ceará',
    'DF': 'Distrito Federal',
    'ES': 'Espírito Santo',
    'GO': 'Goiás',
    'MA': 'Maranhão',
    'MT': 'Mato Grosso',
    'MS': 'Mato Grosso do Sul',
    'MG': 'Minas Gerais',
    'PA': 'Pará',
    'PB': 'Paraíba',
    'PR': 'Paraná',
    'PE': 'Pernambuco',
    'PI': 'Piauí',
    'RJ': 'Rio de Janeiro',
    'RN': 'Rio Grande do Norte',
    'RS': 'Rio Grande do Sul',
    'RO': 'Rondônia',
    'RR': 'Roraima',
    'SC': 'Santa Catarina',
    'SP': 'São Paulo',
    'SE': 'Sergipe',
    'TO': 'Tocantins'
  };

  // Todos os 27 estados brasileiros
  final states = [
    // NORTE
    StateData(
      name: 'Acre',
      recipesCount: recipeCounts['Acre'] ?? recipeCounts['AC'] ?? 0,
      emoji: '🌳',
      color: 0xFF2E7D32,
      region: 'Norte',
    ),
    StateData(
      name: 'Amapá',
      recipesCount: recipeCounts['Amapá'] ?? recipeCounts['AP'] ?? 0,
      emoji: '🐟',
      color: 0xFF00796B,
      region: 'Norte',
    ),
    StateData(
      name: 'Amazonas',
      recipesCount: recipeCounts['Amazonas'] ?? recipeCounts['AM'] ?? 0,
      emoji: '🐠',
      color: 0xFF43A047,
      region: 'Norte',
    ),
    StateData(
      name: 'Pará',
      recipesCount: recipeCounts['Pará'] ?? recipeCounts['PA'] ?? 0,
      emoji: '🍇',
      color: 0xFF8E24AA,
      region: 'Norte',
    ),
    StateData(
      name: 'Rondônia',
      recipesCount: recipeCounts['Rondônia'] ?? recipeCounts['RO'] ?? 0,
      emoji: '☕',
      color: 0xFF6D4C41,
      region: 'Norte',
    ),
    StateData(
      name: 'Roraima',
      recipesCount: recipeCounts['Roraima'] ?? recipeCounts['RR'] ?? 0,
      emoji: '🏔️',
      color: 0xFF455A64,
      region: 'Norte',
    ),
    StateData(
      name: 'Tocantins',
      recipesCount: recipeCounts['Tocantins'] ?? recipeCounts['TO'] ?? 0,
      emoji: '🌾',
      color: 0xFFFDD835,
      region: 'Norte',
    ),

    // NORDESTE
    StateData(
      name: 'Alagoas',
      recipesCount: recipeCounts['Alagoas'] ?? recipeCounts['AL'] ?? 0,
      emoji: '🥥',
      color: 0xFF00897B,
      region: 'Nordeste',
    ),
    StateData(
      name: 'Bahia',
      recipesCount: recipeCounts['Bahia'] ?? recipeCounts['BA'] ?? 0,
      emoji: '🥥',
      color: 0xFFFF6F00,
      region: 'Nordeste',
    ),
    StateData(
      name: 'Ceará',
      recipesCount: recipeCounts['Ceará'] ?? recipeCounts['CE'] ?? 0,
      emoji: '🦀',
      color: 0xFFFF5722,
      region: 'Nordeste',
    ),
    StateData(
      name: 'Maranhão',
      recipesCount: recipeCounts['Maranhão'] ?? recipeCounts['MA'] ?? 0,
      emoji: '🦐',
      color: 0xFFE64A19,
      region: 'Nordeste',
    ),
    StateData(
      name: 'Paraíba',
      recipesCount: recipeCounts['Paraíba'] ?? recipeCounts['PB'] ?? 0,
      emoji: '🌴',
      color: 0xFF1565C0,
      region: 'Nordeste',
    ),
    StateData(
      name: 'Pernambuco',
      recipesCount: recipeCounts['Pernambuco'] ?? recipeCounts['PE'] ?? 0,
      emoji: '🦞',
      color: 0xFFE91E63,
      region: 'Nordeste',
    ),
    StateData(
      name: 'Piauí',
      recipesCount: recipeCounts['Piauí'] ?? recipeCounts['PI'] ?? 0,
      emoji: '🌵',
      color: 0xFF827717,
      region: 'Nordeste',
    ),
    StateData(
      name: 'Rio Grande do Norte',
      recipesCount: recipeCounts['Rio Grande do Norte'] ?? recipeCounts['RN'] ?? 0,
      emoji: '🦐',
      color: 0xFF0277BD,
      region: 'Nordeste',
    ),
    StateData(
      name: 'Sergipe',
      recipesCount: recipeCounts['Sergipe'] ?? recipeCounts['SE'] ?? 0,
      emoji: '🦐',
      color: 0xFF00ACC1,
      region: 'Nordeste',
    ),

    // CENTRO-OESTE
    StateData(
      name: 'Distrito Federal',
      recipesCount: recipeCounts['Distrito Federal'] ?? recipeCounts['DF'] ?? 0,
      emoji: '🏛️',
      color: 0xFF5E35B1,
      region: 'Centro-Oeste',
    ),
    StateData(
      name: 'Goiás',
      recipesCount: recipeCounts['Goiás'] ?? recipeCounts['GO'] ?? 0,
      emoji: '🌽',
      color: 0xFF7CB342,
      region: 'Centro-Oeste',
    ),
    StateData(
      name: 'Mato Grosso',
      recipesCount: recipeCounts['Mato Grosso'] ?? recipeCounts['MT'] ?? 0,
      emoji: '🌿',
      color: 0xFF558B2F,
      region: 'Centro-Oeste',
    ),
    StateData(
      name: 'Mato Grosso do Sul',
      recipesCount: recipeCounts['Mato Grosso do Sul'] ?? recipeCounts['MS'] ?? 0,
      emoji: '🐟',
      color: 0xFF00695C,
      region: 'Centro-Oeste',
    ),

    // SUDESTE
    StateData(
      name: 'Espírito Santo',
      recipesCount: recipeCounts['Espírito Santo'] ?? recipeCounts['ES'] ?? 0,
      emoji: '🐟',
      color: 0xFF0097A7,
      region: 'Sudeste',
    ),
    StateData(
      name: 'Minas Gerais',
      recipesCount: recipeCounts['Minas Gerais'] ?? recipeCounts['MG'] ?? 0,
      emoji: '🧀',
      color: 0xFFFFB300,
      region: 'Sudeste',
    ),
    StateData(
      name: 'Rio de Janeiro',
      recipesCount: recipeCounts['Rio de Janeiro'] ?? recipeCounts['RJ'] ?? 0,
      emoji: '🏖️',
      color: 0xFF00ACC1,
      region: 'Sudeste',
    ),
    StateData(
      name: 'São Paulo',
      recipesCount: recipeCounts['São Paulo'] ?? recipeCounts['SP'] ?? 0,
      emoji: '🏙️',
      color: 0xFF1976D2,
      region: 'Sudeste',
    ),

    // SUL
    StateData(
      name: 'Paraná',
      recipesCount: recipeCounts['Paraná'] ?? recipeCounts['PR'] ?? 0,
      emoji: '🌲',
      color: 0xFF388E3C,
      region: 'Sul',
    ),
    StateData(
      name: 'Rio Grande do Sul',
      recipesCount: recipeCounts['Rio Grande do Sul'] ?? recipeCounts['RS'] ?? 0,
      emoji: '🥩',
      color: 0xFFD32F2F,
      region: 'Sul',
    ),
    StateData(
      name: 'Santa Catarina',
      recipesCount: recipeCounts['Santa Catarina'] ?? recipeCounts['SC'] ?? 0,
      emoji: '🦐',
      color: 0xFF00796B,
      region: 'Sul',
    ),
  ];

  // Ordenar por quantidade de receitas (maior para menor)
  states.sort((a, b) => b.recipesCount.compareTo(a.recipesCount));

  return states;
});

// Provider para filtrar por região
final statesByRegionProvider = FutureProvider.family<List<StateData>, String>((ref, region) async {
  final allStates = await ref.watch(brazilianStatesProvider.future);

  if (region == 'Todos') {
    return allStates;
  }

  return allStates.where((state) => state.region == region).toList();
});

// ✅ CORRIGIDO: Provider para receitas de um estado específico usando getRecipesByState
final recipesByStateProvider = FutureProvider.family<List<Recipe>, String>((ref, stateName) async {
  final service = MockRecipeService();
  print('🔍 recipesByStateProvider chamado para: $stateName');
  final recipes = await service.getRecipesByState(stateName);
  print('📊 recipesByStateProvider retornou ${recipes.length} receitas');
  return recipes;
});