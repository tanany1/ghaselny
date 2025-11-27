import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:ghaselny/features/auth/register/presentation/register_screen.dart';
import 'package:ghaselny/features/home/presentation/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 0 = Phone, 1 = Email
  int selectedTab = 0;

  // 0 = Initial, 1 = Personal Info, 2 = Vehicle Info
  int _registrationStep = 0;

  // ---------------------------

  final _formKey = GlobalKey<FormState>();

  // Step 0 Controllers
  final TextEditingController _inputController = TextEditingController();

  // NEW: Password Controller
  final TextEditingController _passwordController = TextEditingController();

  // NEW: Visibility Toggle
  bool _isPasswordVisible = false;

  // Vehicle Type Selection
  bool isCarSelected = true;

  @override
  void dispose() {
    _inputController.dispose();
    _passwordController.dispose(); // Don't forget to dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A3A74), // Darker purple top
              Color(0xFF9E65A5), // Lighter purple
            ],
          ),
        ),
        child: Column(
          children: [
            // ===============================================
            // HEADER SECTION (Logo & Text)
            // ===============================================
            if (_registrationStep == 0) ...[
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
              const SizedBox(height: 120),
            ],
            Expanded(
              flex: _registrationStep == 0 ? 0 : 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
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
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const Text(
                          "تسجيل الدخول",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Tabs
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTab = 0;
                                      _inputController.clear();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selectedTab == 0
                                          ? const Color(0xFFFCE4EC)
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                      ),
                                      border: selectedTab == 0
                                          ? Border.all(
                                              color: const Color(0xFF8E24AA),
                                              width: 0.5,
                                            )
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.phone_iphone,
                                          size: 20,
                                          color: selectedTab == 0
                                              ? const Color(0xFF8E24AA)
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "رقم الهاتف",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: selectedTab == 0
                                                ? const Color(0xFF8E24AA)
                                                : Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTab = 1;
                                      _inputController.clear();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selectedTab == 1
                                          ? const Color(0xFFFCE4EC)
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        bottomLeft: Radius.circular(25),
                                      ),
                                      border: selectedTab == 1
                                          ? Border.all(
                                              color: const Color(0xFF8E24AA),
                                              width: 0.5,
                                            )
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.email_outlined,
                                          size: 20,
                                          color: selectedTab == 1
                                              ? const Color(0xFF8E24AA)
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "البريد الإلكتروني",
                                          style: TextStyle(
                                            color: selectedTab == 1
                                                ? const Color(0xFF8E24AA)
                                                : Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Input Field (Phone or Email)
                        TextFormField(
                          controller: _inputController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'هذا الحقل مطلوب';
                            }
                            if (selectedTab == 0 && value.length < 9) {
                              return 'رقم الهاتف غير صحيح';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: selectedTab == 0
                                ? 'رقم الهاتف'
                                : 'البريد الإلكتروني',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF8E24AA),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            suffixIcon: selectedTab == 0
                                ? CountryCodePicker(
                                    onChanged: (country) {
                                      print(
                                        "Selected country: ${country.dialCode}",
                                      );
                                    },
                                    initialSelection: 'SA',
                                    favorite: const ['+966', '+971', 'EG'],
                                    showCountryOnly: false,
                                    showOnlyCountryWhenClosed: false,
                                    builder: (country) {
                                      return Container(
                                        width: 110,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Row(
                                          textDirection: TextDirection.ltr,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Image.asset(
                                              country!.flagUri!,
                                              package: 'country_code_picker',
                                              width: 25,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              country.dialCode ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontFamily: 'Cairo',
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : null,
                          ),
                          keyboardType: selectedTab == 0
                              ? TextInputType.phone
                              : TextInputType.emailAddress,
                        ),
                        if (selectedTab == 1) ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'كلمة المرور مطلوبة';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'كلمة المرور',
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF8E24AA),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          // Forgot Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            // Left for RTL 'End'
                            child: TextButton(
                              onPressed: () {
                                // TODO: Handle Forgot Password Navigation
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                "نسيت كلمة المرور؟",
                                style: TextStyle(
                                  color: Color(0xFF7B3F7E),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],

                        // ===============================================
                        const SizedBox(height: 12),

                        // Main Button (Step 0 Action)
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
                              // if (_formKey.currentState!.validate()) {}
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7B3F7E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "ليس لديك حساب؟",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Handle Login
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "انشاء حساب",
                                style: TextStyle(
                                  color: Color(0xFF7B3F7E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
