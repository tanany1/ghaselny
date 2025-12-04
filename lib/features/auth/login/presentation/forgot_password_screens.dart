import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghaselny/features/auth/auth_repository.dart';
import 'package:ghaselny/features/auth/login/presentation/Widgets/login_widgets.dart';
import '../Bloc/forgot_password_bloc.dart';

// Wrapper to provide Bloc
class ForgotPasswordFlowWrapper extends StatelessWidget {
  const ForgotPasswordFlowWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(authRepository: AuthRepository()),
      child: const ForgotPasswordScreen(),
    );
  }
}

// --- SCREEN 1: Enter Email/Phone ---
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedTab = 0; // 0 = Phone, 1 = Email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          } else if (state is ForgotPasswordLinkSentSuccess) {
            // Navigate to Reset Password Screen
            if (state.id != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ForgotPasswordBloc>(),
                    child: ResetPasswordScreen(userId: state.id!),
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم إرسال رابط إعادة التعيين"), backgroundColor: Colors.green),
              );
            }
          }
        },
        builder: (context, state) {
          bool isLoading = state is ForgotPasswordLoading;

          return Stack(
            children: [
              // Background
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF6A3A74), Color(0xFF9E65A5)],
                  ),
                ),
              ),

              Column(
                children: [
                  const SizedBox(height: 100),
                  Image.asset('assets/images/app_icon.png', height: 200),

                  const SizedBox(height: 10),
                  const Text(
                    "نسيت كلمة المرور؟",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "أدخل رقم هاتفك أو بريدك الإلكتروني\nلاستعادة حسابك",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const Spacer(),

                  // White Sheet
                  Container(
                    height: 350,
                    width: double.infinity,
                    padding: const EdgeInsets.all(30.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          LoginTabSwitcher(
                            selectedTab: _selectedTab,
                            onTabChanged: (index) {
                              setState(() {
                                _selectedTab = index;
                                _controller.clear();
                              });
                            },
                          ),
                          const SizedBox(height: 50),

                          LoginTextField(
                            controller: _controller,
                            labelText: _selectedTab == 0 ? 'رقم الهاتف' : 'البريد الإلكتروني',
                            isPhone: _selectedTab == 0,
                            validator: (val) {
                              if (val == null || val.isEmpty) return 'مطلوب';
                              return null;
                            },
                          ),
                          const Spacer(),

                          if (isLoading)
                            const Center(child: CircularProgressIndicator(color: Color(0xFF7B3F7E)))
                          else
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<ForgotPasswordBloc>().add(
                                      ForgotPasswordSubmitted(
                                        identifier: _controller.text,
                                        isPhone: _selectedTab == 0,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7B3F7E),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                                child: const Text("إرسال", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

// --- SCREEN 2: Reset Password ---
class ResetPasswordScreen extends StatefulWidget {
  final String userId;
  const ResetPasswordScreen({super.key, required this.userId});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم تغيير كلمة المرور بنجاح"), backgroundColor: Colors.green),
            );
            // Go back to Login
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (state is ForgotPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          bool isLoading = state is ForgotPasswordLoading;

          return Stack(
            children: [
              // Background
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF6A3A74), Color(0xFF9E65A5)],
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    "تعيين كلمة المرور",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text("أدخل كلمة المرور الجديدة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),

                          LoginTextField(
                            controller: _passwordController,
                            labelText: 'كلمة المرور الجديدة',
                            obscureText: _isObscure,
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _isObscure = !_isObscure),
                            ),
                            validator: (v) => (v != null && v.length < 6) ? 'كلمة المرور قصيرة' : null,
                          ),
                          const SizedBox(height: 15),

                          LoginTextField(
                            controller: _confirmController,
                            labelText: 'تأكيد كلمة المرور',
                            obscureText: _isObscure,
                            validator: (v) => v != _passwordController.text ? 'كلمات المرور غير متطابقة' : null,
                          ),
                          const SizedBox(height: 30),

                          if (isLoading)
                            const Center(child: CircularProgressIndicator(color: Color(0xFF7B3F7E)))
                          else
                            SizedBox(
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<ForgotPasswordBloc>().add(
                                      ResetPasswordSubmitted(
                                        id: widget.userId,
                                        newPassword: _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7B3F7E),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                                child: const Text("تغيير كلمة المرور", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}