import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _islogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscured = true;

  final _formKey = GlobalKey<FormState>();

  void toggleLogin(){
    setState(() {
      _islogin = !_islogin;
    });
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(Duration(seconds: 2)); // fake login delay

    setState(() => _isLoading = false);

    // Do Supabase login logic here
    print("Email: ${_emailController.text}, Password: ${_passwordController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _islogin ? "Login." : "Signup.",
                style: GoogleFonts.lato(
                  fontSize: 50,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: GoogleFonts.lato(
                                fontSize: 17,
                              )
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) => val != null && !val.contains('@') ? "Enter a valid email" : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                            labelText: "Password",
                              labelStyle: GoogleFonts.lato(
                                fontSize: 17,
                              ),
                            suffixIcon: IconButton(
                              icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _isObscured = !_isObscured),
                            ),
                          ),
                          validator: (val) => val != null && val.length < 6 ? "Min 6 characters required" : null,
                        ),
                        const SizedBox(height: 32),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                          onPressed: _login,
                          child: Text(
                              _islogin ? "Login" : "Signup",
                            style: GoogleFonts.lato(
                              fontSize: 18
                            ),

                          ),
                        ),
                        TextButton(
                            onPressed: toggleLogin,
                            child: Text(
                                "Already have an account.",
                                style: GoogleFonts.lato(
                                fontSize: 15,
                                ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
