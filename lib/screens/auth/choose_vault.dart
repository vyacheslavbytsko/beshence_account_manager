import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../misc.dart';
import 'modals.dart';

class ChooseVaultScreen extends StatefulWidget {
  final bool newAccount;
  final String bankId;

  const ChooseVaultScreen({super.key, required this.newAccount, required this.bankId});

  @override
  State<StatefulWidget> createState() => _ChooseVaultScreenState();

}

class _ChooseVaultScreenState extends State<ChooseVaultScreen> {
  @override
  Widget build(BuildContext context) {
    return CenteredScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.dataset_outlined, size: 48, color: TextTheme.of(context).headlineLarge?.color,),
          SizedBox(height: 24,),
          Text("Choose Vault", style: TextTheme.of(context).headlineLarge,),
          SizedBox(height: 24,),
          RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(text: "Vault is where your Account data is stored. "),
                    TextSpan(text: "More info",
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => WhatIsBeshenceModal()
                          );
                        }
                    ),
                    // TODO: if(widget.newAccount) TextSpan(text: "\n\nWant to set up your own Bank? "),
                    // TODO: if(widget.newAccount) TextSpan(text: "Click here", style: TextStyle(color: Colors.blue))
                  ]
              )
          ),
          SizedBox(height: 24,),
          FutureBuilder(future: Beshence.getBank(widget.bankId)!.getVaults(), builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              List<BeshenceRemoteVault> vaults = snapshot.requireData;
              return Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: vaults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(Icons.dataset_outlined),
                            title: Text(vaults[index].name),
                            onTap: () {
                              /*Beshence.selectedAccount!.addVault(
                                bankId: widget.bankId,
                                vaultId: vaults[index].id,
                                priority: 1024
                              );
                              Navigator.pop(context);*/                            },
                          );
                        }
                    ),
                  ]
              );
            }
          }),
        ],
      ),
    );
  }
}

/*
                            List<Map<String, String>> vaults = (await Beshence.getVaultsOfBank(
                                                              address: _bankAddressController.text,
                                                              accessToken: loginBankResponse.accessToken
                                                          )).vaults;

                                                          Navigator.pop(context);
                                                          showDialog(
                                                            useSafeArea: true,
                                                            requestFocus: true,
                                                            barrierDismissible: false,
                                                            context: context,
                                                            builder: (context) => BackdropFilter(
                                                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                                                child: AlertDialog.adaptive(
                                                                    content: Container(
                                                                      width: double.maxFinite,
                                                                      child: Column(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Text("Choose vault"),
                                                                          // TODO: add priority text field
                                                                          Expanded(
                                                                            child: ListView.builder(
                                                                                shrinkWrap: true,
                                                                                itemCount: vaults.length,
                                                                                itemBuilder: (context, index) {
                                                                                  return ListTile(
                                                                                    title: Text(vaults[index]['name']!),
                                                                                    onTap: () {
                                                                                      Beshence.selectedAccount!.addVault(
                                                                                        address: _bankAddressController.text,
                                                                                        vaultId: vaults[index]['id']!,
                                                                                        bankId: pingBankResponse.bankId,
                                                                                        priority: 1024,
                                                                                        refreshToken: loginBankResponse.refreshToken,
                                                                                        accessToken: loginBankResponse.accessToken,
                                                                                      );
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                  );
                                                                                }
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                )
                                                            ),
                                                          );
                             */