import '../../data/repo_impl/welcome_repository_impl.dart';

class WelcomeUseCase {
  final WelcomeRepositoryImpl welcomeRepository = WelcomeRepositoryImpl();

  Future<bool> isUserLoggedIn() async {
    return await welcomeRepository.isUserLoggedIn();
  }
}
