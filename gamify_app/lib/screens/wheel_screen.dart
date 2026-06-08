import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../models/reward_model.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({super.key});

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _spinning = false;

  final List<WheelPrize> _prizes = const [
    WheelPrize(label: '50 монет', value: 50, isCoins: true, color: AppTheme.gold),
    WheelPrize(label: '100 XP', value: 100, isCoins: false, color: AppTheme.xpBlue),
    WheelPrize(label: '20 монет', value: 20, isCoins: true, color: AppTheme.questGreen),
    WheelPrize(label: 'ДЖЕКПОТ 500', value: 500, isCoins: true, color: AppTheme.primary),
    WheelPrize(label: '30 XP', value: 30, isCoins: false, color: AppTheme.legendaryPurple),
    WheelPrize(label: '10 монет', value: 10, isCoins: true, color: AppTheme.bronze),
    WheelPrize(label: '200 XP', value: 200, isCoins: false, color: AppTheme.xpBlue),
    WheelPrize(label: '75 монет', value: 75, isCoins: true, color: AppTheme.gold),
  ];

  double _currentAngle = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spin() {
    final state = context.read<AppState>();
    if (_spinning || !state.wheelSpinAvailable) return;

    final random = Random();
    final prizeIndex = random.nextInt(_prizes.length);
    final segmentAngle = 2 * pi / _prizes.length;
    // 5 полных оборотов + остановка на выбранном сегменте
    final targetAngle = (5 * 2 * pi) +
        (2 * pi - (prizeIndex * segmentAngle) - segmentAngle / 2);

    setState(() => _spinning = true);

    _animation = Tween<double>(begin: _currentAngle, end: targetAngle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward(from: 0).then((_) {
      _currentAngle = targetAngle % (2 * pi);
      setState(() => _spinning = false);
      final prize = _prizes[prizeIndex];
      state.applyWheelPrize(prize);
      _showPrizeDialog(prize);
    });
  }

  void _showPrizeDialog(WheelPrize prize) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 12),
              Text(
                'Поздравляем!',
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Ты выиграл ${prize.label}',
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Забрать',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final available = state.wheelSpinAvailable;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            children: [
              Text(
                'Колесо фортуны',
                style: GoogleFonts.manrope(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                available
                    ? 'У тебя есть 1 бесплатное вращение!'
                    : 'Возвращайся завтра за новым вращением',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: available ? AppTheme.questGreen : AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              // Колесо
              SizedBox(
                width: 300,
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: _spinning
                              ? _animation.value
                              : _currentAngle,
                          child: child,
                        );
                      },
                      child: CustomPaint(
                        size: const Size(300, 300),
                        painter: _WheelPainter(_prizes),
                      ),
                    ),
                    // Центр
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.star_rounded,
                          color: AppTheme.gold, size: 32),
                    ),
                    // Указатель
                    Positioned(
                      top: -6,
                      child: Container(
                        width: 0,
                        height: 0,
                        decoration: const BoxDecoration(),
                        child: CustomPaint(
                          size: const Size(28, 28),
                          painter: _PointerPainter(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (available && !_spinning) ? _spin : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        available ? AppTheme.primary : AppTheme.silver,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _spinning
                        ? 'Крутится...'
                        : available
                            ? 'КРУТИТЬ 🎡'
                            : 'Уже использовано сегодня',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final List<WheelPrize> prizes;
  _WheelPainter(this.prizes);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = 2 * pi / prizes.length;

    for (int i = 0; i < prizes.length; i++) {
      final paint = Paint()
        ..color = prizes[i].color
        ..style = PaintingStyle.fill;
      final startAngle = i * segmentAngle - pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        paint,
      );

      // Текст
      final textAngle = startAngle + segmentAngle / 2;
      final textRadius = radius * 0.62;
      final textOffset = Offset(
        center.dx + textRadius * cos(textAngle),
        center.dy + textRadius * sin(textAngle),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: prizes[i].label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: 70);
      canvas.save();
      canvas.translate(textOffset.dx, textOffset.dy);
      canvas.rotate(textAngle + pi / 2);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    // Обводка
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppTheme.primary;
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}