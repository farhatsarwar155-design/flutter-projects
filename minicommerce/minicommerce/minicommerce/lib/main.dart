import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:badges/badges.dart' as badges;

// ─────────────────────────────────────────────
//  THEME CONSTANTS
// ─────────────────────────────────────────────
const kLime = Color(0xFFCBFF4D);
const kLimeDark = Color(0xFFA8D900);
const kDark = Color(0xFF0D0D0D);
const kCard = Color(0xFF161616);
const kCard2 = Color(0xFF1E1E1E);
const kMuted = Color(0xFF555555);
const kWhite = Color(0xFFF0F0F0);
const kAccentBlue = Color(0xFF4DAFFF);
const kAccentPurple = Color(0xFFB44DFF);

// ─────────────────────────────────────────────
//  DATA MODEL
// ─────────────────────────────────────────────
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final List<String> specs;
  final bool isNew;
  final bool isBestseller;
  final String brand;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice = 0,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviewCount,
    this.specs = const [],
    this.isNew = false,
    this.isBestseller = false,
    this.brand = '',
    this.inStock = true,
  });

  double get discountPercent =>
      originalPrice > 0 ? ((originalPrice - price) / originalPrice * 100) : 0;
}

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

// ─────────────────────────────────────────────
//  SHIPPING METHOD MODEL
// ─────────────────────────────────────────────
class ShippingMethod {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final String eta;
  final IconData icon;

  const ShippingMethod({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.eta,
    required this.icon,
  });
}

final List<ShippingMethod> kShippingMethods = [
  const ShippingMethod(
    id: 'standard',
    name: 'Standard Shipping',
    subtitle: 'Regular postal service',
    price: 0.0,
    eta: '5–7 business days',
    icon: Icons.local_shipping_outlined,
  ),
  const ShippingMethod(
    id: 'express',
    name: 'Express Shipping',
    subtitle: 'Priority courier with tracking',
    price: 12.99,
    eta: '2–3 business days',
    icon: Icons.electric_bolt_rounded,
  ),
  const ShippingMethod(
    id: 'overnight',
    name: 'Overnight Delivery',
    subtitle: 'Next business day guaranteed',
    price: 29.99,
    eta: 'Next business day',
    icon: Icons.rocket_launch_rounded,
  ),
  const ShippingMethod(
    id: 'pickup',
    name: 'Store Pickup',
    subtitle: 'Pick up from our nearest store',
    price: 0.0,
    eta: 'Ready in 2 hours',
    icon: Icons.store_rounded,
  ),
];

// ─────────────────────────────────────────────
//  PRODUCT DATA — Correct images per category
// ─────────────────────────────────────────────
final List<Product> kProducts = [

  // ── HEADPHONES (6) — Using Unsplash headphone images
  const Product(
    id: 1,
    name: 'Sony WH-1000XM5',
    description:
    'Industry-leading noise cancellation with Auto NC Optimizer. 30-hour battery life, multipoint connection for two devices simultaneously, and Crystal clear hands-free calling with 4 beamforming microphones. Foldable design for easy portability.',
    price: 349.99,
    originalPrice: 399.99,
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&q=80',
    category: 'Headphones',
    rating: 4.9,
    reviewCount: 8721,
    specs: ['30hr Battery', 'ANC', 'Multipoint', 'Hi-Res Audio'],
    isBestseller: true,
    brand: 'Sony',
  ),
  const Product(
    id: 2,
    name: 'Bose QuietComfort 45',
    description:
    'Quiet and comfortable with world-class noise cancellation. Awareness Mode lets in outside sound when needed. TriPort acoustic architecture with volume-optimized EQ delivers balanced audio at any level.',
    price: 279.99,
    originalPrice: 329.99,
    imageUrl: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=600&q=80',
    category: 'Headphones',
    rating: 4.7,
    reviewCount: 6340,
    specs: ['24hr Battery', 'ANC', 'USB-C', 'Foldable'],
    brand: 'Bose',
  ),
  const Product(
    id: 3,
    name: 'Apple AirPods Max',
    description:
    'Over-ear headphones with custom acoustic design, Active Noise Cancellation, Transparency mode, and Spatial Audio with dynamic head tracking for a theatre-like listening experience.',
    price: 549.99,
    imageUrl: 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=600&q=80',
    category: 'Headphones',
    rating: 4.8,
    reviewCount: 5120,
    specs: ['20hr Battery', 'Spatial Audio', 'ANC', 'Lightning'],
    brand: 'Apple',
  ),
  const Product(
    id: 4,
    name: 'Sennheiser HD 660S2',
    description:
    'Audiophile open-back headphones with natural and accurate sound reproduction. Low harmonic distortion, transducer matched within 1 dB, and improved low-frequency performance.',
    price: 499.99,
    imageUrl: 'https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=600&q=80',
    category: 'Headphones',
    rating: 4.8,
    reviewCount: 2890,
    specs: ['Open-Back', '150Ω Impedance', 'Balanced', 'Studio Grade'],
    isNew: true,
    brand: 'Sennheiser',
  ),
  const Product(
    id: 5,
    name: 'Jabra Evolve2 85',
    description:
    'Professional headset with world-leading 8-microphone call technology. Advanced ANC with unique HearThrough mode. All-day comfort with 37-hour battery.',
    price: 449.99,
    originalPrice: 499.99,
    imageUrl: 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=600&q=80',
    category: 'Headphones',
    rating: 4.6,
    reviewCount: 3150,
    specs: ['37hr Battery', '8 Mics', 'ANC', 'USB Dongle'],
    brand: 'Jabra',
  ),
  const Product(
    id: 6,
    name: 'Beyerdynamic DT 900 Pro X',
    description:
    'Studio reference headphones with STELLAR.45 driver for open spatial sound. Wide frequency range of 5-40,000Hz, replaceable ear pads and headband, detachable cable.',
    price: 299.99,
    imageUrl: 'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=600&q=80',
    category: 'Headphones',
    rating: 4.7,
    reviewCount: 1870,
    specs: ['48Ω Impedance', 'Open-Back', 'STELLAR.45', 'Studio'],
    isNew: true,
    brand: 'Beyerdynamic',
  ),

  // ── ACCESSORIES (6) — Keyboards, mice, USB hubs etc.
  const Product(
    id: 7,
    name: 'Keychron Q1 Pro',
    description:
    'Premium wireless mechanical keyboard with gasket-mounted structure. Hot-swappable switches, per-key RGB lighting, aluminum body, and Bluetooth 5.1 multi-device connectivity. QMK/VIA compatible.',
    price: 199.99,
    originalPrice: 229.99,
    imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=80',
    category: 'Accessories',
    rating: 4.8,
    reviewCount: 4230,
    specs: ['Wireless BT 5.1', 'Hot-swap', 'RGB', 'Aluminum'],
    isBestseller: true,
    brand: 'Keychron',
  ),
  const Product(
    id: 8,
    name: 'Logitech MX Master 3S',
    description:
    'Advanced wireless mouse with 8K DPI Darkfield sensor that works on glass. MagSpeed electromagnetic scrolling, customizable buttons, ergonomic design. Connects to 3 devices simultaneously.',
    price: 99.99,
    imageUrl: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=600&q=80',
    category: 'Accessories',
    rating: 4.8,
    reviewCount: 9870,
    specs: ['8000 DPI', 'MagSpeed', '3-Device', '70 Days Battery'],
    brand: 'Logitech',
  ),
  const Product(
    id: 9,
    name: 'Anker 737 Power Bank',
    description:
    '24,000mAh power bank with 140W max output and 65W USB-C input. Smart digital display showing power usage, PowerIQ 4.0 for fast charging, enough to fully charge a MacBook Pro.',
    price: 149.99,
    originalPrice: 169.99,
    imageUrl: 'https://images.unsplash.com/photo-1609091839311-d5365f9ff1c5?w=600&q=80',
    category: 'Accessories',
    rating: 4.6,
    reviewCount: 5640,
    specs: ['24000mAh', '140W Output', 'USB-C 65W In', 'LCD Display'],
    brand: 'Anker',
  ),
  const Product(
    id: 10,
    name: 'CalDigit TS4 Thunderbolt 4 Dock',
    description:
    '18 ports including Thunderbolt 4, 2× HDMI 2.1, 2.5G Ethernet, SD/microSD, and USB-A/C ports. Powers laptops up to 98W, supports dual 6K displays.',
    price: 399.99,
    imageUrl: 'https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?w=600&q=80',
    category: 'Accessories',
    rating: 4.7,
    reviewCount: 2340,
    specs: ['18 Ports', 'TB4', '98W Charging', 'Dual 6K'],
    isNew: true,
    brand: 'CalDigit',
  ),
  const Product(
    id: 11,
    name: 'Elgato Stream Deck MK.2',
    description:
    'Customizable LCD key controller with 15 keys for instant one-touch access to tools. Triggers multi-actions, seamlessly switches scenes, launches media, integrates with 400+ tools.',
    price: 149.99,
    imageUrl: 'https://images.unsplash.com/photo-1612198790700-52e1834d9c72?w=600&q=80',
    category: 'Accessories',
    rating: 4.6,
    reviewCount: 3780,
    specs: ['15 LCD Keys', '400+ Integrations', 'USB-C', 'Detachable'],
    brand: 'Elgato',
  ),
  const Product(
    id: 12,
    name: 'Twelve South MagSafe Stand',
    description:
    'Premium aluminum MagSafe charging stand that holds iPhone at the perfect angle for FaceID unlock and FaceTime calls. Adjustable viewing angle and cable management built in.',
    price: 79.99,
    originalPrice: 89.99,
    imageUrl: 'https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=600&q=80',
    category: 'Accessories',
    rating: 4.5,
    reviewCount: 1560,
    specs: ['MagSafe', 'Adjustable', 'Aluminum', 'Cable Mgmt'],
    brand: 'Twelve South',
  ),

  // ── WEARABLES (6) — Smartwatches and wearable tech
  const Product(
    id: 13,
    name: 'Apple Watch Ultra 2',
    description:
    'Most rugged and capable Apple Watch with titanium case, brightest display at 3000 nits, up to 60 hours battery in low-power mode, precision dual-frequency GPS.',
    price: 799.99,
    imageUrl: 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=600&q=80',
    category: 'Wearables',
    rating: 4.9,
    reviewCount: 4120,
    specs: ['Titanium', '3000 nits', '60hr Battery', 'Dual GPS'],
    isBestseller: true,
    brand: 'Apple',
  ),
  const Product(
    id: 14,
    name: 'Samsung Galaxy Watch 6 Pro',
    description:
    'Premium circular smartwatch with sapphire crystal glass and titanium frame. Advanced BioActive sensor for body composition analysis, sleep coaching, ECG, and blood pressure monitoring.',
    price: 499.99,
    originalPrice: 549.99,
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&q=80',
    category: 'Wearables',
    rating: 4.7,
    reviewCount: 3240,
    specs: ['Sapphire Glass', 'ECG', 'Body Comp', '60hr Battery'],
    isNew: true,
    brand: 'Samsung',
  ),
  const Product(
    id: 15,
    name: 'Garmin Fenix 7X Sapphire',
    description:
    'Rugged multisport GPS smartwatch with solar charging capability, 28-day battery life, topographic maps, and advanced health monitoring including Pulse Ox and Body Battery.',
    price: 899.99,
    imageUrl: 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=600&q=80',
    category: 'Wearables',
    rating: 4.8,
    reviewCount: 2780,
    specs: ['Solar Charging', '28 Days', 'Topo Maps', 'MIL-STD-810'],
    brand: 'Garmin',
  ),
  const Product(
    id: 16,
    name: 'Oura Ring Gen 3',
    description:
    'Smart ring with advanced health tracking including sleep staging, heart rate variability, body temperature sensing. 7-day battery, titanium construction, water-resistant to 100m.',
    price: 299.99,
    imageUrl: 'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=600&q=80',
    category: 'Wearables',
    rating: 4.5,
    reviewCount: 5670,
    specs: ['Titanium', '7 Days Battery', '100m WR', 'Sleep Staging'],
    isNew: true,
    brand: 'Oura',
  ),
  const Product(
    id: 17,
    name: 'Fitbit Sense 2',
    description:
    'Advanced health smartwatch with built-in GPS, EDA sensor for stress management, ECG app, skin temperature sensor, and 6-day battery. Google Maps and Google Wallet built in.',
    price: 249.99,
    originalPrice: 299.99,
    imageUrl: 'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=600&q=80',
    category: 'Wearables',
    rating: 4.4,
    reviewCount: 4890,
    specs: ['Built-in GPS', 'EDA Sensor', 'ECG', '6 Days Battery'],
    brand: 'Fitbit',
  ),
  const Product(
    id: 18,
    name: 'Whoop 4.0',
    description:
    'Continuous health monitoring wearable with 24/7 heart rate tracking, blood oxygen monitoring, skin temperature, and respiratory rate. Subscription-based with personalized coaching.',
    price: 239.99,
    imageUrl: 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=600&q=80',
    category: 'Wearables',
    rating: 4.3,
    reviewCount: 7230,
    specs: ['24/7 Monitoring', 'SpO2', 'HRV', 'Strain Coach'],
    brand: 'Whoop',
  ),

  // ── CAMERAS (6) — DSLR, mirrorless, action cameras
  const Product(
    id: 19,
    name: 'Sony A7R V',
    description:
    'Full-frame 61MP BSI CMOS sensor with AI-based subject recognition autofocus. 8-stop in-body stabilization, 8K video recording, dual card slots, and 9.44M-dot OLED EVF.',
    price: 3899.99,
    imageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600&q=80',
    category: 'Cameras',
    rating: 4.9,
    reviewCount: 1890,
    specs: ['61MP', '8K Video', '8-stop IBIS', 'AI AF'],
    isBestseller: true,
    brand: 'Sony',
  ),
  const Product(
    id: 20,
    name: 'Canon EOS R5 Mark II',
    description:
    '45MP stacked CMOS sensor with Digic X processor, 8K RAW video at 60fps with internal recording, Dual Pixel CMOS AF II with eye detection, and up to 30fps continuous shooting.',
    price: 4299.99,
    imageUrl: 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=600&q=80',
    category: 'Cameras',
    rating: 4.9,
    reviewCount: 1240,
    specs: ['45MP Stacked', '8K/60fps RAW', '30fps Burst', 'DPAF II'],
    isNew: true,
    brand: 'Canon',
  ),
  const Product(
    id: 21,
    name: 'Fujifilm X-T5',
    description:
    'Compact 40MP APS-C mirrorless with 5-axis 7-stop IBIS, Film Simulation modes including Classic Negative and Eterna Cinema, 6.2K video recording, and weather resistance.',
    price: 1699.99,
    originalPrice: 1799.99,
    imageUrl: 'https://images.unsplash.com/photo-1580136579312-94651dfd596d?w=600&q=80',
    category: 'Cameras',
    rating: 4.8,
    reviewCount: 2340,
    specs: ['40MP APS-C', '7-stop IBIS', '6.2K Video', 'Film Sims'],
    brand: 'Fujifilm',
  ),
  const Product(
    id: 22,
    name: 'Nikon Z8',
    description:
    'Professional full-frame mirrorless with 45.7MP BSI stacked sensor, 8K/60fps video, 20fps RAW burst shooting, and built-in vertical grip. Subject detection AF and dual card slots.',
    price: 3999.99,
    imageUrl: 'https://images.unsplash.com/photo-1471341971476-ae15ff5dd4ea?w=600&q=80',
    category: 'Cameras',
    rating: 4.8,
    reviewCount: 980,
    specs: ['45.7MP Stacked', '8K/60fps', '20fps RAW', '6-stop IBIS'],
    isNew: true,
    brand: 'Nikon',
  ),
  const Product(
    id: 23,
    name: 'GoPro Hero 12 Black',
    description:
    'Action camera with 5.3K60 video, HyperSmooth 6.0 stabilization, and Enduro battery for extreme conditions. Waterproof to 10m without housing, 10-bit color, and HDR video.',
    price: 399.99,
    originalPrice: 449.99,
    imageUrl: 'https://images.unsplash.com/photo-1551415923-a2297c7fda79?w=600&q=80',
    category: 'Cameras',
    rating: 4.6,
    reviewCount: 8920,
    specs: ['5.3K/60fps', 'HyperSmooth 6.0', '10m Waterproof', 'HDR'],
    brand: 'GoPro',
  ),
  const Product(
    id: 24,
    name: 'DJI Pocket 3 Creator Combo',
    description:
    '1-inch CMOS sensor with 4K/120fps video, 3-axis stabilized gimbal camera, OLED touchscreen, ActiveTrack 360° face tracking, and 166-minute battery life.',
    price: 599.99,
    imageUrl: 'https://images.unsplash.com/photo-1569136489069-8f0a3ef6540f?w=600&q=80',
    category: 'Cameras',
    rating: 4.7,
    reviewCount: 3450,
    specs: ['1-inch CMOS', '4K/120fps', 'ActiveTrack', '166 Min Battery'],
    isNew: true,
    brand: 'DJI',
  ),

  // ── FURNITURE (6) — Chairs, desks, sofas, shelves
  const Product(
    id: 25,
    name: 'Herman Miller Aeron Chair',
    description:
    'Iconic ergonomic office chair with PostureFit SL lumbar support, 8Z Pellicle mesh, 3D-adjustable arms, and tilt limiter. Available in three sizes, 12-year warranty, certified for 24/7 use.',
    price: 1795.00,
    imageUrl: 'https://images.unsplash.com/photo-1592078615290-033ee584e267?w=600&q=80',
    category: 'Furniture',
    rating: 4.9,
    reviewCount: 12340,
    specs: ['PostureFit SL', '8Z Pellicle', '3D Arms', '12-Year Warranty'],
    isBestseller: true,
    brand: 'Herman Miller',
  ),
  const Product(
    id: 26,
    name: 'Uplift V2 Standing Desk',
    description:
    'Commercial-grade height-adjustable desk with ANSI/BIFMA-certified frame, 355 lb lifting capacity, anti-collision system, and memory controller with 4 programmable heights.',
    price: 1149.00,
    originalPrice: 1299.00,
    imageUrl: 'https://images.unsplash.com/photo-1611269154421-4e27233ac5c7?w=600&q=80',
    category: 'Furniture',
    rating: 4.8,
    reviewCount: 8760,
    specs: ['355 lbs Capacity', 'Anti-collision', '4 Memory Presets', 'BIFMA Certified'],
    brand: 'Uplift',
  ),
  const Product(
    id: 27,
    name: 'West Elm Andes Sofa',
    description:
    'Deep-seated sectional with sustainably sourced kiln-dried hardwood frame, high-resiliency foam cushions, and Nomad performance fabric that resists stains. FSC-certified wood.',
    price: 2799.00,
    imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600&q=80',
    category: 'Furniture',
    rating: 4.5,
    reviewCount: 2340,
    specs: ['FSC-Certified Wood', 'Stain Resistant', 'Reversible Chaise', 'Removable Covers'],
    isNew: true,
    brand: 'West Elm',
  ),
  const Product(
    id: 28,
    name: 'IKEA KALLAX Shelf Unit',
    description:
    'Versatile cube storage system that works as room divider, TV bench, or bookcase. Compatible with 35+ accessories including doors and drawers. Weight capacity 13 kg per shelf.',
    price: 179.99,
    imageUrl: 'https://images.unsplash.com/photo-1567225557594-88d73e55f2cb?w=600&q=80',
    category: 'Furniture',
    rating: 4.4,
    reviewCount: 15670,
    specs: ['35+ Accessories', '13kg/Shelf', 'Modular', 'Multiple Sizes'],
    brand: 'IKEA',
  ),
  const Product(
    id: 29,
    name: 'Casper Wave Hybrid Mattress',
    description:
    'Pressure-relieving mattress with 5 ergonomic zones, AirScape foam for cooling, responsive springs for movement isolation, and organic cotton cover. 100-night trial and 10-year warranty.',
    price: 2595.00,
    originalPrice: 2995.00,
    imageUrl: 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=600&q=80',
    category: 'Furniture',
    rating: 4.7,
    reviewCount: 5430,
    specs: ['5 Ergonomic Zones', 'AirScape Cooling', 'Organic Cotton', '100-Night Trial'],
    brand: 'Casper',
  ),
  const Product(
    id: 30,
    name: 'BDI Corridor Media Console',
    description:
    'Modern floating media console with tempered glass doors, adjustable shelves, and integrated cable management. Accommodates TVs up to 90" and is made from FSC-certified wood.',
    price: 1299.00,
    imageUrl: 'https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=600&q=80',
    category: 'Furniture',
    rating: 4.6,
    reviewCount: 1890,
    specs: ['Tempered Glass', 'Cable Mgmt', '90" TV Support', 'FSC Wood'],
    isNew: true,
    brand: 'BDI',
  ),
];

// ─────────────────────────────────────────────
//  REVIEW MODEL (New Feature)
// ─────────────────────────────────────────────
class Review {
  final String author;
  final double rating;
  final String comment;
  final String date;

  const Review({
    required this.author,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

final Map<int, List<Review>> kReviews = {
  1: [
    const Review(author: 'Ahmed K.', rating: 5.0, comment: 'Best noise cancellation I have ever used. Worth every penny!', date: 'Jan 2025'),
    const Review(author: 'Sara M.', rating: 4.8, comment: 'Incredible sound quality. Battery lasts all day easily.', date: 'Feb 2025'),
  ],
  7: [
    const Review(author: 'Zain R.', rating: 5.0, comment: 'Typing feel is amazing. Best keyboard I have owned.', date: 'Mar 2025'),
    const Review(author: 'Hira T.', rating: 4.6, comment: 'Build quality is superb. Bluetooth connection is flawless.', date: 'Feb 2025'),
  ],
  13: [
    const Review(author: 'Omar B.', rating: 5.0, comment: 'Absolutely rugged and beautiful. GPS is insanely accurate.', date: 'Jan 2025'),
    const Review(author: 'Nadia F.', rating: 4.9, comment: 'Best Apple Watch ever made. The action button is a game changer.', date: 'Mar 2025'),
  ],
  19: [
    const Review(author: 'Ali J.', rating: 5.0, comment: '61MP is jaw-dropping. AI autofocus locks on instantly.', date: 'Dec 2024'),
    const Review(author: 'Fatima L.', rating: 4.8, comment: 'Top-tier camera. IBIS is incredibly smooth for video.', date: 'Jan 2025'),
  ],
  25: [
    const Review(author: 'Hassan N.', rating: 5.0, comment: 'My back pain is gone. Best investment for remote work.', date: 'Feb 2025'),
    const Review(author: 'Zara K.', rating: 4.9, comment: '12-year warranty speaks for itself. Absolute quality chair.', date: 'Jan 2025'),
  ],
};

// ─────────────────────────────────────────────
//  CART PROVIDER
// ─────────────────────────────────────────────
class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};
  final List<String> _wishlist = [];
  final List<int> _recentlyViewed = [];
  final Map<int, double> _userRatings = {};

  // ── Shipping
  String _selectedShippingId = 'standard';
  String get selectedShippingId => _selectedShippingId;
  ShippingMethod get selectedShipping =>
      kShippingMethods.firstWhere((s) => s.id == _selectedShippingId);
  void selectShipping(String id) {
    _selectedShippingId = id;
    notifyListeners();
  }

  // ── Advanced add-ons
  bool _giftWrapping = false;
  bool _expressHandling = false;
  bool _insuranceAdded = false;
  bool _signatureRequired = false;
  bool _smsNotifications = true;
  bool _emailNotifications = true;
  String _promoCode = '';
  bool _promoApplied = false;
  String _sortBy = 'popular';

  bool get giftWrapping => _giftWrapping;
  bool get expressHandling => _expressHandling;
  bool get insuranceAdded => _insuranceAdded;
  bool get signatureRequired => _signatureRequired;
  bool get smsNotifications => _smsNotifications;
  bool get emailNotifications => _emailNotifications;
  String get promoCode => _promoCode;
  bool get promoApplied => _promoApplied;
  String get sortBy => _sortBy;
  List<int> get recentlyViewed => _recentlyViewed;
  Map<int, double> get userRatings => _userRatings;

  void setSortBy(String s) { _sortBy = s; notifyListeners(); }
  void toggleGiftWrapping() { _giftWrapping = !_giftWrapping; notifyListeners(); }
  void toggleExpressHandling() { _expressHandling = !_expressHandling; notifyListeners(); }
  void toggleInsurance() { _insuranceAdded = !_insuranceAdded; notifyListeners(); }
  void toggleSignature() { _signatureRequired = !_signatureRequired; notifyListeners(); }
  void toggleSms() { _smsNotifications = !_smsNotifications; notifyListeners(); }
  void toggleEmail() { _emailNotifications = !_emailNotifications; notifyListeners(); }

  void setUserRating(int productId, double rating) {
    _userRatings[productId] = rating;
    notifyListeners();
  }

  void addRecentlyViewed(int id) {
    _recentlyViewed.remove(id);
    _recentlyViewed.insert(0, id);
    if (_recentlyViewed.length > 10) _recentlyViewed.removeLast();
    notifyListeners();
  }

  bool applyPromoCode(String code) {
    if (code.toUpperCase() == 'LIME20') {
      _promoCode = code;
      _promoApplied = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromo() {
    _promoCode = '';
    _promoApplied = false;
    notifyListeners();
  }

  // ── Cart
  Map<int, CartItem> get items => _items;
  List<String> get wishlist => _wishlist;
  int get itemCount => _items.values.fold(0, (sum, i) => sum + i.quantity);
  double get totalPrice =>
      _items.values.fold(0.0, (sum, i) => sum + i.product.price * i.quantity);
  double get discountAmount => totalPrice > 500 ? totalPrice * 0.10 : 0.0;
  double get promoDiscount => _promoApplied ? totalPrice * 0.20 : 0.0;
  double get addonsTotal {
    double t = selectedShipping.price;
    if (_giftWrapping) t += 5.99;
    if (_expressHandling) t += 9.99;
    if (_insuranceAdded) t += 4.99;
    return t;
  }
  double get finalPrice => totalPrice - discountAmount - promoDiscount + addonsTotal;

  bool isInWishlist(int id) => _wishlist.contains(id.toString());
  void toggleWishlist(int id) {
    final key = id.toString();
    _wishlist.contains(key) ? _wishlist.remove(key) : _wishlist.add(key);
    notifyListeners();
  }

  void addToCart(Product product, int qty) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += qty;
    } else {
      _items[product.id] = CartItem(product: product, quantity: qty);
    }
    notifyListeners();
  }

  void increment(int id) {
    if (_items.containsKey(id)) { _items[id]!.quantity++; notifyListeners(); }
  }

  void decrement(int id) {
    if (_items.containsKey(id)) {
      if (_items[id]!.quantity > 1) { _items[id]!.quantity--; } else { _items.remove(id); }
      notifyListeners();
    }
  }

  void remove(int id) { _items.remove(id); notifyListeners(); }
  void clearCart() { _items.clear(); notifyListeners(); }
}

// ─────────────────────────────────────────────
//  MAIN
// ─────────────────────────────────────────────
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LimeStore',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kDark,
        primaryColor: kLime,
        colorScheme: const ColorScheme.dark(
          primary: kLime,
          secondary: kLimeDark,
          surface: kCard,
          onPrimary: kDark,
          onSurface: kWhite,
        ),
        textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home':     (_) => const HomeScreen(),
        '/cart':     (_) => const CartScreen(),
        '/shipping': (_) => const ShippingScreen(),
        '/checkout': (_) => const CheckoutScreen(),
        '/wishlist': (_) => const WishlistScreen(),
        '/settings': (_) => const AdvancedSettingsScreen(),
        '/compare':  (_) => const CompareScreen(),
        '/orders':   (_) => const OrderHistoryScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final product = settings.arguments as Product;
          return PageRouteBuilder(
            pageBuilder: (_, animation, __) =>
                ProductDetailsScreen(product: product),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                child: child,
              ),
            ),
          );
        }
        if (settings.name == '/brand') {
          final brand = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => BrandScreen(brand: brand),
          );
        }
        return null;
      },
    );
  }
}

// ─────────────────────────────────────────────
//  REUSABLE WIDGETS
// ─────────────────────────────────────────────
class LimeButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool outline;
  final double? width;

  const LimeButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.outline = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        decoration: BoxDecoration(
          color: outline ? Colors.transparent : kLime,
          border: Border.all(color: kLime, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: width != null ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: outline ? kLime : kDark, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.dmSans(
                color: outline ? kLime : kDark,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildNetworkImage(String url,
    {double? width, double? height, BoxFit fit = BoxFit.cover}) {
  return ClipRect(
    child: SizedBox(
      width: width,
      height: height,
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: kCard2,
            child: Center(
              child: CircularProgressIndicator(
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                    : null,
                color: kLime,
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: kCard2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.image_rounded, color: kMuted, size: 32),
              const SizedBox(height: 4),
              Text('No image', style: GoogleFonts.dmSans(color: kMuted, fontSize: 10)),
            ],
          ),
        ),
      ),
    ),
  );
}

class StarRating extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final bool compact;
  const StarRating({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          if (i < rating.floor()) return Icon(Icons.star_rounded, color: kLime, size: compact ? 13 : 16);
          if (i < rating)         return Icon(Icons.star_half_rounded, color: kLime, size: compact ? 13 : 16);
          return Icon(Icons.star_border_rounded, color: kMuted, size: compact ? 13 : 16);
        }),
        const SizedBox(width: 5),
        Text(
          compact ? '$rating' : '$rating ($reviewCount)',
          style: GoogleFonts.dmSans(
              color: kMuted, fontSize: compact ? 11 : 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// Interactive Star Rating Widget (New Feature)
class InteractiveStarRating extends StatefulWidget {
  final int productId;
  final double? initialRating;
  final ValueChanged<double> onRated;
  const InteractiveStarRating({
    super.key,
    required this.productId,
    required this.onRated,
    this.initialRating,
  });

  @override
  State<InteractiveStarRating> createState() => _InteractiveStarRatingState();
}

class _InteractiveStarRatingState extends State<InteractiveStarRating> {
  double _hovered = 0;
  double _selected = 0;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialRating ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starVal = i + 1.0;
        final filled = (_hovered > 0 ? _hovered : _selected) >= starVal;
        return GestureDetector(
          onTap: () {
            setState(() => _selected = starVal);
            widget.onRated(starVal);
          },
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovered = starVal),
            onExit: (_) => setState(() => _hovered = 0),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_border_rounded,
              color: filled ? kLime : kMuted,
              size: 28,
            ),
          ),
        );
      }),
    );
  }
}

// Category icon helper
IconData _categoryIcon(String cat) {
  switch (cat) {
    case 'Headphones': return Icons.headphones_rounded;
    case 'Accessories': return Icons.devices_other_rounded;
    case 'Wearables': return Icons.watch_rounded;
    case 'Cameras': return Icons.camera_alt_rounded;
    case 'Furniture': return Icons.chair_rounded;
    default: return Icons.grid_view_rounded;
  }
}

Color _categoryColor(String cat) {
  switch (cat) {
    case 'Headphones': return const Color(0xFF4DAFFF);
    case 'Accessories': return const Color(0xFFFF8C4D);
    case 'Wearables': return const Color(0xFFB44DFF);
    case 'Cameras': return const Color(0xFFFF4D7A);
    case 'Furniture': return const Color(0xFF4DFFB4);
    default: return kLime;
  }
}

// ─────────────────────────────────────────────
//  HOME SCREEN
// ─────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isGrid = true;
  bool _searchFocused = false;
  double? _priceMin;
  double? _priceMax;
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  late AnimationController _bannerCtrl;

  @override
  void initState() {
    super.initState();
    _bannerCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _searchFocus.addListener(() => setState(() => _searchFocused = _searchFocus.hasFocus));
  }

  @override
  void dispose() {
    _bannerCtrl.dispose();
    _searchFocus.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<String> get categories =>
      ['All', ...kProducts.map((p) => p.category).toSet().toList()];

  List<Product> get filteredProducts {
    final cart = context.read<CartProvider>();
    var list = kProducts.where((p) {
      final matchCat = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchMin = _priceMin == null || p.price >= _priceMin!;
      final matchMax = _priceMax == null || p.price <= _priceMax!;
      return matchCat && matchSearch && matchMin && matchMax;
    }).toList();

    switch (cart.sortBy) {
      case 'price_low': list.sort((a, b) => a.price.compareTo(b.price));
      case 'price_high': list.sort((a, b) => b.price.compareTo(a.price));
      case 'rating': list.sort((a, b) => b.rating.compareTo(a.rating));
      case 'newest': list = list.where((p) => p.isNew).toList() + list.where((p) => !p.isNew).toList();
      default: list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    }
    return list;
  }

  // Recently viewed products
  List<Product> _recentProducts(CartProvider cart) {
    return cart.recentlyViewed
        .map((id) => kProducts.firstWhere((p) => p.id == id, orElse: () => kProducts.first))
        .take(5)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final products = filteredProducts;

    return Scaffold(
      backgroundColor: kDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── TOP BAR
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Lime',
                              style: GoogleFonts.dmSans(
                                color: kLime, fontSize: 26,
                                fontWeight: FontWeight.w900, letterSpacing: -1,
                              ),
                            ),
                            TextSpan(
                              text: 'Store',
                              style: GoogleFonts.dmSans(
                                color: kWhite, fontSize: 26,
                                fontWeight: FontWeight.w900, letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('Premium tech, delivered.',
                          style: GoogleFonts.dmSans(color: kMuted, fontSize: 12)),
                    ],
                  ),
                  const Spacer(),
                  _IconChip(icon: Icons.sort_rounded, onTap: () => _showSortSheet(context, cart)),
                  const SizedBox(width: 6),
                  _IconChip(icon: Icons.filter_list_rounded, onTap: () => _showFilterSheet(context)),
                  const SizedBox(width: 6),
                  _IconChip(icon: Icons.favorite_border_rounded, badge: cart.wishlist.length,
                      onTap: () => Navigator.pushNamed(context, '/wishlist')),
                  const SizedBox(width: 6),
                  _IconChip(icon: Icons.shopping_bag_outlined, badge: cart.itemCount,
                      badgeColor: kLime, onTap: () => Navigator.pushNamed(context, '/cart')),
                  const SizedBox(width: 6),
                  _IconChip(icon: Icons.tune_rounded, onTap: () => Navigator.pushNamed(context, '/settings')),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

            const SizedBox(height: 14),

            // ── HERO BANNER
            if (_searchQuery.isEmpty && _selectedCategory == 'All')
              _HeroBanner(controller: _bannerCtrl)
                  .animate().fadeIn(delay: 50.ms, duration: 400.ms).slideY(begin: 0.1),

            if (_searchQuery.isEmpty && _selectedCategory == 'All')
              const SizedBox(height: 14),

            // ── RECENTLY VIEWED (New Feature)
            if (_searchQuery.isEmpty && cart.recentlyViewed.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.history_rounded, color: kMuted, size: 14),
                    const SizedBox(width: 6),
                    Text('Recently Viewed',
                        style: GoogleFonts.dmSans(color: kMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 72,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _recentProducts(cart).length,
                  itemBuilder: (_, i) {
                    final p = _recentProducts(cart)[i];
                    return GestureDetector(
                      onTap: () {
                        cart.addRecentlyViewed(p.id);
                        Navigator.pushNamed(context, '/details', arguments: p);
                      },
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _buildNetworkImage(p.imageUrl, width: 52, height: 52),
                            ),
                            const SizedBox(height: 3),
                            Text(p.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dmSans(color: kMuted, fontSize: 8)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],

            // ── SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _searchFocused ? kLime.withOpacity(0.6) : kMuted.withOpacity(0.25),
                    width: _searchFocused ? 1.5 : 1,
                  ),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  focusNode: _searchFocus,
                  style: GoogleFonts.dmSans(color: kWhite),
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search products, brands…',
                    hintStyle: GoogleFonts.dmSans(color: kMuted, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded, color: kMuted),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                        icon: const Icon(Icons.close_rounded, color: kMuted),
                        onPressed: () { _searchCtrl.clear(); setState(() => _searchQuery = ''); })
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

            const SizedBox(height: 14),

            // ── CATEGORY CHIPS
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final cat = categories[i];
                  final selected = cat == _selectedCategory;
                  final color = cat == 'All' ? kLime : _categoryColor(cat);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? color : kCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: selected ? color : kMuted.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          if (cat != 'All') ...[
                            Icon(_categoryIcon(cat), size: 13, color: selected ? kDark : color),
                            const SizedBox(width: 5),
                          ],
                          Text(cat,
                              style: GoogleFonts.dmSans(
                                  color: selected ? kDark : kMuted,
                                  fontWeight: FontWeight.w700, fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            const SizedBox(height: 12),

            // ── PRICE FILTER INDICATOR
            if (_priceMin != null || _priceMax != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => setState(() { _priceMin = null; _priceMax = null; }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: kAccentBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kAccentBlue.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.filter_alt_rounded, color: kAccentBlue, size: 13),
                        const SizedBox(width: 5),
                        Text(
                          'Price: \$${_priceMin?.toStringAsFixed(0) ?? '0'} – \$${_priceMax?.toStringAsFixed(0) ?? '∞'}   ✕',
                          style: GoogleFonts.dmSans(color: kAccentBlue, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ── RESULTS BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  Text('${products.length} Products',
                      style: GoogleFonts.dmSans(color: kMuted, fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                  if (cart.sortBy != 'popular')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: kLime.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: kLime.withOpacity(0.3)),
                      ),
                      child: Text(_sortLabel(cart.sortBy),
                          style: GoogleFonts.dmSans(color: kLime, fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  const Spacer(),
                  // Compare button (New Feature)
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/compare'),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.compare_arrows_rounded, color: kAccentPurple, size: 18),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isGrid = !_isGrid),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(10)),
                      child: Icon(_isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded,
                          color: kLime, size: 18),
                    ),
                  ),
                ],
              ),
            ),

            // ── PRODUCT LIST
            Expanded(
              child: products.isEmpty
                  ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.search_off_rounded, color: kMuted, size: 48),
                      const SizedBox(height: 12),
                      Text('No products found',
                          style: GoogleFonts.dmSans(color: kMuted, fontSize: 16)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => setState(() {
                          _selectedCategory = 'All';
                          _searchQuery = '';
                          _searchCtrl.clear();
                          _priceMin = null;
                          _priceMax = null;
                        }),
                        child: Text('Clear filters',
                            style: GoogleFonts.dmSans(color: kLime, fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ))
                  : _isGrid
                  ? GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemCount: products.length,
                itemBuilder: (_, i) =>
                    _ProductGridCard(product: products[i])
                        .animate()
                        .fadeIn(delay: Duration(milliseconds: i * 50), duration: 350.ms)
                        .slideY(begin: 0.12),
              )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: products.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ProductListCard(product: products[i])
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: i * 50), duration: 350.ms)
                      .slideX(begin: -0.08),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _sortLabel(String s) {
    switch (s) {
      case 'price_low': return 'Price: Low';
      case 'price_high': return 'Price: High';
      case 'rating': return 'Top Rated';
      case 'newest': return 'Newest';
      default: return 'Popular';
    }
  }

  void _showSortSheet(BuildContext context, CartProvider cart) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) {
        final options = [
          ('popular', Icons.trending_up_rounded, 'Most Popular'),
          ('rating', Icons.star_rounded, 'Top Rated'),
          ('newest', Icons.fiber_new_rounded, 'Newest First'),
          ('price_low', Icons.arrow_upward_rounded, 'Price: Low to High'),
          ('price_high', Icons.arrow_downward_rounded, 'Price: High to Low'),
        ];
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sort By',
                  style: GoogleFonts.dmSans(color: kLime, fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              ...options.map((o) {
                final selected = cart.sortBy == o.$1;
                return GestureDetector(
                  onTap: () { cart.setSortBy(o.$1); Navigator.pop(context); },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: selected ? kLime.withOpacity(0.12) : kCard2,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? kLime.withOpacity(0.5) : Colors.transparent),
                    ),
                    child: Row(
                      children: [
                        Icon(o.$2, color: selected ? kLime : kMuted, size: 18),
                        const SizedBox(width: 12),
                        Text(o.$3,
                            style: GoogleFonts.dmSans(
                                color: selected ? kWhite : kMuted, fontWeight: FontWeight.w600)),
                        if (selected) ...[
                          const Spacer(),
                          const Icon(Icons.check_rounded, color: kLime, size: 16),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // Price Filter Sheet (New Feature)
  void _showFilterSheet(BuildContext context) {
    double tempMin = _priceMin ?? 0;
    double tempMax = _priceMax ?? 5000;
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setS) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter by Price',
                    style: GoogleFonts.dmSans(color: kLime, fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${tempMin.toStringAsFixed(0)}',
                        style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w700)),
                    Text('–', style: GoogleFonts.dmSans(color: kMuted)),
                    Text('\$${tempMax.toStringAsFixed(0)}',
                        style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w700)),
                  ],
                ),
                RangeSlider(
                  values: RangeValues(tempMin, tempMax),
                  min: 0,
                  max: 5000,
                  divisions: 50,
                  activeColor: kLime,
                  inactiveColor: kMuted.withOpacity(0.3),
                  onChanged: (v) => setS(() { tempMin = v.start; tempMax = v.end; }),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() { _priceMin = null; _priceMax = null; });
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            color: kCard2,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('Reset', textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(color: kMuted, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          setState(() { _priceMin = tempMin; _priceMax = tempMax; });
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            color: kLime,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('Apply Filter', textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(color: kDark, fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  HERO BANNER
// ─────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  final AnimationController controller;
  const _HeroBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF1A2A0A), Color(0xFF0D1A05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: kLime.withOpacity(0.25)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned(
                right: -20, top: -20,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (_, __) => Container(
                    width: 130, height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kLime.withOpacity(0.08 + controller.value * 0.05),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: kLime, borderRadius: BorderRadius.circular(6)),
                            child: Text('LIMITED OFFER',
                                style: GoogleFonts.dmSans(
                                    color: kDark, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1)),
                          ),
                          const SizedBox(height: 6),
                          Text('Use code LIME20',
                              style: GoogleFonts.dmSans(
                                  color: kWhite, fontSize: 17, fontWeight: FontWeight.w800, height: 1.1)),
                          Text('for 20% off your order',
                              style: GoogleFonts.dmSans(color: kMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/settings'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(color: kLime, borderRadius: BorderRadius.circular(10)),
                        child: Text('Claim',
                            style: GoogleFonts.dmSans(
                                color: kDark, fontWeight: FontWeight.w800, fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ICON CHIP
// ─────────────────────────────────────────────
class _IconChip extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final int badge;
  final Color badgeColor;

  const _IconChip({
    required this.icon,
    required this.onTap,
    this.badge = 0,
    this.badgeColor = Colors.redAccent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: badges.Badge(
        showBadge: badge > 0,
        badgeContent: Text('$badge',
            style: GoogleFonts.dmSans(color: kDark, fontSize: 9, fontWeight: FontWeight.w800)),
        badgeStyle: badges.BadgeStyle(badgeColor: badgeColor),
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: kWhite, size: 19),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PRODUCT GRID CARD
// ─────────────────────────────────────────────
class _ProductGridCard extends StatelessWidget {
  final Product product;
  const _ProductGridCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final inWish = cart.isInWishlist(product.id);
    final catColor = _categoryColor(product.category);

    return GestureDetector(
      onTap: () {
        cart.addRecentlyViewed(product.id);
        Navigator.pushNamed(context, '/details', arguments: product);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: kMuted.withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    _buildNetworkImage(product.imageUrl, width: double.infinity),
                    Positioned(
                      bottom: 0, left: 0, right: 0, height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [kCard.withOpacity(0.85), Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8, right: 8,
                      child: GestureDetector(
                        onTap: () => context.read<CartProvider>().toggleWishlist(product.id),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: kDark.withOpacity(0.75), shape: BoxShape.circle),
                          child: Icon(
                              inWish ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: inWish ? Colors.redAccent : kMuted, size: 15),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8, left: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(color: catColor, borderRadius: BorderRadius.circular(6)),
                            child: Text(product.category,
                                style: GoogleFonts.dmSans(color: kDark, fontSize: 9, fontWeight: FontWeight.w800)),
                          ),
                          if (product.isNew) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(color: kAccentBlue, borderRadius: BorderRadius.circular(6)),
                              child: Text('NEW',
                                  style: GoogleFonts.dmSans(color: kDark, fontSize: 9, fontWeight: FontWeight.w800)),
                            ),
                          ],
                          if (product.isBestseller) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(6)),
                              child: Text('BEST',
                                  style: GoogleFonts.dmSans(color: kDark, fontSize: 9, fontWeight: FontWeight.w800)),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (product.discountPercent > 0)
                      Positioned(
                        bottom: 8, left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(6)),
                          child: Text('-${product.discountPercent.round()}%',
                              style: GoogleFonts.dmSans(color: kDark, fontSize: 9, fontWeight: FontWeight.w800)),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand tag (New Feature)
                    if (product.brand.isNotEmpty)
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/brand', arguments: product.brand),
                        child: Text(product.brand,
                            style: GoogleFonts.dmSans(color: catColor, fontSize: 9, fontWeight: FontWeight.w700)),
                      ),
                    Text(product.name,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.dmSans(color: kWhite, fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text('\$${product.price.toStringAsFixed(0)}',
                            style: GoogleFonts.dmSans(color: kLime, fontSize: 14, fontWeight: FontWeight.w800)),
                        if (product.originalPrice > 0) ...[
                          const SizedBox(width: 5),
                          Text('\$${product.originalPrice.toStringAsFixed(0)}',
                              style: GoogleFonts.dmSans(
                                  color: kMuted, fontSize: 10, decoration: TextDecoration.lineThrough)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    StarRating(rating: product.rating, reviewCount: product.reviewCount, compact: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PRODUCT LIST CARD
// ─────────────────────────────────────────────
class _ProductListCard extends StatelessWidget {
  final Product product;
  const _ProductListCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColor(product.category);
    return GestureDetector(
      onTap: () {
        context.read<CartProvider>().addRecentlyViewed(product.id);
        Navigator.pushNamed(context, '/details', arguments: product);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kMuted.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildNetworkImage(product.imageUrl, width: 88, height: 88),
                ),
                if (product.isBestseller)
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                      child: const Icon(Icons.star_rounded, color: Colors.white, size: 9),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                            color: catColor.withOpacity(0.15), borderRadius: BorderRadius.circular(5)),
                        child: Text(product.category,
                            style: GoogleFonts.dmSans(color: catColor, fontSize: 9, fontWeight: FontWeight.w800)),
                      ),
                      if (product.isNew) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: kAccentBlue.withOpacity(0.15), borderRadius: BorderRadius.circular(5)),
                          child: Text('NEW',
                              style: GoogleFonts.dmSans(color: kAccentBlue, fontSize: 9, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (product.brand.isNotEmpty)
                    Text(product.brand,
                        style: GoogleFonts.dmSans(color: catColor.withOpacity(0.7), fontSize: 9)),
                  Text(product.name,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(color: kWhite, fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  StarRating(rating: product.rating, reviewCount: product.reviewCount, compact: true),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('\$${product.price.toStringAsFixed(2)}',
                          style: GoogleFonts.dmSans(color: kLime, fontSize: 15, fontWeight: FontWeight.w800)),
                      if (product.originalPrice > 0) ...[
                        const SizedBox(width: 6),
                        Text('\$${product.originalPrice.toStringAsFixed(0)}',
                            style: GoogleFonts.dmSans(
                                color: kMuted, fontSize: 11, decoration: TextDecoration.lineThrough)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: kMuted, size: 14),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PRODUCT DETAILS SCREEN
// ─────────────────────────────────────────────
class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  int _qty = 1;
  bool _addedToCart = false;
  late TabController _tabController;
  bool _showReviewForm = false;
  final _reviewCtrl = TextEditingController();
  double _reviewRating = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reviewCtrl.dispose();
    super.dispose();
  }

  List<Review> get _reviews => kReviews[widget.product.id] ?? [];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final inWish = cart.isInWishlist(widget.product.id);
    final catColor = _categoryColor(widget.product.category);
    final userRating = cart.userRatings[widget.product.id];

    return Scaffold(
      backgroundColor: kDark,
      body: SafeArea(
        child: Column(
          children: [
            // ── IMAGE HERO
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                  child: _buildNetworkImage(widget.product.imageUrl, width: double.infinity, height: 290),
                ),
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [kDark.withOpacity(0.9), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12, left: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(color: kDark.withOpacity(0.7), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite, size: 17),
                    ),
                  ),
                ),
                Positioned(
                  top: 12, right: 12,
                  child: GestureDetector(
                    onTap: () => cart.toggleWishlist(widget.product.id),
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(color: kDark.withOpacity(0.7), shape: BoxShape.circle),
                      child: Icon(
                          inWish ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: inWish ? Colors.redAccent : kWhite, size: 18),
                    ),
                  ),
                ),
                // Share button (New Feature)
                Positioned(
                  top: 52, right: 12,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: kCard,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        content: Text('Link copied to clipboard!',
                            style: GoogleFonts.dmSans(color: kWhite)),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(color: kDark.withOpacity(0.7), shape: BoxShape.circle),
                      child: const Icon(Icons.share_rounded, color: kWhite, size: 18),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 14, left: 16, right: 16,
                  child: Row(
                    children: [
                      // Brand chip (New Feature)
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/brand', arguments: widget.product.brand),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: catColor, borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Icon(_categoryIcon(widget.product.category), color: kDark, size: 13),
                              const SizedBox(width: 4),
                              Text(widget.product.brand.isNotEmpty ? widget.product.brand : widget.product.category,
                                  style: GoogleFonts.dmSans(color: kDark, fontSize: 11, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(color: kLime, borderRadius: BorderRadius.circular(24)),
                        child: Row(
                          children: [
                            Text('\$${widget.product.price.toStringAsFixed(2)}',
                                style: GoogleFonts.dmSans(color: kDark, fontWeight: FontWeight.w900, fontSize: 16)),
                            if (widget.product.originalPrice > 0) ...[
                              const SizedBox(width: 6),
                              Text('\$${widget.product.originalPrice.toStringAsFixed(0)}',
                                  style: GoogleFonts.dmSans(
                                      color: kDark.withOpacity(0.5),
                                      fontSize: 11,
                                      decoration: TextDecoration.lineThrough)),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(widget.product.name,
                                maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSans(
                                    color: kWhite, fontSize: 18, fontWeight: FontWeight.w800, height: 1.1)),
                          ),
                          const SizedBox(width: 8),
                          StarRating(rating: widget.product.rating, reviewCount: widget.product.reviewCount),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (widget.product.specs.isNotEmpty)
                      SizedBox(
                        height: 32,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: widget.product.specs.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 6),
                          itemBuilder: (_, i) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: catColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: catColor.withOpacity(0.3)),
                            ),
                            child: Text(widget.product.specs[i],
                                style: GoogleFonts.dmSans(color: catColor, fontSize: 11, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('About this product',
                              style: GoogleFonts.dmSans(color: kLime, fontSize: 13, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Text(widget.product.description,
                              style: GoogleFonts.dmSans(color: kMuted, fontSize: 13, height: 1.65)),
                          const SizedBox(height: 20),

                          // Qty row
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: kCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: kMuted.withOpacity(0.15)),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Quantity', style: GoogleFonts.dmSans(color: kMuted, fontSize: 11)),
                                    const SizedBox(height: 2),
                                    Text(
                                      '\$${(widget.product.price * _qty).toStringAsFixed(2)}',
                                      style: GoogleFonts.dmSans(
                                          color: kLime, fontWeight: FontWeight.w800, fontSize: 18),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                _QtyControl(
                                  qty: _qty,
                                  onDecrement: () { if (_qty > 1) setState(() => _qty--); },
                                  onIncrement: () => setState(() => _qty++),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: LimeButton(
                                  label: _addedToCart ? '✓ Added!' : 'Add to Cart',
                                  icon: _addedToCart ? null : Icons.shopping_bag_outlined,
                                  onTap: () {
                                    cart.addToCart(widget.product, _qty);
                                    setState(() => _addedToCart = true);
                                    HapticFeedback.mediumImpact();
                                    Future.delayed(const Duration(seconds: 2), () {
                                      if (mounted) setState(() => _addedToCart = false);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      backgroundColor: kCard,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      content: Row(
                                        children: [
                                          const Icon(Icons.check_circle_rounded, color: kLime),
                                          const SizedBox(width: 10),
                                          Text('Added to cart', style: GoogleFonts.dmSans(color: kWhite)),
                                        ],
                                      ),
                                      action: SnackBarAction(
                                        label: 'View Cart',
                                        textColor: kLime,
                                        onPressed: () => Navigator.pushNamed(context, '/cart'),
                                      ),
                                    ));
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => cart.toggleWishlist(widget.product.id),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: inWish ? Colors.redAccent.withOpacity(0.15) : kCard,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: inWish ? Colors.redAccent.withOpacity(0.4) : kMuted.withOpacity(0.2)),
                                  ),
                                  child: Icon(
                                      inWish ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                      color: inWish ? Colors.redAccent : kMuted, size: 22),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          LimeButton(
                            label: 'View Cart',
                            icon: Icons.shopping_cart_outlined,
                            outline: true,
                            width: double.infinity,
                            onTap: () => Navigator.pushNamed(context, '/cart'),
                          ),

                          const SizedBox(height: 24),

                          // ── REVIEWS SECTION (New Feature)
                          Row(
                            children: [
                              Text('Reviews',
                                  style: GoogleFonts.dmSans(color: kLime, fontSize: 14, fontWeight: FontWeight.w800)),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => setState(() => _showReviewForm = !_showReviewForm),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: kLime.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: kLime.withOpacity(0.3)),
                                  ),
                                  child: Text('+ Write Review',
                                      style: GoogleFonts.dmSans(
                                          color: kLime, fontSize: 11, fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Review form
                          if (_showReviewForm)
                            Container(
                              padding: const EdgeInsets.all(14),
                              margin: const EdgeInsets.only(bottom: 14),
                              decoration: BoxDecoration(
                                color: kCard,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: kLime.withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Your Rating',
                                      style: GoogleFonts.dmSans(color: kMuted, fontSize: 11)),
                                  const SizedBox(height: 6),
                                  InteractiveStarRating(
                                    productId: widget.product.id,
                                    initialRating: _reviewRating,
                                    onRated: (r) => setState(() => _reviewRating = r),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: kDark, borderRadius: BorderRadius.circular(10)),
                                    child: TextField(
                                      controller: _reviewCtrl,
                                      style: GoogleFonts.dmSans(color: kWhite, fontSize: 13),
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: 'Share your experience…',
                                        hintStyle: GoogleFonts.dmSans(color: kMuted, fontSize: 13),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.all(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      if (_reviewRating > 0) {
                                        cart.setUserRating(widget.product.id, _reviewRating);
                                        setState(() { _showReviewForm = false; _reviewCtrl.clear(); });
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          backgroundColor: kCard,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          content: Text('Review submitted! Thank you.',
                                              style: GoogleFonts.dmSans(color: kWhite)),
                                        ));
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 11),
                                      decoration: BoxDecoration(
                                          color: kLime, borderRadius: BorderRadius.circular(10)),
                                      child: Text('Submit Review', textAlign: TextAlign.center,
                                          style: GoogleFonts.dmSans(
                                              color: kDark, fontWeight: FontWeight.w800, fontSize: 13)),
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1),

                          // User's previous rating
                          if (userRating != null && !_showReviewForm)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: kLime.withOpacity(0.07),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: kLime.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.person_rounded, color: kLime, size: 16),
                                  const SizedBox(width: 8),
                                  Text('Your rating: ',
                                      style: GoogleFonts.dmSans(color: kMuted, fontSize: 12)),
                                  ...List.generate(5, (i) => Icon(
                                    i < userRating ? Icons.star_rounded : Icons.star_border_rounded,
                                    color: kLime, size: 14,
                                  )),
                                ],
                              ),
                            ),

                          // Reviews list
                          if (_reviews.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text('No reviews yet. Be the first!',
                                  style: GoogleFonts.dmSans(color: kMuted, fontSize: 12)),
                            )
                          else
                            ..._reviews.map((r) => Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: kCard,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: kMuted.withOpacity(0.15)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 30, height: 30,
                                        decoration: BoxDecoration(
                                          color: catColor.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(r.author[0],
                                              style: GoogleFonts.dmSans(
                                                  color: catColor, fontWeight: FontWeight.w800, fontSize: 12)),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(r.author,
                                              style: GoogleFonts.dmSans(
                                                  color: kWhite, fontWeight: FontWeight.w700, fontSize: 12)),
                                          Text(r.date,
                                              style: GoogleFonts.dmSans(color: kMuted, fontSize: 10)),
                                        ],
                                      ),
                                      const Spacer(),
                                      Row(children: List.generate(5, (i) => Icon(
                                        i < r.rating ? Icons.star_rounded : Icons.star_border_rounded,
                                        color: kLime, size: 12,
                                      ))),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(r.comment,
                                      style: GoogleFonts.dmSans(color: kMuted, fontSize: 12, height: 1.5)),
                                ],
                              ),
                            )),

                          // Similar Products (New Feature)
                          const SizedBox(height: 20),
                          Text('More from ${widget.product.category}',
                              style: GoogleFonts.dmSans(color: kLime, fontSize: 13, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 130,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: kProducts.where((p) => p.category == widget.product.category && p.id != widget.product.id).length,
                              itemBuilder: (_, i) {
                                final similar = kProducts.where((p) => p.category == widget.product.category && p.id != widget.product.id).toList()[i];
                                return GestureDetector(
                                  onTap: () {
                                    cart.addRecentlyViewed(similar.id);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: similar)),
                                    );
                                  },
                                  child: Container(
                                    width: 110,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: kCard,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: kMuted.withOpacity(0.15)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                          child: _buildNetworkImage(similar.imageUrl, width: 110, height: 72),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(similar.name,
                                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.dmSans(
                                                      color: kWhite, fontSize: 9, fontWeight: FontWeight.w700)),
                                              Text('\$${similar.price.toStringAsFixed(0)}',
                                                  style: GoogleFonts.dmSans(
                                                      color: kLime, fontSize: 11, fontWeight: FontWeight.w800)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  QTY CONTROLS
// ─────────────────────────────────────────────
class _QtyControl extends StatelessWidget {
  final int qty;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  const _QtyControl({required this.qty, required this.onDecrement, required this.onIncrement});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kCard2, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          _QtyBtn(icon: Icons.remove_rounded, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text('$qty',
                style: GoogleFonts.dmSans(color: kWhite, fontSize: 15, fontWeight: FontWeight.w700)),
          ),
          _QtyBtn(icon: Icons.add_rounded, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: kLime.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: kLime, size: 18),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CART SCREEN
// ─────────────────────────────────────────────
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items.values.toList();

    return Scaffold(
      backgroundColor: kDark,
      appBar: AppBar(
        backgroundColor: kDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('My Cart (${cart.itemCount})',
            style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: kMuted),
            onPressed: () => Navigator.pushNamed(context, '/orders'),
          ),
          if (items.isNotEmpty)
            TextButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: kCard,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: Text('Clear Cart?', style: GoogleFonts.dmSans(color: kWhite)),
                  content: Text('Remove all items from your cart.',
                      style: GoogleFonts.dmSans(color: kMuted)),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel', style: GoogleFonts.dmSans(color: kMuted))),
                    TextButton(
                        onPressed: () { cart.clearCart(); Navigator.pop(context); },
                        child: Text('Clear', style: GoogleFonts.dmSans(color: Colors.redAccent))),
                  ],
                ),
              ),
              child: Text('Clear', style: GoogleFonts.dmSans(color: Colors.redAccent, fontSize: 13)),
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: kCard, shape: BoxShape.circle),
              child: const Icon(Icons.shopping_bag_outlined, color: kMuted, size: 48),
            ),
            const SizedBox(height: 20),
            Text('Your cart is empty',
                style: GoogleFonts.dmSans(color: kWhite, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Add some items to get started',
                style: GoogleFonts.dmSans(color: kMuted, fontSize: 13)),
            const SizedBox(height: 24),
            LimeButton(label: 'Continue Shopping', icon: Icons.storefront_rounded,
                onTap: () => Navigator.pop(context)),
          ],
        ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9)),
      )
          : Column(
        children: [
          if (cart.totalPrice > 500)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kLime.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kLime.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_offer_rounded, color: kLime, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('10% bulk discount applied on orders over \$500!',
                        style: GoogleFonts.dmSans(color: kLime, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.3),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) => _CartItemCard(item: items[i])
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: i * 60), duration: 350.ms)
                  .slideX(begin: -0.08),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(top: BorderSide(color: kMuted.withOpacity(0.15))),
            ),
            child: Column(
              children: [
                _SummaryRow('Subtotal', '\$${cart.totalPrice.toStringAsFixed(2)}'),
                if (cart.discountAmount > 0) ...[
                  const SizedBox(height: 6),
                  _SummaryRow('Bulk Discount (10%)',
                      '-\$${cart.discountAmount.toStringAsFixed(2)}', valueColor: Colors.greenAccent),
                ],
                if (cart.promoDiscount > 0) ...[
                  const SizedBox(height: 6),
                  _SummaryRow('Promo (${cart.promoCode.toUpperCase()})',
                      '-\$${cart.promoDiscount.toStringAsFixed(2)}', valueColor: Colors.greenAccent),
                ],
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping', style: GoogleFonts.dmSans(color: kMuted, fontSize: 13)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/shipping'),
                      child: Row(
                        children: [
                          Text(
                            cart.selectedShipping.price == 0
                                ? 'FREE'
                                : '\$${cart.selectedShipping.price.toStringAsFixed(2)}',
                            style: GoogleFonts.dmSans(
                                color: cart.selectedShipping.price == 0 ? Colors.greenAccent : kWhite,
                                fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.edit_rounded, color: kLime, size: 13),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: kMuted, height: 18),
                _SummaryRow('Total', '\$${cart.finalPrice.toStringAsFixed(2)}', large: true),
                const SizedBox(height: 14),
                LimeButton(
                  label: 'Select Shipping & Checkout',
                  icon: Icons.arrow_forward_rounded,
                  width: double.infinity,
                  onTap: () => Navigator.pushNamed(context, '/shipping'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool large;
  const _SummaryRow(this.label, this.value, {this.valueColor, this.large = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.dmSans(
                color: large ? kWhite : kMuted,
                fontWeight: large ? FontWeight.w800 : FontWeight.w500,
                fontSize: large ? 15 : 13)),
        Text(value,
            style: GoogleFonts.dmSans(
                color: valueColor ?? (large ? kLime : kWhite),
                fontWeight: FontWeight.w800,
                fontSize: large ? 20 : 13)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  CART ITEM CARD
// ─────────────────────────────────────────────
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final catColor = _categoryColor(item.product.category);

    return Dismissible(
      key: ValueKey(item.product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(color: Colors.red.withOpacity(0.25), borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.delete_rounded, color: Colors.redAccent),
      ),
      onDismissed: (_) => cart.remove(item.product.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kLime,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: kLime.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildNetworkImage(item.product.imageUrl, width: 72, height: 72),
                ),
                Positioned(
                  top: 0, left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                        color: catColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12), bottomRight: Radius.circular(6))),
                    child: Text(item.product.category,
                        style: GoogleFonts.dmSans(color: kDark, fontSize: 8, fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(color: kDark, fontWeight: FontWeight.w800, fontSize: 13)),
                  const SizedBox(height: 3),
                  Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                      style: GoogleFonts.dmSans(color: kDark, fontWeight: FontWeight.w800, fontSize: 16)),
                  Text('\$${item.product.price.toStringAsFixed(2)} each',
                      style: GoogleFonts.dmSans(color: kDark.withOpacity(0.45), fontSize: 10)),
                ],
              ),
            ),
            Column(
              children: [
                _DarkQtyControl(
                  qty: item.quantity,
                  onDecrement: () => cart.decrement(item.product.id),
                  onIncrement: () => cart.increment(item.product.id),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => cart.remove(item.product.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.12), borderRadius: BorderRadius.circular(7)),
                    child: Text('Remove',
                        style: GoogleFonts.dmSans(color: Colors.red[800], fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DarkQtyControl extends StatelessWidget {
  final int qty;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  const _DarkQtyControl({required this.qty, required this.onDecrement, required this.onIncrement});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kDark.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          _DarkQtyBtn(icon: Icons.remove_rounded, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('$qty',
                style: GoogleFonts.dmSans(color: kDark, fontSize: 14, fontWeight: FontWeight.w800)),
          ),
          _DarkQtyBtn(icon: Icons.add_rounded, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _DarkQtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _DarkQtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: kDark.withOpacity(0.12), borderRadius: BorderRadius.circular(7)),
        child: Icon(icon, color: kDark, size: 16),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SHIPPING SCREEN
// ─────────────────────────────────────────────
class ShippingScreen extends StatelessWidget {
  const ShippingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: kDark,
      appBar: AppBar(
        backgroundColor: kDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Shipping Method',
            style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w800)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [kLime.withOpacity(0.12), kLime.withOpacity(0.04)]),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kLime.withOpacity(0.25)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_shipping_rounded, color: kLime, size: 26),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Choose your delivery speed',
                                  style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w700, fontSize: 13)),
                              Text('Free standard shipping on all orders',
                                  style: GoogleFonts.dmSans(color: kMuted, fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text('Available Options',
                      style: GoogleFonts.dmSans(color: kLime, fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),

                  ...kShippingMethods.asMap().entries.map((entry) {
                    final method = entry.value;
                    final selected = cart.selectedShippingId == method.id;
                    return GestureDetector(
                      onTap: () => cart.selectShipping(method.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: selected ? kLime : kCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: selected ? kLime : kMuted.withOpacity(0.2), width: selected ? 2 : 1),
                          boxShadow: selected
                              ? [BoxShadow(color: kLime.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                  color: selected ? kDark.withOpacity(0.12) : kLime.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(method.icon, color: selected ? kDark : kLime, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(method.name,
                                      style: GoogleFonts.dmSans(
                                          color: selected ? kDark : kWhite,
                                          fontWeight: FontWeight.w800, fontSize: 13)),
                                  Text(method.subtitle,
                                      style: GoogleFonts.dmSans(
                                          color: selected ? kDark.withOpacity(0.55) : kMuted, fontSize: 11)),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Icon(Icons.schedule_rounded, size: 11,
                                          color: selected ? kDark.withOpacity(0.55) : kMuted),
                                      const SizedBox(width: 3),
                                      Text(method.eta,
                                          style: GoogleFonts.dmSans(
                                              color: selected ? kDark.withOpacity(0.6) : kMuted, fontSize: 10)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  method.price == 0 ? 'FREE' : '\$${method.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.dmSans(
                                      color: selected ? kDark : (method.price == 0 ? Colors.greenAccent : kWhite),
                                      fontWeight: FontWeight.w800, fontSize: 14),
                                ),
                                const SizedBox(height: 6),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 20, height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: selected ? kDark : Colors.transparent,
                                    border: Border.all(color: selected ? kDark : kMuted, width: 2),
                                  ),
                                  child: selected
                                      ? const Icon(Icons.check_rounded, color: kLime, size: 13)
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: Duration(milliseconds: entry.key * 70), duration: 300.ms).slideX(begin: 0.08);
                  }),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(top: BorderSide(color: kMuted.withOpacity(0.15))),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Method', style: GoogleFonts.dmSans(color: kMuted, fontSize: 12)),
                    Text(cart.selectedShipping.name,
                        style: GoogleFonts.dmSans(color: kLime, fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ETA', style: GoogleFonts.dmSans(color: kMuted, fontSize: 12)),
                    Text(cart.selectedShipping.eta,
                        style: GoogleFonts.dmSans(color: kWhite, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 14),
                LimeButton(
                  label: 'Continue to Checkout',
                  icon: Icons.arrow_forward_rounded,
                  width: double.infinity,
                  onTap: () => Navigator.pushNamed(context, '/checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BRAND SCREEN (New Feature)
// ─────────────────────────────────────────────
class BrandScreen extends StatelessWidget {
  final String brand;
  const BrandScreen({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    final brandProducts = kProducts.where((p) => p.brand == brand).toList();

    return Scaffold(
      backgroundColor: kDark,
      appBar: AppBar(
        backgroundColor: kDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(brand, style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w800)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: kLime.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Text('${brandProducts.length} products',
                  style: GoogleFonts.dmSans(color: kLime, fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.68,
        ),
        itemCount: brandProducts.length,
        itemBuilder: (_, i) => _ProductGridCard(product: brandProducts[i])
            .animate()
            .fadeIn(delay: Duration(milliseconds: i * 60), duration: 400.ms)
            .slideY(begin: 0.12),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  COMPARE SCREEN (New Feature)
// ─────────────────────────────────────────────
class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});
  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  Product? _productA;
  Product? _productB;
  String _selectedCategory = 'Headphones';

  List<Product> get _categoryProducts =>
      kProducts.where((p) => p.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDark,
      appBar: AppBar(
        backgroundColor: kDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Compare Products',
            style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category selector
            Text('Select Category',
                style: GoogleFonts.dmSans(color: kLime, fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ['Headphones', 'Accessories', 'Wearables', 'Cameras', 'Furniture']
                    .map((cat) {
                  final sel = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedCategory = cat;
                      _productA = null;
                      _productB = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? _categoryColor(cat) : kCard,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(cat,
                          style: GoogleFonts.dmSans(
                              color: sel ? kDark : kMuted,
                              fontWeight: FontWeight.w700, fontSize: 12)),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Product A and B selectors
            Row(
              children: [
                Expanded(child: _ProductSelector(
                  label: 'Product A',
                  selected: _productA,
                  products: _categoryProducts,
                  onSelect: (p) => setState(() => _productA = p),
                )),
                const SizedBox(width: 12),
                Expanded(child: _ProductSelector(
                  label: 'Product B',
                  selected: _productB,
                  products: _categoryProducts,
                  onSelect: (p) => setState(() => _productB = p),
                )),
              ],
            ),

            if (_productA != null && _productB != null) ...[
              const SizedBox(height: 24),
              Text('Comparison', style: GoogleFonts.dmSans(color: kLime, fontSize: 14, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              _CompareRow('Price',
                '\$${_productA!.price.toStringAsFixed(2)}',
                '\$${_productB!.price.toStringAsFixed(2)}',
                aWins: _productA!.price < _productB!.price,
              ),
              _CompareRow('Rating',
                '${_productA!.rating}★',
                '${_productB!.rating}★',
                aWins: _productA!.rating > _productB!.rating,
              ),
              _CompareRow('Reviews',
                '${_productA!.reviewCount}',
                '${_productB!.reviewCount}',
                aWins: _productA!.reviewCount > _productB!.reviewCount,
              ),
              _CompareRow('Discount',
                _productA!.discountPercent > 0 ? '-${_productA!.discountPercent.round()}%' : 'None',
                _productB!.discountPercent > 0 ? '-${_productB!.discountPercent.round()}%' : 'None',
                aWins: _productA!.discountPercent > _productB!.discountPercent,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: LimeButton(
                      label: 'Add A to Cart',
                      onTap: () {
                        context.read<CartProvider>().addToCart(_productA!, 1);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: kCard, behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          content: Text('${_productA!.name} added to cart',
                              style: GoogleFonts.dmSans(color: kWhite)),
                        ));
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LimeButton(
                      label: 'Add B to Cart',
                      outline: true,
                      onTap: () {
                        context.read<CartProvider>().addToCart(_productB!, 1);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: kCard, behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          content: Text('${_productB!.name} added to cart',
                              style: GoogleFonts.dmSans(color: kWhite)),
                        ));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProductSelector extends StatelessWidget {
  final String label;
  final Product? selected;
  final List<Product> products;
  final ValueChanged<Product> onSelect;
  const _ProductSelector({required this.label, required this.selected, required this.products, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: kCard,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          builder: (_) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (_, i) {
              final p = products[i];
              return GestureDetector(
                onTap: () { onSelect(p); Navigator.pop(context); },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: kCard2, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(8),
                          child: _buildNetworkImage(p.imageUrl, width: 44, height: 44)),
                      const SizedBox(width: 10),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w700, fontSize: 12)),
                          Text('\$${p.price.toStringAsFixed(2)}',
                              style: GoogleFonts.dmSans(color: kLime, fontWeight: FontWeight.w700, fontSize: 11)),
                        ],
                      )),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected != null ? kLime.withOpacity(0.4) : kMuted.withOpacity(0.2)),
        ),
        child: selected == null
            ? Column(
          children: [
            const Icon(Icons.add_rounded, color: kLime, size: 28),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.dmSans(color: kMuted, fontSize: 12)),
          ],
        )
            : Column(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(8),
                child: _buildNetworkImage(selected!.imageUrl, width: double.infinity, height: 80)),
            const SizedBox(height: 6),
            Text(selected!.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w700, fontSize: 11)),
            Text('\$${selected!.price.toStringAsFixed(2)}',
                style: GoogleFonts.dmSans(color: kLime, fontWeight: FontWeight.w800, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _CompareRow extends StatelessWidget {
  final String metric;
  final String valueA;
  final String valueB;
  final bool aWins;
  const _CompareRow(this.metric, this.valueA, this.valueB, {required this.aWins});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Text(valueA,
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                    color: aWins ? kLime : kMuted,
                    fontWeight: aWins ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 13)),
          ),
          SizedBox(width: 80,
            child: Text(metric, textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(color: kMuted, fontSize: 11)),
          ),
          Expanded(
            child: Text(valueB,
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                    color: !aWins ? kLime : kMuted,
                    fontWeight: !aWins ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ORDER HISTORY SCREEN (New Feature)
// ─────────────────────────────────────────────
class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final demoOrders = [
      {'id': '#LS-4821', 'date': 'May 12, 2025', 'total': '\$449.98', 'status': 'Delivered', 'items': 'Sony WH-1000XM5, Logitech MX Master 3S'},
      {'id': '#LS-3917', 'date': 'Apr 28, 2025', 'total': '\$1,795.00', 'status': 'Delivered', 'items': 'Herman Miller Aeron Chair'},
      {'id': '#LS-3204', 'date': 'Mar 15, 2025', 'total': '\$299.99', 'status': 'Returned', 'items': 'Garmin Fenix 7X Sapphire'},
    ];

    return Scaffold(
      backgroundColor: kDark,
      appBar: AppBar(
        backgroundColor: kDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Order History',
            style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w800)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoOrders.length,
        itemBuilder: (_, i) {
          final order = demoOrders[i];
          final isDelivered = order['status'] == 'Delivered';
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kMuted.withOpacity(0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(order['id']!,
                        style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w800, fontSize: 14)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDelivered ? Colors.greenAccent.withOpacity(0.12) : Colors.redAccent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(order['status']!,
                          style: GoogleFonts.dmSans(
                              color: isDelivered ? Colors.greenAccent : Colors.redAccent,
                              fontWeight: FontWeight.w700, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(order['items']!,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(color: kMuted, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, color: kMuted, size: 12),
                    const SizedBox(width: 4),
                    Text(order['date']!, style: GoogleFonts.dmSans(color: kMuted, fontSize: 11)),
                    const Spacer(),
                    Text(order['total']!,
                        style: GoogleFonts.dmSans(color: kLime, fontWeight: FontWeight.w800, fontSize: 15)),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: i * 80), duration: 350.ms).slideY(begin: 0.1);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ADVANCED SETTINGS SCREEN
// ─────────────────────────────────────────────
class AdvancedSettingsScreen extends StatefulWidget {
  const AdvancedSettingsScreen({super.key});
  @override
  State<AdvancedSettingsScreen> createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  final _promoCtrl = TextEditingController();
  String? _promoMsg;
  bool _promoSuccess = false;

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: kDark,
      appBar: AppBar(
        backgroundColor: kDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Settings',
            style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _SectionHeader(icon: Icons.add_box_rounded, title: 'Order Add-ons'),
            const SizedBox(height: 12),
            _SettingToggleTile(
              icon: Icons.card_giftcard_rounded,
              title: 'Gift Wrapping',
              subtitle: 'Premium gift packaging with message card',
              price: '+\$5.99',
              value: cart.giftWrapping,
              onChanged: (_) => cart.toggleGiftWrapping(),
            ),
            _SettingToggleTile(
              icon: Icons.flash_on_rounded,
              title: 'Express Handling',
              subtitle: 'Priority warehouse processing in 1 hour',
              price: '+\$9.99',
              value: cart.expressHandling,
              onChanged: (_) => cart.toggleExpressHandling(),
            ),
            _SettingToggleTile(
              icon: Icons.security_rounded,
              title: 'Package Insurance',
              subtitle: 'Full coverage against loss or damage',
              price: '+\$4.99',
              value: cart.insuranceAdded,
              onChanged: (_) => cart.toggleInsurance(),
            ),
            _SettingToggleTile(
              icon: Icons.draw_rounded,
              title: 'Signature Required',
              subtitle: 'Requires your signature upon delivery',
              price: 'FREE',
              priceColor: Colors.greenAccent,
              value: cart.signatureRequired,
              onChanged: (_) => cart.toggleSignature(),
            ),

            const SizedBox(height: 24),

            _SectionHeader(icon: Icons.discount_rounded, title: 'Promo Code'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kMuted.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cart.promoApplied) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Code "${cart.promoCode.toUpperCase()}" — 20% off applied!',
                              style: GoogleFonts.dmSans(
                                  color: Colors.greenAccent, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => cart.removePromo(),
                            child: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Text('Enter promo code', style: GoogleFonts.dmSans(color: kMuted, fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: kDark,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kMuted.withOpacity(0.25)),
                            ),
                            child: TextField(
                              controller: _promoCtrl,
                              style: GoogleFonts.dmSans(
                                  color: kWhite, letterSpacing: 1.5, fontWeight: FontWeight.w700),
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                hintText: 'e.g. LIME20',
                                hintStyle: GoogleFonts.dmSans(color: kMuted, fontSize: 13),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            final ok = cart.applyPromoCode(_promoCtrl.text);
                            setState(() {
                              _promoSuccess = ok;
                              _promoMsg = ok ? '20% discount applied!' : 'Invalid code. Try LIME20';
                            });
                            if (ok) _promoCtrl.clear();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                            decoration: BoxDecoration(color: kLime, borderRadius: BorderRadius.circular(10)),
                            child: Text('Apply',
                                style: GoogleFonts.dmSans(color: kDark, fontWeight: FontWeight.w800)),
                          ),
                        ),
                      ],
                    ),
                    if (_promoMsg != null) ...[
                      const SizedBox(height: 8),
                      Text(_promoMsg!,
                          style: GoogleFonts.dmSans(
                              color: _promoSuccess ? Colors.greenAccent : Colors.redAccent,
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: kLime.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                      child: Text('Hint: Use code LIME20 for 20% off',
                          style: GoogleFonts.dmSans(color: kLime, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            _SectionHeader(icon: Icons.notifications_rounded, title: 'Notifications'),
            const SizedBox(height: 12),
            _SettingToggleTile(
              icon: Icons.sms_rounded,
              title: 'SMS Notifications',
              subtitle: 'Receive order updates via SMS',
              value: cart.smsNotifications,
              onChanged: (_) => cart.toggleSms(),
            ),
            _SettingToggleTile(
              icon: Icons.email_rounded,
              title: 'Email Notifications',
              subtitle: 'Receive receipts and order status emails',
              value: cart.emailNotifications,
              onChanged: (_) => cart.toggleEmail(),
            ),

            const SizedBox(height: 24),

            if (cart.addonsTotal > 0 || cart.promoDiscount > 0) ...[
              _SectionHeader(icon: Icons.receipt_long_rounded, title: 'Current Add-ons'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kLime.withOpacity(0.15)),
                ),
                child: Column(
                  children: [
                    if (cart.giftWrapping) _AddOnRow('Gift Wrapping', '+\$5.99'),
                    if (cart.expressHandling) _AddOnRow('Express Handling', '+\$9.99'),
                    if (cart.insuranceAdded) _AddOnRow('Package Insurance', '+\$4.99'),
                    if (cart.selectedShipping.price > 0)
                      _AddOnRow(cart.selectedShipping.name,
                          '+\$${cart.selectedShipping.price.toStringAsFixed(2)}'),
                    if (cart.promoDiscount > 0)
                      _AddOnRow('Promo Discount', '-\$${cart.promoDiscount.toStringAsFixed(2)}',
                          color: Colors.greenAccent),
                    const Divider(color: kMuted, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Net Add-ons',
                            style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w700)),
                        Text('\$${(cart.addonsTotal - cart.promoDiscount).toStringAsFixed(2)}',
                            style: GoogleFonts.dmSans(color: kLime, fontWeight: FontWeight.w800, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            _SectionHeader(icon: Icons.warning_amber_rounded, title: 'Danger Zone'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: kCard,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: Text('Reset Settings?', style: GoogleFonts.dmSans(color: kWhite)),
                  content: Text('This will clear all add-ons and promo codes.',
                      style: GoogleFonts.dmSans(color: kMuted)),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel', style: GoogleFonts.dmSans(color: kMuted))),
                    TextButton(
                        onPressed: () {
                          if (cart.giftWrapping) cart.toggleGiftWrapping();
                          if (cart.expressHandling) cart.toggleExpressHandling();
                          if (cart.insuranceAdded) cart.toggleInsurance();
                          if (cart.signatureRequired) cart.toggleSignature();
                          if (cart.promoApplied) cart.removePromo();
                          cart.selectShipping('standard');
                          Navigator.pop(context);
                          setState(() { _promoMsg = null; });
                        },
                        child: Text('Reset', style: GoogleFonts.dmSans(color: Colors.redAccent))),
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.restore_rounded, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reset All Settings',
                              style: GoogleFonts.dmSans(color: Colors.redAccent, fontWeight: FontWeight.w700)),
                          Text('Remove all add-ons and promo codes',
                              style: GoogleFonts.dmSans(color: kMuted, fontSize: 11)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Colors.redAccent, size: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: kLime, size: 16),
        const SizedBox(width: 8),
        Text(title, style: GoogleFonts.dmSans(color: kLime, fontSize: 14, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _SettingToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? price;
  final Color priceColor;

  const _SettingToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.price,
    this.priceColor = kLime,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: value ? kLime.withOpacity(0.07) : kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: value ? kLime.withOpacity(0.4) : kMuted.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: value ? kLime.withOpacity(0.18) : kMuted.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: value ? kLime : kMuted, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(title,
                          style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w700, fontSize: 12)),
                    ),
                    if (price != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                            color: priceColor.withOpacity(0.12), borderRadius: BorderRadius.circular(5)),
                        child: Text(price!,
                            style: GoogleFonts.dmSans(color: priceColor, fontSize: 9, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ],
                ),
                Text(subtitle, style: GoogleFonts.dmSans(color: kMuted, fontSize: 10)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: kDark,
            activeTrackColor: kLime,
            inactiveTrackColor: kMuted.withOpacity(0.25),
            inactiveThumbColor: kMuted,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

class _AddOnRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _AddOnRow(this.label, this.value, {this.color = kWhite});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.dmSans(color: kMuted, fontSize: 12)),
          Text(value, style: GoogleFonts.dmSans(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CHECKOUT SCREEN
// ─────────────────────────────────────────────
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _confirmed = false;
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _paymentMethod = 'Card';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      backgroundColor: kDark,
      appBar: AppBar(
        backgroundColor: kDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Checkout',
            style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w800)),
      ),
      body: _confirmed ? _buildSuccess(context) : _buildForm(context, cart),
    );
  }

  Widget _buildForm(BuildContext context, CartProvider cart) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary',
              style: GoogleFonts.dmSans(color: kLime, fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 12),
          ...cart.items.values.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildNetworkImage(item.product.imageUrl, width: 44, height: 44),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item.product.name,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(color: kWhite, fontSize: 12, fontWeight: FontWeight.w600))),
                  Text('×${item.quantity}',
                      style: GoogleFonts.dmSans(color: kMuted, fontSize: 12)),
                  const SizedBox(width: 8),
                  Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                      style: GoogleFonts.dmSans(color: kLime, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          )),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kLime.withOpacity(0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kLime.withOpacity(0.25)),
            ),
            child: Row(
              children: [
                Icon(cart.selectedShipping.icon, color: kLime, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cart.selectedShipping.name,
                          style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w700, fontSize: 12)),
                      Text(cart.selectedShipping.eta,
                          style: GoogleFonts.dmSans(color: kMuted, fontSize: 10)),
                    ],
                  ),
                ),
                Text(
                  cart.selectedShipping.price == 0 ? 'FREE' : '\$${cart.selectedShipping.price.toStringAsFixed(2)}',
                  style: GoogleFonts.dmSans(
                      color: cart.selectedShipping.price == 0 ? Colors.greenAccent : kLime,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text('Delivery Info',
              style: GoogleFonts.dmSans(color: kLime, fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 12),
          _InputField(controller: _nameCtrl, hint: 'Full Name', icon: Icons.person_outline_rounded),
          const SizedBox(height: 10),
          _InputField(controller: _addressCtrl, hint: 'Delivery Address', icon: Icons.location_on_outlined),
          const SizedBox(height: 10),
          _InputField(controller: _phoneCtrl, hint: 'Phone Number', icon: Icons.phone_outlined),

          const SizedBox(height: 20),

          Text('Payment Method',
              style: GoogleFonts.dmSans(color: kLime, fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            children: ['Card', 'Cash', 'Crypto'].map((m) {
              final sel = m == _paymentMethod;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _paymentMethod = m),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: sel ? kLime : kCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: sel ? kLime : kMuted.withOpacity(0.2))),
                    child: Text(m,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                            color: sel ? kDark : kMuted, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                _SummaryRow('Items (${cart.itemCount})', '\$${cart.totalPrice.toStringAsFixed(2)}'),
                if (cart.discountAmount > 0) ...[
                  const SizedBox(height: 6),
                  _SummaryRow('Discount (10%)', '-\$${cart.discountAmount.toStringAsFixed(2)}',
                      valueColor: Colors.greenAccent),
                ],
                if (cart.promoDiscount > 0) ...[
                  const SizedBox(height: 6),
                  _SummaryRow('Promo (${cart.promoCode.toUpperCase()})',
                      '-\$${cart.promoDiscount.toStringAsFixed(2)}', valueColor: Colors.greenAccent),
                ],
                const SizedBox(height: 6),
                _SummaryRow('Shipping',
                    cart.selectedShipping.price == 0 ? 'FREE' : '\$${cart.selectedShipping.price.toStringAsFixed(2)}',
                    valueColor: cart.selectedShipping.price == 0 ? Colors.greenAccent : null),
                if (cart.giftWrapping) ...[const SizedBox(height: 6), _SummaryRow('Gift Wrapping', '+\$5.99')],
                if (cart.expressHandling) ...[const SizedBox(height: 6), _SummaryRow('Express Handling', '+\$9.99')],
                if (cart.insuranceAdded) ...[const SizedBox(height: 6), _SummaryRow('Package Insurance', '+\$4.99')],
                const Divider(color: kMuted, height: 18),
                _SummaryRow('Total', '\$${cart.finalPrice.toStringAsFixed(2)}', large: true),
              ],
            ),
          ),

          const SizedBox(height: 20),

          LimeButton(
            label: 'Place Order',
            icon: Icons.check_circle_outline_rounded,
            width: double.infinity,
            onTap: () {
              HapticFeedback.heavyImpact();
              setState(() => _confirmed = true);
              cart.clearCart();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: const BoxDecoration(color: kLime, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: kDark, size: 52),
            ).animate().scale(begin: const Offset(0, 0), duration: 500.ms, curve: Curves.elasticOut).fadeIn(),
            const SizedBox(height: 24),
            Text('Order Placed!',
                style: GoogleFonts.dmSans(color: kWhite, fontSize: 28, fontWeight: FontWeight.w900))
                .animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 8),
            Text('Your order is confirmed and will\nbe delivered to your address.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(color: kMuted, fontSize: 13, height: 1.5))
                .animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: kLime.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kLime.withOpacity(0.25))),
              child: Text('Paid via $_paymentMethod',
                  style: GoogleFonts.dmSans(color: kLime, fontWeight: FontWeight.w600)),
            ).animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 40),
            LimeButton(
              label: 'Back to Home',
              icon: Icons.home_rounded,
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
            ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  INPUT FIELD
// ─────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  const _InputField({required this.controller, required this.hint, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        style: GoogleFonts.dmSans(color: kWhite),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.dmSans(color: kMuted, fontSize: 13),
          prefixIcon: Icon(icon, color: kMuted, size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WISHLIST SCREEN
// ─────────────────────────────────────────────
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final wishedProducts = kProducts.where((p) => cart.isInWishlist(p.id)).toList();

    return Scaffold(
      backgroundColor: kDark,
      appBar: AppBar(
        backgroundColor: kDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Wishlist (${wishedProducts.length})',
            style: GoogleFonts.dmSans(color: kWhite, fontWeight: FontWeight.w800)),
        actions: [
          if (wishedProducts.isNotEmpty)
            TextButton(
              onPressed: () {
                for (final p in wishedProducts) {
                  cart.addToCart(p, 1);
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: kCard,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  content: Text('All wishlist items added to cart!',
                      style: GoogleFonts.dmSans(color: kWhite)),
                ));
              },
              child: Text('Add All',
                  style: GoogleFonts.dmSans(color: kLime, fontSize: 13, fontWeight: FontWeight.w700)),
            ),
        ],
      ),
      body: wishedProducts.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: kCard, shape: BoxShape.circle),
              child: const Icon(Icons.favorite_border_rounded, color: kMuted, size: 48),
            ),
            const SizedBox(height: 20),
            Text('No items in wishlist',
                style: GoogleFonts.dmSans(color: kWhite, fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Tap ♡ on products to save them',
                style: GoogleFonts.dmSans(color: kMuted, fontSize: 12)),
            const SizedBox(height: 24),
            LimeButton(label: 'Explore Products', icon: Icons.explore_rounded,
                onTap: () => Navigator.pop(context)),
          ],
        ).animate().fadeIn(duration: 400.ms),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.68,
        ),
        itemCount: wishedProducts.length,
        itemBuilder: (_, i) => _ProductGridCard(product: wishedProducts[i])
            .animate()
            .fadeIn(delay: Duration(milliseconds: i * 60), duration: 400.ms)
            .slideY(begin: 0.12),
      ),
    );
  }
}