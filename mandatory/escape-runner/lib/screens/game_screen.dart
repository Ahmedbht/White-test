import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/difficulty.dart';
import '../models/obstacle.dart';
import '../models/power_up.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_text.dart';
import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  static const double _playerRadius = 20;
  static const double _playerBottomMargin = 90;
  static const double _baseFallSpeed = 150; // px/sec
  static const double _baseSpawnInterval = 1.15; // seconds
  static const double _minSpawnInterval = 0.32;
  static const double _scorePerSecond = 12;
  static const double _maxDt = 0.05; // clamp to avoid physics jumps
  static const double _minPowerUpInterval = 5.0;
  static const double _maxPowerUpInterval = 9.0;
  static const double _shieldInvulnerabilityDuration = 0.5;

  static double _randomPowerUpInterval() {
    final rng = Random();
    return _minPowerUpInterval +
        rng.nextDouble() * (_maxPowerUpInterval - _minPowerUpInterval);
  }

  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;

  double _screenWidth = 0;
  double _screenHeight = 0;
  bool _sizeReady = false;

  double _playerX = 0;
  final List<Obstacle> _obstacles = [];
  final List<PowerUp> _powerUps = [];

  double _score = 0;
  double _gameTime = 0;
  double _spawnAccumulator = 0;
  double _powerUpSpawnAccumulator = 0;
  double _nextPowerUpInterval = _randomPowerUpInterval();
  bool _hasShield = false;
  double _invulnerabilityTimer = 0;
  bool _gameOver = false;
  bool _paused = false;
  bool _navigatedAway = false;

  Difficulty _difficulty = Difficulty.medium;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _loadSettingsAndStart();
  }

  Future<void> _loadSettingsAndStart() async {
    final name = await StorageService.instance.getDifficulty();
    if (!mounted) return;
    setState(() {
      _difficulty = DifficultyX.fromName(name);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = MediaQuery.of(context).size;
      setState(() {
        _screenWidth = size.width;
        _screenHeight = size.height;
        _playerX = _screenWidth / 2;
        _sizeReady = true;
      });
      _ticker.start();
    });
  }

  void _onTick(Duration elapsed) {
    if (_lastElapsed == Duration.zero) {
      _lastElapsed = elapsed;
      return;
    }
    var dt = (elapsed - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = elapsed;
    if (dt <= 0) return;
    if (dt > _maxDt) dt = _maxDt;

    if (_gameOver || _paused || !_sizeReady) return;

    _gameTime += dt;
    _score += dt * _scorePerSecond;

    final speedMultiplier =
        _difficulty.speedMultiplier * (1 + _gameTime * 0.035).clamp(1.0, 3.5);
    final fallSpeed = _baseFallSpeed * speedMultiplier;

    final spawnInterval = max(
      _minSpawnInterval,
      _baseSpawnInterval * _difficulty.spawnMultiplier - _gameTime * 0.012,
    );
    _spawnAccumulator += dt;
    if (_spawnAccumulator >= spawnInterval) {
      _spawnAccumulator = 0;
      _obstacles.add(Obstacle.random(screenWidth: _screenWidth, y: -50));
    }

    _powerUpSpawnAccumulator += dt;
    if (_powerUpSpawnAccumulator >= _nextPowerUpInterval) {
      _powerUpSpawnAccumulator = 0;
      _nextPowerUpInterval = _randomPowerUpInterval();
      _powerUps.add(PowerUp.random(screenWidth: _screenWidth, y: -50));
    }

    for (final obstacle in _obstacles) {
      obstacle.y += fallSpeed * dt;
    }
    _obstacles.removeWhere((o) => o.y > _screenHeight + 60);

    for (final powerUp in _powerUps) {
      powerUp.y += fallSpeed * dt;
    }
    _powerUps.removeWhere((p) => p.y > _screenHeight + 60);

    if (_invulnerabilityTimer > 0) {
      _invulnerabilityTimer = max(0, _invulnerabilityTimer - dt);
    }

    final playerCenter = Offset(_playerX, _screenHeight - _playerBottomMargin);

    final collectedPowerUp = _powerUps.any(
      (p) => _circleRectCollide(playerCenter, _playerRadius, p.rect),
    );
    if (collectedPowerUp) {
      _hasShield = true;
      _powerUps.removeWhere(
        (p) => _circleRectCollide(playerCenter, _playerRadius, p.rect),
      );
    }

    for (final obstacle in _obstacles) {
      if (_circleRectCollide(playerCenter, _playerRadius, obstacle.rect)) {
        if (_invulnerabilityTimer > 0) {
          break;
        }
        if (_hasShield) {
          _hasShield = false;
          _invulnerabilityTimer = _shieldInvulnerabilityDuration;
          _obstacles.remove(obstacle);
        } else {
          _endGame();
        }
        break;
      }
    }

    if (mounted) setState(() {});
  }

  bool _circleRectCollide(Offset circleCenter, double radius, Rect rect) {
    final closestX = circleCenter.dx.clamp(rect.left, rect.right);
    final closestY = circleCenter.dy.clamp(rect.top, rect.bottom);
    final dx = circleCenter.dx - closestX;
    final dy = circleCenter.dy - closestY;
    return (dx * dx + dy * dy) <= radius * radius;
  }

  Future<void> _endGame() async {
    if (_gameOver) return;
    _gameOver = true;
    _ticker.stop();
    final finalScore = _score.floor();
    final isNewHigh = await StorageService.instance.submitScore(finalScore);
    if (!mounted || _navigatedAway) return;
    _navigatedAway = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            GameOverScreen(score: finalScore, isNewHighScore: isNewHigh),
      ),
    );
  }

  void _movePlayer(double dx) {
    if (!_sizeReady) return;
    setState(() {
      _playerX =
          (_playerX + dx).clamp(_playerRadius, _screenWidth - _playerRadius);
    });
  }

  void _onTapDown(TapDownDetails details) {
    if (!_sizeReady) return;
    final isLeft = details.localPosition.dx < _screenWidth / 2;
    _movePlayer(isLeft ? -64 : 64);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _movePlayer(details.delta.dx);
  }

  void _togglePause() {
    if (_gameOver) return;
    setState(() => _paused = !_paused);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonColors.background,
      body: !_sizeReady
          ? const Center(
              child: CircularProgressIndicator(color: NeonColors.cyan),
            )
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: _onTapDown,
              onHorizontalDragUpdate: _onPanUpdate,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(color: NeonColors.background),
                  ),
                  for (final obstacle in _obstacles) _ObstacleView(obstacle),
                  for (final powerUp in _powerUps) _PowerUpView(powerUp),
                  _buildPlayer(),
                  _buildHud(),
                  if (_paused) _buildPauseOverlay(),
                ],
              ),
            ),
    );
  }

  Widget _buildPlayer() {
    return Positioned(
      left: _playerX - _playerRadius,
      top: _screenHeight - _playerBottomMargin - _playerRadius,
      width: _playerRadius * 2,
      height: _playerRadius * 2,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [Colors.white, NeonColors.cyan],
          ),
          border: _hasShield
              ? Border.all(color: NeonColors.yellow, width: 3)
              : null,
          boxShadow: [
            BoxShadow(
              color: NeonColors.cyan.withValues(alpha: 0.9),
              blurRadius: 20,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: NeonColors.cyan.withValues(alpha: 0.5),
              blurRadius: 40,
              spreadRadius: 6,
            ),
            if (_hasShield)
              BoxShadow(
                color: NeonColors.yellow.withValues(alpha: 0.9),
                blurRadius: 26,
                spreadRadius: 6,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHud() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NeonText(
                'SCORE  ${_score.floor()}',
                color: NeonColors.cyan,
                fontSize: 18,
                letterSpacing: 2,
              ),
              Row(
                children: [
                  if (_hasShield)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.shield_rounded,
                        color: NeonColors.yellow,
                        size: 20,
                      ),
                    ),
                  Text(
                    _difficulty.label.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white54,
                      letterSpacing: 2,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                      color: NeonColors.purple,
                    ),
                    onPressed: _togglePause,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPauseOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _togglePause,
        child: Container(
          color: Colors.black.withValues(alpha: 0.72),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const NeonText(
                  'PAUSED',
                  color: NeonColors.purple,
                  fontSize: 32,
                  letterSpacing: 6,
                ),
                const SizedBox(height: 16),
                Text(
                  'TAP TO RESUME',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    letterSpacing: 2,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ObstacleView extends StatelessWidget {
  const _ObstacleView(this.obstacle);

  final Obstacle obstacle;

  @override
  Widget build(BuildContext context) {
    final isCircle = obstacle.shape == ObstacleShape.circle;
    final decoration = BoxDecoration(
      shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: isCircle
          ? null
          : BorderRadius.circular(
              obstacle.shape == ObstacleShape.square ? 6 : 4,
            ),
      color: obstacle.color.withValues(alpha: 0.22),
      border: Border.all(color: obstacle.color, width: 2.5),
      boxShadow: [
        BoxShadow(
          color: obstacle.color.withValues(alpha: 0.9),
          blurRadius: 16,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: obstacle.color.withValues(alpha: 0.4),
          blurRadius: 28,
          spreadRadius: 2,
        ),
      ],
    );

    return Positioned(
      left: obstacle.x,
      top: obstacle.y,
      width: obstacle.size,
      height: obstacle.size,
      child: DecoratedBox(decoration: decoration),
    );
  }
}

class _PowerUpView extends StatelessWidget {
  const _PowerUpView(this.powerUp);

  final PowerUp powerUp;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: powerUp.x,
      top: powerUp.y,
      width: powerUp.size,
      height: powerUp.size,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: NeonColors.yellow.withValues(alpha: 0.22),
          border: Border.all(color: NeonColors.yellow, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: NeonColors.yellow.withValues(alpha: 0.9),
              blurRadius: 16,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: NeonColors.yellow.withValues(alpha: 0.4),
              blurRadius: 28,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.shield_rounded,
          color: NeonColors.yellow,
          size: 18,
        ),
      ),
    );
  }
}
