import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/pet_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _idleController;
  late final AnimationController _reactionController;
  late final Animation<double> _squish;

  Offset? _position;
  bool _reacting = false;
  int _heartSeed = 0;
  final List<_Heart> _hearts = [];

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _reactionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _squish = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.22)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.22, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_reactionController);

    _reactionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _reacting = false);
      }
    });
  }

  @override
  void dispose() {
    _idleController.dispose();
    _reactionController.dispose();
    super.dispose();
  }

  void _onPetTapped(AppState appState) {
    appState.pet();
    final id = _heartSeed++;
    setState(() {
      _reacting = true;
      _hearts.add(_Heart(id));
    });
    _reactionController.forward(from: 0);
    if (appState.soundEnabled) {
      HapticFeedback.mediumImpact();
    }
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _hearts.removeWhere((h) => h.id == id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final size = appState.petSize;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bounds = Size(constraints.maxWidth, constraints.maxHeight);
        _position ??= Offset(
          bounds.width / 2 - size / 2,
          bounds.height / 2 - size / 2,
        );
        final clamped = Offset(
          _position!.dx.clamp(0, max(0, bounds.width - size)),
          _position!.dy.clamp(0, max(0, bounds.height - size)),
        );

        return DecoratedBox(
          decoration: BoxDecoration(gradient: appState.backgroundTheme.gradient),
          child: Stack(
            children: [
              Positioned(
                top: 24,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      appState.selectedPet.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6B4A75),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Drag me around ✨ Tap me for love!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF8A6D96),
                          ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: clamped.dx,
                top: clamped.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      final next = clamped + details.delta;
                      _position = Offset(
                        next.dx.clamp(0, max(0, bounds.width - size)),
                        next.dy.clamp(0, max(0, bounds.height - size)),
                      );
                    });
                  },
                  onTap: () => _onPetTapped(appState),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_idleController, _reactionController]),
                    builder: (context, child) {
                      final bounce = _reacting
                          ? 0.0
                          : sin(_idleController.value * pi) * size * 0.06;
                      final scale = _reacting ? _squish.value : 1.0;
                      return Transform.translate(
                        offset: Offset(0, -bounce),
                        child: Transform.scale(scale: scale, child: child),
                      );
                    },
                    child: PetAvatar(pet: appState.selectedPet, size: size),
                  ),
                ),
              ),
              ..._hearts.map(
                (h) => _FloatingHeart(
                  key: ValueKey(h.id),
                  origin: Offset(
                    clamped.dx + size / 2,
                    clamped.dy,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Heart {
  final int id;
  _Heart(this.id);
}

class _FloatingHeart extends StatefulWidget {
  final Offset origin;
  const _FloatingHeart({super.key, required this.origin});

  @override
  State<_FloatingHeart> createState() => _FloatingHeartState();
}

class _FloatingHeartState extends State<_FloatingHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Positioned(
          left: widget.origin.dx - 12,
          top: widget.origin.dy - t * 60,
          child: Opacity(
            opacity: (1 - t).clamp(0, 1),
            child: const Text('💖', style: TextStyle(fontSize: 24)),
          ),
        );
      },
    );
  }
}
