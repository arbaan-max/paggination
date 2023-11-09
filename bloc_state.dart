part of 'driver_bloc.dart';

class DriverState extends Equatable {
  const DriverState({
    this.drivers = const <Driver>[],
    this.availableDrivers = const <Driver>[],
    this.isLoading = false,
    this.error = '',
    this.message = '',
  });
  final List<Driver> drivers;
  final List<Driver> availableDrivers;
  final bool isLoading;
  final String error;
  final String message;

  DriverState copyWith({
    List<Driver>? drivers,
    List<Driver>? availableDrivers,
    bool? isLoading,
    String? error,
    String? message,
  }) =>
      DriverState(
        drivers: drivers ?? this.drivers,
        availableDrivers: availableDrivers ?? this.availableDrivers,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        message: message ?? this.message,
      );

  /// fromJson is used to convert the Map to the DriverState
  factory DriverState.fromJson(Map<String, dynamic> json) {
    return DriverState(
      drivers: List<Driver>.from(
        json['DriverStateDrivers']?.map((driver) => Driver.fromJson(driver)) ??
            <Driver>[],
      ),
    );
  }

  /// toJson is used to convert the DriverState to the Map
  Map<String, dynamic> toJson() => {
        'DriverStateDrivers': drivers.map((driver) => driver.toJson()).toList(),
      };

  @override
  List<Object?> get props =>
      [drivers, availableDrivers, isLoading, error, message];
}

// class DriverInitial extends DriverState {}

// class DriverLoading extends DriverState {}

// class DriverLoaded extends DriverState {
//   final List<Driver> drivers;
//   const DriverLoaded({required this.drivers});
// }

// class DriverOrdersLoaded extends DriverState {
//   final List<DriverOrder> orders;
//   const DriverOrdersLoaded({required this.orders});
// }

// class DriverError extends DriverState {
//   final String message;
//   const DriverError({required this.message});
// }
