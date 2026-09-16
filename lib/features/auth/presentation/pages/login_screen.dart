import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_vibecode_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:my_vibecode_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_vibecode_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:my_vibecode_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:my_vibecode_app/features/home/presentation/pages/home_screen.dart';
import 'package:my_vibecode_app/features/home/domain/usecases/load_home_overview_use_case.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    required this.loginUseCase,
    this.loadHomeOverview,
  });

  final LoginUseCase loginUseCase;
  final LoadHomeOverviewUseCase? loadHomeOverview;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(loginUseCase: loginUseCase),
      child: _LoginView(loadHomeOverview: loadHomeOverview),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView({required this.loadHomeOverview});

  final LoadHomeOverviewUseCase? loadHomeOverview;

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  static const _ink = Color(0xFF17302C);
  static const _mutedInk = Color(0xFF6C7D78);
  static const _surface = Color(0xFFFFFEFC);
  static const _canvas = Color(0xFFF5F7F3);
  static const _emerald = Color(0xFF0F766E);
  static const _emeraldDark = Color(0xFF075E58);
  static const _error = Color(0xFFB54745);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<AuthBloc>().add(
      LoginSubmitted(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _canvas,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 600;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 20 : 32,
                vertical: isCompact ? 28 : 48,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listenWhen: (previous, current) =>
                        previous.status != current.status,
                    listener: (context, state) {
                      if (state.status == AuthStatus.success &&
                          state.user != null &&
                          widget.loadHomeOverview != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => HomeScreen(
                              user: state.user!,
                              loadHomeOverview: widget.loadHomeOverview!,
                            ),
                          ),
                        );
                      } else if (state.status == AuthStatus.success &&
                          state.user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: _emeraldDark,
                            content: Text('Welcome, ${state.user!.name}'),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return _LoginCard(
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        obscurePassword: _obscurePassword,
                        state: state,
                        onSubmit: _submit,
                        onTogglePassword: () => setState(() {
                          _obscurePassword = !_obscurePassword;
                        }),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.state,
    required this.onSubmit,
    required this.onTogglePassword,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final AuthState state;
  final VoidCallback onSubmit;
  final VoidCallback onTogglePassword;

  @override
  Widget build(BuildContext context) {
    final isLoading = state.status == AuthStatus.loading;
    final hasFailure =
        state.status == AuthStatus.failure && state.failure != null;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _LoginViewState._surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE3EAE4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1417302C),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _BrandMark(),
            const SizedBox(height: 28),
            const Text(
              'Welcome back',
              style: TextStyle(
                color: _LoginViewState._ink,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Sign in to pick up where you left off.',
              style: TextStyle(
                color: _LoginViewState._mutedInk,
                fontSize: 15,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                label: 'Email address',
                icon: Icons.alternate_email_rounded,
              ),
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => onSubmit(),
              decoration: _inputDecoration(
                label: 'Password',
                icon: Icons.lock_outline_rounded,
                suffix: IconButton(
                  tooltip: obscurePassword ? 'Show password' : 'Hide password',
                  onPressed: onTogglePassword,
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: isLoading ? null : () {},
                style: TextButton.styleFrom(
                  foregroundColor: _LoginViewState._emerald,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Forgot password?'),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: isLoading ? null : onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: _LoginViewState._emerald,
                disabledBackgroundColor: _LoginViewState._emerald.withValues(
                  alpha: 0.6,
                ),
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: isLoading
                  ? const SizedBox.square(
                      dimension: 21,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    )
                  : const Text('Sign in'),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: hasFailure
                  ? Container(
                      key: const ValueKey('auth-failure'),
                      margin: const EdgeInsets.only(top: 18),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF3D2CD)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: _LoginViewState._error,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              state.failure!.message,
                              style: const TextStyle(
                                color: _LoginViewState._error,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(height: 18, key: ValueKey('no-failure')),
            ),
            const SizedBox(height: 14),
            Text.rich(
              TextSpan(
                text: 'New here? ',
                style: const TextStyle(color: _LoginViewState._mutedInk),
                children: [
                  TextSpan(
                    text: 'Create an account',
                    style: const TextStyle(
                      color: _LoginViewState._emerald,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: _LoginViewState._mutedInk, size: 21),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF7F9F6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFDDE6DF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFDDE6DF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: _LoginViewState._emerald,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: _LoginViewState._error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: _LoginViewState._error, width: 1.5),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: _LoginViewState._emerald,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F0F766E),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.auto_awesome_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}
