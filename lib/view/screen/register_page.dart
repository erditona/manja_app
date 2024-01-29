import 'package:flutter/material.dart';
import 'package:manja_app/services/api_services.dart';
import 'package:manja_app/view/screen/login_page.dart';
import 'package:manja_app/view/widget/text_field_builder.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final ApiService apiService = ApiService();

  bool _passwordVisible = false;
  bool _confirmpassVisible = false;

  bool _loading = false;
  String _responseMessage = '';

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _toggleConfirmPassVisibility() {
    setState(() {
      _confirmpassVisible = !_confirmpassVisible;
    });
  }

  Future<void> _register() async {
    final isValid = _validateForm();

    if (!isValid) {
      return;
    }

    setState(() {
      _loading = true;
      _responseMessage = ''; // Clear previous response message
    });

    try {
      Map<String, dynamic> result = await apiService.register(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
      );

      // Handle the API response
      // For example, show a success message or navigate to the login page
      print(result);
      setState(() {
        _responseMessage = result['message'];
      });

      // Check the status code
      if (result['status'] == 200) {
        // If status is 200, registration is successful
        _loading = false;
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Success'),
              content: Text(_responseMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigate to login page after closing the alert dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // If status is not 200, handle the registration failure
        _showSnackbar('Registration failed. ${result['message']}', Colors.red);
      }
    } catch (error) {
      // Handle registration error
      print('Registration error: $error');
      setState(() {
        _responseMessage = 'Registration failed. Please try again.';
      });
    } finally {
      // Set loading to false after the registration process is complete
      setState(() {
        _loading = false;
      });
    }
  }

  // Validate the form fields
  bool _validateForm() {
    String fullName = fullNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();

    // Validasi semua field masih kosong
    if (fullName.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty &&
        phoneNumber.isEmpty) {
      _showSnackbar('Lengkapi Semua Data.', Colors.red);
      return false;
    }

    // Validasi nama lengkap
    if (fullName.isEmpty ||
        !RegExp(r'^[A-Z][a-z]+ [A-Z][a-z]+$').hasMatch(fullName)) {
      _showSnackbar(
          'Masukan nama lengkap dengan benar. Contoh: Budi Wati.', Colors.red);
      return false;
    }

    // Validasi email
    if (email.isEmpty ||
        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(email)) {
      _showSnackbar('Masukan email dengan format yang sesuai.', Colors.red);
      return false;
    }

    // Validasi password
    if (password.isEmpty || password.length < 6) {
      _showSnackbar('Password Tidak Sesuai, minimal 8 karakter.', Colors.red);
      return false;
    }

    // Validasi konfirmasi password
    if (confirmPassword.isEmpty || confirmPassword != password) {
      _showSnackbar('Password Tidak Sesuai, konfirmasi ulang.', Colors.red);
      return false;
    }

    // Validasi nomor telepon
    if (phoneNumber.isEmpty || !RegExp(r'^62[0-9]+$').hasMatch(phoneNumber)) {
      _showSnackbar('Masukan Nomor telepon dengan format "62".', Colors.red);
      return false;
    }

    return true;
  }

  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Response'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: !_passwordVisible,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmpassVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _toggleConfirmPassVisibility,
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: !_confirmpassVisible,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  _register();
                },
                child: Text('Sign Up'),
              ),
              SizedBox(height: 16.0),
              Visibility(
                visible: _loading,
                child: Center(
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF39A7FF)),
                  ),
                ),
              ),
              // Register Button
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
