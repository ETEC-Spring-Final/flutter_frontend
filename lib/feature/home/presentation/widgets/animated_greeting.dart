import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/theme/app_colors.dart';

class AnimatedGreeting extends StatefulWidget {
  const AnimatedGreeting({super.key});

  @override
  State<AnimatedGreeting> createState() => _AnimatedGreetingState();
}

class _AnimatedGreetingState extends State<AnimatedGreeting>
    with SingleTickerProviderStateMixin {
  // ============================================================
  // MESSAGES
  // ============================================================

  final List<String> _messages = [
    'Ready for your next journey?',
    'Find your perfect car.',
    'Your next adventure starts here.',
    'Drive with confidence.',
  ];

  // ============================================================
  // TYPEWRITER STATE
  // ============================================================

  String _displayText = '';

  Timer? _timer;

  int _messageIndex = 0;
  int _characterIndex = 0;

  bool _isDeleting = false;

  // ============================================================
  // ENTRANCE ANIMATION
  // ============================================================

  late final AnimationController _animationController;

  late final Animation<double> _fadeAnimation;

  late final Animation<Offset> _slideAnimation;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    // ------------------------------------------------------------
    // Fade + Slide Up
    // ------------------------------------------------------------

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Start entrance animation
    _animationController.forward();

    // Start typewriter after entrance animation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      _startTyping();
    });
  }

  // ============================================================
  // TYPEWRITER
  // ============================================================

  void _startTyping() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(milliseconds: 70), (_) {
      if (!mounted) return;

      final currentMessage = _messages[_messageIndex];

      // ========================================================
      // TYPING
      // ========================================================

      if (!_isDeleting) {
        if (_characterIndex < currentMessage.length) {
          setState(() {
            _characterIndex++;

            _displayText = currentMessage.substring(0, _characterIndex);
          });
        } else {
          // Message completed
          _timer?.cancel();

          Future.delayed(const Duration(seconds: 3), () {
            if (!mounted) return;

            _isDeleting = true;

            _startTyping();
          });
        }
      }
      // ========================================================
      // DELETING
      // ========================================================
      else {
        if (_characterIndex > 0) {
          setState(() {
            _characterIndex--;

            _displayText = currentMessage.substring(0, _characterIndex);
          });
        } else {
          // ----------------------------------------------------
          // Move to next message
          // ----------------------------------------------------

          _timer?.cancel();

          _messageIndex = (_messageIndex + 1) % _messages.length;

          _isDeleting = false;

          Future.delayed(const Duration(milliseconds: 500), () {
            if (!mounted) return;

            _startTyping();
          });
        }
      }
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();

    super.dispose();
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // GREETING
            // ==================================================
            Text(
              'Hello, Visal 👋',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),

            // ==================================================
            // TYPEWRITER TEXT
            // ==================================================
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _displayText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    //color: theme.colorScheme.onSurfaceVariant,
                    color: AppColors.primary,
                  ),
                ),

                // Cursor
                AnimatedOpacity(
                  opacity: _isDeleting ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    '|',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
