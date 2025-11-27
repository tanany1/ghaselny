import 'dart:async';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:ghaselny/features/auth/login/presentation/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 0 = Phone, 1 = Email
  int selectedTab = 0;

  // 0 = Initial, 1 = Personal Info, 2 = Vehicle Info
  int _registrationStep = 0;

  // --- OTP STATE VARIABLES ---
  bool showOTP = false;
  Timer? _timer;
  int _start = 60;
  bool _isResendEnabled = false;

  // ---------------------------

  final _formKey = GlobalKey<FormState>();

  // Step 0 Controller
  final TextEditingController _inputController = TextEditingController();

  // Step 1 Controllers (Personal)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Step 2 Controllers (Vehicle)
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _plateLettersController = TextEditingController();
  final TextEditingController _plateNumbersController = TextEditingController();

  // Vehicle Type Selection
  bool isCarSelected = true;

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer on dispose
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

  // Timer Logic
  void startTimer() {
    setState(() {
      _isResendEnabled = false;
      _start = 30;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _isResendEnabled = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  // Helper widget for Vehicle Toggle (Car/Bike)
  Widget _buildVehicleToggle(String label, IconData icon, bool isCar) {
    bool isSelected = (isCarSelected == isCar);
    return GestureDetector(
      onTap: () {
        setState(() {
          isCarSelected = isCar;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3E5F5) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF7B3F7E) : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? const Color(0xFF7B3F7E) : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF7B3F7E) : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
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
            // Visible ONLY in Step 0
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
              const Spacer(), // Pushes the white container to the bottom
            ] else ...[
              // For Step 1 & 2: Just a top spacing so the white sheet
              // starts higher up (approx 2/3 of screen available)
              const SizedBox(height: 120),
            ],

            // ===============================================
            // WHITE SHEET CONTAINER
            // ===============================================
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

                        // ============================================
                        // STATE 0: INITIAL SCREEN
                        // ============================================
                        if (_registrationStep == 0) ...[
                          // ------------------------------------------
                          // SCENARIO A: SHOW YOUR CUSTOM OTP VIEW
                          // ------------------------------------------
                          if (showOTP) ...[
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
                            // Subtitle with number
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

                            // Visual Representation of 6 OTP Lines
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(6, (index) {
                                  return Container(
                                    width: 40,
                                    height: 2,
                                    color:
                                        Colors.grey[300], // The underline color
                                  );
                                }),
                              ),
                            ),

                            const SizedBox(height: 70),

                            // Confirm Button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () {
                                  // HANDLE CONFIRMATION & MOVE TO STEP 1
                                  // 1. Transfer Phone Data
                                  _phoneController.text = _inputController.text;
                                  _emailController.clear();

                                  // 2. Stop Timer
                                  _timer?.cancel();

                                  // 3. Navigate
                                  setState(() {
                                    showOTP = false;
                                    _registrationStep = 1;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7B3F7E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  "تأكيد الرمز",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Resend / Timer Text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "لم تحصل على الكود بعد؟",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                TextButton(
                                  onPressed: _isResendEnabled
                                      ? () {
                                          startTimer(); // Restart timer
                                        }
                                      : null,
                                  child: Text(
                                    _isResendEnabled
                                        ? "إعادة الارسال"
                                        : "إعادة الارسال (00:${_start.toString().padLeft(2, '0')})",
                                    style: TextStyle(
                                      color: _isResendEnabled
                                          ? const Color(0xFF8E24AA)
                                          : Colors.grey, // Grey when disabled
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]
                          // ------------------------------------------
                          // SCENARIO B: SHOW INPUT/TABS (DEFAULT)
                          // ------------------------------------------
                          else ...[
                            const Text(
                              "إنشاء حساب جديد",
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
                                          _inputController
                                              .clear(); // Clears text when switching to Phone
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
                                                  color: const Color(
                                                    0xFF8E24AA,
                                                  ),
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
                                          _inputController
                                              .clear(); // Clears text when switching to Phone
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
                                                  color: const Color(
                                                    0xFF8E24AA,
                                                  ),
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
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
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
                                                  package:
                                                      'country_code_picker',
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

                            const SizedBox(height: 60),

                            // Main Button (Step 0 Action)
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (selectedTab == 0) {
                                      // PHONE -> TRIGGER YOUR OTP VIEW
                                      setState(() {
                                        showOTP = true;
                                      });
                                      startTimer();
                                    } else {
                                      // EMAIL -> SKIP OTP, GO TO STEP 1
                                      _emailController.text =
                                          _inputController.text;
                                      _phoneController.clear();
                                      setState(() {
                                        _registrationStep = 1;
                                      });
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7B3F7E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  selectedTab == 0
                                      ? "ارسل كود التحقق"
                                      : "إنشاء حساب جديد",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Footer
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "هل لديك حساب بالفعل؟",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Handle Login
                                    Navigator.of(
                                      context,
                                    ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                                  },
                                  child: const Text(
                                    "تسجيل الدخول",
                                    style: TextStyle(
                                      color: Color(0xFF7B3F7E),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ]
                        // ============================================
                        // STATE 1: PERSONAL INFO (1 of 2)
                        // ============================================
                        else if (_registrationStep == 1) ...[
                          const Text(
                            "إنشاء حساب جديد (1 من 2)",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "معلوماتك الشخصية",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Name Field
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\u0600-\u06FF\s]'),
                              ),
                            ],
                            controller: _nameController,
                            textAlign: TextAlign.right,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'الاسم مطلوب';
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'اسمك بالكامل',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'البريد الإلكتروني مطلوب';
                              if (!value.contains('@'))
                                return 'بريد إلكتروني غير صحيح';
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'البريد الإلكتروني',
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Colors.grey,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Phone Field
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'رقم الهاتف مطلوب';
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'رقم الهاتف',
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              suffixIcon: CountryCodePicker(
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
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            textAlign: TextAlign.right,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'كلمة المرور مطلوبة';
                              if (value.length < 6)
                                return 'كلمة المرور قصيرة جداً';
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'كلمة المرور',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.grey,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Confirm Password Field
                          TextFormField(
                            controller: _confirmPasswordController,
                            textAlign: TextAlign.right,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'تأكيد كلمة المرور مطلوب';
                              if (value != _passwordController.text)
                                return 'كلمات المرور غير متطابقة';
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'تأكيد كلمة المرور',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.grey,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),

                          const SizedBox(height: 100),

                          // Next Button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: OutlinedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _registrationStep = 2;
                                  });
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF7B3F7E),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "التالي",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7B3F7E),
                                ),
                              ),
                            ),
                          ),
                        ]
                        // ============================================
                        // STATE 2: VEHICLE INFO (2 of 2)
                        // ============================================
                        else if (_registrationStep == 2) ...[
                          const Text(
                            "إنشاء حساب جديد (2 من 2)",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "معلومات مركبتك",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Make
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\u0600-\u06FF\s]'),
                              ),
                            ],
                            controller: _makeController,
                            textAlign: TextAlign.right,
                            validator: (value) => (value?.isEmpty ?? true)
                                ? 'هذا الحقل مطلوب'
                                : null,
                            decoration: InputDecoration(
                              hintText: 'مصنع المركبة (الماركة)',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Model
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\u0600-\u06FF\s]'),
                              ),
                            ],
                            controller: _modelController,
                            textAlign: TextAlign.right,
                            validator: (value) => (value?.isEmpty ?? true)
                                ? 'هذا الحقل مطلوب'
                                : null,
                            decoration: InputDecoration(
                              hintText: 'طراز المركبة (الموديل)',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Plate Number Label & Toggles
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "رقم اللوحة",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Car/Bike Toggle Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildVehicleToggle(
                                "سيارة",
                                Icons.directions_car,
                                true,
                              ),
                              const SizedBox(width: 12),
                              _buildVehicleToggle(
                                "دراجة",
                                Icons.two_wheeler,
                                false,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // Plate Inputs (Letters & Numbers)
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z\u0600-\u06FF\s]'),
                                    ),
                                  ],
                                  controller: _plateLettersController,
                                  textAlign: TextAlign.center,
                                  validator: (value) =>
                                      (value?.isEmpty ?? true) ? 'مطلوب' : null,
                                  decoration: InputDecoration(
                                    hintText: 'احرف',
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _plateNumbersController,
                                  textAlign: TextAlign.center,
                                  validator: (value) =>
                                      (value?.isEmpty ?? true) ? 'مطلوب' : null,
                                  decoration: InputDecoration(
                                    hintText: 'ارقام',
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 100),

                          // Final Create Account Button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // FINAL SUBMISSION LOGIC
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("تم إنشاء الحساب بنجاح!"),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7B3F7E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                "انشاء الحساب",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
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
