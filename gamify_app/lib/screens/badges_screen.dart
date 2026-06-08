import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ─── Data model ───────────────────────────────────────────────────────────────

class Badge {
  final String id;
  final String emoji;        // shown when earned
  final String name;
  final String description;  // how to earn
  final String milestone;    // e.g. "7 дней подряд"
  final Color color;         // accent when earned
  final bool earned;

  const Badge({
    required this.id,
    required this.emoji,
    required this.name,
    required this.description,
    required this.milestone,
    required this.color,
    this.earned = false,
  });
}

const _badges = [
  Badge(
    id: 'first_step',
    emoji: '🚀',
    name: 'Первый шаг',
    description: 'Войди в приложение первый раз',
    milestone: 'Вход в систему',
    color: AppTheme.questGreen,
    earned: true, // ← единственный полученный
  ),
  Badge(
    id: 'week_streak',
    emoji: '🔥',
    name: 'Огненная неделя',
    description: 'Заходи 7 дней подряд',
    milestone: '7 дней подряд',
    color: AppTheme.primary,
  ),
  Badge(
    id: 'coin_collector',
    emoji: '💰',
    name: 'Монетный двор',
    description: 'Накопи 1000 монет',
    milestone: '1000 монет',
    color: AppTheme.gold,
  ),
  Badge(
    id: 'wheel_master',
    emoji: '🎡',
    name: 'Мастер колеса',
    description: 'Выиграй джекпот на колесе',
    milestone: 'Джекпот ×1',
    color: AppTheme.legendaryPurple,
  ),
  Badge(
    id: 'legend',
    emoji: '👑',
    name: 'Легенда',
    description: 'Достигни 10 уровня',
    milestone: 'Уровень 10',
    color: AppTheme.xpBlue,
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final earned = _badges.where((b) => b.earned).length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2)),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 16, color: AppTheme.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Мои бейджи',
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  // Progress pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppTheme.primary.withOpacity(0.2), width: 1.5),
                    ),
                    child: Text(
                      '$earned / ${_badges.length}',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Собери все бейджи — стань легендой',
                    style: GoogleFonts.manrope(
                        fontSize: 13, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ── Overall progress bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: earned / _badges.length,
                      minHeight: 8,
                      backgroundColor: AppTheme.textHint.withOpacity(0.15),
                      valueColor:
                          const AlwaysStoppedAnimation(AppTheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ── List ──
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                itemCount: _badges.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _BadgeTile(badge: _badges[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Badge tile ───────────────────────────────────────────────────────────────

class _BadgeTile extends StatelessWidget {
  final Badge badge;
  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: badge.earned
            ? Border.all(color: badge.color.withOpacity(0.35), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: badge.earned
                ? badge.color.withOpacity(0.10)
                : Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // ── Badge icon ──
            _BadgeIcon(badge: badge),
            const SizedBox(width: 16),

            // ── Text ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        badge.name,
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: badge.earned
                              ? AppTheme.textPrimary
                              : AppTheme.textSecondary,
                        ),
                      ),
                      if (badge.earned) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: badge.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Получен',
                            style: GoogleFonts.manrope(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: badge.color,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    badge.description,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Milestone chip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: badge.earned
                          ? badge.color.withOpacity(0.09)
                          : AppTheme.textHint.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          badge.earned
                              ? Icons.check_circle_rounded
                              : Icons.lock_outline_rounded,
                          size: 11,
                          color: badge.earned
                              ? badge.color
                              : AppTheme.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          badge.milestone,
                          style: GoogleFonts.manrope(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: badge.earned
                                ? badge.color
                                : AppTheme.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Badge icon widget ────────────────────────────────────────────────────────

class _BadgeIcon extends StatelessWidget {
  final Badge badge;
  const _BadgeIcon({required this.badge});

  @override
  Widget build(BuildContext context) {
    if (badge.earned) {
      // Full coloured hexagon-ish badge
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Color.lerp(badge.color, Colors.white, 0.3)!,
              badge.color,
            ],
            center: const Alignment(-0.3, -0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: badge.color.withOpacity(0.40),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.4), width: 2),
              ),
            ),
            Text(badge.emoji, style: const TextStyle(fontSize: 28)),
          ],
        ),
      );
    }

    // Locked — grey silhouette
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.textHint.withOpacity(0.10),
        border:
            Border.all(color: AppTheme.textHint.withOpacity(0.20), width: 2),
      ),
      child: Center(
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.2, 0.2, 0.2, 0, 0,
            0.2, 0.2, 0.2, 0, 0,
            0.2, 0.2, 0.2, 0, 0,
            0,   0,   0,   0.25, 0,
          ]),
          child: Text(badge.emoji, style: const TextStyle(fontSize: 28)),
        ),
      ),
    );
  }
}