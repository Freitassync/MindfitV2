import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_has_app/providers/user_provider.dart';
import 'package:smart_has_app/providers/notification_provider.dart';
import 'package:smart_has_app/screens/main_dashboard_screen.dart'; // Importe seu provider de notificações

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MainDashboardScreen())),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "CONFIGURAÇÕES",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Perfil do usuário
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Perfil do Usuário",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.green,
                              child: Text(
                                userProvider.userName.isNotEmpty
                                    ? userProvider.userName[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userProvider.userName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${userProvider.currentUser?.age} anos",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Edição de perfil em desenvolvimento'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (userProvider.currentUser?.specialConditions.isNotEmpty ?? false) ...[
                          const Text(
                            "Condições Especiais:",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            children: userProvider.currentUser!.specialConditions.map((condition) =>
                              Chip(
                                label: Text(condition),
                                backgroundColor: Colors.blue.shade50,
                              ),
                            ).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Simulação de notificações
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Simular Notificações",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.fitness_center),
                          label: const Text("Treino"),
                          onPressed: () {
                            notificationProvider.simulateWorkoutReminder();
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.water_drop),
                          label: const Text("Água"),
                          onPressed: () {
                            notificationProvider.simulateWaterReminder();
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.restaurant),
                          label: const Text("Nutrição"),
                          onPressed: () {
                            notificationProvider.simulateNutritionAlert();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text("Limpar Notificações"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        notificationProvider.clearNotifications();
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Notificações Recebidas:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Consumer<NotificationProvider>(
                      builder: (context, notifProvider, child) {
                        if (notifProvider.notifications.isEmpty) {
                          return const Text(
                            "Nenhuma notificação recebida ainda.",
                            style: TextStyle(color: Colors.grey),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: notifProvider.notifications.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.notifications),
                              title: Text(notifProvider.notifications[index]),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sobre o App
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.info,
                    title: "Sobre o App",
                    subtitle: "Versão 1.0.0",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Sobre o MindFit'),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('MindFit - Seu aplicativo de saúde e fitness'),
                              SizedBox(height: 8),
                              Text('Versão: 1.0.0'),
                              Text('Desenvolvido com Flutter'),
                              SizedBox(height: 8),
                              Text('© 2024 MindFit. Todos os direitos reservados.'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Fechar'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingsTile(
                    icon: Icons.logout,
                    title: "Sair",
                    subtitle: "Fazer logout da conta",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar Saída'),
                          content: const Text('Deseja realmente sair da sua conta?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Logout em desenvolvimento'),
                                  ),
                                );
                              },
                              child: const Text('Sair', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    textColor: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}