import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/bazar_entities.dart';
import '../../domain/repositories/bazar_repository.dart';

class MarketDetailScreen extends StatefulWidget {
  final MarketplaceEntity marketplace;

  const MarketDetailScreen({
    super.key,
    required this.marketplace,
  });

  @override
  State<MarketDetailScreen> createState() => _MarketDetailScreenState();
}

class _MarketDetailScreenState extends State<MarketDetailScreen> {
  String? _currentlyPlayingId;
  final Set<String> _cartItems = {};
  double _totalSpent = 0.0;

  @override
  void dispose() {
    context.read<HybridAudioPlaybackService>().stop();
    super.dispose();
  }

  Future<void> _speakText(String id, String text) async {
    final audioService = context.read<HybridAudioPlaybackService>();

    if (_currentlyPlayingId == id) {
      await audioService.stop();
      if (mounted) {
        setState(() => _currentlyPlayingId = null);
      }
      return;
    }

    setState(() => _currentlyPlayingId = id);

    final dialect = widget.marketplace.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    await audioService.playAudioOrSpeak(
      fallbackText: text,
      dialect: dialect,
      rate: 0.95,
    );

    if (mounted) {
      setState(() => _currentlyPlayingId = null);
    }
  }

  void _toggleBuyItem(MarketItemEntity item) {
    setState(() {
      if (_cartItems.contains(item.id)) {
        _cartItems.remove(item.id);
        _totalSpent -= item.defaultPrice;
      } else {
        _cartItems.add(item.id);
        _totalSpent += item.defaultPrice;
      }
    });

    // Record purchase progress in repository
    if (_cartItems.contains(item.id)) {
      context.read<BazarRepository>().recordMarketPurchase(
            marketId: widget.marketplace.id,
            itemsCount: 1,
            totalSpent: item.defaultPrice,
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Куплено: ${item.namePt} (${item.nameRu})!'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final market = widget.marketplace;

    return Scaffold(
      appBar: AppBar(
        title: Text(market.namePt),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(market.dialectFlag, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      market.dialectLabel,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _cartItems.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_basket_rounded,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'В корзине: ${_cartItems.length} тов.',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Итого: ${market.isPtPt ? "€" : "R\$"}${_totalSpent.toStringAsFixed(2)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          _cartItems.clear();
                          _totalSpent = 0.0;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Покупки успешно оформлены на рынке! 🛒'),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Оплатить'),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header Hero Banner
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        market.coverEmoji,
                        style: const TextStyle(fontSize: 44),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      market.namePt,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${market.nameRu} • ${market.city}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      market.atmosphereRu,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.history_edu_rounded,
                            size: 20,
                            color: colorScheme.secondary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              market.historicalContextRu,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.storefront_rounded, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Торговые лавки (${market.stalls.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...market.stalls.map((stall) => _buildStallCard(context, stall)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStallCard(BuildContext context, MarketStallEntity stall) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPlayingCatchphrase = _currentlyPlayingId == stall.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stall Header & Catchphrase
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    stall.vendorEmoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stall.stallNamePt,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${stall.stallNameRu} • ${stall.vendorName}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Catchphrase Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _speakText(stall.id, stall.catchphrasePt),
                    icon: Icon(
                      isPlayingCatchphrase
                          ? Icons.volume_up_rounded
                          : Icons.volume_down_rounded,
                      color: isPlayingCatchphrase
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Слушать кричалку торговца',
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '«${stall.catchphrasePt}»',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          stall.catchphraseRu,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ассортимент товаров:',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            // Items List
            ...stall.items.map((item) => _buildItemTile(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, MarketItemEntity item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isBought = _cartItems.contains(item.id);
    final isPlayingItem = _currentlyPlayingId == item.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isBought
            ? colorScheme.primaryContainer.withValues(alpha: 0.2)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBought
              ? colorScheme.primary
              : colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Text(item.itemEmoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.namePt,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isPlayingItem
                            ? Icons.volume_up_rounded
                            : Icons.volume_down_rounded,
                        size: 16,
                        color: isPlayingItem
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () => _speakText(item.id, item.namePt),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                Text(
                  '${item.nameRu} • ${item.descriptionRu}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.currencySymbol}${item.defaultPrice.toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                'за ${item.unitRu}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _toggleBuyItem(item),
            icon: Icon(
              isBought
                  ? Icons.check_circle_rounded
                  : Icons.add_shopping_cart_rounded,
              color: isBought ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
            tooltip: isBought ? 'Убрать из покупок' : 'Купить',
          ),
        ],
      ),
    );
  }
}
