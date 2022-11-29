import 'package:flutter/material.dart';
import 'package:inventory/controllers/category_controller.dart';

Future customSimpleDialog(
    {required BuildContext context, required Widget content}) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
              child: content,
            )
          ],
        );
      }).then((value) => value);
}

Future createInventoryDialog(
    {required BuildContext context, required String barcode}) async {
  final _formFieldKey = GlobalKey<FormState>();

  TextEditingController label = TextEditingController(text: "");
  TextEditingController description = TextEditingController(text: "");

  return await customSimpleDialog(
      context: context,
      content: Form(
        key: _formFieldKey,
        child: Column(
          children: [
            Text(barcode),
            Text("Label"),
            TextFormField(
              controller: label,
              validator: (value) => value!.isEmpty ? "Label is require" : null,
            ),
            Text("Description"),
            TextFormField(
              controller: description,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (_formFieldKey.currentState!.validate()) {
                      await createCategory(
                          barcode: barcode,
                          label: label.text,
                          context: context,
                          description: description.text);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Create"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
              ],
            )
          ],
        ),
      ));
}
