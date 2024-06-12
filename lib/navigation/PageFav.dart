import 'package:app_kosmetik/models/ModelProduk.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PageFav extends StatelessWidget {
  const PageFav({super.key});

  Future<List<Datum>> _loadFavoriteProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteProductIds =
        prefs.getStringList('favoriteProducts') ?? [];

    // Initialize empty list to store fetched products
    List<Datum> fetchedProducts = [];

    for (String id in favoriteProductIds) {
      Datum? product = await _fetchProductById(id);
      if (product != null) {
        fetchedProducts.add(product);
      }
    }

    return fetchedProducts;
  }

  Future<Datum?> _fetchProductById(String id) async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/products/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Datum(
        id: data['id'],
        productName: data['productName'],
        description: data['description'],
        price: data['price'],
        image: data['image'],
        isFavorite: true,
        categoryId: data['categoryId'],
        stock: data['stock'],
        createdAt: data['createdAt'],
        updatedAt: data['updatedAt'],
      );
    } else {
      return null;
    }
  }

  Future<void> _removeFavorite(String id, List<Datum> favoriteProducts, Function updateState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteProductIds =
        prefs.getStringList('favoriteProducts') ?? [];
    favoriteProductIds.remove(id);
    await prefs.setStringList('favoriteProducts', favoriteProductIds);

    updateState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Datum>>(
        future: _loadFavoriteProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading favorite products'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorite products found'));
          } else {
            final favoriteProducts = snapshot.data!;
            return ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return ListTile(
                  leading: Image.network(
                    'http://127.0.0.1:8000/image/${product.image}',
                    width: 50,
                    height: 50,
                  ),
                  title: Text(product.productName),
                  subtitle: Text('Rp. ${product.price}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () async {
                      await _removeFavorite(product.id.toString(), favoriteProducts, () {
                        // trigger the FutureBuilder to rebuild
                        (context as Element).reassemble();
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
