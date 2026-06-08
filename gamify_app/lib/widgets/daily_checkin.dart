import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';

/// Карточка ежедневного входа с наградами за 7 дней
class DailyCheckIn extends StatelessWidget {
  const DailyCheckIn({super.key});

  static const List<int> rewards = [10, 20, 30, 40, 50, 75, 150];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final streak = state.user.streak;
    final claimed = state.dailyClaimedToday;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department_rounded,
                  color: AppTheme.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                'Ежедневный вход',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                'Серия: $streak 🔥',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 7 дней
          Row(
            children: List.generate(7, (i) {
              final day = i + 1;
              final isPast = day <= streak;
              final isToday = day == streak + 1 && !claimed;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 6 ? 6 : 0),
                  child: Column(
                    children: [
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: isPast
                              ? AppTheme.primary
                              : isToday
                                  ? AppTheme.primary.withOpacity(0.12)
                                  : AppTheme.background,
                          borderRadius: BorderRadius.circular(12),
                          border: isToday
                              ? Border.all(color: AppTheme.primary, width: 2)
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isPast
                                  ? Icons.check_rounded
                                  : Icons.monetization_on_rounded,
                              color: isPast
                                  ? Colors.white
                                  : isToday
                                      ? AppTheme.primary
                                      : AppTheme.textHint,
                              size: 18,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${rewards[i]}',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: isPast
                                    ? Colors.white
                                    : isToday
                                        ? AppTheme.primary
                                        : AppTheme.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Д$day',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: claimed
                  ? null
                  : () {
                      final reward = rewards[streak.clamp(0, 6)];
                      state.claimDaily(reward, 20);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('+$reward монет и +20 XP за вход! 🎉'),
                          backgroundColor: AppTheme.questGreen,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    claimed ? AppTheme.silver : AppTheme.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                claimed ? 'Уже получено сегодня ✓' : 'Забрать награду',
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}