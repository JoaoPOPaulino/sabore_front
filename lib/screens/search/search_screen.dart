import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const String route = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isSearching = false;

  // Lista de receitas mock (adapte com seus dados)
  final List<Map<String, dynamic>> allRecipes = [
    {
      'name': 'Bolo de milho sem açúcar',
      'time': '1h20min',
      'ingredients': 9,
      'image': 'assets/images/bolo_milho.jpg'
    },
    {
      'name': 'Brownie sem lactose',
      'time': '40min',
      'ingredients': 11,
      'image': 'assets/images/brownie.jpg'
    },
    // Adicione suas receitas aqui
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Buscar receitas...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          onSubmitted: _performSearch,
          onChanged: (value) {
            if (value.isNotEmpty) {
              _performSearch(value);
            } else {
              setState(() {
                searchResults = [];
              });
            }
          },
        ),
      ),
      body: _buildSearchBody(),
    );
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      isSearching = true;
    });

    // Simular delay de busca
    Future.delayed(Duration(milliseconds: 300), () {
      final filtered = allRecipes.where((recipe) {
        return recipe['name'].toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        searchResults = filtered;
        isSearching = false;
      });
    });
  }

  Widget _buildSearchBody() {
    if (isSearching) {
      return Center(child: CircularProgressIndicator());
    }

    if (_searchController.text.isEmpty) {
      return _buildSuggestions();
    }

    if (searchResults.isEmpty) {
      return _buildNoResults();
    }

    return _buildSearchResults();
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sugestões',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSuggestionChip('Bolo'),
              _buildSuggestionChip('Brownie'),
              _buildSuggestionChip('Sem lactose'),
              _buildSuggestionChip('Sem açúcar'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String suggestion) {
    return GestureDetector(
      onTap: () {
        _searchController.text = suggestion;
        _performSearch(suggestion);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(suggestion),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Nenhuma receita encontrada',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final recipe = searchResults[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                recipe['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(recipe['name']),
            subtitle: Text('${recipe['time']} • ${recipe['ingredients']} ingredientes'),
            onTap: () {
              // Navegar para receita
            },
          ),
        );
      },
    );
  }
}