import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> notifications = [
      {
        'type': 'like',
        'user': 'Maria Silva',
        'avatar': 'assets/images/chef.jpg',
        'message': 'curtiu sua receita "Brownie zero açúcar"',
        'time': '5 min atrás',
        'isRead': false,
      },
      {
        'type': 'comment',
        'user': 'João Santos',
        'avatar': 'assets/images/chef.jpg',
        'message': 'comentou em "Lasanha de panela"',
        'time': '1 hora atrás',
        'isRead': false,
      },
      {
        'type': 'follow',
        'user': 'Ana Souza',
        'avatar': 'assets/images/chef.jpg',
        'message': 'começou a seguir você',
        'time': '2 horas atrás',
        'isRead': true,
      },
      {
        'type': 'rating',
        'user': 'Pedro Lima',
        'avatar': 'assets/images/chef.jpg',
        'message': 'avaliou "Bolo de milho" com 5 estrelas',
        'time': '1 dia atrás',
        'isRead': true,
      },
      {
        'type': 'save',
        'user': 'Carla Dias',
        'avatar': 'assets/images/chef.jpg',
        'message': 'salvou sua receita "Canjica zero lactose"',
        'time': '2 dias atrás',
        'isRead': true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF7CB342),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'Notificações',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF3C4D18),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              print('Mark all as read');
              // Implementar marcar todas como lidas
            },
            child: Text(
              'Marcar todas\ncomo lidas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Color(0xFFFA9500),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(context, notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, Map<String, dynamic> notification) {
    IconData icon;
    Color iconColor;

    switch (notification['type']) {
      case 'like':
        icon = Icons.favorite;
        iconColor = Colors.red;
        break;
      case 'comment':
        icon = Icons.comment;
        iconColor = Color(0xFFFA9500);
        break;
      case 'follow':
        icon = Icons.person_add;
        iconColor = Color(0xFF7CB342);
        break;
      case 'rating':
        icon = Icons.star;
        iconColor = Color(0xFFFFB300);
        break;
      case 'save':
        icon = Icons.bookmark;
        iconColor = Color(0xFFFA9500);
        break;
      default:
        icon = Icons.notifications;
        iconColor = Color(0xFF666666);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: notification['isRead'] ? Colors.white : Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: notification['isRead']
              ? Color(0xFFE0E0E0)
              : Color(0xFFFA9500).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage(notification['avatar']),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Color(0xFF3C4D18),
            ),
            children: [
              TextSpan(
                text: notification['user'],
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: ' ${notification['message']}',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            notification['time'],
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              color: Color(0xFF999999),
            ),
          ),
        ),
        trailing: !notification['isRead']
            ? Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Color(0xFFFA9500),
            shape: BoxShape.circle,
          ),
        )
            : null,
        onTap: () {
          print('Notification tapped: ${notification['message']}');
          // Navegar para o conteúdo relacionado
        },
      ),
    );
  }
}