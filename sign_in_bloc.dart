import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:store/bloc/store/store_bloc.dart';
import 'package:store/core/utils/constants.dart';
import 'package:store/data/models/store_details.dart';
import 'package:store/data/repository/auth_repository.dart';
import 'authentication_bloc.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({
    required this.authRepository,
    required this.authenticationBloc,
    required this.storeBloc,
  }) : super(SignInInitial()) {
    on<SignIn>(_onSignIn);
    on<SignOut>(_onSignOut);
  }

  FutureOr<void> _onSignIn(SignIn event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    try {
      final response = await authRepository.signIn(event.phone, event.password);
      if (response.success) {
        final store = response.data as StoreDetail;
        storeBloc.add(UpdateStoreDetails(store: store));
        await HydratedBloc.storage.write(kUser, store.token);
        authenticationBloc.add(AuthenticationAuthenticated());
        emit(SignInSuccess());
      } else {
        emit(SignInFailure(message: response.message));
      }
    } catch (error) {
      emit(SignInFailure(message: 'An error occurred : $error'));
    }
  }

  FutureOr<void> _onSignOut(SignOut event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    await HydratedBloc.storage.clear();
    authenticationBloc.add(AuthenticationUnAuthenticated());
    emit(SignInInitial());
  }

  final AuthRepository authRepository;
  final AuthenticationBloc authenticationBloc;
  final StoreBloc storeBloc;
}
