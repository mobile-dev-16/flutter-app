import 'package:eco_bites/features/cart/presentation/bloc/cart_item_bloc.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_item_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class QuantityInput extends StatelessWidget {
  const QuantityInput({
    super.key,
    required this.onIncrease,
    required this.onDecrease,
  });

  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    return _QuantityInputContent(
      onIncrease: onIncrease,
      onDecrease: onDecrease,
    );
  }
}

class _QuantityInputContent extends StatelessWidget {
  const _QuantityInputContent({
    required this.onIncrease,
    required this.onDecrease,
  });

  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocBuilder<CartItemBloc, CartItemState>(
      builder: (BuildContext context, CartItemState state) {
        return SizedBox(
          height: 28,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(14),
              color: theme.colorScheme.surface,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildButton(
                  icon: state.quantity == 1
                      ? Symbols.delete_rounded
                      : Symbols.remove_rounded,
                  onPressed: onDecrease,
                  theme: theme,
                  isLeft: true,
                ),
                Container(
                  width: 28,
                  alignment: Alignment.center,
                  child: Text(
                    state.quantity.toString(),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                _buildButton(
                  icon: Symbols.add_rounded,
                  onPressed: onIncrease,
                  theme: theme,
                  isLeft: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onPressed,
    required ThemeData theme,
    required bool isLeft,
  }) {
    return Material(
      color: theme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.horizontal(
        left: isLeft ? const Radius.circular(14) : Radius.zero,
        right: !isLeft ? const Radius.circular(14) : Radius.zero,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.horizontal(
          left: isLeft ? const Radius.circular(14) : Radius.zero,
          right: !isLeft ? const Radius.circular(14) : Radius.zero,
        ),
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 16,
          ),
        ),
      ),
    );
  }
}
