import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/quest_model.dart';
import '../models/badge_model.dart';
import '../models/reward_model.dart';

class AppState extends ChangeNotifier {
  final UserModel user = UserModel.demo();
  final List<QuestModel> quests = QuestModel.demoList();
  final List<BadgeModel> badges = BadgeModel.demoList();
  final List<RewardHistoryItem> history = RewardHistoryItem.demoList();
  final List<LeaderboardEntry> leaderboard = LeaderboardEntry.demoList();

  bool dailyClaimedToday = false;
  bool wheelSpinAvailable = true;

  // ── Ежедневный вход ──
  void claimDaily(int coins, int xp) {
    if (dailyClaimedToday) return;
    dailyClaimedToday = true;
    user.coins += coins;
    user.xp += xp;
    user.streak += 1;
    _checkLevelUp();
    history.insert(
      0,
      RewardHistoryItem(
        title: 'Ежедневный вход',
        subtitle: 'Серия ${user.streak} дней',
        amount: coins,
        isCoins: true,
        icon: Icons.calendar_today_rounded,
        color: const Color(0xFFE8002D),
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  // ── Квесты ──
  void claimQuest(QuestModel quest) {
    if (!quest.isCompleted || quest.claimed) return;
    quest.claimed = true;
    user.coins += quest.coinReward;
    user.xp += quest.xpReward;
    _checkLevelUp();
    history.insert(
      0,
      RewardHistoryItem(
        title: 'Квест выполнен',
        subtitle: quest.title,
        amount: quest.xpReward,
        isCoins: false,
        icon: Icons.emoji_events_rounded,
        color: quest.color,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  // ── Колесо фортуны ──
  void applyWheelPrize(WheelPrize prize) {
    wheelSpinAvailable = false;
    if (prize.isCoins) {
      user.coins += prize.value;
    } else {
      user.xp += prize.value;
      _checkLevelUp();
    }
    history.insert(
      0,
      RewardHistoryItem(
        title: 'Колесо фортуны',
        subtitle: 'Выигрыш: ${prize.label}',
        amount: prize.value,
        isCoins: prize.isCoins,
        icon: Icons.casino_rounded,
        color: prize.color,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  // ── Магазин ──
  void spendCoins(int amount) {
    if (user.coins < amount) return;
    user.coins -= amount;
    history.insert(
      0,
      RewardHistoryItem(
        title: 'Покупка в магазине',
        subtitle: 'Списание монет',
        amount: -amount,
        isCoins: true,
        icon: Icons.shopping_bag_rounded,
        color: const Color(0xFF9E9E9E),
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void _checkLevelUp() {
    while (user.xp >= user.level * 500) {
      user.level += 1;
    }
  }
}