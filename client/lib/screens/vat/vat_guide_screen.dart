import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';

class VatGuideScreen extends StatefulWidget {
  const VatGuideScreen({super.key});

  @override
  State<VatGuideScreen> createState() => _VatGuideScreenState();
}

class _VatGuideScreenState extends State<VatGuideScreen> {
  final _searchController = TextEditingController();
  List<dynamic> _items = [];
  bool _isLoading = false;
  String? _error;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await ApiService.instance.searchVat(query);
      setState(() {
        _items = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load VAT items: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(
            'VAT Reference Guide',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Search and explore VAT rates across product and service categories.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: (val) => _search(val.trim()),
            decoration: InputDecoration(
              hintText: 'Search VAT items...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _search('');
                      },
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Standard (7.5%)', 'Zero-Rated (0%)', 'Exempt'].map((f) {
                final isActive = _selectedFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f, style: const TextStyle(fontSize: 12)),
                    selected: isActive,
                    onSelected: (_) => setState(() => _selectedFilter = f),
                    selectedColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isActive ? Colors.white : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Results
          if (_error != null)
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_error!, style: TextStyle(color: theme.colorScheme.onErrorContainer)),
              ),
            ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _items.isEmpty
                    ? const Center(child: Text('No items found.'))
                    : ListView.separated(
                        itemCount: _filteredItems.length + 1, // +1 for CTA card
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, idx) {
                          if (idx == _filteredItems.length) {
                            return _askAiCard(theme);
                          }
                          final item = _filteredItems[idx];
                          return _vatCard(theme, item);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  List<dynamic> get _filteredItems {
    if (_selectedFilter == 'All') return _items;
    return _items.where((item) {
      final status = (item['status'] as String? ?? '').toUpperCase();
      if (_selectedFilter.contains('Standard') && status == 'STANDARD') return true;
      if (_selectedFilter.contains('Zero') && status == 'ZERO_RATED') return true;
      if (_selectedFilter.contains('Exempt') && status == 'EXEMPT') return true;
      return false;
    }).toList();
  }

  Widget _vatCard(ThemeData theme, dynamic item) {
    final status = (item['status'] as String? ?? 'STANDARD').toUpperCase();
    final rate = item['rate'] != null ? double.parse(item['rate'].toString()) : 7.5;

    Color topBorderColor;
    Color badgeColor;
    Color badgeFg;
    String badgeLabel;

    switch (status) {
      case 'ZERO_RATED':
        topBorderColor = const Color(0xFF15803D);
        badgeColor = const Color(0xFFE2FBE9);
        badgeFg = const Color(0xFF15803D);
        badgeLabel = 'Zero-Rated (0%)';
        break;
      case 'EXEMPT':
        topBorderColor = theme.colorScheme.secondary;
        badgeColor = theme.colorScheme.surfaceContainerHigh;
        badgeFg = theme.colorScheme.onSurfaceVariant;
        badgeLabel = 'Exempt';
        break;
      case 'STANDARD':
      default:
        topBorderColor = theme.colorScheme.primary;
        badgeColor = theme.colorScheme.primaryContainer.withValues(alpha: 0.4);
        badgeFg = theme.colorScheme.primary;
        badgeLabel = 'Standard (${rate.toStringAsFixed(1)}%)';
    }

    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: topBorderColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['name'] as String? ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          badgeLabel,
                          style: TextStyle(
                            color: badgeFg,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['category'] as String? ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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

  Widget _askAiCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHigh,
            theme.colorScheme.primary.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.support_agent, color: theme.colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unsure about a rate?',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ask our AI Tax Assistant for specific VAT guidance.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.go('/chat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: theme.colorScheme.primary,
            ),
            child: const Text('Ask AI'),
          ),
        ],
      ),
    );
  }
}
