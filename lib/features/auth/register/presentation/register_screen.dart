import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:ghaselny/features/auth/login/presentation/login_screen.dart';
import 'package:ghaselny/features/auth/register/bloc/register_bloc.dart';
import 'package:ghaselny/features/auth/auth_repository.dart';
import 'Widgets/register_widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(authRepository: AuthRepository()),
      child: const RegisterScreenContent(),
    );
  }
}

class RegisterScreenContent extends StatefulWidget {
  const RegisterScreenContent({super.key});

  @override
  State<RegisterScreenContent> createState() => _RegisterScreenContentState();
}

class _RegisterScreenContentState extends State<RegisterScreenContent> {
  // Step 0 State (Initial)
  int selectedTab = 0; // 0 = Phone, 1 = Email
  bool showOTP = false;
  Timer? _timer;
  int _start = 60;
  bool _isResendEnabled = false;

  // Controllers
  final _inputController = TextEditingController(); // For Step 0
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateLettersController = TextEditingController();
  final _plateNumbersController = TextEditingController();

  // Vehicle State
  bool _isCar = true;

  // Form Keys
  final _step0Key = GlobalKey<FormState>();
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  @override
  void dispose() {
    _timer?.cancel();
    _inputController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _plateLettersController.dispose();
    _plateNumbersController.dispose();
    super.dispose();
  }

  // --- Timer Logic for OTP ---
  void startTimer() {
    setState(() {
      _isResendEnabled = false;
      _start = 60;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _isResendEnabled = true;
        });
      } else {
        setState(() => _start--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          } else if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم إنشاء الحساب بنجاح!"), backgroundColor: Colors.green),
            );
            // Navigate to Login or Home
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
          }
        },
        builder: (context, state) {
          int currentStep = 0;
          bool isLoading = false;

          if (state is RegisterInitial) {
            currentStep = state.step;
          } else if (state is RegisterLoading) {
            isLoading = true;
          }

          return Stack(
            children: [
              // Background Gradient (Exact Match)
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
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                children: [
                  // --- Header ---
                  if (currentStep == 0 && !showOTP) ...[
                    const SizedBox(height: 100),
                    Image.asset('assets/images/app_icon.png', height: 100),
                    const SizedBox(height: 20),
                    const Text(
                      "غسل سيارتك\nفي اي وقت و اي مكان",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                  ] else ...[
                    // For Step 1 & 2: spacing
                    const SizedBox(height: 120),
                  ],

                  // --- White Sheet ---
                  Expanded(
                    flex: (currentStep == 0 && !showOTP) ? 0 : 1,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: SingleChildScrollView(
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

                            // --- Step Logic ---
                            if (isLoading)
                              const Center(child: CircularProgressIndicator(color: Color(0xFF7B3F7E)))
                            else if (currentStep == 0)
                              _buildStep0(context)
                            else if (currentStep == 1)
                                RegisterPersonalInfoStep(
                                  formKey: _step1Key,
                                  nameController: _nameController,
                                  emailController: _emailController,
                                  phoneController: _phoneController,
                                  passwordController: _passwordController,
                                  confirmPasswordController: _confirmPasswordController,
                                  onNext: () {
                                    context.read<RegisterBloc>().add(RegisterNextStep());
                                  },
                                )
                              else if (currentStep == 2)
                                  RegisterVehicleInfoStep(
                                    formKey: _step2Key,
                                    makeController: _makeController,
                                    modelController: _modelController,
                                    plateLettersController: _plateLettersController,
                                    plateNumbersController: _plateNumbersController,
                                    onVehicleTypeChanged: (val) => _isCar = val,
                                    onSubmit: () {
                                      context.read<RegisterBloc>().add(RegisterSubmit(
                                        fullName: _nameController.text,
                                        email: _emailController.text,
                                        phone: _phoneController.text, // Should include country code logic if needed
                                        password: _passwordController.text,
                                        manufacturer: _makeController.text,
                                        model: _modelController.text,
                                        isCar: _isCar,
                                        plateLetters: _plateLettersController.text,
                                        plateNumbers: _plateNumbersController.text,
                                      ));
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Back Button for steps > 0
              if (currentStep > 0)
                Positioned(
                  top: 50,
                  right: 20, // RTL
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: () {
                      context.read<RegisterBloc>().add(RegisterPreviousStep());
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // --- Step 0: Initial / OTP Logic (kept locally as it has complex local UI state) ---
  Widget _buildStep0(BuildContext context) {
    if (showOTP) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          const Text(
            "التحقق من رقم الهاتف المسجل",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "الرجاء ادخال رمز التحقق المرسل على \n${_inputController.text}",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 70),
          // OTP Lines Visual
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (i) => Container(width: 40, height: 2, color: Colors.grey[300]))
            ),
          ),
          const SizedBox(height: 70),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                // OTP Success -> Move to BLoC Step 1
                _phoneController.text = _inputController.text;
                _timer?.cancel();
                setState(() => showOTP = false);
                context.read<RegisterBloc>().add(RegisterNextStep());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B3F7E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: const Text("تأكيد الرمز", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "لم تحصل على الكود بعد؟",
                style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(width: 24),
              TextButton(
                onPressed: _isResendEnabled ? startTimer : null,
                child: Text(
                  _isResendEnabled ? "إعادة الارسال" : "إعادة الارسال (00:${_start.toString().padLeft(2, '0')})",
                  style: TextStyle(
                    color: _isResendEnabled ? const Color(0xFF8E24AA) : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          )
        ],
      );
    }

    // Default Step 0 View (Phone/Email Entry)
    return Form(
      key: _step0Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "إنشاء حساب جديد",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
          const SizedBox(height: 20),

          // Tab Switcher (Exact Design Restoration)
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(25)
            ),
            child: Row(
              children: [
                _buildTabItem(0, "رقم الهاتف", Icons.phone_iphone),
                _buildTabItem(1, "البريد الإلكتروني", Icons.email_outlined),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Input Field
          CustomTextField(
            controller: _inputController,
            hintText: '',
            labelText: selectedTab == 0 ? 'رقم الهاتف' : 'البريد الإلكتروني',
            keyboardType: selectedTab == 0 ? TextInputType.phone : TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';
              if (selectedTab == 0 && v.length < 9) return 'رقم الهاتف غير صحيح';
              return null;
            },
            suffixIcon: selectedTab == 0
                ? CountryCodePicker(
              onChanged: (country) { print("Selected country: ${country.dialCode}"); },
              initialSelection: 'SA',
              favorite: const ['+966', '+971', 'EG'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              builder: (country) {
                return Container(
                  width: 110,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(country!.flagUri!, package: 'country_code_picker', width: 25),
                      const SizedBox(width: 6),
                      Text(
                        country.dialCode ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Cairo'),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
                    ],
                  ),
                );
              },
            )
                : null,
          ),

          const SizedBox(height: 60),

          // Main Action Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                if (_step0Key.currentState!.validate()) {
                  if (selectedTab == 0) {
                    setState(() => showOTP = true);
                    startTimer();
                  } else {
                    _emailController.text = _inputController.text;
                    // Move to Step 1 via BLoC
                    context.read<RegisterBloc>().add(RegisterNextStep());
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B3F7E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: Text(
                selectedTab == 0 ? "ارسل كود التحقق" : "إنشاء حساب جديد",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("هل لديك حساب بالفعل؟", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                child: const Text("تسجيل الدخول", style: TextStyle(color: Color(0xFF7B3F7E), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Exact Tab Item Design
  Widget _buildTabItem(int index, String title, IconData icon) {
    bool isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() { selectedTab = index; _inputController.clear(); }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFCE4EC) : Colors.transparent,
            borderRadius: index == 0
                ? const BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25))
                : const BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
            border: isSelected
                ? Border.all(color: const Color(0xFF8E24AA), width: 0.5)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: isSelected ? const Color(0xFF8E24AA) : Colors.grey),
              const SizedBox(width: 8),
              Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF8E24AA) : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}