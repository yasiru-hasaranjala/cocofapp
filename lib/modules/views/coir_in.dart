// ignore_for_file: avoid_init_to_null

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cocofapp/shared/components/components.dart';
import 'package:flutter/widgets.dart';
import 'package:cocofapp/shared/globals.dart' as globals;

class CoirInputs extends StatefulWidget {
  const CoirInputs({super.key});

  @override
  State<CoirInputs> createState() => _CoirInputsState();
}

class _CoirInputsState extends State<CoirInputs> {
  final TextEditingController _textFieldController = TextEditingController();
  var pay = TextEditingController();
  var weight = TextEditingController();
  var dropdownValue;
  final ref = FirebaseDatabase.instance.ref();
  var formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  late String errorMessage;
  late DateTime now;
  List<String> supList = [];
  List<String> ops = [" ", "ADMN","EDITR"];

  int cash = 0;
  int coir = 0;    
    

  var dropdVal, dropdV;
  String hintVal = 'Supplier', hintV = "By";
  @override
  void initState() {
    super.initState();
    setState(() {
      loadData();
    });

    pay.addListener(() => setState(() {}));
    weight.addListener(() => setState(() {}));
  }
  void loadData() async {
    DatabaseEvent event = await ref.child("suplys").once();
    var snapshot = event.snapshot;
    snapshot.children.forEach((child) {
      supList.add(child.value.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                height: 60,
              ),
              const Text(
                'Coir Inputs',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 50,
                    width: 90,
                    padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
                    child: DropdownButton<String>(
                      value: dropdV,
                      padding: EdgeInsets.all(0),
                      style: TextStyle(fontSize: 12),
                      
                      hint: Text(
                        hintV,
                        style: TextStyle(fontSize: 12),
                      ),
                      
                      onChanged: (String? newValue) {
                        setState(() {
                          if(newValue == " "){
                            hintV = "By";
                            dropdV = null;
                          }
                          else{
                            hintV = newValue!;
                            dropdV = newValue!;
                          }
                        });
                      },
                      items: ops.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 14,color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  StreamBuilder(
                    stream: ref.child("suplys").onValue,
                    builder: (context, snap) {
                      if (snap.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }
                      if (snap.data!.snapshot.value == null) {
                        return const Text(" ");
                      }
                      final data = snap.data!.snapshot.value as List<dynamic>;                
                      List<String> items = [];
                      items.add(" ");
                      data.forEach((data) => items.add(data.toString()));
                      items.removeWhere((item) => item == 'null');
                      // List<String> names=[];

                      // List<String> cityNameList = items.map((city) => city.name).toList()

                      return Container(
                            height: 50,
                            width: 120,
                            padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                            child: DropdownButton<String>(
                              value: dropdVal,
                              padding: EdgeInsets.all(0),
                              style: TextStyle(fontSize: 12),
                              
                              hint: Text(
                                hintVal,
                                style: TextStyle(fontSize: 12),
                              ),
                              
                              onChanged: (String? newValue) {
                                setState(() {
                                  if(newValue == " "){
                                    hintVal = "Supplier";
                                    dropdVal = null;
                                  }
                                  else{
                                    hintVal = newValue!;
                                    dropdVal = newValue!;
                                  }
                                });
                              },
                              items: items.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  
                                  child: Text(
                                    value,
                                    style: const TextStyle(fontSize: 14,color: Colors.black),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                    }
                  ),

                ],
              ),
              StreamBuilder(
                    stream: ref.child('coir_in').onValue,
                    builder: (context, snap) {
                      if (snap.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }
                      if (snap.data!.snapshot.value == null) {
                        return const Text("No Data to Show");
                      }
                      final data = snap.data!.snapshot.value as Map<dynamic, dynamic>;
                      List items = [];
                      data.forEach((index, data) => items.add({"key": index, ...data}));
                      items.sort((a, b) => b['date'].compareTo(a['date']));

                      if(dropdVal != null)
                      {
                        items = items.where((i) => i['suply'] == dropdVal).toList();
                      }
                      if(dropdV != null)
                      {
                        items = items.where((i) => (i['by'] && dropdV == "ADMN") || (!i['by'] && dropdV == "EDITR")).toList();
                      }

                    return DataTable(
                      horizontalMargin: 0,
                      columnSpacing: 10,
                      columns: const[
                          DataColumn(label: Center(child: Text("   Date")),),
                          DataColumn(label: Center(child: Text(" Supplier"))),
                          DataColumn(label: Center(child: Text("Weight"))),
                          DataColumn(label: Center(child: Text("Payment"))),
                          DataColumn(label: Center(child: Text(" By"))),
                      ],
                      rows: _buildList(context, items),
                    );
                  }
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            halfButton(
              text: 'Add Coir',
              width: size.width/2-30,
              function: () {
                now = DateTime.now();
                _displayTextInputDialog(context, null);
              },
              fontWeight: FontWeight.bold,
            ),
            halfButton(
              text: 'Go Back',
              width: size.width/2-30,
              function: () {
                Navigator.pushNamed(context, 'menu_screen');
              },
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }


  List<DataRow> _buildList(BuildContext context, List items){
    return items.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, final data){
    return DataRow(
      onLongPress: (){
        now = DateTime.now();
        if(globals.isAdmin || ( !globals.isAdmin && now.toString().substring(0,11) == data["data"].toString().substring(0,11)))
        {
          dropdownValue = data["suply"];
          pay.text = data["payment"].toString();
          weight.text = data["weight"].toString();
          _displayTextInputDialog(context, data);
        }
      },
      cells: [
      DataCell(Text(data["date"].substring(0,11), style: const TextStyle(fontSize: 11),)),
      DataCell(Text(" ${data["suply"]}")),
      DataCell(Text(data["weight"].toString())),
      DataCell(Text(data["payment"].toString())),
      DataCell(Text(data["by"] ? "ADMN" : "EDITR", style: const TextStyle(fontSize: 9),)),
    ]);
  }

  Future<void> _displayTextInputDialog(BuildContext context, final data) async {
    String? valueText;
    int cash = 0,coir = 0;
    int oldP = 0,oldW = 0;
    String hintValue = 'Select';
    return showDialog(
    context: context,
    builder: (context) {
      if(data != null)
      {
        oldW = int.parse(data["weight"]);
        oldP = int.parse(data["payment"]);
      }
      return AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data == null ? 'Coir Input' : 'Coir Input Edit'),
          ],
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 14),
                Text("Supplier - ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 3, 18, 17),
                    fontWeight: FontWeight.normal,
                  )
                ),
                SizedBox(height: 25),
                Text("Weight(kg) - ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 3, 18, 17),
                    fontWeight: FontWeight.normal,
                  )
                ),
                SizedBox(height: 25,),
                Text("Payment(Rs) - ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 3, 18, 17),
                    fontWeight: FontWeight.normal,
                  )
                ),
        
              ],
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 150,
                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                    child: StatefulBuilder(
                      builder: (context,  setState) {
                        return DropdownButtonFormField<String>(
                          value: dropdownValue,
                          padding: EdgeInsets.all(0),
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            focusColor: Colors.black45,
                            fillColor: Colors.black12,
                            filled: true,
                            hintStyle: const TextStyle(fontSize: 15,color: Colors.black26),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.red),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.red),
                            ),
                            errorStyle: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400),
                            contentPadding: const EdgeInsets.fromLTRB(
                                8.0, 5, 5, 6.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(width: 1,color: Colors.white12),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          hint: Text(
                            hintValue,
                            style: TextStyle(fontSize: 14),
                          ),
                          
                          validator: (value) => value == null ? 'Field is required' : null,
                          onChanged: (String? newValue) {
                            setState(() {
                              hintValue = newValue!;
                              dropdownValue = newValue!;
                            });
                          },
                          items: supList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              
                              child: Text(
                                value,
                                style: const TextStyle(fontSize: 14,color: Colors.black),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    ),
                  ),
                  /*weight*/ textFieldMini(
                    keyboardType: TextInputType.number,
                    controller: weight,
                    hinttext: '1000',
                    typeF: 1,
                    suffixIcon: weight.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            icon: const Icon(Icons.close, size: 15.0, color: Colors.black),
                            onPressed: () => weight.clear(),
                          ),
                  ),
                  SizedBox(height: 8),
                  /*pay*/ textFieldMini(
                    keyboardType: TextInputType.number,
                    controller: pay,
                    hinttext: '25000',
                    suffixIcon: pay.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.close, size: 15.0, color: Colors.black, ),
                            onPressed: () => pay.clear(),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          MaterialButton(
            color: Colors.red,
            textColor: Colors.white,
            child: const Text('Cancel'),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
              pay.clear();
              weight.clear();
            },
          ),
          MaterialButton(
            color: Colors.green,
            textColor: Colors.white,
            child: const Text('Submit'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                setState(() {
                  showSpinner = true;
                });
                try {
                  if (formKey.currentState!.validate() && (pay.text != "0" && weight.text != "0" )) {
                    ref.get().then((DataSnapshot data) async {
                      cash = (data.child('account').value! as Map) ['cash'];
                      coir = (data.child('account').value! as Map) ['coir'];
                    });
                    if(data == null) {
                      await ref.child("coir_in").update({
                        now.toString().substring(0,19) : {
                          "by": globals.isAdmin,
                          "date": now.toString(),
                          "payment": pay.text,
                          "suply": dropdownValue.toString(),
                          "weight": weight.text,
                        }
                      });
                    }
                    else {
                      await ref.child("coir_in").update({
                        data["date"].toString().substring(0,19) : {
                          "by": globals.isAdmin,
                          "date": data["date"].toString(),
                          "payment": pay.text,
                          "suply": dropdownValue.toString(),
                          "weight": weight.text,
                        }
                      });
                    }
                    if(!globals.isAdmin){
                      await ref.child("account").child("cash").set(cash + oldP - int.parse(pay.text));
                    }
                    await ref.child("account").child("coir").set(coir - oldW + int.parse(weight.text));
                    Navigator.pop(context);
                    pay.clear();
                    weight.clear();
                  }
                } catch (e) {
                  setState(() {
                    errorMessage = e.toString();
                  });
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                setState(() {
                  showSpinner = false;
                });
              }
              // final uid = loggedinUser.uid.toString();
              // await ref.child("Users/$uid/Review").set("$valueText");
              // setState(() {
              //   Navigator.pop(context);
              // });
            },
          ),
        ],
      );
    });
  }

}
