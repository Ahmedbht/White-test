import 'package:flutter/material.dart';
import '../data/mock_games.dart';
import '../models/game.dart';

enum LibrarySort { name, recentlyPlayed }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _categoryFilter;
  LibrarySort _sort = LibrarySort.recentlyPlayed;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Game> get _filteredGames {
    var games = mockGames.where((g) {
      final matchesQuery = g.name.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory =
          _categoryFilter == null || g.category == _categoryFilter;
      return matchesQuery && matchesCategory;
    }).toList();

    switch (_sort) {
      case LibrarySort.name:
        games.sort((a, b) => a.name.compareTo(b.name));
        break;
      case LibrarySort.recentlyPlayed:
        games.sort((a, b) => b.lastPlayed.compareTo(a.lastPlayed));
        break;
    }
    return games;
  }

  List<String> get _categories =>
      mockGames.map((g) => g.category).toSet().toList()..sort();

  @override
  Widget build(BuildContext context) {
    final games = _filteredGames;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LIBRARY',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _query = v),
                        decoration: InputDecoration(
                          hintText: 'Search installed games',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          suffixIcon: _query.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _query = '');
                                  },
                                )
                              : null,
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    PopupMenuButton<LibrarySort>(
                      icon: const Icon(Icons.sort_rounded),
                      tooltip: 'Sort',
                      initialValue: _sort,
                      onSelected: (v) => setState(() => _sort = v),
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: LibrarySort.name,
                          child: Text('Sort by name'),
                        ),
                        PopupMenuItem(
                          value: LibrarySort.recentlyPlayed,
                          child: Text('Recently played'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterChip(
                        label: 'All',
                        selected: _categoryFilter == null,
                        onTap: () => setState(() => _categoryFilter = null),
                      ),
                      const SizedBox(width: 8),
                      ..._categories.expand(
                        (c) => [
                          _FilterChip(
                            label: c,
                            selected: _categoryFilter == c,
                            onTap: () => setState(() => _categoryFilter = c),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: games.isEmpty
                ? Center(
                    child: Text(
                      'No games match your search',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: games.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _LibraryTile(
                      game: games[index],
                      sort: _sort,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: scheme.primary.withValues(alpha: 0.25),
      labelStyle: TextStyle(
        color: selected ? scheme.primary : null,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }
}

class _LibraryTile extends StatelessWidget {
  final Game game;
  final LibrarySort sort;

  const _LibraryTile({required this.game, required this.sort});

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final mutedColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.5);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [game.accent, game.accent.withValues(alpha: 0.5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(game.icon, color: Colors.white, size: 24),
        ),
        title: Text(
          game.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          sort == LibrarySort.recentlyPlayed
              ? 'Played ${_formatDate(game.lastPlayed)}'
              : '${game.category} · ${game.sizeGb.toStringAsFixed(1)} GB',
          style: TextStyle(fontSize: 12, color: mutedColor),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_circle_fill_rounded),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Launching ${game.name}...')),
            );
          },
        ),
      ),
    );
  }
}
