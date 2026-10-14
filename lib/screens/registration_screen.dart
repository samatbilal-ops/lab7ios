import 'package:flutter/material.dart';

import 'root_screen.dart';

/// LAB 6: Registration form with validation.
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _confirmKey = GlobalKey<FormFieldState<String>>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  static const List<String> _roles = ['Student', 'Teacher', 'Developer'];
  String? _role;
  bool _acceptedTerms = false;
  bool _hidePassword = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ---------- Validators ----------
  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Full name is required';
    return null;
  }

  String? _validateEmail(String? v) {
    final email = v?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';
    if (!email.contains('@') || !email.contains('.')) {
      return 'Email must contain "@" and "." (e.g. name@narxoz.kz)';
    }
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!valid) return 'Enter a valid email (e.g. name@narxoz.kz)';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != _passwordCtrl.text) return 'Passwords do not match';
    return null;
  }

  // ---------- Submit ----------
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ));
      return;
    }

    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();

    // Print form data in terminal (password is masked on purpose).
    // ignore: avoid_print
    print('===== REGISTRATION DATA =====');
    // ignore: avoid_print
    print('Full name : $name');
    // ignore: avoid_print
    print('Email     : $email');
    // ignore: avoid_print
    print('Password  : ${'*' * _passwordCtrl.text.length}');
    // ignore: avoid_print
    print('Role      : $_role');
    // ignore: avoid_print
    print('Terms     : $_acceptedTerms');

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Welcome, $name! Registration successful.'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ));

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Registration successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name'),
            Text('Email: $email'),
            Text('Role: $_role'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    await _openProduct(name);
    if (!mounted) return;
    _resetForm();
  }

  // Lab 7 root screen (tabs) opens after successful registration.
  Future<void> _openProduct(String name) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RootScreen(userName: name),
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameCtrl.clear();
    _emailCtrl.clear();
    _passwordCtrl.clear();
    _confirmCtrl.clear();
    setState(() {
      _role = null;
      _acceptedTerms = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Register & set up your profile',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _nameCtrl,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateName,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'name@narxoz.kz',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _hidePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _hidePassword ? 'Show' : 'Hide',
                          icon: Icon(_hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                        ),
                      ),
                      validator: _validatePassword,
                      onChanged: (_) {
                        if (_confirmCtrl.text.isNotEmpty) {
                          _confirmKey.currentState?.validate();
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      key: _confirmKey,
                      controller: _confirmCtrl,
                      obscureText: _hideConfirm,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_reset),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _hideConfirm ? 'Show' : 'Hide',
                          icon: Icon(_hideConfirm
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              setState(() => _hideConfirm = !_hideConfirm),
                        ),
                      ),
                      validator: _validateConfirm,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      // ignore: deprecated_member_use
                      value: _role,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Select your role'),
                      items: [
                        for (final r in _roles)
                          DropdownMenuItem(value: r, child: Text(r)),
                      ],
                      onChanged: (v) => setState(() => _role = v),
                      validator: (v) => v == null ? 'Please select a role' : null,
                    ),
                    const SizedBox(height: 8),

                    FormField<bool>(
                      initialValue: _acceptedTerms,
                      validator: (_) => _acceptedTerms
                          ? null
                          : 'You must accept the Terms and Conditions',
                      builder: (state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              title:
                                  const Text('I accept the Terms and Conditions'),
                              value: _acceptedTerms,
                              onChanged: (v) {
                                setState(() => _acceptedTerms = v ?? false);
                                state.didChange(v ?? false);
                              },
                            ),
                            if (state.hasError)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  state.errorText!,
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      child: const Text('Register'),
                    ),
                    const SizedBox(height: 8),

                    // Shortcut to open the app without registering.
                    TextButton(
                      onPressed: () => _openProduct('Guest'),
                      child: const Text('Skip (continue as guest)'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
