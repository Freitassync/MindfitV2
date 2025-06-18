import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_has_app/providers/user_provider.dart';
import 'package:smart_has_app/screens/main_dashboard_screen.dart';
import 'package:smart_has_app/screens/workout_planner_screen.dart';
import 'package:smart_has_app/screens/nutrition_tracker_screen.dart';
import 'package:smart_has_app/screens/settings_screen.dart';
import 'package:smart_has_app/widgets/compact_map_widget.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Adiciona mensagem de boas-vindas
    _addBotMessage(
        "Olá! Sou seu assistente de saúde e fitness. Como posso ajudá-lo hoje?");
  }

  void _addBotMessage(String message) {
    setState(() {
      _messages.add({
        'text': message,
        'isUser': false,
        'timestamp': DateTime.now(),
      });
    });
    _scrollToBottom();
  }

  void _addUserMessage(String message) {
    setState(() {
      _messages.add({
        'text': message,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _addUserMessage(message);
    _messageController.clear();

    // Simula resposta do bot
    Future.delayed(const Duration(milliseconds: 1000), () {
      _generateBotResponse(message);
    });
  }

  void _generateBotResponse(String userMessage) {
    String response = "Desculpe, não entendi sua pergunta. Pode reformular?";

    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('treino') || lowerMessage.contains('exercício')) {
      response =
          "Ótima pergunta sobre treinos! Baseado no seu perfil, recomendo começar com exercícios de intensidade moderada. Que tipo de atividade você prefere: cardio, força ou flexibilidade?";
    } else if (lowerMessage.contains('dieta') ||
        lowerMessage.contains('alimentação') ||
        lowerMessage.contains('comida')) {
      response =
          "Para uma alimentação saudável, é importante manter o equilíbrio entre proteínas, carboidratos e gorduras boas. Considerando suas restrições alimentares, posso sugerir algumas opções específicas. O que você gostaria de saber?";
    } else if (lowerMessage.contains('peso') ||
        lowerMessage.contains('emagrecer') ||
        lowerMessage.contains('perder')) {
      response =
          "Para atingir seu objetivo de peso, é importante combinar exercícios regulares com uma alimentação balanceada. Baseado no seu perfil atual, você está no caminho certo! Quer dicas específicas?";
    } else if (lowerMessage.contains('água') ||
        lowerMessage.contains('hidratação')) {
      response =
          "A hidratação é fundamental! Recomendo beber pelo menos 2-3 litros de água por dia, especialmente antes, durante e após os exercícios.";
    } else if (lowerMessage.contains('sono') ||
        lowerMessage.contains('dormir')) {
      response =
          "O sono é crucial para a recuperação muscular e o bem-estar geral. Tente manter uma rotina de 7-9 horas de sono por noite para melhores resultados.";
    } else if (lowerMessage.contains('motivação') ||
        lowerMessage.contains('desânimo')) {
      response =
          "Entendo que às vezes é difícil manter a motivação. Lembre-se dos seus objetivos e celebre cada pequena conquista. Você já fez muito progresso!";
    } else if (lowerMessage.contains('olá') ||
        lowerMessage.contains('oi') ||
        lowerMessage.contains('bom dia')) {
      response =
          "Olá! Como você está se sentindo hoje? Posso ajudá-lo com dicas de treino, alimentação ou qualquer dúvida sobre saúde e fitness.";
    }

    _addBotMessage(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const MainDashboardScreen())),
        ),
        title: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return Text(
              "Olá, ${userProvider.userName}!",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Área de chat
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  // Header do chat
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green,
                          child:
                              const Icon(Icons.smart_toy, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Assistente MindFit",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Online • Sempre pronto para ajudar",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Mensagens
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
                  ),

                  // Campo de entrada
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12)),
                      border:
                          Border(top: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: "Digite sua mensagem...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.green,
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: _sendMessage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.black),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    final text = message['text'] as String;
    final timestamp = message['timestamp'] as DateTime;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green,
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? Colors.green : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
