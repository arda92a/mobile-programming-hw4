class Product {
  final String barcodeNo;
  final String productName;
  final String category;
  final double unitPrice;
  final int taxRate;
  final double price;
  final int? stockInfo;

  Product({
    required this.barcodeNo,
    required this.productName,
    required this.category,
    required this.unitPrice,
    required this.taxRate,
    required this.price,
    this.stockInfo,
  });

  /// Convert Product to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'barcodeNo': barcodeNo,
      'productName': productName,
      'category': category,
      'unitPrice': unitPrice,
      'taxRate': taxRate,
      'price': price,
      'stockInfo': stockInfo,
    };
  }

  /// Create Product from Map (database query result)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      barcodeNo: map['barcodeNo'] as String,
      productName: map['productName'] as String,
      category: map['category'] as String,
      unitPrice: map['unitPrice'] as double,
      taxRate: map['taxRate'] as int,
      price: map['price'] as double,
      stockInfo: map['stockInfo'] as int?,
    );
  }

  /// Create a copy of Product with optional field updates
  Product copyWith({
    String? barcodeNo,
    String? productName,
    String? category,
    double? unitPrice,
    int? taxRate,
    double? price,
    int? stockInfo,
  }) {
    return Product(
      barcodeNo: barcodeNo ?? this.barcodeNo,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      unitPrice: unitPrice ?? this.unitPrice,
      taxRate: taxRate ?? this.taxRate,
      price: price ?? this.price,
      stockInfo: stockInfo ?? this.stockInfo,
    );
  }

  @override
  String toString() {
    return 'Product(barcodeNo: $barcodeNo, productName: $productName, category: $category, '
        'unitPrice: $unitPrice, taxRate: $taxRate, price: $price, stockInfo: $stockInfo)';
  }
}
