const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/login_screen.dart', 'utf-8');

// 1. Add _rememberMe and initState
const stateVarsRegex = /bool _isPasswordVisible = false;/;
const stateVarsNew = `bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');
    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
        _rememberMe = true;
      });
    }
  }`;
text = text.replace(stateVarsRegex, stateVarsNew);

// 2. Add to _submit
const submitRegex = /if \(_isLogin\) \{[\s\S]*?await authRepo\.loginWithEmail\([\s\S]*?\);/;
const submitNew = `if (_isLogin) {
        await authRepo.loginWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          await prefs.setString('saved_email', _emailController.text.trim());
          await prefs.setString('saved_password', _passwordController.text.trim());
        } else {
          await prefs.remove('saved_email');
          await prefs.remove('saved_password');
        }`;
text = text.replace(submitRegex, submitNew);

// 3. Add UI checkbox
const passwordFieldRegex = /obscureText: !_isPasswordVisible,\s*\),\s*const SizedBox\(height: 24\),/;
const passwordFieldNew = `obscureText: !_isPasswordVisible,
                ),
                if (_isLogin)
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text('Remember Password'),
                    ],
                  ),
                const SizedBox(height: 16),`;
text = text.replace(passwordFieldRegex, passwordFieldNew);

fs.writeFileSync('lib/features/auth/screens/login_screen.dart', text, 'utf-8');
console.log('Added Remember Password feature');
