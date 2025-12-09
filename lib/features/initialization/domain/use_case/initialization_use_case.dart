import '../repository/initialization_repository.dart';

class InitializationUseCase {
  final InitializationRepository initializationRepository;

  InitializationUseCase(this.initializationRepository);

  Future<bool> isUserLoggedIn() async {
    return await initializationRepository.isUserLoggedIn();
  }
}
