import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF18243C), Color(0xFF2E3B55).withOpacity(0.8)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sobre o App',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.info, color: Color(0xFFFF9626), size: 24),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 2,
                    width: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF9626), Colors.white],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // O que o app faz
                _buildSectionTitle('O que o App Faz', context),
                _buildSectionContent(
                  'O "Guia Turístico Inteligente para Chimoio" é um aplicativo móvel projetado para ajudar turistas e moradores a explorar a cidade de Chimoio, Moçambique. Ele oferece uma experiência interativa com:\n\n'
                  'Lista de Pontos Turísticos: Descubra locais como Monte Bengo e Lago Chicamba.\n'
                  'Restaurantes: Encontre opções gastronômicas locais.\n'
                  'Eventos: Fique por dentro de festivais e atividades.\n'
                  'Roteiros Personalizados: Crie itinerários com distâncias e tempos estimados.\n'
                  'Mapa Interativo: Visualize rotas e pontos de interesse com suporte offline para dados locais.',
                  context,
                ),

                // Benefícios
                _buildSectionTitle('Benefícios', context),
                _buildSectionContent(
                  'Facilidade de Uso: Interface intuitiva e amigável.\n'
                  'Modo Offline: Acesso a listas mesmo sem internet.\n'
                  'Navegação: Rotas em tempo real com Google Maps.\n'
                  'Personalização: Monte seu próprio roteiro.\n'
                  'Informação Local: Detalhes sobre Chimoio ao seu alcance.',
                  context,
                ),

                // Desenvolvedor
                _buildSectionTitle('Desenvolvedor', context),
                _buildSectionContent(
                  'Desenvolvido por Francelino David N. Rungo, um entusiasta apaixonado por tecnologia e turismo, com o objetivo de promover Chimoio como destino turístico e facilitar a experiência dos visitantes.',
                  context,
                ),

                // Ferramentas Usadas
                _buildSectionTitle('Ferramentas Usadas', context),
                _buildSectionContent(
                  'Flutter: Framework para desenvolvimento multiplataforma.\n'
                  'Dart: Linguagem de programação.\n'
                  'Google Maps API: Para mapas e rotas.\n'
                  'SQFLite: Banco de dados local para modo offline.\n'
                  'Outras: HTTP, Location, e bibliotecas Flutter.',
                  context,
                ),

                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF9626),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'Voltar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFF9626),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Text(
        content,
        style: TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
      ),
    );
  }
}
