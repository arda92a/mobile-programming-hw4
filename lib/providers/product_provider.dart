import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database/database_helper.dart';

class ProductProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchBarcode = '';

  /// Getters
  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchBarcode => _searchBarcode;

  /// Load all products from database
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _dbHelper.getProducts();
      _filteredProducts = List.from(_products);
    } catch (e) {
      _errorMessage = 'Failed to load products: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Search product by barcode
  Future<Product?> searchByBarcode(String barcode) async {
    _searchBarcode = barcode;
    
    if (barcode.isEmpty) {
      _filteredProducts = List.from(_products);
      notifyListeners();
      return null;
    }

    try {
      final product = await _dbHelper.getProductByBarcode(barcode);
      if (product != null) {
        _filteredProducts = [product];
      } else {
        _filteredProducts = [];
      }
      notifyListeners();
      return product;
    } catch (e) {
      _errorMessage = 'Search failed: $e';
      notifyListeners();
      return null;
    }
  }

  /// Clear search and show all products
  void clearSearch() {
    _searchBarcode = '';
    _filteredProducts = List.from(_products);
    notifyListeners();
  }

  /// Add a new product
  Future<bool> addProduct(Product product) async {
    try {
      // Check for duplicate barcode
      if (await _dbHelper.barcodeExists(product.barcodeNo)) {
        _errorMessage = 'A product with this barcode already exists!';
        notifyListeners();
        return false;
      }

      await _dbHelper.insertProduct(product);
      await loadProducts();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add product: $e';
      notifyListeners();
      return false;
    }
  }

  /// Update an existing product
  Future<bool> updateProduct(Product product) async {
    try {
      await _dbHelper.updateProduct(product);
      await loadProducts();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update product: $e';
      notifyListeners();
      return false;
    }
  }

  /// Delete a product
  Future<bool> deleteProduct(String barcodeNo) async {
    try {
      await _dbHelper.deleteProduct(barcodeNo);
      await loadProducts();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete product: $e';
      notifyListeners();
      return false;
    }
  }

  /// Validate product input
  String? validateProduct({
    required String barcodeNo,
    required String productName,
    required String category,
    required String unitPrice,
    required String taxRate,
    required String price,
    String? stockInfo,
  }) {
    if (barcodeNo.isEmpty) {
      return 'Barcode number is required';
    }
    if (productName.isEmpty) {
      return 'Product name is required';
    }
    if (category.isEmpty) {
      return 'Category is required';
    }
    
    final parsedUnitPrice = double.tryParse(unitPrice);
    if (parsedUnitPrice == null || parsedUnitPrice < 0) {
      return 'Please enter a valid unit price (non-negative number)';
    }
    
    final parsedTaxRate = int.tryParse(taxRate);
    if (parsedTaxRate == null || parsedTaxRate < 0 || parsedTaxRate > 100) {
      return 'Please enter a valid tax rate (0-100)';
    }
    
    final parsedPrice = double.tryParse(price);
    if (parsedPrice == null || parsedPrice < 0) {
      return 'Please enter a valid price (non-negative number)';
    }
    
    if (stockInfo != null && stockInfo.isNotEmpty) {
      final parsedStock = int.tryParse(stockInfo);
      if (parsedStock == null || parsedStock < 0) {
        return 'Stock info must be a non-negative integer';
      }
    }
    
    return null; // No validation errors
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
