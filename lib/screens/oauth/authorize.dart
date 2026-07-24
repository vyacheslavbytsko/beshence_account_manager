import 'package:account_manager/misc.dart';
import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class OauthAuthorizeScreen extends StatefulWidget {
  final Map<String, String> queryParameters;

  const OauthAuthorizeScreen({super.key, required this.queryParameters});

  @override
  State<StatefulWidget> createState() => _OauthAuthorizeScreenState();

}

class _OauthAuthorizeScreenState extends State<OauthAuthorizeScreen> {
  @override
  Widget build(BuildContext context) {
    return CenteredScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.account_circle_outlined, size: 48, color: TextTheme.of(context).headlineLarge?.color,),
          SizedBox(height: 24,),
          Text("Connect new app", style: TextTheme.of(context).headlineLarge,),
          SizedBox(height: 24,),
          SizedBox(height: 24,),
          OverflowBar(
            alignment: .end,
            overflowAlignment: .end,
            spacing: 16,
            overflowSpacing: 0,
            overflowDirection: .up,
            children: [
              FilledButton(
                onPressed: () {
                  String tokenId = Uuid().v4();
                  Beshence.selectedAccount!.issueToken(
                    tokenId: tokenId,
                    scope: widget.queryParameters["scope"]!);
                },
                child: const Text('Continue'),
              ),
            ],
          )
        ],
      ),
    );
  }
}