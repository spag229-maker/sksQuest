import 'package:flutter/material.dart';

/// Награда в истории бонусов
class RewardHistoryItem {
  final String title;
  final String subtitle;
  final int amount; // положительное = начислено, отрицательное = потрачено
  final bool isCoins; // true = монеты, false = XP
  final IconData icon;
  final Color color;
  final DateTime date;

  RewardHistoryItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isCoins,
    required this.icon,
    required this.color,
    required this.date,
  });

  static List<RewardHistoryItem> demoList() => [
        RewardHistoryItem(
          title: 'Ежедневный вход',
          subtitle: 'Серия 7 дней',
          amount: 50,
          isCoins: true,
          icon: Icons.calendar_today_rounded,
          color: const Color(0xFFE8002D),
          date: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        RewardHistoryItem(
          title: 'Квест выполнен',
          subtitle: 'Оплати 3 счёта',
          amount: 150,
          isCoins: false,
          icon: Icons.emoji_events_rounded,
          color: const Color(0xFF00C853),
          date: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        RewardHistoryItem(
          title: 'Колесо фортуны',
          subtitle: 'Выигрыш',
          amount: 100,
          isCoins: true,
          icon: Icons.casino_rounded,
          color: const Color(0xFF7C4DFF),
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        RewardHistoryItem(
          title: 'Обмен на скидку',
          subtitle: 'Скидка 10%',
          amount: -200,
          isCoins: true,
          icon: Icons.local_offer_rounded,
          color: const Color(0xFF2979FF),
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];
}

/// Приз в колесе фортуны
class WheelPrize {
  final String label;
  final int value;
  final bool isCoins;
  final Color color;

  const WheelPrize({
    required this.label,
    required this.value,
    required this.isCoins,
    required this.color,
  });
}

/// Игрок в лидерборде
class LeaderboardEntry {
  final int rank;
  final String name;
  final int xp;
  final String league;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.xp,
    required this.league,
    this.isCurrentUser = false,
  });

  static List<LeaderboardEntry> demoList() => const [
        LeaderboardEntry(rank: 1, name: 'Мария В.', xp: 4820, league: 'Gold'),
        LeaderboardEntry(rank: 2, name: 'Дмитрий С.', xp: 3650, league: 'Gold'),
        LeaderboardEntry(rank: 3, name: 'Елена П.', xp: 2900, league: 'Silver'),
        LeaderboardEntry(
            rank: 4,
            name: 'Алексей К.',
            xp: 1240,
            league: 'Silver',
            isCurrentUser: true),
        LeaderboardEntry(rank: 5, name: 'Игорь М.', xp: 1100, league: 'Silver'),
        LeaderboardEntry(rank: 6, name: 'Ольга Т.', xp: 980, league: 'Bronze'),
        LeaderboardEntry(rank: 7, name: 'Сергей Л.', xp: 720, league: 'Bronze'),
      ];
}