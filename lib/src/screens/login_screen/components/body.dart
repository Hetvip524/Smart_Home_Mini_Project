import 'package:domus/config/size_config.dart';
import 'package:domus/provider/getit.dart';
import 'package:domus/view/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
	const Body({Key? key}) : super(key: key);

	@override
	State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
	final _formKey = GlobalKey<FormState>();
	final _emailController = TextEditingController();
	final _passwordController = TextEditingController();
	final _authViewModel = getIt<AuthViewModel>();
	bool _isRegistering = false;
	bool _isPasswordVisible = false;

	@override
	void dispose() {
		_emailController.dispose();
		_passwordController.dispose();
		super.dispose();
	}

	Future<void> _handleSubmit() async {
		if (_formKey.currentState!.validate()) {
			final success = await (_isRegistering
					? _authViewModel.registerWithEmailAndPassword(
							_emailController.text.trim(),
							_passwordController.text,
					)
					: _authViewModel.signInWithEmailAndPassword(
							_emailController.text.trim(),
							_passwordController.text,
					));
			
			if (!success && mounted) {
				ScaffoldMessenger.of(context).showSnackBar(
					SnackBar(
						content: Text(_authViewModel.errorMessage ?? 'Authentication failed'),
						backgroundColor: Colors.red,
					),
				);
			}
		}
	}

	Future<void> _handleGoogleSignIn() async {
		final success = await _authViewModel.signInWithGoogle();
		if (!success && mounted) {
			ScaffoldMessenger.of(context).showSnackBar(
				SnackBar(
					content: Text(_authViewModel.errorMessage ?? 'Google Sign-In failed'),
					backgroundColor: Colors.red,
				),
			);
		}
	}

	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider.value(
			value: _authViewModel,
			child: Consumer<AuthViewModel>(
				builder: (context, authViewModel, _) {
					return SingleChildScrollView(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Stack(
									children: [
										Image.asset('assets/images/login.png',
												height: getProportionateScreenHeight(300),
												width: double.infinity,
												fit: BoxFit.fill,),

										Positioned(
												bottom: getProportionateScreenHeight(20),
												left: getProportionateScreenWidth(20),
												child: Column(

														crossAxisAlignment: CrossAxisAlignment.start,

														children: [
																Text('SMART',style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.black, fontSize: 33),),
																Text('HOME', style:  Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.black, fontSize: 64),)
														],
										)),
									],
								),
								Padding(
										padding: const EdgeInsets.all(20.0),
										child: Text(
												_isRegistering
														? 'Create an account\nto manage your devices'
														: 'Sign in to\nmanage your devices',
												style: const TextStyle(fontSize: 18),
										),
								),

								Form(
										key: _formKey,
										child: Column(
												children: [
														Padding(
																padding: const EdgeInsets.symmetric(horizontal: 20.0),
																child: TextFormField(
																		controller: _emailController,
																		keyboardType: TextInputType.emailAddress,
																		autovalidateMode: AutovalidateMode.onUserInteraction,
																		decoration: InputDecoration(
																				contentPadding: const EdgeInsets.only(left: 40.0, right: 20.0),
																				border: OutlineInputBorder(borderRadius: BorderRadius.circular(70.0),),
																				hintText: 'Email',
																				errorMaxLines: 2,
																				suffixIcon: const Icon(Icons.email, color: Colors.black,)
																		),
																		validator: (value) {
																				if (value == null || value.isEmpty) {
																						return 'Email is required';
																				}
																				final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
																				if (!emailRegex.hasMatch(value)) {
																						return 'Please enter a valid email address\n(e.g., example@domain.com)';
																				}
																				return null;
																		},
																),
														),

														SizedBox(height: getProportionateScreenHeight(20)),
														Padding(
																padding: const EdgeInsets.symmetric(horizontal: 20.0),
																child: TextFormField(
																		controller: _passwordController,
																		obscureText: !_isPasswordVisible,
																		autovalidateMode: AutovalidateMode.onUserInteraction,
																		decoration: InputDecoration(
																				contentPadding: const EdgeInsets.only(left: 40.0, right: 20.0),
																				border: OutlineInputBorder(borderRadius: BorderRadius.circular(70.0),),
																				hintText: 'Password',
																				errorMaxLines: 3,
																				helperText: _isRegistering ? 'Password must be at least 6 characters long' : null,
																				helperMaxLines: 2,
																				suffixIcon: IconButton(
																						icon: Icon(
																								_isPasswordVisible
																										? Icons.visibility
																										: Icons.visibility_off,
																						color: Colors.black,
																						),
																						onPressed: () {
																								setState(() {
																										_isPasswordVisible = !_isPasswordVisible;
																								});
																						},
																				),
																		),
																		validator: (value) {
																				if (value == null || value.isEmpty) {
																						return 'Password is required';
																				}
																				if (_isRegistering) {
																						if (value.length < 6) {
																								return 'Password must be at least 6 characters long';
																						}
																						if (!value.contains(RegExp(r'[A-Z]'))) {
																								return 'Password must contain at least one uppercase letter';
																						}
																						if (!value.contains(RegExp(r'[0-9]'))) {
																								return 'Password must contain at least one number';
																						}
																				}
																				return null;
																		},
																),
														),
												],
										),
								),
								if (authViewModel.errorMessage != null)
										Padding(
												padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
												child: Text(
														authViewModel.errorMessage!,
														style: const TextStyle(color: Colors.red),
												),
										),
								SizedBox(height: getProportionateScreenHeight(20)),
								Padding(
										padding: const EdgeInsets.symmetric(horizontal: 20.0),
										child: Column(
												children: [
														ElevatedButton(
																onPressed: authViewModel.isLoading ? null : _handleSubmit,
																style: ElevatedButton.styleFrom(
																		backgroundColor: const Color(0xFF464646),
																		shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70.0),),
																		minimumSize: const Size(double.infinity, 50),
																),
																child: authViewModel.isLoading
																		? const CircularProgressIndicator(color: Colors.white)
																		: Text(
																		_isRegistering ? 'Register' : 'Sign In',
																		style: const TextStyle(color: Colors.white),
																),
														),
														SizedBox(height: getProportionateScreenHeight(10)),
														TextButton(
																onPressed: authViewModel.isLoading
																		? null
																		: () => setState(() => _isRegistering = !_isRegistering),
																child: Text(
																		_isRegistering
																				? 'Already have an account? Sign In'
																				: 'Don\'t have an account? Register',
																),
														),
														SizedBox(height: getProportionateScreenHeight(20)),
														ElevatedButton.icon(
																onPressed: authViewModel.isLoading ? null : _handleGoogleSignIn,
																style: ElevatedButton.styleFrom(
																		backgroundColor: Colors.white,
																		foregroundColor: Colors.black,
																		shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70.0),),
																		minimumSize: const Size(double.infinity, 50),
																),
																icon: const Icon(FontAwesomeIcons.google),
																label: const Text('Sign in with Google'),
														),
												],
										),
								),
							],
						),
					);
				},
			),
		);
	}
}
