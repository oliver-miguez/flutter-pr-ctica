import 'package:flutter/material.dart';

import 'FileChecker.dart';
import 'LocalPDFViewer.dart';



class Contracts_Viewer extends StatefulWidget{
  const Contracts_Viewer({super.key});

  @override
  State<Contracts_Viewer> createState() => _Contracts_ViewerState();
}



class _Contracts_ViewerState extends State<Contracts_Viewer> {
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _checkFiles();
  }

  Future<void> _checkFiles() async {
    final descargados = await FileChecker.checkAndDownloadFiles();
    print("Descargados: $descargados");

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final names = ["Contrato coches", "Contrato furgonetas", "Contratos motos", "Contratos campers"];
    final contracts = ["PDF_A_FIRMAR.pdf","PDF_A_FIRMAR.pdf","PDF_A_FIRMAR.pdf","PDF_A_FIRMAR.pdf"];
    final list = buildList(4, names, contracts);
    return Scaffold(
      appBar: AppBar(
        title: Text("Visor de contratos"),
        centerTitle: true,
      ),
      body: Padding(padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...list
          ],
        ),
      ),
    );
  }

  Widget buildCard (String name, String contractName){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LocalPDFViewer(pdfFileName: contractName, isSigned: false,)));
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildList (int numberCards, List<String> names, List<String> contracts){
    List<Widget> list = [];
    for(int i = 0; i < numberCards; i++){
      list.add(buildCard(names[i],contracts[i]));
    }
    return list;
  }
}