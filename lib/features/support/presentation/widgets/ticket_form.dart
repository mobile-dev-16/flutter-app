import 'package:eco_bites/features/support/presentation/bloc/support_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketForm extends StatelessWidget {
  TicketForm({super.key, required this.category, required this.subOption});
  final String category;
  final String subOption;

  final TextEditingController reasonController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupportBloc, SupportState>(
      listener: (BuildContext context, SupportState state) {
        if (state is SupportSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ticket submitted successfully')),
          );
          Navigator.pop(context);
        } else if (state is SupportFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit ticket: ${state.error}')),
          );
        } else if (state is SupportCached) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
          Navigator.pop(context); // Navegar hacia atrás al guardar en caché
        }
      },
      builder: (BuildContext context, SupportState state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: state is SupportLoading
                    ? null
                    : () {
                        context.read<SupportBloc>().add(
                              SubmitTicketEvent(
                                category: category,
                                subOption: subOption,
                                reason: reasonController.text,
                                description: descriptionController.text,
                              ),
                            );
                      },
                child: state is SupportLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit Ticket'),
              ),
            ],
          ),
        );
      },
    );
  }
}
