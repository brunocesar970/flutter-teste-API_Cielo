import 'package:flutter/material.dart';
import 'package:cielo_ecommerce/cielo_ecommerce.dart';
import 'package:fluttertoast/fluttertoast.dart';

const baseURL = "https://api.cieloecommerce.cielo.com.br/";

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

final nameController = TextEditingController();
final numeroCartaoController = TextEditingController();
final dataController = TextEditingController();
final cvvController = TextEditingController();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CieloEcommerce cielo = CieloEcommerce(
      environment: Environment.production,
      merchant: Merchant(
        merchantId: "57be18b4-e44c-4a5d-9688-e360ccc9d27a",
        merchantKey: "mebOy0Q6U4OxVghgDoXCbfP1xcNVTH6q1uDmGikP",
      ));

  bool loading = false;

  _makePayment() async {
    print("Transação Simples");
    print("Iniciando pagamento....");
    //Objeto de venda
    Sale sale = Sale(
      merchantOrderId: "2020032601", // Numero de identificação do Pedido
      customer: Customer(
        name: "Comprador crédito simples", // Nome do Comprador
      ),
      payment: Payment(
        type: TypePayment.creditCard, // Tipo do Meio de Pagamento
        amount: 9, // Valor do Pedido (ser enviado em centavos)
        installments: 1, // Número de Parcelas
        softDescriptor:
            "Mensagem", // Descrição que aparecerá no extrato do usuário. Apenas 15 caracteres
        creditCard: CreditCard(
          cardNumber: "4024007153763191", // Número do Cartão do Comprador
          holder: 'Teste accept', // Nome do Comprador impresso no cartão
          expirationDate: '08/2030', // Data de validade impresso no cartão
          securityCode:
              '123', // Código de segurança impresso no verso do cartão
          brand: 'Visa', // Bandeira do cartão
          saveCard: true,
        ),
      ),
    );

    try {
      var response = await cielo.createSale(sale);

      print('Payment accepted with paymentId: ${response.payment.paymentId}, \nTokenID: ${response.payment.tid}');
    } on CieloException catch (e) {
      print(e);
      print(e.message);
      print(e.errors[0].message);
      print(e.errors[0].code);
    }
  }

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
              decoration: InputDecoration(hintText: "Nome"),
              controller: nameController,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(hintText: "expiração data MM/AAAA"),
              keyboardType: TextInputType.datetime,
              controller: dataController,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(hintText: "CVV"),
              keyboardType: TextInputType.number,
              controller: cvvController,
            ),
            SizedBox(
              height: 25.0,
            ),
            SizedBox(
              height: 44.0,
              child: RaisedButton(
                child: loading ? CircularProgressIndicator(backgroundColor: Colors.white,) : Text(
                  "Comprar",
                  style: TextStyle(fontSize: 18.0),
                ),
                color: Colors.blue,
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  await _makePayment();
                  toast();
                   setState(() {
                    loading = false;
                  });
                },
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            SizedBox(
              height: 44.0,
              child: RaisedButton(
                child: Text(
                  "Toquenizando o cartao",
                  style: TextStyle(fontSize: 18.0),
                ),
                color: Colors.blue,
                onPressed: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

toast() => Fluttertoast.showToast(
        msg: "Pagamento aprovado com sucesso!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
