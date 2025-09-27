class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final List<String> imageUrls;
  final ProductCategory category;
  final ProductSubcategory subcategory;
  final String brand;
  final double rating;
  final int reviewCount;
  final bool isInStock;
  final int stockQuantity;
  final List<String> tags;
  final Map<String, dynamic>? specifications;
  final bool isPregnancySafe;
  final List<String> pregnancyStages; // Which stages this product is suitable for
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.currency = 'USD',
    required this.imageUrls,
    required this.category,
    required this.subcategory,
    required this.brand,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isInStock = true,
    this.stockQuantity = 0,
    required this.tags,
    this.specifications,
    this.isPregnancySafe = true,
    required this.pregnancyStages,
    required this.createdAt,
  });

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  bool get hasReviews => reviewCount > 0;
  String get stockStatus => isInStock ? 'In Stock' : 'Out of Stock';

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      currency: json['currency'] ?? 'USD',
      imageUrls: List<String>.from(json['image_urls']),
      category: ProductCategory.values[json['category']],
      subcategory: ProductSubcategory.values[json['subcategory']],
      brand: json['brand'],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      isInStock: json['is_in_stock'] ?? true,
      stockQuantity: json['stock_quantity'] ?? 0,
      tags: List<String>.from(json['tags']),
      specifications: json['specifications'],
      isPregnancySafe: json['is_pregnancy_safe'] ?? true,
      pregnancyStages: List<String>.from(json['pregnancy_stages']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'image_urls': imageUrls,
      'category': category.index,
      'subcategory': subcategory.index,
      'brand': brand,
      'rating': rating,
      'review_count': reviewCount,
      'is_in_stock': isInStock,
      'stock_quantity': stockQuantity,
      'tags': tags,
      'specifications': specifications,
      'is_pregnancy_safe': isPregnancySafe,
      'pregnancy_stages': pregnancyStages,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

enum ProductCategory {
  prenatalVitamins,
  maternityClothing,
  babyGear,
  nurseryFurniture,
  skincare,
  books,
  technology,
  fitness,
  nutrition,
  breastfeeding
}

enum ProductSubcategory {
  // Prenatal Vitamins
  multivitamins,
  folicAcid,
  iron,
  calcium,
  omega3,
  
  // Maternity Clothing
  tops,
  bottoms,
  dresses,
  undergarments,
  sleepwear,
  
  // Baby Gear
  strollers,
  carSeats,
  carriers,
  babyMonitors,
  feeding,
  
  // Nursery
  cribs,
  changing,
  nurseryStorage,
  decor,
  lighting,
  
  // Skincare
  stretchMarks,
  moisturizers,
  sunscreen,
  cleansers,
  
  // Books
  pregnancy,
  parenting,
  childDevelopment,
  
  // Technology
  apps,
  wearables,
  techMonitors,
  
  // Fitness
  prenatalYoga,
  equipment,
  classes,
  
  // Nutrition
  snacks,
  supplements,
  teas,
  
  // Breastfeeding
  pumps,
  accessories,
  breastfeedingStorage,
  clothing
}

class CartItem {
  final String id;
  final String productId;
  final Product product;
  final int quantity;
  final double unitPrice;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.productId,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.addedAt,
  });

  double get totalPrice => unitPrice * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['product_id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
      addedAt: DateTime.parse(json['added_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product': product.toJson(),
      'quantity': quantity,
      'unit_price': unitPrice,
      'added_at': addedAt.toIso8601String(),
    };
  }

  CartItem copyWith({
    String? id,
    String? productId,
    Product? product,
    int? quantity,
    double? unitPrice,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}

class ShoppingCart {
  final String id;
  final String userId;
  final List<CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShoppingCart({
    required this.id,
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * 0.08; // 8% tax rate
  double get shipping => subtotal > 50 ? 0.0 : 9.99; // Free shipping over $50
  double get total => subtotal + tax + shipping;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  factory ShoppingCart.fromJson(Map<String, dynamic> json) {
    return ShoppingCart(
      id: json['id'],
      userId: json['user_id'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final ShippingAddress shippingAddress;
  final DateTime orderDate;
  final DateTime? shippedDate;
  final DateTime? deliveredDate;
  final String? trackingNumber;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.orderDate,
    this.shippedDate,
    this.deliveredDate,
    this.trackingNumber,
  });

  bool get isDelivered => status == OrderStatus.delivered;
  bool get isShipped => status == OrderStatus.shipped || isDelivered;
  bool get canCancel => status == OrderStatus.pending || status == OrderStatus.processing;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      tax: json['tax'].toDouble(),
      shipping: json['shipping'].toDouble(),
      total: json['total'].toDouble(),
      status: OrderStatus.values[json['status']],
      paymentMethod: PaymentMethod.fromJson(json['payment_method']),
      shippingAddress: ShippingAddress.fromJson(json['shipping_address']),
      orderDate: DateTime.parse(json['order_date']),
      shippedDate: json['shipped_date'] != null ? DateTime.parse(json['shipped_date']) : null,
      deliveredDate: json['delivered_date'] != null ? DateTime.parse(json['delivered_date']) : null,
      trackingNumber: json['tracking_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'shipping': shipping,
      'total': total,
      'status': status.index,
      'payment_method': paymentMethod.toJson(),
      'shipping_address': shippingAddress.toJson(),
      'order_date': orderDate.toIso8601String(),
      'shipped_date': shippedDate?.toIso8601String(),
      'delivered_date': deliveredDate?.toIso8601String(),
      'tracking_number': trackingNumber,
    };
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'],
      productName: json['product_name'],
      productImage: json['product_image'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
      totalPrice: json['total_price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
  }
}

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded
}

class PaymentMethod {
  final String id;
  final PaymentType type;
  final String? cardLast4;
  final String? cardBrand;
  final String? expiryMonth;
  final String? expiryYear;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    this.cardLast4,
    this.cardBrand,
    this.expiryMonth,
    this.expiryYear,
    this.isDefault = false,
  });

  String get displayName {
    switch (type) {
      case PaymentType.creditCard:
        return '$cardBrand ending in $cardLast4';
      case PaymentType.debitCard:
        return 'Debit card ending in $cardLast4';
      case PaymentType.paypal:
        return 'PayPal';
      case PaymentType.applePay:
        return 'Apple Pay';
      case PaymentType.googlePay:
        return 'Google Pay';
    }
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      type: PaymentType.values[json['type']],
      cardLast4: json['card_last4'],
      cardBrand: json['card_brand'],
      expiryMonth: json['expiry_month'],
      expiryYear: json['expiry_year'],
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'card_last4': cardLast4,
      'card_brand': cardBrand,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'is_default': isDefault,
    };
  }
}

enum PaymentType {
  creditCard,
  debitCard,
  paypal,
  applePay,
  googlePay
}

class ShippingAddress {
  final String id;
  final String firstName;
  final String lastName;
  final String address1;
  final String? address2;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phone;
  final bool isDefault;

  ShippingAddress({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address1,
    this.address2,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.phone,
    this.isDefault = false,
  });

  String get fullName => '$firstName $lastName';
  String get fullAddress {
    String addr = address1;
    if (address2 != null && address2!.isNotEmpty) {
      addr += ', $address2';
    }
    return '$addr, $city, $state $zipCode, $country';
  }

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      address1: json['address1'],
      address2: json['address2'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      country: json['country'],
      phone: json['phone'],
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'phone': phone,
      'is_default': isDefault,
    };
  }
}

class ProductReview {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final int rating;
  final String title;
  final String comment;
  final List<String> imageUrls;
  final DateTime createdAt;
  final bool isVerifiedPurchase;
  final int helpfulCount;

  ProductReview({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.title,
    required this.comment,
    required this.imageUrls,
    required this.createdAt,
    this.isVerifiedPurchase = false,
    this.helpfulCount = 0,
  });

  bool get hasImages => imageUrls.isNotEmpty;

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'],
      productId: json['product_id'],
      userId: json['user_id'],
      userName: json['user_name'],
      rating: json['rating'],
      title: json['title'],
      comment: json['comment'],
      imageUrls: List<String>.from(json['image_urls']),
      createdAt: DateTime.parse(json['created_at']),
      isVerifiedPurchase: json['is_verified_purchase'] ?? false,
      helpfulCount: json['helpful_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'user_name': userName,
      'rating': rating,
      'title': title,
      'comment': comment,
      'image_urls': imageUrls,
      'created_at': createdAt.toIso8601String(),
      'is_verified_purchase': isVerifiedPurchase,
      'helpful_count': helpfulCount,
    };
  }
}
