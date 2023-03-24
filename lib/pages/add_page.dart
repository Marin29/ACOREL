import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  final ligneNameController = TextEditingController();
  int? selectedType;
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {

    super.dispose();

    ligneNameController.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nom ligne',
                        hintText: 'rentre message',
                      border: OutlineInputBorder(),
                  ),
                validator: (value){
                    if(value==null || value.isEmpty){
                      return "tu dois compléter le texte";
                    }
                    return null;
                },
                controller: ligneNameController,
              ),
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: DropdownButtonFormField(
                  items: const [
                    DropdownMenuItem(value: 1, child: Text("ligne 01")),
                    DropdownMenuItem(value: 2, child: Text("ligne 02")),
                    DropdownMenuItem(value: 3, child: Text("ligne 03")),
                    DropdownMenuItem(value: 4, child: Text("ligne 04")),
                    DropdownMenuItem(value: 5, child: Text("ligne 05")),
                    DropdownMenuItem(value: 6, child: Text("ligne 06"))
                  ],
                  decoration: const InputDecoration(
                      hintText: 'choisir une ligne',
                    border: OutlineInputBorder()

                  ),
                  value: selectedType,
                  onChanged: (value){
                    setState(() {
                      selectedType=value!;
                    });
                  }
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: DateTimeFormField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black45),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                  labelText: 'Choisir une date',
                ),
                mode: DateTimeFieldPickerMode.dateAndTime,
                autovalidateMode: AutovalidateMode.always,
                validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                onDateSelected: (DateTime value) {
                  setState(() {
                    selectedDate=value;
                  });
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      final ligneName = ligneNameController.text;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Envoi en cours..."))
                      );
                      FocusScope.of(context).requestFocus(FocusNode());//permet de fermer le clavier quand on clique sur envoyer
                      print("Ajout de la ligne $ligneName de type $selectedType à $selectedDate");

                    }
                  },
                  child: const Text("Envoyer")
              ),
            )

          ],
        )
      ),
    );
  }
}

