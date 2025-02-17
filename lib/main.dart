import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget { // Alteração de estado da tela
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cepController = TextEditingController(); // Controlador do campo de texto - é utilizado para acessar o valor do campo de texto
  String _result = ''; // Variável para armazenar o resultado da consulta

  Future<void> _searchCEP() async {
    final response = await http.get(Uri.parse('https://viacep.com.br/ws/${_cepController.text}/json/')); // Consulta de CEP chamando a API do ViaCEP

    if (response.statusCode == 200) { // Verifica se a requisição foi bem sucedida
      _result = response.body; // Armazena o resultado da consulta
      // Transforma o JSON retornado pela API em um Map
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() { //Mudança de estado para atualizar interface
        _result = 'CEP: ${data['cep']}\n'
            'Logradouro: ${data['logradouro']}\n'
            'Complemento: ${data['complemento']}\n'
            'Bairro: ${data['bairro']}\n'
            'Localidade: ${data['localidade']}\n'
            'UF: ${data['uf']}';
      });
       } else {
      setState(() { // Mudança de estado para atualizar interface
        _result = 'CEP não encontrado';
      });
    }
  }

  @override // Método que constrói a interface do aplicativo
  Widget build(BuildContext context) { // Recebe o contexto do aplicativo
    return Scaffold( // Retorna um Scaffold que é a estrutura básica de uma tela
      appBar: AppBar( // Barra superior da tela
        title: const Text('Consulta de CEP - Gabriel Rodrigues - 17/06/2024',
          style: TextStyle(fontSize: 14),), // Título da tela
      ),
      body: Padding( // Corpo da tela
        padding: const EdgeInsets.all(16.0), // Espaçamento
        child: Column( // Coluna de widgets
          children: [
            TextField( // Campo de texto para o CEP
              controller: _cepController,
              decoration: const InputDecoration(labelText: 'CEP'),
            ),
            ElevatedButton( // Botão para realizar a consulta
              onPressed: _searchCEP, // Função que é chamada ao pressionar o botão
              child: const Text('Consultar'), // Texto do botão
            ),
            const SizedBox(height: 16), // Espaçamento
            Text(_result), // Resultado da consulta
          ],
        ),
      ),
    );
  }
}