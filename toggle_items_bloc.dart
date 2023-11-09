import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/data/models/toggle_items/items_model.dart';
import 'package:store/data/repository/toggled_items_repo.dart';

part 'toggle_items_event.dart';
part 'toggle_items_state.dart';

class ToggleItemsBloc extends Bloc<ToggleItemsEvent, ToggleItemsState> {
  ToggleItemsBloc({required this.repository})
      : super(const ToggleItemsState()) {
    on<GetAllToggleItems>(_onGetAllToggleItems);
    on<UpdateToggleItems>(_onUpdateToggleItems);
    on<SearchToggleItems>(_onSearchToggleItems);
  }

  final ToggledItemsRepos repository;

  FutureOr<void> _onGetAllToggleItems(
      GetAllToggleItems event, Emitter<ToggleItemsState> emit) async {
    if (event.refresh) {
      emit(const ToggleItemsState());
    }
    final oldItems = state.toggleItems;
    emit(state.copyWith(isLoading: true, message: '', error: ''));
    try {
      final response = await repository.getAllItems(state.page, state.limit);
      if (response.success) {
        final items = response.data as List<ToggleItems>;
        emit(state.copyWith(
          isLoading: false,
          toggleItems: [...oldItems, ...items],
          hasReachedMax: items.isEmpty || items.length < state.limit,
          page: state.page + 1,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: response.message,
        ));
      }
    } on Exception catch (_) {
      emit(state.copyWith(
        isLoading: false,
        error: 'There was an error fetching the items.',
      ));
    }
  }

  FutureOr<void> _onSearchToggleItems(
      SearchToggleItems event, Emitter<ToggleItemsState> emit) async {
    emit(const ToggleItemsState());
    final oldItems = state.toggleItems;
    emit(state.copyWith(isLoading: true, message: '', error: ''));
    try {
      final response = await repository.searchItems(event.search);
      if (response.success) {
        final items = response.data as List<ToggleItems>;
        emit(state.copyWith(
          isLoading: false,
          toggleItems: [...oldItems, ...items],
          hasReachedMax: items.isEmpty || items.length < state.limit,
          page: state.page + 1,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: response.message,
        ));
      }
    } on Exception catch (_) {
      emit(state.copyWith(
        isLoading: false,
        error: 'There was an error fetching the items.',
      ));
    }
  }

  FutureOr<void> _onUpdateToggleItems(
      UpdateToggleItems event, Emitter<ToggleItemsState> emit) async {
    emit(state.copyWith(isLoading: true, message: '', error: ''));
    try {
      final response = await repository.updateItemStatus(id: event.id);
      if (response.success) {
        emit(state.copyWith(isLoading: false, message: response.message));
        add(const GetAllToggleItems(refresh: true));
      } else {
        emit(state.copyWith(isLoading: false, error: response.message));
      }
    } on Exception catch (_) {
      emit(state.copyWith(
        isLoading: false,
        error: 'There was an error fetching the items.',
      ));
    }
  }
}
