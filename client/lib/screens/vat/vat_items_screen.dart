import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/app_formatter.dart';
import '../../providers/vat_provider.dart';

class VatItemsScreen extends ConsumerStatefulWidget {
  const VatItemsScreen({super.key});

  @override
  ConsumerState<VatItemsScreen> createState() => _VatItemsScreenState();
}

class _VatItemsScreenState extends ConsumerState<VatItemsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vatState = ref.watch(vatProvider);
    final filteredItems = vatState.filteredItems;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VAT Items',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Browse items classified under the 2025 Nigeria Tax Act.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),

          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search items or categories...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(vatProvider.notifier).setSearchQuery('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (v) => ref.read(vatProvider.notifier).setSearchQuery(v),
          ),
          const SizedBox(height: 16),

          // Filter chips
          _buildFilterChips(theme, vatState),
          const SizedBox(height: 16),

          // Summary row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${filteredItems.length} item${filteredItems.length == 1 ? '' : 's'}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              _buildLegend(theme),
            ],
          ),
          const SizedBox(height: 12),

          // Items list
          if (vatState.isLoading)
            const Center(child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ))
          else if (vatState.error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.cloud_off_outlined, size: 40, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(height: 12),
                    Text('Failed to load VAT items', style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => ref.read(vatProvider.notifier).fetchItems(),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (filteredItems.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 40, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(height: 12),
                    Text(
                      _searchController.text.isNotEmpty
                          ? 'No items match your search'
                          : 'No items in this category',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...filteredItems.map((item) => _vatItemTile(theme, item)),
        ],
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme, VatState vatState) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip(theme, 'All', VatFilter.all, vatState.filter),
          const SizedBox(width: 8),
          _chip(theme, 'Standard (7.5%)', VatFilter.standard, vatState.filter),
          const SizedBox(width: 8),
          _chip(theme, 'Zero-Rated (0%)', VatFilter.zeroRated, vatState.filter),
          const SizedBox(width: 8),
          _chip(theme, 'Exempt', VatFilter.exempt, vatState.filter),
        ],
      ),
    );
  }

  Widget _chip(ThemeData theme, String label, VatFilter value, VatFilter current) {
    final isSelected = value == current;
    return FilterChip(
      label: Text(label, style: TextStyle(fontSize: 13)),
      selected: isSelected,
      onSelected: (_) => ref.read(vatProvider.notifier).setFilter(value),
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.primary,
      side: BorderSide(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.3)
            : theme.colorScheme.outlineVariant,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Row(
      children: [
        _legendDot(theme, const Color(0xFF15803D), 'Zero-Rated'),
        const SizedBox(width: 10),
        _legendDot(theme, const Color(0xFFB45309), 'Exempt'),
        const SizedBox(width: 10),
        _legendDot(theme, theme.colorScheme.primary, 'Standard'),
      ],
    );
  }

  Widget _legendDot(ThemeData theme, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        )),
      ],
    );
  }

  Widget _vatItemTile(ThemeData theme, VatItem item) {
    final statusColor = item.status == 'ZERO_RATED'
        ? const Color(0xFF15803D)
        : item.status == 'EXEMPT'
            ? const Color(0xFFB45309)
            : theme.colorScheme.primary;

    final statusLabel = item.status == 'ZERO_RATED'
        ? 'Zero-Rated'
        : item.status == 'EXEMPT'
            ? 'Exempt'
            : 'Standard';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.status == 'STANDARD' ? '7.5%' : '0%',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
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
