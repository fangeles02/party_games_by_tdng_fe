import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:party_games_by_tdng/pages/interface/mainmenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsernameNominationPage extends StatefulWidget {
  const UsernameNominationPage({super.key});

  @override
  State<UsernameNominationPage> createState() => _UsernameNominationPageState();
}

class _UsernameNominationPageState extends State<UsernameNominationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "What should we call you?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 25,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: "Your name",
                          ),
                          autocorrect: false,
                          validator: (value) {
                            return value == null || value.isEmpty
                                ? "This field is required"
                                : null;
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String? res = await showDialog<String>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text("Confirmation"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Is this correct?"),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              _nameController.text,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            const Text(
                                                "Note: You can also change your name later in app settings.",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, "Cancel"),
                                              child: const Text("Cancel")),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, "Yes"),
                                              child: const Text("Yes")),
                                        ],
                                      ));

                              if ((res ?? "") == "Yes") {
                                 SharedPreferences prefs = await SharedPreferences.getInstance();
                                 await prefs.setString('player_name', _nameController.text);

                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainMenu()));
                              }
                            }
                          },
                          child: const Text("Continue"),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
