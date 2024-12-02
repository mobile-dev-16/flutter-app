import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/core/blocs/internet_connection/internet_connection_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  SupportBloc({required this.firestore, required this.internetConnectionBloc})
      : super(SupportInitial()) {
    on<SubmitTicketEvent>(_onSubmitTicket);
    on<RetryCachedTicketsEvent>(_onRetryCachedTickets);

    internetConnectionBloc.stream.listen((InternetConnectionState state) {
      if (state is ConnectedInternet) {
        add(RetryCachedTicketsEvent());
      }
    });
  }

  final FirebaseFirestore firestore;
  final InternetConnectionBloc internetConnectionBloc;

  Future<void> _onSubmitTicket(
    SubmitTicketEvent event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoading());
    try {
      // Intentar subir el ticket a Firestore
      await firestore.collection('support_tickets').add(<String, dynamic>{
        'category': event.category,
        'subOption': event.subOption,
        'reason': event.reason,
        'description': event.description,
        'timestamp': FieldValue.serverTimestamp(),
      });
      emit(SupportSuccess());
    } catch (e) {
      await _cacheTicket(event);
      emit(const SupportCached(
        message: 'Your ticket has been saved and will be submitted once the internet is restored.',
      ),);
    }
  }

  Future<void> _cacheTicket(SubmitTicketEvent event) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> cachedTickets =
        prefs.getStringList('cachedTickets') ?? <String>[];
    cachedTickets.add(jsonEncode(<String, String>{
      'category': event.category,
      'subOption': event.subOption,
      'reason': event.reason,
      'description': event.description,
    }),);
    await prefs.setStringList('cachedTickets', cachedTickets);
  }

  Future<void> _onRetryCachedTickets(
    RetryCachedTicketsEvent event,
    Emitter<SupportState> emit,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> cachedTickets =
        prefs.getStringList('cachedTickets') ?? <String>[];

    for (final String ticket in cachedTickets) {
      final Map<String, dynamic> ticketData = jsonDecode(ticket);
      try {
        await firestore.collection('support_tickets').add(<String, dynamic>{
          'category': ticketData['category'],
          'subOption': ticketData['subOption'],
          'reason': ticketData['reason'],
          'description': ticketData['description'],
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        emit(SupportFailure(error: e.toString()));
        return;
      }
    }

    await prefs.remove('cachedTickets');
    emit(SupportSuccess());
  }
}
