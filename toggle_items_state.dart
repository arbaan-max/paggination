part of 'toggle_items_bloc.dart';

class ToggleItemsState extends Equatable {
  const ToggleItemsState({
    this.toggleItems = const <ToggleItems>[],
    this.isLoading = false,
    this.message = '',
    this.error = '',
    this.hasReachedMax = false,
    this.page = 0,
    this.limit = 10,
  });

  final List<ToggleItems> toggleItems;
  final bool isLoading;
  final String message;
  final String error;
  final bool hasReachedMax;
  final int page;
  final int limit;

  ToggleItemsState copyWith({
    List<ToggleItems>? toggleItems,
    bool? isLoading,
    String? message,
    String? error,
    bool? hasReachedMax,
    int? page,
    int? limit,
  }) =>
      ToggleItemsState(
        toggleItems: toggleItems ?? this.toggleItems,
        isLoading: isLoading ?? this.isLoading,
        message: message ?? this.message,
        error: error ?? this.error,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        page: page ?? this.page,
        limit: limit ?? this.limit,
      );

  factory ToggleItemsState.fromJson(Map<String, dynamic> json) =>
      ToggleItemsState(
        toggleItems: List<ToggleItems>.from(
          json["toggleItems"]?.map((x) => ToggleItems.fromJson(x)) ??
              <ToggleItems>[],
        ),
      );

  Map<String, dynamic> toJson() => {
        "toggleItems": toggleItems.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object> get props => [
        toggleItems,
        isLoading,
        message,
        error,
        hasReachedMax,
        page,
        limit,
      ];
}
