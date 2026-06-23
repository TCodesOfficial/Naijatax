import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          // ─── Search Bar ───────────────────────────────────────────────────
          TextField(
            controller: _searchController,
            onChanged: (val) => _search(val.trim()),
            decoration: InputDecoration(
              hintText: 'Search VAT registry (e.g. milk, services...)',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _search('');
                      },
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),

          // ─── Search Results ───────────────────────────────────────────────
          if (_error != null)
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _error!,
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
            ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _items.isEmpty
                    ? const Center(
                        child: Text('No goods or services found matching search.'),
                      )
                    : ListView.separated(
                        itemCount: _items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, idx) {
                          final item = _items[idx];
                          return Card(
                            child: ListTile(
                              title: Text(
                                item['name'] as String? ?? '',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                item['category'] as String? ?? '',
                                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                              ),
                              trailing: _buildStatusBadge(theme, item['status'] as String? ?? 'STANDARD', item['rate'] != null ? double.parse(item['rate'].toString()) : 7.5),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme, String status, double rate) {
    Color bgColor;
    Color fgColor;
    String label;

    switch (status.toUpperCase()) {
      case 'EXEMPT':
        bgColor = theme.colorScheme.surfaceContainerHighest;
        fgColor = theme.colorScheme.onSurfaceVariant;
        label = 'Exempt (0%)';
        break;
      case 'ZERO_RATED':
        bgColor = const Color(0xFFE2FBE9);
        fgColor = const Color(0xFF15803D);
        label = 'Zero Rated (0%)';
        break;
      case 'STANDARD':
      default:
        bgColor = theme.colorScheme.primaryContainer.withOpacity(0.4);
        fgColor = theme.colorScheme.primary;
        label = 'Standard (${rate.toStringAsFixed(1)}%)';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fgColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
