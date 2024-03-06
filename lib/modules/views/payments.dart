import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cocofapp/shared/components/components.dart';
import 'package:flutter/widgets.dart';
import 'package:cocofapp/shared/globals.dart' as globals;

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  final TextEditingController _textFieldController = TextEditingController();
  var pay = TextEditingController();
  var reason = TextEditingController();
  var dropdownValue;
  final ref = FirebaseDatabase.instance.ref();
  var formKey = GlobalKey<FormState>();
    bool showSpinner = false;
  late String errorMessage;
  late DateTime now;
  List<String> supList = [];
  List<String> ops = [" ", "ADMN","EDITR"];
  List<String> pType = [" ", "Add Cash", "Other"];
  List<String> pType2 = ["Add Cash", "Other"];
    

  var dropdVal, dropdV;
  String hintVal = 'Pay Type', hintV = "By";
  @override
  void initState() {
    super.initState();
    setState(() {
      loadData();
    });
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
                'Other Payments',
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
                  Container(
                    height: 50,
                    width: 120,
                    padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
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
                            hintVal = "Pay Type";
                            dropdVal = null;
                          }
                          else{
                            hintVal = newValue!;
                            dropdVal = newValue!;
                          }
                        });
                      },
                      items: pType.map<DropdownMenuItem<String>>((String value) {
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
                  
                ],
              ),
              StreamBuilder(
                    stream: ref.child('pays').onValue,
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
                        items = items.where((i) => (dropdVal == "Add Cash" && i['reason'] == dropdVal) || (dropdVal == "Other" && i['reason'] != "Add Cash")).toList();
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
                          DataColumn(label: Center(child: Text("Reason"))),
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
              text: 'New Payment',
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
          dropdownValue = (data["reason"].toString() == "Add Cash") ? "Add Cash" : "Other";
          pay.text = data["payment"];
          reason.text = data["reason"].toString();
          _displayTextInputDialog(context, data);
        }
      },
      cells: [
      DataCell(Text(data["date"].substring(0,11), style: const TextStyle(fontSize: 11),)),
      DataCell(Text(data["reason"].toString())),
      DataCell(Text(data["payment"])),
      DataCell(Text(data["by"] ? "ADMN" : "EDITR", style: const TextStyle(fontSize: 9),)),
    ]);
  }

  Future<void> _displayTextInputDialog(BuildContext context, final data) async {
    // String? valueText;
    int cash = 0;
    int oldP = 0;
    String oldR = "";
    
    String hintValue = 'Select';
    return showDialog(
    context: context,
    builder: (context) {
      if(data != null)
      {
        oldP = int.parse(data["payment"]);
        oldR = data["reason"].toString();
      }
      return AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data == null ? 'New Payment' : 'Edit Payment'),
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
                Text("Type - ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 3, 18, 17),
                    fontWeight: FontWeight.normal,
                  )
                ),
                SizedBox(height: 25),
                Text("Reason - ",
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
                              dropdownValue = newValue;
                              reason.text = newValue;
                            });
                          },
                          items: pType2.map<DropdownMenuItem<String>>((String value) {
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
                  /*reason*/ textFieldMini(
                    keyboardType: TextInputType.name,
                    controller: reason,
                    hinttext: 'Add cash',
                    isEnabled: true,
                    typeF: 2,
                    suffixIcon: reason.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            icon: const Icon(Icons.close, size: 15.0, color: Colors.black),
                            onPressed: () => reason.clear(),
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
              reason.clear();
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
                  if (formKey.currentState!.validate()) {
                    ref.get().then((DataSnapshot data) async {
                      cash = (data.child('account').value! as Map) ['cash'];                
                    });
                    if(dropdownValue == "Add Cash")
                    {
                      if(data == null) {
                        await ref.child("pays").update({
                          now.toString().substring(0,19) : {
                            "by": globals.isAdmin,
                            "date": now.toString(),
                            "payment": pay.text,
                            "reason": dropdownValue.toString(),
                          }
                        });
                        await ref.child("account").child("cash").set(cash + int.parse(pay.text));
                      }
                      else {
                        await ref.child("pays").update({
                          data["date"].toString().substring(0,19) : {
                            "by": globals.isAdmin,
                            "date": data["date"].toString(),
                            "payment": pay.text,
                            "reason": dropdownValue.toString(),
                          }
                        });
                        if(oldR != "Add Cash" && data["by"] == "EDITR"){
                          await ref.child("account").child("cash").set(cash + oldP + int.parse(pay.text));
                        }
                        else if(oldR != "Add Cash" && data["by"] == "ADMN"){
                          await ref.child("account").child("cash").set(cash + int.parse(pay.text));
                        }
                        else if(oldR == "Add Cash" && data["by"] == "ADMN"){
                          await ref.child("account").child("cash").set(cash - oldP + int.parse(pay.text));
                        }
                        else {
                          await ref.child("account").child("cash").set(cash - oldP + int.parse(pay.text));
                        }
                      }
                    }
                    else
                    {
                      if (data == null) {
                        await ref.child("pays").update({
                          now.toString().substring(0,19) : {
                            "by": globals.isAdmin,
                            "date": now.toString(),
                            "payment": pay.text,
                            "reason": reason.text,
                          }
                        });
                        if(!globals.isAdmin)
                        {
                            await ref.child("account").child("cash").set(cash - int.parse(pay.text));
                        }
                      }
                      else {
                        await ref.child("pays").update({
                          data["date"].toString().substring(0,19) : {
                            "by": globals.isAdmin,
                            "date": data["date"].toString(),
                            "payment": pay.text,
                            "reason": reason.text,
                          }
                        });
                        if(oldR != "Add Cash" && data["by"] == "EDITR"){
                          await ref.child("account").child("cash").set(cash + oldP - int.parse(pay.text));
                        }
                        else if(oldR != "Add Cash" && data["by"] == "ADMN"){
                          await ref.child("account").child("cash").set(cash + int.parse(pay.text));
                        }
                        else if(oldR == "Add Cash" && data["by"] == "ADMN"){
                          await ref.child("account").child("cash").set(cash - oldP - int.parse(pay.text));
                        }
                        else {
                          await ref.child("account").child("cash").set(cash - oldP - int.parse(pay.text));
                        }
                      }
                    }
                    Navigator.pop(context);
                    pay.clear();
                    reason.clear();
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
