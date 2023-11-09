part of 'toggle_items_bloc.dart';

sealed class ToggleItemsEvent extends Equatable {
  const ToggleItemsEvent();

  @override
  List<Object> get props => [];
}

class GetAllToggleItems extends ToggleItemsEvent {
  const GetAllToggleItems({this.refresh = false});
  final bool refresh;

  @override
  List<Object> get props => [refresh];
}

class UpdateToggleItems extends ToggleItemsEvent {
  const UpdateToggleItems({required this.id});
  final String id;

  @override
  List<Object> get props => [id];
}

class SearchToggleItems extends ToggleItemsEvent {
  const SearchToggleItems({ required this.search});
  final String search;

  @override
  List<Object> get props => [search];
}
