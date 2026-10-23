import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/tax_provider.dart';
import '../../widgets/calculation_history_list.dart';

/// Full-screen history of saved tax calculations (reachable from the
/// Calculator tab section and the Profile "Calculation History" tile).
class CalculationHistoryScreen extends ConsumerStatefulWidget {
  const CalculationHistoryScreen({super.key});

  @override
  ConsumerState<CalculationHistoryScreen> createState() =>
      _CalculationHistoryScreenState();
}

class _CalculationHistoryScreenState
    extends ConsumerState<CalculationHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(taxProvider.notifier).fetchHistory());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final hasBottomNav = size.width < AppConstants.tabletBreakpoint;
    final taxState = ref.watch(taxProvider);

    final items = taxState.history;
    final latest = items.isNotEmpty ? items.first.createdAt : null;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 24,
        isMobile ? 16 : 24,
        isMobile ? 16 : 24,
        hasBottomNav ? (isMobile ? 16 : 24) + 76 : (isMobile ? 16 : 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calculation History',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            items.isEmpty
                ? 'Your saved assessments will appear here.'
                : '${items.length} saved assessment${items.length == 1 ? '' : 's'}'
                    '${latest != null ? ' · last run ${DateFormat('d MMM yyyy').format(latest.toLocal())}' : ''}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          if (taxState.historyLoading && items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (items.isEmpty)
            const EmptyHistoryState()
          else
            CalculationHistoryList(items: items, shrinkWrap: true),
        ],
      ),
    );
  }
}
