import 'package:cocofapp/shared/components/components.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cocofapp/shared/globals.dart' as globals;

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final TextEditingController _textFieldController = TextEditingController();
  var nameC = TextEditingController();
  var pwC = TextEditingController();
  bool showSpinner = false;
  var formKey = GlobalKey<FormState>();
  var formKeyPW = GlobalKey<FormState>();
  late String errorMessage;
  final ref = FirebaseDatabase.instance.ref();
  List<String> ops = ["Supplier", "Buyer", "Employee"];
  List<String> supList = [];
  List<String> buyList = [];
  List<String> empList = [];

  @override
  void initState() {
    super.initState();
    supList = [];
    buyList = [];
    empList = [];

    nameC.addListener(() => setState(() {}));
    pwC.addListener(() => setState(() {}));
  }


  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {return false;},
      child: Scaffold(
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
                  height: 10,
                ),
                const Text(
                  'CoCoFApp Web ',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Image.asset('assets/coir.png', scale: 1.75),
                ),
                StreamBuilder(
                    stream: ref.child("account").onValue,
                    builder: (context, snap) {
                      if (snap.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }
                      String cash = snap.data!.snapshot.child('cash').value.toString();
                      String coir = snap.data!.snapshot.child('coir').value.toString();
                    return Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white38,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(color: Colors.red)
                                ),
                              ),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  const Text("Cash in Hand - ",
                                    style: TextStyle(
                                      fontSize: 21,
                                      color: Color.fromARGB(255, 3, 18, 17),
                                      fontWeight: FontWeight.normal,
                                    )
                                  ),
                                  Text(
                                    "Rs $cash",
                                    style: const TextStyle(fontSize: 22,color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white38,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(color: Colors.red)
                                ),
                              ),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  const Text("Coir in Stock - ",
                                    style: TextStyle(
                                      fontSize: 21,
                                      color: Color.fromARGB(255, 3, 18, 17),
                                      fontWeight: FontWeight.normal,
                                    )
                                  ),
                                  Text(
                                    "$coir kg",
                                    style: const TextStyle(fontSize: 22,color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "coir_in_screen");
                            },
                            child: const Text("Coir Input", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "coir_out_screen");
                            },
                            child: const Text("Coir Output", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 67, vertical: 20),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "salary_screen");
                            },
                            child: const Text("Salary", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 49, vertical: 20),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "pay_screen");
                            },
                            child: const Text("Payments", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 20),
                            ),
                            onPressed: () {
                              _displayMemberInputDialog(context);
                            },
                            child: const Text("Add Member", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black45,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "login_screen");
                            },
                            child: const Text("Log Out", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: globals.isAdmin ? 20 : 1),
                // globals.isAdmin ? Center(
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.black45,
                //       elevation: 0,
                //       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                //     ),
                //     onPressed: () {
                //       _displayTextInputDialog(context);
                //     },
                //     child: const Text("Reset Data", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                //   ),
                // ) : const SizedBox(height: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loadData() async {
    DatabaseEvent event = await ref.child("suplys").once();
    var snapshot = event.snapshot;
    snapshot.children.forEach((child) {
      supList.add(child.value.toString());
    });

    DatabaseEvent event2 = await ref.child("buys").once();
    var snapshot2 = event2.snapshot;
    snapshot2.children.forEach((child) {
      buyList.add(child.value.toString());
    });

    DatabaseEvent event3 = await ref.child("emplys").once();
    var snapshot3 = event3.snapshot;
    snapshot3.children.forEach((child) {
      empList.add(child.value.toString());
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    // String? valueText;
    return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Do you realy want to Reset?'),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 9),
                Text("Password - ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 3, 18, 17),
                    fontWeight: FontWeight.normal,
                  )
                ),
              ],
            ),
            Form(
              key: formKeyPW,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /*weight*/ textFieldMini(
                    keyboardType: TextInputType.name,
                    controller: pwC,
                    hinttext: 'password',
                    typeF: 2,
                    suffixIcon: pwC.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            icon: const Icon(Icons.close, size: 15.0, color: Colors.black),
                            onPressed: () => pwC.clear(),
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
            },
          ),
          MaterialButton(
            color: Colors.green,
            textColor: Colors.white,
            child: const Text('Sure'),
            onPressed: () async {
              if (formKeyPW.currentState!.validate()) {
                setState(() {
                  showSpinner = true;
                });
                try {
                  if (pwC.text == "qwer1234") {
                    await ref.child("account").child("cash").set(0);
                    await ref.child("account").child("coir").set(0);
                    await ref.child("coir_in").set(null);
                    await ref.child("coir_out").set(null);
                    await ref.child("salary").set(null);
                    await ref.child("pays").set(null);
                    await ref.child("suplys").set(null);
                    await ref.child("buys").set(null);
                    await ref.child("emplys").set(null);

                    Navigator.pop(context);

                  }
                  else{
                    throw("Incorrect Password");
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
            },
          ),
        ],
      );
    });
  }

  Future<void> _displayMemberInputDialog(BuildContext context) async {
    // String? valueText;
    int cash = 0;
    int coir = 0;

    var dropdownValue;
    String hintValue = 'Select';
    return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Add New Member'),
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
                Text("Member Type - ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 3, 18, 17),
                    fontWeight: FontWeight.normal,
                  )
                ),
                SizedBox(height: 25,),
                Text("Name - ",
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
                          items: ops.map<DropdownMenuItem<String>>((String value) {
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
                    keyboardType: TextInputType.name,
                    controller: nameC,
                    hinttext: 'C Nimal',
                    typeF: 2,
                    suffixIcon: nameC.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            icon: const Icon(Icons.close, size: 15.0, color: Colors.black),
                            onPressed: () => nameC.clear(),
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
              nameC.clear();
            },
          ),
          MaterialButton(
            color: Colors.green,
            textColor: Colors.white,
            child: const Text('Submit'),
            onPressed: () async {
              await loadData();
              if (formKey.currentState!.validate()) {
                setState(() {
                  showSpinner = true;
                });
                try {
                  if (formKey.currentState!.validate()) {
                    if(dropdownValue == "Employee" && empList.contains(dropdownValue))
                    {
                      throw("Name already In the list");
                    }
                    else if(dropdownValue == "Supplier" && supList.contains(dropdownValue))
                    {
                      throw("Name already In the list");
                    }
                    else if(dropdownValue == "Buyer" && buyList.contains(dropdownValue))
                    {
                      throw("Name already In the list");
                    }

                    if(dropdownValue == "Employee")
                    {
                      await ref.child("emplys").update({
                          (empList.length+1).toString(): nameC.text,
                      });
                      Navigator.pop(context);
                      nameC.clear();
                    }
                    else if(dropdownValue == "Supplier")
                    {
                      await ref.child("suplys").update({
                          (supList.length+1).toString(): nameC.text,
                      });
                      Navigator.pop(context);
                      nameC.clear();
                    }
                    else if(dropdownValue == "Buyer")
                    {
                      await ref.child("buys").update({
                          (buyList.length+1).toString(): nameC.text,
                      });
                      Navigator.pop(context);
                      nameC.clear();
                    }

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
