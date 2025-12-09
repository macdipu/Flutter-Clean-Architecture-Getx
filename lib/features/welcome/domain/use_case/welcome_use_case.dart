import '../repository/welcome_repository.dart';

class WelcomeUseCase {
  final WelcomeRepository welcomeRepository;

  WelcomeUseCase(this.welcomeRepository);

  Future<bool> isUserLoggedIn() async {
    return await welcomeRepository.isUserLoggedIn();
  }
}
