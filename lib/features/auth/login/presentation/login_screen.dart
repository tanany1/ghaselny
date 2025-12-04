import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghaselny/features/auth/auth_repository.dart';
import 'package:ghaselny/features/auth/login/bloc/login_bloc.dart';
import 'package:ghaselny/features/auth/login/presentation/forgot_password_screens.dart';
import 'package:ghaselny/features/auth/register/presentation/register_screen.dart';
import 'package:ghaselny/features/home/presentation/home_screen.dart';
import 'Widgets/login_widgets.dart'; // Import the new screens

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(authRepository: AuthRepository()),
      child: const LoginScreenContent(),
    );
  }
}

class LoginScreenContent extends StatefulWidget {
  const LoginScreenContent({super.key});

  @override
  State<LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<LoginScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          } else if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم تسجيل الدخول بنجاح!"), backgroundColor: Colors.green),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        },
        builder: (context, state) {
          int selectedTab = 0;
          bool isPasswordVisible = false;
          bool isLoading = false;

          if (state is LoginInitial) {
            selectedTab = state.selectedTab;
            isPasswordVisible = state.isPasswordVisible;
          } else if (state is LoginLoading) {
            isLoading = true;
          }

          return Stack(
            children: [
              // 1. Background Gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF653662), Color(0xFFFFD6F7)],
                  ),
                ),
              ),
              Positioned.fill(
                child: Image.asset(
                  "assets/images/pattern.png",
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  // 2. Header (Logo)
                  const LoginHeader(),
                  const Spacer(),

                  // 3. White Sheet (Form)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Handle bar
                            Center(
                              child: Container(
                                width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                              ),
                            ),

                            const Text(
                              "تسجيل الدخول",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87),
                            ),
                            const SizedBox(height: 20),

                            // Tab Switcher
                            LoginTabSwitcher(
                              selectedTab: selectedTab,
                              onTabChanged: (index) {
                                _inputController.clear();
                                context.read<LoginBloc>().add(LoginTabChanged(index));
                              },
                            ),
                            const SizedBox(height: 20),

                            // Input Field (Phone or Email)
                            LoginTextField(
                              controller: _inputController,
                              labelText: selectedTab == 0 ? 'رقم الهاتف' : 'البريد الإلكتروني',
                              keyboardType: selectedTab == 0 ? TextInputType.phone : TextInputType.emailAddress,
                              isPhone: selectedTab == 0,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'هذا الحقل مطلوب';
                                if (selectedTab == 0 && value.length < 9) return 'رقم الهاتف غير صحيح';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password Field & Forgot Password (ONLY FOR EMAIL)
                            if (selectedTab == 1) ...[
                              LoginTextField(
                                controller: _passwordController,
                                labelText: 'كلمة المرور',
                                obscureText: !isPasswordVisible,
                                validator: (value) => (value?.isEmpty ?? true) ? 'كلمة المرور مطلوبة' : null,
                                suffixIcon: IconButton(
                                  icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                                  onPressed: () {
                                    context.read<LoginBloc>().add(LoginVisibilityToggled());
                                  },
                                ),
                              ),

                              // Forgot Password Link
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ForgotPasswordFlowWrapper()),
                                    );
                                  },
                                  style: TextButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                  child: const Text("نسيت كلمة المرور؟", style: TextStyle(color: Color(0xFF7B3F7E), fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],

                            const SizedBox(height: 12),

                            // Login Button
                            if (isLoading)
                              const Center(child: CircularProgressIndicator(color: Color(0xFF7B3F7E)))
                            else
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<LoginBloc>().add(LoginSubmitted(
                                        identifier: _inputController.text,
                                        // Send empty password if using phone (Tab 0)
                                        password: selectedTab == 1 ? _passwordController.text : "",
                                        isPhone: selectedTab == 0,
                                      ));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF7B3F7E),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    elevation: 0,
                                  ),
                                  child: const Text("تسجيل الدخول", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ),

                            const SizedBox(height: 8),

                            // Footer
                            LoginFooter(
                              onRegisterTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                );
                              },
                            ),
                          ],
                        ),
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