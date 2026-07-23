import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../misc.dart';

class LoginToBankScreen extends StatefulWidget {
  final bool newAccount;
  final String bankId;

  const LoginToBankScreen({super.key, required this.newAccount, required this.bankId});

  @override
  State<StatefulWidget> createState() => _LoginToBankScreenState();
}

class _LoginToBankScreenState extends State<LoginToBankScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CenteredScaffold(
      body: Column(
        crossAxisAlignment: .start,
        children: [
          Icon(Icons.dns_outlined, size: 48, color: TextTheme.of(context).headlineLarge?.color,),
          SizedBox(height: 24,),
          Text("Login to Bank", style: TextTheme.of(context).headlineLarge,),
          SizedBox(height: 24,),
          FutureBuilder(future: Beshence.pingBank(bankId: widget.bankId), builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              List<String> loginMethods = snapshot.requireData.loginMethods;
              return Column(
                children: [
                  if(loginMethods.contains("usernameAndPassword")) ...[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      controller: _usernameController,
                      enabled: _enabled,
                    ),
                    SizedBox(height: 16,),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      enabled: _enabled,
                    ),
                    SizedBox(height: 24,),
                    OverflowBar(
                      alignment: widget.newAccount ? .spaceBetween : .end,
                      overflowAlignment: .end,
                      spacing: 16,
                      overflowSpacing: 0,
                      overflowDirection: .up,
                      children: [
                        if(widget.newAccount) TextButton(
                          onPressed: !_enabled ? null : () => context.push("/register/register_in_bank"),
                          child: const Text('Register instead'),
                        ),
                        FilledButton(
                          onPressed: !_enabled ? null : () async {
                            setState(() {
                              _enabled = false;
                            });

                            await Beshence.loginToBank(
                                bankId: widget.bankId,
                                username: _usernameController.text,
                                password: _passwordController.text);

                            context.go("${widget.newAccount ? "/register" : "/login"}/choose_vault?bank_id=${widget.bankId}");

                            setState(() {
                              _enabled = true;
                            });
                          },
                          child: const Text('Log in'),
                        ),
                      ],
                    )
                  ]
                ]
              );
            }
          }),
        ],
      ),
    );
  }
}