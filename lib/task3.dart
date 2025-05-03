import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Netflix Styled Cart',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE50914),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: ProductListPage(),
    ),
  );
}

// ------------------ Product Model ------------------
class Product {
  final int id;
  final String name;
  final double price;

  Product(this.id, this.name, this.price);
}

// ------------------ GetX Controller ------------------
class CartController extends GetxController {
  var cartItems = <Product>[].obs;

  void addToCart(Product product) {
    cartItems.add(product);
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
  }

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.price);
}

// ------------------ Product List Page ------------------
class ProductListPage extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  final List<Product> products = [
    Product(1, "Wireless Mouse", 19.99),
    Product(2, "Bluetooth Headphones", 49.99),
    Product(3, "Smartwatch", 79.99),
    Product(4, "USB-C Charger", 25.99),
    Product(5, "Mechanical Keyboard", 99.99),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Netflix Store"),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, size: 28),
                onPressed: () => Get.to(() => CartPage()),
              ),
              Obx(() {
                return Positioned(
                  right: 6,
                  top: 6,
                  child:
                      cartController.cartItems.isNotEmpty
                          ? Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Color(0xFFE50914),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${cartController.cartItems.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                          : SizedBox.shrink(),
                );
              }),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            color: Colors.grey[900],
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: ElevatedButton.icon(
                  icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                  label: Text("Add"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE50914),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => cartController.addToCart(product),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ------------------ Cart Page ------------------
class CartPage extends StatelessWidget {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Text(
              "Your cart is empty!",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartController.cartItems[index];
                  return Card(
                    color: Colors.grey[900],
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        product.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "\$${product.price.toStringAsFixed(2)}",
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => cartController.removeFromCart(product),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border(top: BorderSide(color: Colors.redAccent)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Total: \$${cartController.totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE50914),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Get.snackbar(
                        "Checkout",
                        "Purchase completed successfully!",
                        backgroundColor: Color(0xFFE50914),
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      cartController.cartItems.clear();
                    },
                    child: Text("Checkout"),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
