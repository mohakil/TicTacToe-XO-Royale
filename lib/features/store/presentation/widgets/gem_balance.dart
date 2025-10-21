import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/shared/widgets/feedback/currency_display.dart';

class GemBalance extends ConsumerWidget {
  const GemBalance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gems = ref.watch(profileGemsProvider);

    return CurrencyDisplay(
      amount: gems,
      icon: Icons.diamond,
      label: 'Your Gems',
      variant: CurrencyVariant.compact,
    );
  }
}
