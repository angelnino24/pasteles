import 'package:flutter/material.dart';

void main() {
  runApp(CakeOrderApp());
}

class CakeOrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CakesXpress',
      theme: ThemeData(
        primarySwatch:  Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CakeOrderPage(),
    );
  }
}

class CakeOrderPage extends StatefulWidget {
  @override
  _CakeOrderPageState createState() => _CakeOrderPageState();
}

class _CakeOrderPageState extends State<CakeOrderPage> {
  List<Cake> selectedCakes = [];

  void _placeOrder() {
    // Action to place the order
    if (selectedCakes.isNotEmpty) {
      print('Hacer un Pedido: ${selectedCakes.map((cake) => cake.name).join(", ")}');
      _showPaymentDialog();
    } else {
      print('Porfavor seleccione al menos un pastel.');
    }
  }

  Future<void> _showPaymentDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccione Método de Pago'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: Text('Pago en Efectivo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showConfirmationDialog('Efectivo');
                  },
                ),
                ListTile(
                  title: Text('Pago con Tarjeta'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showConfirmationDialog('Tarjeta');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showConfirmationDialog(String paymentMethod) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Orden Confirmada'),
          content: Text('Usted ha ordenado: ${selectedCakes.map((cake) => cake.name).join(", ")}\nMétodo de Pago: $paymentMethod'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orden de Pateles'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.cake), text: 'Pateles'),
              Tab(icon: Icon(Icons.shopping_cart), text: 'Carrito'),
            ],
            indicatorColor: Color.fromARGB(255, 238, 188, 250),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              color: const Color.fromARGB(255, 196, 221, 241),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Bienvenido a CakesXpress, ¿cuál es su orden?',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: CakeSelection(selectedCakes: selectedCakes, onCakeSelected: _onCakeSelected),
                  ),
                ],
              ),
            ),
            CartWidget(selectedCakes: selectedCakes, onPlaceOrder: _placeOrder),
          ],
        ),
      ),
    );
  }

  void _onCakeSelected(Cake cake, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedCakes.add(cake);
      } else {
        selectedCakes.remove(cake);
      }
    });
  }
}

class CakeSelection extends StatelessWidget {
  final List<Cake> selectedCakes;
  final Function(Cake, bool) onCakeSelected;

  CakeSelection({required this.selectedCakes, required this.onCakeSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: cakes.length,
      itemBuilder: (BuildContext context, int index) {
        return CheckboxListTile(
          title: Text(cakes[index].name),
          subtitle: Text('\$${cakes[index].price.toString()}'),
          value: selectedCakes.contains(cakes[index]),
          onChanged: (bool? value) {
            onCakeSelected(cakes[index], value ?? false);
          },
        );
      },
    );
  }
}

class CartWidget extends StatelessWidget {
  final List<Cake> selectedCakes;
  final Function() onPlaceOrder;

  CartWidget({required this.selectedCakes, required this.onPlaceOrder});

  @override
  Widget build(BuildContext context) {
    double totalPrice = selectedCakes.fold(0, (total, current) => total + current.price);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Resumen de Orden',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10.0),
        Expanded(
          child: ListView.builder(
            itemCount: selectedCakes.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(selectedCakes[index].name),
                subtitle: Text('\$${selectedCakes[index].price.toString()}'),
              );
            },
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Total: \$${totalPrice.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.end,
        ),
        SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: onPlaceOrder,
          child: Text('Realizar Pedido'),
        ),
      ],
    );
  }
}

class Cake {
  final String name;
  final double price;

  Cake({required this.name, required this.price});
}

// Sample cakes data
List<Cake> cakes = [
  Cake(
    name: 'Pastel de Chocolate',
    price: 250.00,
  ),
  Cake(
    name: 'Pastel de Fresa',
    price: 300.00,
  ),
  Cake(
    name: 'Pastel de Red Velvet',
    price: 280.00,
  ),
  Cake(
    name: 'Pastel de Vainilla',
    price: 200.00,
  ),
  Cake(
    name: 'Pay de Queso',
    price: 320.00,
  ),
  Cake(
    name: 'Pastel de Zanahoria',
    price: 260.00,
  ),
  Cake(
    name: 'Pastel de Tiramisu',
    price: 350.00,
  ),
];

