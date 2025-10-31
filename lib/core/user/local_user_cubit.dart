import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/core/services/storage_service.dart';

part 'local_user_state.dart';

class LocalUserCubit extends Cubit<LocalUserState> {
  LocalUserCubit({required this.storageService}) : super(LocalUserInitial());

  final StorageService storageService;

  Future<void> loadUser() async {
    emit(LocalUserLoading());
    final hasCompletedOnboarding = await storageService.isOnboardingCompleted();
    emit(LocalUserSuccess(!hasCompletedOnboarding));
  }

  Future<void> completeOnboarding() async {
    await storageService.setOnboardingCompleted();
    emit(const LocalUserSuccess(false));
  }
}
