class LoginState {
  final String email;
  final String password;
  final bool obscurePassword;
  final bool agreedToTerms;
  final bool isLoading;

  const LoginState({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.agreedToTerms = false,
    this.isLoading = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
    bool? agreedToTerms,
    bool? isLoading,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
