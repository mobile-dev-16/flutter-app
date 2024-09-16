import 'package:eco_bites/features/cart/presentation/bloc/quantity_bloc.dart';
import 'package:eco_bites/features/cart/presentation/bloc/quantity_event.dart';
import 'package:eco_bites/features/cart/presentation/bloc/quantity_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class QuantityInput extends StatelessWidget {
  const QuantityInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final int initialValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuantityBloc>(
      create: (BuildContext context) =>
          QuantityBloc(initialValue: initialValue),
      child: _QuantityInputContent(onChanged: onChanged),
    );
  }
}

class _QuantityInputContent extends StatelessWidget {
  const _QuantityInputContent({required this.onChanged});

  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocBuilder<QuantityBloc, QuantityState>(
      builder: (BuildContext context, QuantityState state) {
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
                  icon: state.value == 1
                      ? Symbols.delete_rounded
                      : Symbols.remove_rounded,
                  onPressed: () {
                    context.read<QuantityBloc>().add(QuantityDecreased());
                    onChanged(context.read<QuantityBloc>().state.value);
                  },
                  theme: theme,
                  isLeft: true,
                ),
                Container(
                  width: 28,
                  alignment: Alignment.center,
                  child: Text(
                    state.value.toString(),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                _buildButton(
                  icon: Symbols.add_rounded,
                  onPressed: () {
                    context.read<QuantityBloc>().add(QuantityIncreased());
                    onChanged(context.read<QuantityBloc>().state.value);
                  },
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
