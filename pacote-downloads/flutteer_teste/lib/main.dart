import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cielo/flutter_cielo.dart';
import 'package:http/http.dart'as http;
import 'dart:async';

const request = "https://api.cieloecommerce.cielo.com.br/";
void main (){
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

 final nameController = TextEditingController();
final numeroCartaoController = TextEditingController();
final dataController = TextEditingController();
final CVVController = TextEditingController();

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

//inicia objeto da api
  final CieloEcommerce cielo = CieloEcommerce(
      environment: Environment.PRODUCTION, // ambiente de desenvolvimento
      merchant: Merchant(
        merchantId: "57be18b4-e44c-4a5d-9688-e360ccc9d27a",
        merchantKey: "mebOy0Q6U4OxVghgDoXCbfP1xcNVTH6q1uDmGikP",
      ));


//Objeto de venda
  Sale sale = Sale(
      merchantOrderId: "24345", // id único de sua venda
      customer: Customer( //objeto de dados do usuário
          name: "BRUNO CESAR PINTO"
      ),
      payment: Payment(    // objeto para de pagamento
          type: TypePayment.creditCard, //tipo de pagamento
          amount: 300, // valor da compra em centavos
          installments: 1, // número de parcelas
          softDescriptor: "Cielo", //descrição que aparecerá no extrato do usuário. Apenas 15 caracteres
          creditCard: CreditCard( //objeto de Cartão de crédito
            cardNumber: numeroCartaoController.text, //número do cartão
            holder: nameController.text, //nome do usuário impresso no cartão
            expirationDate: dataController.text, // data de expiração
            securityCode: CVVController.text, // código de segurança
            brand: "Master", // bandeira
          )
      )
  );

  CreditCard cart = CreditCard(
    customerName: "BRUNO CESAR PINTO",
    cardNumber: numeroCartaoController.text,
    holder: nameController.text,
    expirationDate: dataController.text,
    brand: "Master",
  );




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teste Api"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Form(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: "Nº Cartão",
              ),
            keyboardType: TextInputType.number,
              controller: numeroCartaoController,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Nome"
              ),
            controller: nameController,
            ),
            SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "expiração data MM/AAAA"
                  ),
                    keyboardType: TextInputType.datetime,
                  controller: dataController,
                ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                  hintText: "CVV"
              ),
                keyboardType: TextInputType.number,
              controller: CVVController,
            ),
            SizedBox(height: 25.0,),
            SizedBox(height: 44.0,
            child: RaisedButton(
              child: Text("Comprar",
              style: TextStyle(fontSize: 18.0),
              ),
              color: Colors.blue,
              onPressed: () async {

                try{
                  var response = await cielo.createSale(sale);
                  print("numero paymentID" + response.payment.paymentId);
                  http.Response response2 = await http.post(request);
                  json.decode(response2.body);
                  print(response2);

                }
                on CieloException catch(e){
                  print(e.message);
                  print(e.errors[0].message);
                  print(e.errors[0].code);
                }

              },
            ),
            ),
            SizedBox(height: 25.0,),
            SizedBox(height: 44.0,
              child: RaisedButton(
                child: Text("Toquenizando o cartao",
                  style: TextStyle(fontSize: 18.0),
                ),
                color: Colors.blue,
                onPressed: () async {
                  print("numero cartao: ${numeroCartaoController.text}");
                    print("TAMANHO DO CAMPO: ${numeroCartaoController.text.length}");
                  try {
                    var response = await cielo.tokenizeCard(cart);
                    print(response.cardToken);
                  } on CieloException catch(e){
                    print(e.message);
                    print(e.errors[0].message);
                    print(e.errors[0].code);
                  }



                },
              ),
            ),


          ],
        ),
      ),
    );
  }


}


