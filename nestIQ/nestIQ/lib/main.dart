import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ════════════════════════════════════════════════════════════
//  ENTRY
// ════════════════════════════════════════════════════════════
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const NestiqApp());
}

// ════════════════════════════════════════════════════════════
//  GLOBAL STATE
// ════════════════════════════════════════════════════════════
class _AppGlobal extends ChangeNotifier {
  bool isDark = false;
  final Set<String> favorites = {};
  final List<String> recents = [];
  final Set<String> compare = {};

  void toggleDark() {
    isDark = !isDark;
    notifyListeners();
  }

  bool isFav(String id) => favorites.contains(id);

  void toggleFav(String id) {
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    notifyListeners();
  }

  void addRecent(String id) {
    recents.remove(id);
    recents.insert(0, id);
    if (recents.length > 20) recents.removeLast();
    notifyListeners();
  }

  bool inCompare(String id) => compare.contains(id);

  void toggleCompare(String id) {
    if (compare.contains(id)) {
      compare.remove(id);
    } else if (compare.length < 2) {
      compare.add(id);
    }
    notifyListeners();
  }

  void clearCompare() {
    compare.clear();
    notifyListeners();
  }

  void clearRecents() {
    recents.clear();
    notifyListeners();
  }
}

final G = _AppGlobal();

// ════════════════════════════════════════════════════════════
//  COLORS
// ════════════════════════════════════════════════════════════
class C {
  static const green1 = Color(0xFF1B5E20);
  static const green2 = Color(0xFF2E7D32);
  static const green3 = Color(0xFF43A047);
  static const gold = Color(0xFFFFC107);
  static const red = Color(0xFFE53935);
  static const blue = Color(0xFF1565C0);
  static const wa = Color(0xFF25D366);

  static Color bg(bool d) =>
      d ? const Color(0xFF0F1923) : const Color(0xFFF0F4F1);
  static Color card(bool d) => d ? const Color(0xFF1C2A35) : Colors.white;
  static Color surf(bool d) =>
      d ? const Color(0xFF243342) : const Color(0xFFE8F5E9);
  static Color txt(bool d) =>
      d ? const Color(0xFFE8EDF2) : const Color(0xFF1A1A2E);
  static Color sub(bool d) =>
      d ? const Color(0xFF8FA3B1) : const Color(0xFF6B7280);
  static Color border(bool d) =>
      d ? const Color(0xFF2E3F4F) : const Color(0xFFE0E0E0);
}

// ════════════════════════════════════════════════════════════
//  MODELS
// ════════════════════════════════════════════════════════════
class RoomImg {
  final String label, url, description;
  const RoomImg(this.label, this.url, {this.description = ''});
}

class PlotFeature {
  final IconData icon;
  final String label;
  const PlotFeature(this.icon, this.label);
}

class Prop {
  final String id, title, loc, price, type, cat, phone, email, desc, img;
  final int beds, baths, halls;
  final double pv;
  final List<RoomImg> rooms;
  final double? lat, lng;
  final int? area;
  final String? city;
  final bool featured;
  final int views;
  final List<String> amenities;
  final List<PlotFeature> plotFeatures;
  final String? facing;
  final String? plotType;
  final String? possessionStatus;
  final int? constructionYear;
  final String? furnishing;

  const Prop({
    required this.id,
    required this.title,
    required this.loc,
    required this.price,
    required this.type,
    required this.cat,
    required this.phone,
    required this.email,
    required this.desc,
    required this.img,
    required this.beds,
    required this.baths,
    this.halls = 0,
    this.pv = 0,
    this.rooms = const [],
    this.lat,
    this.lng,
    this.area,
    this.city,
    this.featured = false,
    this.views = 0,
    this.amenities = const [],
    this.plotFeatures = const [],
    this.facing,
    this.plotType,
    this.possessionStatus,
    this.constructionYear,
    this.furnishing,
  });
}

// ════════════════════════════════════════════════════════════
//  DATA
// ════════════════════════════════════════════════════════════
final List<Prop> allProps = [
  // ── HOUSES ──
  Prop(
    id: 'h1',
    title: 'Luxury 5 Marla House — DHA Phase 5',
    loc: 'DHA Phase 5, Block L, Street 22, Lahore',
    price: 'PKR 2.5 Crore',
    type: 'Sale',
    cat: 'House',
    phone: '+92 300 1234567',
    email: 'owner.dha@gmail.com',
    desc:
    'Beautifully constructed 5 Marla double-storey house in one of DHA Phase 5\'s most sought-after streets. The ground floor features a spacious drawing room with imported Italian marble flooring, a formal dining area, a modern open-concept kitchen fitted with German cabinets and granite countertops, and a guest bedroom with attached bath.\n\nThe upper floor houses 3 large bedrooms — the master suite with walk-in wardrobe, dressing area, and spa-style bathroom with rainfall shower. All bedrooms are air-conditioned. The house has 5-marla beautifully tiled outdoor space with a small garden and covered car porch for 2 vehicles. 24/7 DHA security, UPS backup, and solar net-metering already installed.',
    img: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=900',
    beds: 4,
    baths: 3,
    halls: 1,
    pv: 25000000,
    area: 5,
    city: 'Lahore',
    featured: true,
    views: 3240,
    constructionYear: 2021,
    furnishing: 'Semi-Furnished',
    facing: 'East',
    amenities: [
      'Solar Panel',
      'UPS Backup',
      'CCTV Cameras',
      'Gated Community',
      'Car Porch',
      'Marble Flooring',
      'Gas Central Heating',
      'Modular Kitchen',
    ],
    rooms: [
      RoomImg(
        'Master Bedroom',
        'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=900',
        description:
        'Spacious master suite with king bed, walk-in closet, and direct access to private balcony.',
      ),
      RoomImg(
        'Bedroom 2',
        'https://images.unsplash.com/photo-1540518614846-7eded433c457?w=900',
        description: 'Bright second bedroom with queen bed and built-in wardrobe.',
      ),
      RoomImg(
        'Master Bathroom',
        'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=900',
        description: 'Luxurious en-suite with rainfall shower and double vanity.',
      ),
      RoomImg(
        'Drawing Hall',
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=900',
        description: 'Formal drawing room with imported marble floors and recessed lighting.',
      ),
      RoomImg(
        'Modular Kitchen',
        'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=900',
        description: 'Fully fitted kitchen with German cabinets and granite countertops.',
      ),
    ],
    lat: 31.47,
    lng: 74.40,
  ),

  Prop(
    id: 'h2',
    title: 'Double Storey Family House — Johar Town',
    loc: 'Johar Town Block P, Street 8, Lahore',
    price: 'PKR 38,000/month',
    type: 'Rent',
    cat: 'House',
    phone: '+92 300 9988776',
    email: 'owner.johar@gmail.com',
    desc:
    'Well-maintained 5 Marla double-storey house in the heart of Johar Town. Located on a quiet residential street near Emporium Mall and major schools. Ground floor has a large TV lounge, separate dining, and a fully tiled kitchen with built-in cabinets. Upper floor has 3 bedrooms with attached bathrooms.\n\nThe house also features a separate servant quarter, covered car parking, and a small garden. Water supply from both municipal and underground pump. Gas available. Families only preferred.',
    img: 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=900',
    beds: 3,
    baths: 3,
    halls: 2,
    pv: 38000,
    area: 5,
    city: 'Lahore',
    views: 1870,
    furnishing: 'Unfurnished',
    facing: 'West',
    amenities: [
      'Servant Quarter',
      'Car Parking',
      'Garden',
      'Gas Available',
      'Water Pump',
      'Tiled Floors',
      'Gated Street',
    ],
    rooms: [
      RoomImg(
        'Master Bedroom',
        'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?w=900',
        description: 'Large master bedroom on upper floor with attached bath and built-in wardrobe.',
      ),
      RoomImg(
        'TV Lounge',
        'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=900',
        description: 'Spacious TV lounge on ground floor with tiled flooring.',
      ),
      RoomImg(
        'Kitchen',
        'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=900',
        description: 'Tiled kitchen with built-in cabinets and gas connection.',
      ),
    ],
    lat: 31.46,
    lng: 74.27,
  ),

  Prop(
    id: 'h3',
    title: '5 Marla House — Gulshan Iqbal Block 13',
    loc: 'Gulshan Iqbal Block 13, Karachi',
    price: 'PKR 1.85 Crore',
    type: 'Sale',
    cat: 'House',
    phone: '+92 321 1122334',
    email: 'owner.gulshan@gmail.com',
    desc:
    'Ground + first floor house in a well-developed block of Gulshan Iqbal. The property features 3 bedrooms, 2 full bathrooms, a spacious TV lounge, and a separate kitchen. The house is well-maintained with porcelain tile flooring throughout, new electrical wiring (2022), and a covered gate with car porch.\n\nLocated minutes away from main bus routes and nearby government schools and hospitals. Ideal for end-user family.',
    img: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=900',
    beds: 3,
    baths: 2,
    halls: 1,
    pv: 18500000,
    area: 5,
    city: 'Karachi',
    views: 1260,
    constructionYear: 2018,
    furnishing: 'Unfurnished',
    facing: 'North',
    amenities: [
      'Car Porch',
      'New Wiring',
      'Porcelain Tiles',
      'Water Tanker Access',
      'Boundary Wall',
      'Main Road Nearby',
    ],
    rooms: [
      RoomImg(
        'Living Room',
        'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?w=900',
        description: 'Ground floor living room with tile floors and natural ventilation.',
      ),
      RoomImg(
        'Bedroom 1',
        'https://images.unsplash.com/photo-1540518614846-7eded433c457?w=900',
        description: 'Upper floor bedroom with attached bath and window AC.',
      ),
    ],
    lat: 24.92,
    lng: 67.10,
  ),

  Prop(
    id: 'h4',
    title: 'Brand New 7 Marla House — Bahria Town Phase 4',
    loc: 'Bahria Town Phase 4, Block BB, Rawalpindi',
    price: 'PKR 1.35 Crore',
    type: 'Sale',
    cat: 'House',
    phone: '+92 345 5566778',
    email: 'bahria.owner@gmail.com',
    desc:
    'Freshly constructed 7 Marla corner plot house in Bahria Town Phase 4. Never lived in. 5 spacious bedrooms, 4 attached bathrooms, 2 halls (drawing + TV lounge), and a modern kitchen. The property sits on a wider street with 50 ft road and has a large car porch and small lawn area.\n\nBahria Town amenities: 24/7 security, parks, mosques, schools and shopping all within walking distance. Ideal first home or rental investment.',
    img: 'https://images.unsplash.com/photo-1449844908441-8829872d2607?w=900',
    beds: 5,
    baths: 4,
    halls: 2,
    pv: 13500000,
    area: 7,
    city: 'Rawalpindi',
    featured: true,
    views: 4200,
    constructionYear: 2024,
    furnishing: 'Unfurnished',
    facing: 'South',
    amenities: [
      'Corner Plot',
      '50 Ft Road',
      '24/7 Security',
      'Boundary Wall',
      'Lawn Area',
      'Car Porch',
      'Bahria Utilities',
      'Near Park',
    ],
    rooms: [
      RoomImg(
        'Master Suite',
        'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=900',
        description: 'Large master bedroom with attached dressing area and full bath.',
      ),
      RoomImg(
        'Drawing Hall',
        'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=900',
        description: 'Grand drawing hall on ground floor with imported tiles and high ceilings.',
      ),
    ],
    lat: 33.55,
    lng: 73.15,
  ),

  Prop(
    id: 'h5',
    title: '1 Kanal Villa — Gulberg II',
    loc: 'Gulberg II, GOR Colony, Lahore',
    price: 'PKR 9.5 Crore',
    type: 'Sale',
    cat: 'House',
    phone: '+92 302 8877665',
    email: 'gulberg.villa@gmail.com',
    desc:
    'Prestigious 1 Kanal villa in the most sought-after address of Lahore — Gulberg II. The property has been completely renovated in 2023 with the finest finishes. Ground floor: grand entrance foyer, formal drawing room, formal dining, powder room. Upper floor: 5 en-suite bedrooms, all with imported tiles and premium fixtures.\n\nBasement: home cinema, gym space, and storage. Outdoor: beautifully landscaped garden with lawn, swimming pool shell (ready for tiling), and 3-car covered garage. CCTV 16-camera system, intercom, solar net-metering 10KW, and standby diesel generator included in sale.',
    img: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=900',
    beds: 6,
    baths: 6,
    halls: 3,
    pv: 95000000,
    city: 'Lahore',
    featured: true,
    views: 7800,
    constructionYear: 2014,
    furnishing: 'Fully Furnished',
    facing: 'East',
    amenities: [
      'Swimming Pool Shell',
      'Solar 10KW',
      'Diesel Generator',
      'CCTV 16-Cam',
      'Home Cinema Basement',
      'Gym Space',
      'Landscaped Garden',
      '3-Car Garage',
      'Intercom System',
      'Marble Flooring',
    ],
    rooms: [
      RoomImg(
        'Grand Entrance',
        'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=900',
        description: 'Double-height entrance foyer with chandelier and imported marble staircase.',
      ),
      RoomImg(
        'Master Suite',
        'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=900',
        description: 'Opulent master suite with private sitting area and spa bathroom.',
      ),
      RoomImg(
        'Drawing Room',
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=900',
        description: 'Formal drawing room with coffered ceiling and Italian marble.',
      ),
      RoomImg(
        'Formal Dining',
        'https://images.unsplash.com/photo-1617806118233-18e1de247200?w=900',
        description: 'Formal dining room accommodating 12-seater dining set.',
      ),
      RoomImg(
        'Kitchen',
        'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=900',
        description: 'Professional-grade kitchen with island counter and German appliances.',
      ),
      RoomImg(
        'Garden View',
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=900',
        description: 'Professionally landscaped garden with automated irrigation.',
      ),
    ],
    lat: 31.51,
    lng: 74.34,
  ),

  Prop(
    id: 'h6',
    title: 'Furnished House — F-7/2 Islamabad',
    loc: 'F-7/2, Street 45, Islamabad',
    price: 'PKR 1.4 Crore',
    type: 'Sale',
    cat: 'House',
    phone: '+92 51 2883344',
    email: 'f7.islamabad@gmail.com',
    desc:
    'Well-located 10 Marla house in the prestigious F-7/2 sector of Islamabad. This double-storey property is in excellent condition with 4 bedrooms (all attached baths), a large TV lounge, dining room, and modern kitchen. Ground floor also has a guest bedroom with separate entrance.\n\nThe house features Italian marble flooring, newly renovated bathrooms, and a modular kitchen with built-in appliances. Central gas heating, 2 split ACs, and solar geyser included.',
    img: 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=900',
    beds: 4,
    baths: 4,
    halls: 2,
    pv: 14000000,
    area: 10,
    city: 'Islamabad',
    views: 2100,
    constructionYear: 2015,
    furnishing: 'Semi-Furnished',
    facing: 'West',
    amenities: [
      'Italian Marble',
      'Solar Geyser',
      'Central Gas Heating',
      'Split ACs x2',
      'Front Garden',
      'Car Porch x2',
      'Servant Quarter',
      'Near CDA Market',
    ],
    rooms: [
      RoomImg(
        'TV Lounge',
        'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=900',
        description: 'Large TV lounge with marble floors and sliding door to rear courtyard.',
      ),
      RoomImg(
        'Master Bedroom',
        'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=900',
        description: 'Master bedroom with walk-in closet and attached bathroom with jacuzzi.',
      ),
    ],
    lat: 33.73,
    lng: 73.04,
  ),

  Prop(
    id: 'h7',
    title: 'Clifton Block 4 Bungalow — Sea View',
    loc: 'Clifton Block 4, Do Talwar Rd, Karachi',
    price: 'PKR 5.8 Crore',
    type: 'Sale',
    cat: 'House',
    phone: '+92 312 1234001',
    email: 'clifton.bungalow@gmail.com',
    desc:
    '500 sqyd renovated bungalow in the most prestigious location of Karachi — Clifton Block 4. Just 2 minutes from the sea. The property features 6 large bedrooms all with attached baths, 2 formal drawing rooms, spacious dining, and a modern kitchen. The rooftop has been converted into a furnished entertainment area with sea views.\n\nThe bungalow has been fully renovated in 2022 — new plumbing, new electrical wiring, Italian marble throughout, brand new kitchen and bathrooms. Double boundary wall with CCTV.',
    img: 'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=900',
    beds: 6,
    baths: 6,
    halls: 2,
    pv: 58000000,
    city: 'Karachi',
    featured: true,
    views: 5600,
    constructionYear: 2005,
    furnishing: 'Fully Furnished',
    facing: 'South',
    amenities: [
      'Sea View Rooftop',
      'Italian Marble',
      'CCTV System',
      'Rooftop Entertainment Area',
      'Double Boundary Wall',
      '2022 Renovation',
      'Generator Backup',
      'Staff Quarter x2',
    ],
    rooms: [
      RoomImg(
        'Drawing Room',
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=900',
        description: 'Grand formal drawing room with imported marble and chandelier.',
      ),
      RoomImg(
        'Master Suite',
        'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=900',
        description: 'Sea-facing master suite with private balcony and spa bathroom.',
      ),
      RoomImg(
        'Rooftop Lounge',
        'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=900',
        description: 'Converted rooftop with seating area and panoramic sea views.',
      ),
    ],
    lat: 24.82,
    lng: 67.02,
  ),

  Prop(
    id: 'h8',
    title: '10 Marla House — Model Town Lahore',
    loc: 'Model Town Block H, Lahore',
    price: 'PKR 60,000/month',
    type: 'Rent',
    cat: 'House',
    phone: '+92 333 7788990',
    email: 'modeltown@gmail.com',
    desc:
    'Elegant 10 Marla double-storey house in the prestigious Model Town Block H. The property is in excellent condition with 4 bedrooms (all attached), TV lounge, separate dining, and a fully-equipped kitchen. The house has a beautifully maintained front lawn and covered car parking for 2 vehicles.\n\nServant quarter with separate bathroom is attached at the rear. Underground water storage, pump, and gas water geyser. Quiet, tree-lined street. Families only.',
    img: 'https://images.unsplash.com/photo-1597047084897-51e81819a499?w=900',
    beds: 4,
    baths: 4,
    halls: 2,
    pv: 60000,
    area: 10,
    city: 'Lahore',
    views: 1430,
    furnishing: 'Unfurnished',
    facing: 'North',
    amenities: [
      'Front Lawn',
      'Servant Quarter',
      'Car Parking x2',
      'Underground Water Tank',
      'Gas Geyser',
      'Tree-lined Street',
      'Gas Heating',
    ],
    rooms: [
      RoomImg(
        'TV Lounge',
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=900',
        description: 'Ground floor TV lounge with garden view and marble floors.',
      ),
    ],
    lat: 31.49,
    lng: 74.32,
  ),

  Prop(
    id: 'h9',
    title: '5 Marla House — DHA Multan Phase 1',
    loc: 'DHA Multan Phase 1, Block R, Multan',
    price: 'PKR 1.65 Crore',
    type: 'Sale',
    cat: 'House',
    phone: '+92 61 4501234',
    email: 'dha.multan@gmail.com',
    desc:
    'Newly built 5 Marla house in DHA Multan — one of Pakistan\'s fastest-growing real estate projects. 3 well-sized bedrooms with built-in wardrobes, 2 full attached bathrooms, a large TV lounge, and an open-concept kitchen. Solar panel-ready roof structure installed. All utility connections done.\n\nWalking distance from DHA Multan commercial area, mosque, and central park. Perfect for first home buyers or investment.',
    img: 'https://images.unsplash.com/photo-1600585154526-990dced4db0d?w=900',
    beds: 3,
    baths: 2,
    halls: 1,
    pv: 16500000,
    area: 5,
    city: 'Multan',
    views: 1820,
    constructionYear: 2023,
    furnishing: 'Unfurnished',
    facing: 'East',
    amenities: [
      'Solar Ready Roof',
      'SNGPL Gas',
      'DHA Utilities',
      'Near Commercial',
      'Near Park',
      'Near Mosque',
      'Boundary Wall',
    ],
    rooms: [
      RoomImg(
        'TV Lounge',
        'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=900',
        description: 'Open TV lounge connected to kitchen with tiled floors.',
      ),
      RoomImg(
        'Bedroom 1',
        'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=900',
        description: 'Master bedroom with built-in wardrobe and attached tiled bathroom.',
      ),
    ],
    lat: 30.18,
    lng: 71.47,
  ),

  Prop(
    id: 'h10',
    title: 'Furnished House — Hayatabad Phase 5',
    loc: 'Hayatabad Phase 5, Sector C, Peshawar',
    price: 'PKR 80,000/month',
    type: 'Rent',
    cat: 'House',
    phone: '+92 91 5550011',
    email: 'hayatabad.owner@gmail.com',
    desc:
    'Fully furnished 1 Kanal house available for rent in Hayatabad Phase 5. The property is furnished with quality sofa sets, dining table, imported beds in all 5 bedrooms, and a fully equipped kitchen with fridge, microwave, and washing machine.\n\nThe house has central gas heating (ducted), standby generator, basement storage, and a shaded car porch for 2 vehicles. Close to Hayatabad Sports Complex, Ring Road, and hospitals.',
    img: 'https://images.unsplash.com/photo-1598228723793-52759bba239c?w=900',
    beds: 5,
    baths: 5,
    halls: 2,
    pv: 80000,
    city: 'Peshawar',
    views: 2380,
    furnishing: 'Fully Furnished',
    facing: 'West',
    amenities: [
      'Fully Furnished',
      'Central Gas Heating',
      'Standby Generator',
      'Basement Storage',
      'Car Porch x2',
      'Fridge & Microwave',
      'Washing Machine',
      'Near Sports Complex',
    ],
    rooms: [
      RoomImg(
        'Living Room',
        'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=900',
        description: 'Furnished living room with imported sofa set and smart TV bracket.',
      ),
      RoomImg(
        'Master Bedroom',
        'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=900',
        description: 'King-sized furnished master bedroom with dressing table and attached bath.',
      ),
      RoomImg(
        'Dining Area',
        'https://images.unsplash.com/photo-1617806118233-18e1de247200?w=900',
        description: '8-seater dining area adjacent to the kitchen with chandelier lighting.',
      ),
    ],
    lat: 33.99,
    lng: 71.42,
  ),

  // ── APARTMENTS ──
  Prop(
    id: 'a1',
    title: 'Luxury 2-Bed Apartment — Gulberg III',
    loc: 'Gulberg III, MM Alam Road, Lahore',
    price: 'PKR 50,000/month',
    type: 'Rent',
    cat: 'Apartment',
    phone: '+92 321 9876543',
    email: 'owner2@gmail.com',
    desc:
    'Premium 2-bedroom fully furnished apartment on the 5th floor of a modern gated tower in the heart of Gulberg. Renovated in 2023 with imported tiles, modern kitchen with built-in appliances, and spa-style bathrooms.\n\nBuilding amenities include 24/7 security with CCTV, elevator, standby generator, rooftop gym, and covered basement parking. Rent includes generator fuel. Walking distance to Gulberg Galleria and Liberty Market.',
    img: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=900',
    beds: 2,
    baths: 2,
    halls: 1,
    pv: 50000,
    city: 'Lahore',
    featured: true,
    views: 3800,
    furnishing: 'Fully Furnished',
    facing: 'North',
    amenities: [
      'Elevator',
      'Generator Backup',
      'CCTV Security',
      'Rooftop Gym',
      'Basement Parking',
      'Near MM Alam Road',
      'Imported Tiles',
      'Built-in Appliances',
    ],
    rooms: [
      RoomImg(
        'Living Room',
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=900',
        description: 'Modern furnished living room with large windows and city view.',
      ),
      RoomImg(
        'Master Bedroom',
        'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=900',
        description: 'Furnished master bedroom with queen bed, wardrobe, split AC, and attached bath.',
      ),
      RoomImg(
        'Kitchen',
        'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=900',
        description: 'Open modular kitchen with granite counter and built-in hob.',
      ),
    ],
    lat: 31.52,
    lng: 74.35,
  ),

  Prop(
    id: 'a2',
    title: 'Sea-View Apartment — Clifton Block 9',
    loc: 'Clifton Block 9, Kehkashan, Karachi',
    price: 'PKR 1.65 Crore',
    type: 'Sale',
    cat: 'Apartment',
    phone: '+92 322 1234567',
    email: 'clifton.flat@gmail.com',
    desc:
    'Breathtaking sea-facing 3-bedroom apartment on the 10th floor in an upscale Clifton building. The unit has been finished to a very high standard — imported marble throughout, custom kitchen with German appliances, and 3 bathrooms with floor-to-ceiling tiles.\n\nThe building has a rooftop swimming pool, gym, dedicated security, elevator, and covered parking. Panoramic Arabian Sea views from the living room and master bedroom.',
    img: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=900',
    beds: 3,
    baths: 3,
    halls: 1,
    pv: 16500000,
    city: 'Karachi',
    views: 2920,
    furnishing: 'Semi-Furnished',
    facing: 'South',
    amenities: [
      'Sea View',
      'Rooftop Swimming Pool',
      'Gym',
      'Elevator',
      'Covered Parking',
      'German Appliances',
      'Marble Flooring',
      'Dedicated Security',
    ],
    rooms: [
      RoomImg(
        'Sea-View Lounge',
        'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=900',
        description: 'Floor-to-ceiling windows framing the Arabian Sea.',
      ),
      RoomImg(
        'Master Bedroom',
        'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=900',
        description: 'Sea-facing master suite with walk-in closet and premium bathroom.',
      ),
    ],
    lat: 24.81,
    lng: 67.03,
  ),

  Prop(
    id: 'a3',
    title: 'Executive Studio — Blue Area Islamabad',
    loc: 'Blue Area, Fazl-ul-Haq Road, Islamabad',
    price: 'PKR 32,000/month',
    type: 'Rent',
    cat: 'Apartment',
    phone: '+92 335 5544332',
    email: 'bluearea.flat@gmail.com',
    desc:
    'Modern executive studio apartment on the 5th floor of a new commercial-residential tower in Blue Area. Fully furnished with sofa-bed, wardrobe, kitchenette with fridge and microwave, and a full bathroom with geyser.\n\nPerfect for working professionals or bachelors. Elevator, CCTV security, 24/7 guard. Walking distance to F-7 Jinnah Super, Centaurus Mall, and major government offices.',
    img: 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=900',
    beds: 1,
    baths: 1,
    halls: 1,
    pv: 32000,
    city: 'Islamabad',
    views: 1640,
    furnishing: 'Fully Furnished',
    facing: 'East',
    amenities: [
      'Elevator',
      'CCTV',
      '24/7 Guard',
      'Kitchenette',
      'Fridge & Microwave',
      'Near Centaurus',
      'Walking to F-7',
    ],
    rooms: [
      RoomImg(
        'Studio Living',
        'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?w=900',
        description: 'Open-plan studio with sofa-bed, kitchenette, and large window with city view.',
      ),
    ],
    lat: 33.72,
    lng: 73.06,
  ),

  Prop(
    id: 'a4',
    title: 'Penthouse — Bahria Heights Islamabad',
    loc: 'Bahria Heights, Sector E, Islamabad',
    price: 'PKR 3.2 Crore',
    type: 'Sale',
    cat: 'Apartment',
    phone: '+92 51 4400221',
    email: 'penthouse.bahria@gmail.com',
    desc:
    'Stunning top-floor penthouse with panoramic Margalla Hills view in Bahria Heights, Islamabad. 4 bedrooms all with attached baths, a massive open terrace, island kitchen, and a large living/dining area. Smart home automation — automated lights, curtains, AC control via app.\n\nBuilding has gym, indoor heated pool, 2-level underground parking, and concierge service. Private rooftop deck access exclusive to this unit.',
    img: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=900',
    beds: 4,
    baths: 4,
    halls: 2,
    pv: 32000000,
    city: 'Islamabad',
    featured: true,
    views: 6800,
    constructionYear: 2022,
    furnishing: 'Fully Furnished',
    facing: 'North',
    amenities: [
      'Margalla Hills View',
      'Smart Home System',
      'Private Rooftop Deck',
      'Indoor Heated Pool',
      'Gym',
      'Concierge',
      'Underground Parking x2',
      'Island Kitchen',
    ],
    rooms: [
      RoomImg(
        'Panoramic Living',
        'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=900',
        description: 'Floor-to-ceiling views of Margalla Hills from the open-plan living area.',
      ),
      RoomImg(
        'Master Suite',
        'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=900',
        description: 'Master suite with Hills view, walk-in closet, and spa bath.',
      ),
      RoomImg(
        'Island Kitchen',
        'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=900',
        description: 'Premium island kitchen with German appliances and breakfast bar.',
      ),
      RoomImg(
        'Private Terrace',
        'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=900',
        description: 'Private rooftop terrace with 360-degree views and BBQ area.',
      ),
    ],
    lat: 33.54,
    lng: 73.13,
  ),

  Prop(
    id: 'a5',
    title: 'Creek Vista — DHA Phase 8 Karachi',
    loc: 'Creek Vista, DHA Phase 8, Karachi',
    price: 'PKR 90,000/month',
    type: 'Rent',
    cat: 'Apartment',
    phone: '+92 21 3500990',
    email: 'creekvista@gmail.com',
    desc:
    'Premium 3-bedroom fully furnished apartment in the iconic Creek Vista Towers, DHA Phase 8. 12th floor with spectacular creek and sea views. Brand-new quality furniture throughout, 3 split ACs, high-speed WiFi included in rent.\n\nBuilding amenities: swimming pool, gym, squash court, 24/7 CCTV, doorman, 2 dedicated parking. Monthly maintenance included in rent. Ideal for expats or senior management.',
    img: 'https://images.unsplash.com/photo-1574362848149-11496d93a7c7?w=900',
    beds: 3,
    baths: 3,
    halls: 2,
    pv: 90000,
    city: 'Karachi',
    views: 4200,
    furnishing: 'Fully Furnished',
    facing: 'South',
    amenities: [
      'Creek View',
      'Swimming Pool',
      'Gym',
      'Squash Court',
      'CCTV',
      'Doorman',
      'WiFi Included',
      'Parking x2',
      'Maintenance Included',
    ],
    rooms: [
      RoomImg(
        'Creek View Living',
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=900',
        description: 'Furnished living room with panoramic creek view.',
      ),
      RoomImg(
        'Master Bedroom',
        'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=900',
        description: 'Creek-facing master with king bed and premium bath.',
      ),
      RoomImg(
        'Creek Balcony',
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=900',
        description: 'Private balcony with seating area offering unobstructed creek and sea views.',
      ),
    ],
    lat: 24.79,
    lng: 67.08,
  ),

  // ── PLOTS ──
  Prop(
    id: 'p1',
    title: '10 Marla Residential Plot — Bahria Town',
    loc: 'Bahria Town Phase 4, Block CC, Rawalpindi',
    price: 'PKR 85 Lakh',
    type: 'Sale',
    cat: 'Plot',
    phone: '+92 345 6677889',
    email: 'bahria.plot@gmail.com',
    desc:
    'Excellent 10 Marla residential plot in Bahria Town Phase 4, Block CC. This is a corner plot facing a 50ft wide road — ideal for a spacious double-storey home with garden. Possession in hand, all dues cleared, and file is readily transferable within 24 hours.\n\nAll Bahria Town utilities available: electricity, gas, sewerage, and water supply. The plot is surrounded by developed houses and is just 3 minutes walk from the sector park and commercial market.',
    img: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=900',
    beds: 0,
    baths: 0,
    halls: 0,
    pv: 8500000,
    area: 10,
    city: 'Rawalpindi',
    views: 1290,
    facing: 'East',
    plotType: 'Residential',
    possessionStatus: 'Possession in Hand',
    plotFeatures: [
      PlotFeature(Icons.crop_square, 'Corner Plot'),
      PlotFeature(Icons.straighten, '50ft Road Facing'),
      PlotFeature(Icons.electric_bolt, 'Electricity Done'),
      PlotFeature(Icons.local_fire_department, 'Gas Available'),
      PlotFeature(Icons.water_drop, 'Water Supply'),
      PlotFeature(Icons.swap_horiz, 'Transfer Ready'),
    ],
    amenities: [
      'Corner Plot',
      '50ft Road',
      'Possession in Hand',
      'All Dues Cleared',
      'Bahria Town Utilities',
      'Near Park',
      'Near Commercial',
    ],
    rooms: [
      RoomImg(
        'Plot Front View',
        'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=900',
        description: 'Corner plot with 50ft road facing. Boundary wall on two sides.',
      ),
      RoomImg(
        'Surroundings',
        'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=900',
        description: 'Developed neighbourhood with paved roads, streetlights, and parks nearby.',
      ),
    ],
    lat: 33.54,
    lng: 73.14,
  ),

  Prop(
    id: 'p2',
    title: '1 Kanal Plot — DHA Phase 7 Lahore',
    loc: 'DHA Phase 7, Block R, Lahore',
    price: 'PKR 2.3 Crore',
    type: 'Sale',
    cat: 'Plot',
    phone: '+92 302 5566778',
    email: 'dha7.plot@gmail.com',
    desc:
    '1 Kanal prime location plot in DHA Phase 7, Block R — one of the most developed and populated blocks in Phase 7. The plot is on a 40ft road, ideal for a large family house. Possession transferred, all DHA dues paid, and the file is verified by DHA with no pending objections.\n\nSurrounded by completed houses on 3 sides. Street already has underground utilities, paved road, and streetlights.',
    img: 'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=900',
    beds: 0,
    baths: 0,
    halls: 0,
    pv: 23000000,
    city: 'Lahore',
    featured: true,
    views: 3100,
    facing: 'West',
    plotType: 'Residential',
    possessionStatus: 'Possession Transferred',
    plotFeatures: [
      PlotFeature(Icons.crop_square, '1 Kanal — 272 Sq Yds'),
      PlotFeature(Icons.straighten, '40ft Road Facing'),
      PlotFeature(Icons.electric_bolt, 'Underground Utilities'),
      PlotFeature(Icons.local_fire_department, 'Gas Available'),
      PlotFeature(Icons.verified, 'DHA Verified File'),
      PlotFeature(Icons.swap_horiz, 'No Objection'),
    ],
    amenities: [
      '1 Kanal',
      '40ft Road',
      'Possession Transferred',
      'DHA Verified',
      'No Objections',
      'Paved Streets',
      'Near Sector Park',
    ],
    rooms: [
      RoomImg(
        'Plot View',
        'https://images.unsplash.com/photo-1558981285-6f0c9d792c1a?w=900',
        description: '1 Kanal plot on a 40ft street in Block R. Houses on 3 sides already constructed.',
      ),
      RoomImg(
        'Aerial View',
        'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=900',
        description: 'Aerial perspective showing the plot\'s location within the developed block.',
      ),
    ],
    lat: 31.44,
    lng: 74.43,
  ),

  Prop(
    id: 'p3',
    title: '8 Marla Plot — G-13 Islamabad',
    loc: 'G-13/1, Street 7, Islamabad',
    price: 'PKR 1.5 Crore',
    type: 'Sale',
    cat: 'Plot',
    phone: '+92 307 6655441',
    email: 'g13.plot@gmail.com',
    desc:
    '8 Marla CDA residential plot in the quiet and green G-13/1 sector of Islamabad. The plot is on a 30ft road in a peaceful residential setting. Near Government Girls High School, sector park, and G-13 Markaz commercial area.\n\nCDA allotment letter available. No encumbrances. Ideal for construction of 6-7 bedroom house. Underground sewerage, electricity, and gas connections available in the street.',
    img: 'https://images.unsplash.com/photo-1558981285-6f0c9d792c1a?w=900',
    beds: 0,
    baths: 0,
    halls: 0,
    pv: 15000000,
    area: 8,
    city: 'Islamabad',
    views: 875,
    facing: 'South',
    plotType: 'Residential',
    possessionStatus: 'CDA Allotment Available',
    plotFeatures: [
      PlotFeature(Icons.crop_square, '8 Marla — 200 Sq Yds'),
      PlotFeature(Icons.straighten, '30ft Road Facing'),
      PlotFeature(Icons.electric_bolt, 'CDA Electricity'),
      PlotFeature(Icons.local_fire_department, 'SNGPL Gas'),
      PlotFeature(Icons.verified, 'CDA Allotment Letter'),
      PlotFeature(Icons.water_drop, 'CDA Water'),
    ],
    amenities: [
      'CDA Plot',
      '30ft Road',
      'CDA Allotment',
      'No Encumbrances',
      'Near School',
      'Near Sector Park',
      'Underground Utilities',
    ],
    rooms: [
      RoomImg(
        'Sector View',
        'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=900',
        description: 'Green and quiet G-13/1 sector with wide streets and established infrastructure.',
      ),
    ],
    lat: 33.66,
    lng: 72.99,
  ),

  Prop(
    id: 'p4',
    title: '5 Marla Residential Plot — Bahria Enclave Sector A',
    loc: 'Bahria Enclave, Sector A, Islamabad',
    price: 'PKR 68 Lakh',
    type: 'Sale',
    cat: 'Plot',
    phone: '+92 51 8880023',
    email: 'bahria.enclave@gmail.com',
    desc:
    '5 Marla residential plot in Bahria Enclave Sector A — possession in hand. All development work completed — asphalted roads, electricity, SNGPL gas, and municipal water supply all available. No additional dues or development charges.\n\nIdeal for immediate construction. Peaceful community with green belts, jogging track, parks, and a mosque within the sector.',
    img: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=900',
    beds: 0,
    baths: 0,
    halls: 0,
    pv: 6800000,
    area: 5,
    city: 'Islamabad',
    views: 1530,
    facing: 'North',
    plotType: 'Residential',
    possessionStatus: 'Possession in Hand',
    plotFeatures: [
      PlotFeature(Icons.crop_square, '5 Marla — 125 Sq Yds'),
      PlotFeature(Icons.electric_bolt, 'Electricity Connected'),
      PlotFeature(Icons.local_fire_department, 'SNGPL Gas'),
      PlotFeature(Icons.water_drop, 'Water Supply'),
      PlotFeature(Icons.park, 'Near Green Belt'),
      PlotFeature(Icons.swap_horiz, 'No Additional Dues'),
    ],
    amenities: [
      'Possession in Hand',
      'Asphalted Roads',
      'Electricity Connected',
      'SNGPL Gas',
      'Water Supply',
      'No Extra Dues',
      'Near Park',
      'Near Mosque',
    ],
    rooms: [
      RoomImg(
        'Plot & Surroundings',
        'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=900',
        description: 'Fully developed surrounding area with paved roads, streetlights, and green belts.',
      ),
    ],
    lat: 33.58,
    lng: 73.10,
  ),

  Prop(
    id: 'p5',
    title: '10 Marla Plot — DHA Phase 9 Prism Block D',
    loc: 'DHA Phase 9 Prism, Block D, Lahore',
    price: 'PKR 2.0 Crore',
    type: 'Sale',
    cat: 'Plot',
    phone: '+92 42 3598800',
    email: 'dha9prism@gmail.com',
    desc:
    '10 Marla plot in DHA Phase 9 Prism, Block D — ballot cleared and possession transferred. This is a 50ft main road facing plot in a rapidly developing block with significant construction activity already visible. NOC is clear, all DHA dues paid, and transfer can be done within 24 hours from DHA office.\n\nDHA Phase 9 Prism is Lahore\'s newest DHA phase and is expected to fully develop by 2026. Excellent mid-to-long term investment opportunity with strong capital appreciation.',
    img: 'https://images.unsplash.com/photo-1558981285-6f0c9d792c1a?w=900',
    beds: 0,
    baths: 0,
    halls: 0,
    pv: 20000000,
    area: 10,
    city: 'Lahore',
    featured: true,
    views: 4400,
    facing: 'South',
    plotType: 'Residential',
    possessionStatus: 'Possession Transferred',
    plotFeatures: [
      PlotFeature(Icons.crop_square, '10 Marla — 272 Sq Yds'),
      PlotFeature(Icons.straighten, '50ft Main Road'),
      PlotFeature(Icons.verified, 'DHA NOC Clear'),
      PlotFeature(Icons.electric_bolt, 'Utilities Coming'),
      PlotFeature(Icons.swap_horiz, '24-Hour Transfer'),
      PlotFeature(Icons.trending_up, 'High Appreciation'),
    ],
    amenities: [
      '50ft Main Road',
      'Ballot Cleared',
      'Possession Transferred',
      'NOC Clear',
      'DHA Dues Paid',
      '24-Hour Transfer',
      'Investment Grade',
    ],
    rooms: [
      RoomImg(
        '50ft Road Facing',
        'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=900',
        description: 'Plot facing the 50ft main boulevard of Block D with active construction in the area.',
      ),
      RoomImg(
        'Block Overview',
        'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=900',
        description: 'Overhead view of Phase 9 Prism Block D showing rapid development progress.',
      ),
    ],
    lat: 31.40,
    lng: 74.35,
  ),

  // ── SHOPS ──
  Prop(
    id: 's1',
    title: 'Commercial Shop — Susan Road Faisalabad',
    loc: 'Susan Road, Main Market, Faisalabad',
    price: 'PKR 28,000/month',
    type: 'Rent',
    cat: 'Shop',
    phone: '+92 333 1122334',
    email: 'fsd.shop@gmail.com',
    desc:
    '250 sq ft ground floor commercial shop on the main Susan Road with excellent road-side visibility. The shop has tiled flooring, new paint, a dedicated electricity meter, and a separate washroom at the rear. Currently vacant, immediate possession available.\n\nSusan Road has very high daily footfall from both residential and commercial traffic. Ideal for mobile shop, clothing, bakery, or pharmacy.',
    img: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=900',
    beds: 0,
    baths: 1,
    halls: 0,
    pv: 28000,
    city: 'Faisalabad',
    views: 730,
    furnishing: 'Unfurnished',
    amenities: [
      'Main Road Facing',
      'High Footfall',
      'Separate Electricity Meter',
      'Tiled Flooring',
      'Washroom',
      'Immediate Possession',
    ],
    rooms: [
      RoomImg(
        'Shop Front',
        'https://images.unsplash.com/photo-1534452203293-494d7ddbf7e0?w=900',
        description: 'Ground floor shop with glass front shutters and high visibility.',
      ),
    ],
    lat: 31.45,
    lng: 73.12,
  ),

  Prop(
    id: 's2',
    title: 'Premium Shop — MM Alam Road Lahore',
    loc: 'MM Alam Road, Gulberg II, Lahore',
    price: 'PKR 2.8 Lakh/month',
    type: 'Rent',
    cat: 'Shop',
    phone: '+92 321 4455667',
    email: 'mmalam.shop@gmail.com',
    desc:
    'Rare opportunity to rent a 550 sq ft ground floor shop directly on Lahore\'s most prestigious commercial street — MM Alam Road, Gulberg. The shop has been freshly renovated with polished concrete floors, LED lighting, a large glass storefront, and an integrated security shutter.\n\nMM Alam Road attracts thousands of affluent daily customers. Ideal for high-end clothing boutique, international food brand, salon, or jewellery.',
    img: 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=900',
    beds: 0,
    baths: 1,
    halls: 0,
    pv: 280000,
    city: 'Lahore',
    featured: true,
    views: 2980,
    furnishing: 'Unfurnished',
    amenities: [
      'MM Alam Road Frontage',
      'Massive Daily Footfall',
      'LED Lighting',
      'Glass Storefront',
      'Security Shutter',
      'Separate Meter',
      'CCTV in Building',
    ],
    rooms: [
      RoomImg(
        'Shop Exterior',
        'https://images.unsplash.com/photo-1534452203293-494d7ddbf7e0?w=900',
        description: 'Renovated glass-front shop on MM Alam Road with maximum visibility.',
      ),
      RoomImg(
        'Interior',
        'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=900',
        description: 'Open retail space with polished floors, LED lighting, and high ceiling.',
      ),
    ],
    lat: 31.52,
    lng: 74.35,
  ),

  Prop(
    id: 's3',
    title: 'Investment Shop — Bahria Town Civic Centre',
    loc: 'Bahria Town Civic Centre, Lahore',
    price: 'PKR 2.4 Crore',
    type: 'Sale',
    cat: 'Shop',
    phone: '+92 42 3510099',
    email: 'bahria.civic@gmail.com',
    desc:
    'Highly sought-after 280 sq ft ground floor shop in Bahria Town Civic Centre — one of Lahore\'s busiest retail destinations. The shop is currently rented at PKR 75,000/month on a 3-year registered rental deed, yielding over 3.7% annual return.\n\nThe shop has its own electricity meter, internal AC duct connection, and is located in a premium air-conditioned mall with food court, brand stores, and cinema.',
    img: 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=900',
    beds: 0,
    baths: 1,
    halls: 0,
    pv: 24000000,
    city: 'Lahore',
    views: 3890,
    furnishing: 'Unfurnished',
    amenities: [
      'Currently Rented',
      'PKR 75K/Month Income',
      '3.7% Annual Yield',
      'AC Mall',
      'Food Court Nearby',
      'Brand Stores Nearby',
      'Own Electricity Meter',
    ],
    rooms: [
      RoomImg(
        'Mall Exterior',
        'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=900',
        description: 'Bahria Town Civic Centre — major air-conditioned mall.',
      ),
      RoomImg(
        'Shop Interior',
        'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=900',
        description: 'Ground floor shop inside the mall currently rented to a clothing brand.',
      ),
    ],
    lat: 31.36,
    lng: 74.17,
  ),

  Prop(
    id: 's4',
    title: 'Office Space — F-10 Markaz Islamabad',
    loc: 'F-10 Markaz, 3rd Floor, Islamabad',
    price: 'PKR 1.2 Lakh/month',
    type: 'Rent',
    cat: 'Shop',
    phone: '+92 51 2295599',
    email: 'f10.office@gmail.com',
    desc:
    '850 sq ft fully fitted office space in F-10 Markaz, Islamabad. The office has 3 private cabins, an open floor plan, a reception lobby, 2 washrooms, and a pantry area. High-speed fiber internet conduit installed. Views of F-10 park from the office.\n\nBuilding has an elevator, standby generator, and basement parking for 2 cars. Perfect for law firm, tech company, or consultancy.',
    img: 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=900',
    beds: 0,
    baths: 2,
    halls: 1,
    pv: 120000,
    city: 'Islamabad',
    views: 1740,
    furnishing: 'Semi-Furnished',
    amenities: [
      '3 Private Cabins',
      'Open Floor Plan',
      'Reception Lobby',
      'Fiber Internet Conduit',
      'Generator Backup',
      'Parking x2',
      'Elevator',
      'F-10 Park View',
    ],
    rooms: [
      RoomImg(
        'Reception',
        'https://images.unsplash.com/photo-1534452203293-494d7ddbf7e0?w=900',
        description: 'Professional reception lobby with visitor seating.',
      ),
      RoomImg(
        'Cabin Area',
        'https://images.unsplash.com/photo-1497366216548-37526070297c?w=900',
        description: '3 private AC cabins with glass partitions and park-facing windows.',
      ),
    ],
    lat: 33.69,
    lng: 73.02,
  ),
];

// ════════════════════════════════════════════════════════════
//  STOCK PHOTOS
// ════════════════════════════════════════════════════════════
const _stockPhotos = [
  'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800',
  'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800',
  'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
  'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
  'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
  'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
  'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
  'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800',
  'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=800',
  'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800',
];

// ════════════════════════════════════════════════════════════
//  ROOT APP
// ════════════════════════════════════════════════════════════
class NestiqApp extends StatefulWidget {
  const NestiqApp({super.key});
  @override
  State<NestiqApp> createState() => _NestiqAppState();
}

class _NestiqAppState extends State<NestiqApp> {
  @override
  void initState() {
    super.initState();
    G.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Nestiq',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: C.green1,
      colorScheme: ColorScheme.fromSeed(seedColor: C.green1),
      scaffoldBackgroundColor: C.bg(false),
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: C.green1,
      colorScheme: ColorScheme.fromSeed(
          seedColor: C.green1, brightness: Brightness.dark),
      scaffoldBackgroundColor: C.bg(true),
    ),
    themeMode: G.isDark ? ThemeMode.dark : ThemeMode.light,
    home: const _SplashScreen(),
  );
}

// ════════════════════════════════════════════════════════════
//  SPLASH
// ════════════════════════════════════════════════════════════
class _SplashScreen extends StatefulWidget {
  const _SplashScreen();
  @override
  State<_SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<_SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _lc =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
    ..forward();
  late final AnimationController _tc =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  late final Animation<double> _lScale =
  CurvedAnimation(parent: _lc, curve: Curves.elasticOut)
      .drive(Tween(begin: 0.0, end: 1.0));
  late final Animation<double> _tFade = _tc.drive(Tween(begin: 0.0, end: 1.0));
  late final Animation<double> _tSlide =
  CurvedAnimation(parent: _tc, curve: Curves.easeOut)
      .drive(Tween(begin: 30.0, end: 0.0));

  @override
  void initState() {
    super.initState();
    _lc.addStatusListener((s) {
      if (s == AnimationStatus.completed) _tc.forward();
    });
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a, __) =>
                FadeTransition(opacity: a, child: const _Shell()),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _lc.dispose();
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [C.green1, C.green2, Color(0xFF1A3A1A)],
        ),
      ),
      child: Stack(children: [
        Positioned(
            top: -80,
            right: -80,
            child: _Circle(300, Colors.white, 0.04)),
        Positioned(
            bottom: -100,
            left: -60,
            child: _Circle(280, Colors.white, 0.04)),
        Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _lScale,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 12))
                        ],
                      ),
                      child: const Icon(Icons.home_work_rounded,
                          size: 62, color: C.green1),
                    ),
                  ),
                  const SizedBox(height: 28),
                  AnimatedBuilder(
                    animation: _tc,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(0, _tSlide.value),
                      child: Opacity(opacity: _tFade.value, child: child),
                    ),
                    child: Column(children: [
                      const Text('Nestiq',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.5)),
                      const SizedBox(height: 6),
                      Text(
                          'No Agent. No Commission. Just Home.',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13,
                              letterSpacing: 0.8)),
                    ]),
                  ),
                  const SizedBox(height: 56),
                  ScaleTransition(
                      scale: _lScale, child: const _PulsingDot()),
                ])),
      ]),
    ),
  );
}

class _Circle extends StatelessWidget {
  final double s;
  final Color c;
  final double o;
  const _Circle(this.s, this.c, this.o);
  @override
  Widget build(BuildContext context) => Container(
      width: s,
      height: s,
      decoration:
      BoxDecoration(color: c.withOpacity(o), shape: BoxShape.circle));
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800))
    ..repeat(reverse: true);
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
      opacity: Tween(begin: 0.2, end: 1.0).animate(_c),
      child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
              color: Colors.white60, shape: BoxShape.circle)));
}

// ════════════════════════════════════════════════════════════
//  SHELL
// ════════════════════════════════════════════════════════════
class _Shell extends StatefulWidget {
  const _Shell();
  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  int _tab = 0;
  @override
  void initState() {
    super.initState();
    G.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final d = G.isDark;
    const screens = [
      _HomeScreen(),
      _SavedScreen(),
      _RecentScreen(),
      _AddScreen(),
      _ProfileScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _tab, children: screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: C.card(d),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -4))
          ],
        ),
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavBtn(
                        icon: Icons.explore_outlined,
                        activeIcon: Icons.explore,
                        label: 'Explore',
                        idx: 0,
                        cur: _tab,
                        d: d,
                        onTap: () => setState(() => _tab = 0)),
                    _NavBtn(
                        icon: Icons.favorite_outline,
                        activeIcon: Icons.favorite,
                        label: 'Saved',
                        idx: 1,
                        cur: _tab,
                        d: d,
                        badge: G.favorites.length,
                        onTap: () => setState(() => _tab = 1)),
                    _NavBtn(
                        icon: Icons.history_outlined,
                        activeIcon: Icons.history,
                        label: 'Recent',
                        idx: 2,
                        cur: _tab,
                        d: d,
                        onTap: () => setState(() => _tab = 2)),
                    _NavBtn(
                        icon: Icons.add_home_outlined,
                        activeIcon: Icons.add_home,
                        label: 'List',
                        idx: 3,
                        cur: _tab,
                        d: d,
                        onTap: () => setState(() => _tab = 3)),
                    _NavBtn(
                        icon: Icons.person_outline,
                        activeIcon: Icons.person,
                        label: 'Profile',
                        idx: 4,
                        cur: _tab,
                        d: d,
                        onTap: () => setState(() => _tab = 4)),
                  ]),
            )),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final int idx, cur;
  final bool d;
  final int badge;
  final VoidCallback onTap;
  const _NavBtn(
      {required this.icon,
        required this.activeIcon,
        required this.label,
        required this.idx,
        required this.cur,
        required this.d,
        required this.onTap,
        this.badge = 0});

  @override
  Widget build(BuildContext context) {
    final on = idx == cur;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
            color: on ? C.green1.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(14)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(clipBehavior: Clip.none, children: [
            Icon(on ? activeIcon : icon,
                color: on ? C.green1 : C.sub(d), size: 24),
            if (badge > 0)
              Positioned(
                  top: -4,
                  right: -6,
                  child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          color: C.red, shape: BoxShape.circle),
                      child: Text('$badge',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold)))),
          ]),
          const SizedBox(height: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: on ? FontWeight.w700 : FontWeight.w400,
                  color: on ? C.green1 : C.sub(d))),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  HOME SCREEN
// ════════════════════════════════════════════════════════════
class _HomeScreen extends StatefulWidget {
  const _HomeScreen();
  @override
  State<_HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<_HomeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  final _searchCtrl = TextEditingController();
  String _q = '',
      _fType = 'All',
      _fCat = 'All',
      _sortBy = 'Default',
      _fCity = 'All';
  RangeValues _range = const RangeValues(0, 100000000);
  bool _showSlider = false;
  bool _showFilters = true;
  double _mScale = 1.0, _mBase = 1.0;
  Offset _mOff = Offset.zero, _mLast = Offset.zero;
  String? _selectedPinId;

  @override
  void initState() {
    super.initState();
    G.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<String> get _cities {
    final Set<String> s = {'All'};
    for (final p in allProps) {
      if (p.city != null) s.add(p.city!);
    }
    return s.toList();
  }

  List<Prop> get _filtered {
    var list = allProps.where((p) {
      final t = _fType == 'All' || p.type == _fType;
      final c = _fCat == 'All' || p.cat == _fCat;
      final cy = _fCity == 'All' || p.city == _fCity;
      final s = _q.isEmpty ||
          p.title.toLowerCase().contains(_q.toLowerCase()) ||
          p.loc.toLowerCase().contains(_q.toLowerCase());
      final r = p.pv >= _range.start && p.pv <= _range.end;
      return t && c && s && r && cy;
    }).toList();

    switch (_sortBy) {
      case 'Price ↑':
        list.sort((a, b) => a.pv.compareTo(b.pv));
        break;
      case 'Price ↓':
        list.sort((a, b) => b.pv.compareTo(a.pv));
        break;
      case 'Popular':
        list.sort((a, b) => b.views.compareTo(a.views));
        break;
      case 'Featured':
        list.sort(
                (a, b) => (b.featured ? 1 : 0).compareTo(a.featured ? 1 : 0));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final d = G.isDark;
    final cnt = G.compare.length;
    return Scaffold(
      backgroundColor: C.bg(d),
      body: Column(children: [
        _buildHeader(d),
        if (_showFilters) _buildFilters(d),
        if (_showSlider) _buildSlider(d),
        _buildBar(d),
        Expanded(
            child: TabBarView(
              controller: _tabs,
              physics: const NeverScrollableScrollPhysics(),
              children: [_buildList(d), _buildMap(d)],
            )),
      ]),
      floatingActionButton: cnt > 0
          ? FloatingActionButton.extended(
        backgroundColor: C.green1,
        onPressed: () => _push(_CompareScreen(ids: G.compare.toList())),
        icon: const Icon(Icons.compare_arrows, color: Colors.white),
        label: Text('Compare ($cnt)',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      )
          : null,
    );
  }

  Widget _buildHeader(bool d) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [C.green1, C.green2]),
      ),
      padding: EdgeInsets.fromLTRB(16, top + 12, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.home_work_rounded, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          const Text('Nestiq',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5)),
          const Spacer(),
          _HeaderBtn(
              icon: G.isDark ? Icons.light_mode : Icons.dark_mode,
              onTap: G.toggleDark),
          const SizedBox(width: 8),
          _HeaderBtn(
              icon: Icons.filter_list,
              active: _showFilters,
              onTap: () => setState(() => _showFilters = !_showFilters)),
          const SizedBox(width: 8),
          _HeaderBtn(
              icon: Icons.tune,
              active: _showSlider,
              onTap: () => setState(() => _showSlider = !_showSlider)),
        ]),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (v) => setState(() => _q = v),
            style: const TextStyle(color: Color(0xFF1A1A2E)),
            decoration: InputDecoration(
              hintText: 'City ya area search karo...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: const Icon(Icons.search, color: C.green1),
              suffixIcon: _q.isNotEmpty
                  ? IconButton(
                  icon:
                  const Icon(Icons.clear, size: 18, color: Colors.grey),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _q = '');
                  })
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 36,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10)),
          child: TabBar(
            controller: _tabs,
            indicator:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            labelColor: C.green1,
            unselectedLabelColor: Colors.white,
            labelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            tabs: const [
              Tab(text: '  List View  '),
              Tab(text: '  Map View  ')
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildFilters(bool d) {
    return Container(
      color: C.card(d),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
            children: ['All', 'Sale', 'Rent'].map((f) {
              final on = _fType == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _fType = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                        color: on ? C.green1 : C.surf(d),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(f,
                        style: TextStyle(
                            color: on ? Colors.white : C.txt(d),
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ),
                ),
              );
            }).toList()),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (final entry in [
              ('All', Icons.apps),
              ('House', Icons.house),
              ('Apartment', Icons.apartment),
              ('Plot', Icons.landscape),
              ('Shop', Icons.storefront)
            ])
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _fCat = entry.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                        color: _fCat == entry.$1 ? C.green3 : C.surf(d),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(entry.$2,
                          size: 14,
                          color: _fCat == entry.$1 ? Colors.white : C.sub(d)),
                      const SizedBox(width: 4),
                      Text(entry.$1,
                          style: TextStyle(
                              color: _fCat == entry.$1
                                  ? Colors.white
                                  : C.txt(d),
                              fontSize: 13,
                              fontWeight: _fCat == entry.$1
                                  ? FontWeight.w600
                                  : FontWeight.w400)),
                    ]),
                  ),
                ),
              ),
          ]),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: C.surf(d), borderRadius: BorderRadius.circular(20)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _fCity,
                  isDense: true,
                  dropdownColor: C.card(d),
                  style: TextStyle(
                      color: C.txt(d),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                  icon: Icon(Icons.keyboard_arrow_down,
                      size: 14, color: C.sub(d)),
                  items: _cities
                      .map((c) =>
                      DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _fCity = v ?? 'All'),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: C.surf(d), borderRadius: BorderRadius.circular(20)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _sortBy,
                  isDense: true,
                  dropdownColor: C.card(d),
                  style: TextStyle(
                      color: C.txt(d),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                  icon: Icon(Icons.sort, size: 14, color: C.sub(d)),
                  items: [
                    'Default',
                    'Price ↑',
                    'Price ↓',
                    'Popular',
                    'Featured'
                  ]
                      .map((s) =>
                      DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _sortBy = v ?? 'Default'),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _buildSlider(bool d) {
    return Container(
      color: C.surf(d),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.payments, color: C.green1, size: 16),
          const SizedBox(width: 6),
          Text('Price Range',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: C.txt(d),
                  fontSize: 13)),
          const Spacer(),
          GestureDetector(
            onTap: () =>
                setState(() => _range = const RangeValues(0, 100000000)),
            child: const Text('Reset',
                style: TextStyle(
                    color: C.green3,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ]),
        const SizedBox(height: 2),
        Text(
            '${_pFmt(_range.start.round())} — ${_pFmt(_range.end.round())}',
            style: const TextStyle(
                color: C.green1, fontWeight: FontWeight.bold, fontSize: 12)),
        RangeSlider(
          values: _range,
          min: 0,
          max: 100000000,
          activeColor: C.green1,
          inactiveColor: C.green1.withOpacity(0.2),
          onChanged: (v) => setState(() => _range = v),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Free', style: TextStyle(color: C.sub(d), fontSize: 10)),
          Text('10 Crore+',
              style: TextStyle(color: C.sub(d), fontSize: 10)),
        ]),
      ]),
    );
  }

  Widget _buildBar(bool d) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
    child: Row(children: [
      Text('${_filtered.length} Properties',
          style: TextStyle(
              color: C.sub(d),
              fontSize: 13,
              fontWeight: FontWeight.w600)),
      const Spacer(),
      if (G.compare.isNotEmpty)
        Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: C.green1.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Text('${G.compare.length}/2 comparing',
                style: const TextStyle(
                    color: C.green1,
                    fontSize: 11,
                    fontWeight: FontWeight.w600))),
    ]),
  );

  Widget _buildList(bool d) {
    final props = _filtered;
    if (props.isEmpty) {
      return Center(
          child:
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.search_off, size: 80, color: C.sub(d)),
            const SizedBox(height: 12),
            Text('Koi property nahi mili',
                style: TextStyle(color: C.sub(d), fontSize: 16)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() {
                _q = '';
                _fType = 'All';
                _fCat = 'All';
                _fCity = 'All';
                _sortBy = 'Default';
                _range = const RangeValues(0, 100000000);
                _searchCtrl.clear();
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: C.green1, borderRadius: BorderRadius.circular(20)),
                child: const Text('Filters Reset Karo',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ]));
    }

    final featured = props.where((p) => p.featured).toList();
    final normal = props.where((p) => !p.featured).toList();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (featured.isNotEmpty && _sortBy == 'Default') ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Row(children: [
              const Icon(Icons.star, color: C.gold, size: 16),
              const SizedBox(width: 4),
              Text('Featured Properties',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: C.txt(d),
                      fontSize: 14)),
            ]),
          ),
          ...featured.map((p) => _PropCard(
              prop: p,
              d: d,
              onTap: () {
                G.addRecent(p.id);
                _push(_DetailScreen(prop: p));
              })),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 4, left: 4),
            child: Text('All Properties',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: C.txt(d),
                    fontSize: 14)),
          ),
          ...normal.map((p) => _PropCard(
              prop: p,
              d: d,
              onTap: () {
                G.addRecent(p.id);
                _push(_DetailScreen(prop: p));
              })),
        ] else
          ...props.map((p) => _PropCard(
              prop: p,
              d: d,
              onTap: () {
                G.addRecent(p.id);
                _push(_DetailScreen(prop: p));
              })),
      ],
    );
  }

  Widget _buildMap(bool d) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final mapH = constraints.maxHeight * 0.50;
      final mapW = constraints.maxWidth - 24;

      return Column(children: [
        GestureDetector(
          onScaleStart: (e) {
            _mBase = _mScale;
            _mLast = e.localFocalPoint;
          },
          onScaleUpdate: (e) => setState(() {
            _mScale = (_mBase * e.scale).clamp(0.8, 4.0);
            _mOff += e.localFocalPoint - _mLast;
            _mLast = e.localFocalPoint;
          }),
          onDoubleTap: () => setState(() {
            if (_mScale > 1.5) {
              _mScale = 1.0;
              _mOff = Offset.zero;
            } else {
              _mScale = 2.2;
            }
          }),
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            height: mapH,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: d
                  ? const Color(0xFF243342)
                  : const Color(0xFFD4E9D6),
              border: Border.all(
                  color: C.green1.withOpacity(0.25), width: 1.5),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3))
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(children: [
              Positioned.fill(child: CustomPaint(painter: _GridPainter(d))),
              Center(
                  child: Text('Pakistan',
                      style: TextStyle(
                          color: C.green1.withOpacity(0.1),
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4))),
              ..._buildCityLabels(d, mapW, mapH),
              Positioned.fill(
                child: ClipRect(
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(_mOff.dx, _mOff.dy)
                      ..scale(_mScale),
                    alignment: Alignment.center,
                    child: Stack(
                      children: _filtered.take(12).map((p) {
                        final seed = p.id.codeUnitAt(0) * 137 +
                            p.id.codeUnitAt(p.id.length - 1) * 31;
                        final lx = ((seed % 76) + 5).toDouble();
                        final ly = ((seed * 7 % 72) + 6).toDouble();
                        final selected = _selectedPinId == p.id;
                        return Positioned(
                          left: lx / 100 * mapW,
                          top: ly / 100 * mapH,
                          child: GestureDetector(
                            onTap: () {
                              setState(
                                      () => _selectedPinId =
                                  selected ? null : p.id);
                              if (!selected) {
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  G.addRecent(p.id);
                                  _push(_DetailScreen(prop: p));
                                });
                              }
                            },
                            child: _MapPin(p, selected),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    _ZBtn(Icons.add,
                            () => setState(() => _mScale = (_mScale + 0.4).clamp(0.8, 4.0))),
                    const SizedBox(height: 4),
                    _ZBtn(Icons.remove,
                            () => setState(() => _mScale = (_mScale - 0.4).clamp(0.8, 4.0))),
                    const SizedBox(height: 4),
                    _ZBtn(Icons.my_location, () => setState(() {
                      _mScale = 1.0;
                      _mOff = Offset.zero;
                    })),
                  ])),
              Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                          '${(_mScale * 100).round()}%  •  Pinch / Double-tap',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 9)))),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMapLegend('Sale', C.green1),
                        const SizedBox(height: 3),
                        _buildMapLegend('Rent', C.green3),
                      ])),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Row(children: [
            Icon(Icons.touch_app, size: 12, color: C.sub(d)),
            const SizedBox(width: 4),
            Text('Drag • Pinch • Double-tap to zoom',
                style: TextStyle(color: C.sub(d), fontSize: 10)),
            const Spacer(),
            Text('${_filtered.length} pins',
                style: const TextStyle(
                    color: C.green1,
                    fontWeight: FontWeight.w600,
                    fontSize: 11)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 4, 14, 2),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Properties',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: C.txt(d)))),
        ),
        Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _MapTile(
                prop: _filtered[i],
                d: d,
                onTap: () {
                  G.addRecent(_filtered[i].id);
                  _push(_DetailScreen(prop: _filtered[i]));
                },
              ),
            )),
      ]);
    });
  }

  // FIX: Renamed _MapLegend from top-level function to instance method
  Widget _buildMapLegend(String label, Color color) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600)),
      ]);

  List<Widget> _buildCityLabels(bool d, double w, double h) {
    final cities = [
      ('Karachi', 0.28, 0.82),
      ('Lahore', 0.58, 0.42),
      ('Islamabad', 0.52, 0.22),
      ('Faisalabad', 0.48, 0.45),
      ('Rawalpindi', 0.51, 0.24),
    ];
    return cities
        .map((c) => Positioned(
      left: c.$2 * w,
      top: c.$3 * h,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
            color: d ? Colors.black38 : Colors.white60,
            borderRadius: BorderRadius.circular(4)),
        child: Text(c.$1,
            style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: C.txt(d))),
      ),
    ))
        .toList();
  }

  void _push(Widget w) => Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, __) => SlideTransition(
          position: Tween<Offset>(
              begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(
              parent: a, curve: Curves.easeOutCubic)),
          child: w,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ));
}

class _HeaderBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  const _HeaderBtn(
      {required this.icon, required this.onTap, this.active = false});
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: active
                  ? Colors.white
                  : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon,
              color: active ? C.green1 : Colors.white, size: 20)));
}

class _GridPainter extends CustomPainter {
  final bool d;
  _GridPainter(this.d);
  @override
  void paint(Canvas c, Size s) {
    final g = Paint()
      ..color = (d ? Colors.white : C.green1).withOpacity(0.06)
      ..strokeWidth = 1;
    final r = Paint()
      ..color = (d ? Colors.white : C.green1).withOpacity(0.13)
      ..strokeWidth = 2.5;
    for (double x = 0; x < s.width; x += 44) {
      c.drawLine(Offset(x, 0), Offset(x, s.height), g);
    }
    for (double y = 0; y < s.height; y += 44) {
      c.drawLine(Offset(0, y), Offset(s.width, y), g);
    }
    c.drawLine(Offset(0, s.height * .33), Offset(s.width, s.height * .33), r);
    c.drawLine(Offset(0, s.height * .66), Offset(s.width, s.height * .66), r);
    c.drawLine(Offset(s.width * .3, 0), Offset(s.width * .3, s.height), r);
    c.drawLine(Offset(s.width * .7, 0), Offset(s.width * .7, s.height), r);
  }

  @override
  bool shouldRepaint(_GridPainter o) => o.d != d;
}

class _MapPin extends StatelessWidget {
  final Prop p;
  final bool selected;
  const _MapPin(this.p, this.selected);
  @override
  Widget build(BuildContext context) {
    final col = p.type == 'Sale' ? C.green1 : C.green3;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      // FIX: Use Matrix4.identity() with ..scale() instead of scaleByDouble
      transform: selected
          ? (Matrix4.identity()..scale(1.2, 1.2, 1.0))
          : Matrix4.identity(),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: selected ? C.gold : col,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(selected ? 0.4 : 0.25),
                  blurRadius: selected ? 8 : 5)
            ],
          ),
          child: Text(p.price.split(' ').take(2).join(' '),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold)),
        ),
        Container(width: 2, height: 6, color: selected ? C.gold : col),
        Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
                color: selected ? C.gold : col, shape: BoxShape.circle)),
      ]),
    );
  }
}

class _ZBtn extends StatelessWidget {
  final IconData i;
  final VoidCallback t;
  const _ZBtn(this.i, this.t);
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: t,
      child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.15), blurRadius: 4)
              ]),
          child: Icon(i, size: 17, color: C.green1)));
}

class _MapTile extends StatelessWidget {
  final Prop prop;
  final bool d;
  final VoidCallback onTap;
  const _MapTile(
      {required this.prop, required this.d, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: C.card(d), borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(prop.img,
                    width: 60,
                    height: 55,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 55,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported,
                            color: Colors.grey)))),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prop.title,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: C.txt(d)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(prop.loc,
                          style: TextStyle(color: C.sub(d), fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(prop.price,
                          style: const TextStyle(
                              color: C.green1,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ])),
            Icon(Icons.arrow_forward_ios, size: 13, color: C.sub(d)),
          ])));
}

// ════════════════════════════════════════════════════════════
//  PROPERTY CARD
// ════════════════════════════════════════════════════════════
class _PropCard extends StatefulWidget {
  final Prop prop;
  final bool d;
  final VoidCallback onTap;
  const _PropCard(
      {required this.prop, required this.d, required this.onTap});
  @override
  State<_PropCard> createState() => _PropCardState();
}

class _PropCardState extends State<_PropCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hc = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 250));
  @override
  void initState() {
    super.initState();
    G.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _hc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.prop;
    final d = widget.d;
    final fav = G.isFav(p.id);
    final inCmp = G.inCompare(p.id);
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: C.card(d),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(d ? 0.3 : 0.07),
                blurRadius: 12,
                offset: const Offset(0, 5))
          ],
        ),
        child:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(p.img,
                  height: 195,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      height: 195,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported,
                          size: 60, color: Colors.grey))),
            ),
            Positioned.fill(
                child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20)),
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3)
                                ]))))),
            Positioned(
                top: 12,
                left: 12,
                child: _Badge(
                    p.type, p.type == 'Sale' ? C.green1 : C.green3)),
            Positioned(
                top: 12, right: 52, child: _Badge(p.cat, Colors.black54)),
            if (p.featured)
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: _Badge(
                      '⭐ Featured', C.gold.withOpacity(0.9))),
            Positioned(
                bottom: 10,
                right: 10,
                child: Row(children: [
                  const Icon(Icons.remove_red_eye_outlined,
                      color: Colors.white70, size: 12),
                  const SizedBox(width: 3),
                  Text('${p.views}',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 10)),
                ])),
            Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    _hc.forward().then((_) => _hc.reverse());
                    G.toggleFav(p.id);
                  },
                  child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          shape: BoxShape.circle),
                      child: ScaleTransition(
                          scale: Tween(begin: 1.0, end: 1.3).animate(
                              CurvedAnimation(
                                  parent: _hc,
                                  curve: Curves.elasticOut)),
                          child: Icon(
                              fav
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color:
                              fav ? Colors.redAccent : Colors.white,
                              size: 20))),
                )),
            if (inCmp)
              Positioned(
                  top: 48,
                  right: 8,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: C.gold,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Text('Comparing',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)))),
          ]),
          Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: C.txt(d))),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.location_on_outlined,
                          size: 13, color: C.green3),
                      const SizedBox(width: 3),
                      Expanded(
                          child: Text(p.loc,
                              style: TextStyle(
                                  color: C.sub(d), fontSize: 12),
                              overflow: TextOverflow.ellipsis)),
                    ]),
                    const SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(p.price,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: C.green1)),
                          Row(children: [
                            if (p.beds > 0)
                              _RChip(Icons.bed_outlined, '${p.beds}', d),
                            if (p.baths > 0)
                              _RChip(
                                  Icons.bathtub_outlined, '${p.baths}', d),
                            if (p.halls > 0)
                              _RChip(Icons.meeting_room_outlined,
                                  '${p.halls}', d),
                          ]),
                        ]),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => G.toggleCompare(p.id),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                              color: inCmp
                                  ? C.green1.withOpacity(0.1)
                                  : C.surf(d),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: inCmp
                                      ? C.green1
                                      : Colors.transparent)),
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.compare_arrows,
                                    size: 14,
                                    color: inCmp ? C.green1 : C.sub(d)),
                                const SizedBox(width: 4),
                                Text(
                                    inCmp
                                        ? 'Remove from Compare'
                                        : 'Add to Compare',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color:
                                        inCmp ? C.green1 : C.sub(d),
                                        fontWeight: FontWeight.w500)),
                              ])),
                    ),
                  ])),
        ]),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String t;
  final Color c;
  const _Badge(this.t, this.c);
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
      BoxDecoration(color: c, borderRadius: BorderRadius.circular(20)),
      child: Text(t,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold)));
}

class _RChip extends StatelessWidget {
  final IconData i;
  final String l;
  final bool d;
  const _RChip(this.i, this.l, this.d);
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(i, size: 14, color: C.sub(d)),
        const SizedBox(width: 2),
        Text(l, style: TextStyle(color: C.sub(d), fontSize: 12))
      ]));
}

// ════════════════════════════════════════════════════════════
//  ROOM DETAIL BOTTOM SHEET
// ════════════════════════════════════════════════════════════
void _showRoomDetail(BuildContext context, RoomImg room, bool d) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, sc) => Container(
        decoration: BoxDecoration(
          color: C.card(d),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2)),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: sc,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      const Icon(Icons.photo_library_outlined,
                          color: C.green1, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(room.label,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: C.txt(d))),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: Image.network(
                      room.url,
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          height: 260,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported,
                              size: 80, color: Colors.grey)),
                    ),
                  ),
                  if (room.description.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Room Details',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: C.txt(d))),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: C.surf(d),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.info_outline,
                                        color: C.green1, size: 18),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(room.description,
                                          style: TextStyle(
                                              color: C.sub(d),
                                              fontSize: 14,
                                              height: 1.6)),
                                    ),
                                  ]),
                            ),
                          ]),
                    ),
                  ],
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ]),
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════
//  PLOT FEATURES BOTTOM SHEET
// ════════════════════════════════════════════════════════════
void _showPlotFeatures(BuildContext context, Prop p, bool d) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: C.card(d),
        borderRadius:
        const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(height: 16),
        Row(children: [
          const Icon(Icons.landscape, color: C.green1, size: 22),
          const SizedBox(width: 10),
          Text('Plot Details',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: C.txt(d))),
        ]),
        const SizedBox(height: 8),
        if (p.possessionStatus != null)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: C.green1.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: C.green1.withOpacity(0.3)),
            ),
            child: Row(children: [
              const Icon(Icons.check_circle, color: C.green1, size: 18),
              const SizedBox(width: 8),
              Text(p.possessionStatus!,
                  style: const TextStyle(
                      color: C.green1,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ]),
          ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: p.plotFeatures
              .map((f) => Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
                color: C.surf(d),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: C.green1.withOpacity(0.2))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(f.icon, size: 16, color: C.green1),
              const SizedBox(width: 8),
              Text(f.label,
                  style: TextStyle(
                      color: C.txt(d),
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ]),
          ))
              .toList(),
        ),
        const SizedBox(height: 20),
      ]),
    ),
  );
}

// ════════════════════════════════════════════════════════════
//  STAT DETAIL BOTTOM SHEET
// ════════════════════════════════════════════════════════════
void _showStatRooms(
    BuildContext context, Prop p, String statType, bool d) {
  List<RoomImg> relevantRooms = [];
  IconData statIcon = Icons.home;
  String statTitle = '';

  switch (statType) {
    case 'beds':
      statIcon = Icons.bed;
      statTitle = '${p.beds} Bedroom${p.beds > 1 ? 's' : ''}';
      relevantRooms = p.rooms
          .where((r) =>
      r.label.toLowerCase().contains('bed') ||
          r.label.toLowerCase().contains('master') ||
          r.label.toLowerCase().contains('suite') ||
          r.label.toLowerCase().contains('room'))
          .toList();
      if (relevantRooms.isEmpty) {
        relevantRooms = p.rooms.take(p.beds.clamp(0, p.rooms.length)).toList();
      }
      break;
    case 'baths':
      statIcon = Icons.bathtub;
      statTitle = '${p.baths} Bathroom${p.baths > 1 ? 's' : ''}';
      relevantRooms = p.rooms
          .where((r) =>
      r.label.toLowerCase().contains('bath') ||
          r.label.toLowerCase().contains('toilet') ||
          r.label.toLowerCase().contains('washroom'))
          .toList();
      if (relevantRooms.isEmpty && p.rooms.isNotEmpty) {
        relevantRooms = [p.rooms.first];
      }
      break;
    case 'halls':
      statIcon = Icons.meeting_room;
      statTitle = '${p.halls} Hall${p.halls > 1 ? 's' : ''}';
      relevantRooms = p.rooms
          .where((r) =>
      r.label.toLowerCase().contains('hall') ||
          r.label.toLowerCase().contains('lounge') ||
          r.label.toLowerCase().contains('living') ||
          r.label.toLowerCase().contains('drawing') ||
          r.label.toLowerCase().contains('dining'))
          .toList();
      if (relevantRooms.isEmpty && p.rooms.isNotEmpty) {
        relevantRooms = [p.rooms.first];
      }
      break;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: relevantRooms.isEmpty ? 0.4 : 0.7,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (_, sc) => Container(
        decoration: BoxDecoration(
          color: C.card(d),
          borderRadius:
          const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          controller: sc,
          child: Column(children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: C.green1.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(statIcon, color: C.green1, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(statTitle,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: C.txt(d))),
                      Text(p.title,
                          style:
                          TextStyle(color: C.sub(d), fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ]),
              ]),
            ),
            if (relevantRooms.isEmpty)
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(children: [
                  Icon(statIcon, size: 60, color: C.sub(d)),
                  const SizedBox(height: 12),
                  Text('No photos available yet',
                      style: TextStyle(
                          color: C.sub(d),
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Text('Owner ne abhi tak photos upload nahi ki',
                      style: TextStyle(color: C.sub(d), fontSize: 12)),
                ]),
              )
            else
              ...relevantRooms.map((r) => GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _showRoomDetail(context, r, d);
                },
                child: Container(
                  margin:
                  const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(children: [
                      Image.network(r.url,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              height: 180,
                              color: Colors.grey[300],
                              child: const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey))),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.75),
                                        Colors.transparent
                                      ])),
                              child: Row(children: [
                                Expanded(
                                  child: Text(r.label,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight:
                                          FontWeight.bold)),
                                ),
                                const Icon(Icons.open_in_full,
                                    color: Colors.white70, size: 14),
                              ]))),
                    ]),
                  ),
                ),
              )),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════
//  AMENITIES BOTTOM SHEET
// ════════════════════════════════════════════════════════════
void _showAmenities(BuildContext context, Prop p, bool d) {
  final amenityIcons = {
    'Solar': Icons.solar_power,
    'Generator': Icons.electric_bolt,
    'CCTV': Icons.videocam,
    'Gated': Icons.lock,
    'Parking': Icons.local_parking,
    'Pool': Icons.pool,
    'Gym': Icons.fitness_center,
    'Garden': Icons.park,
    'Elevator': Icons.elevator,
    'Marble': Icons.home,
    'Furnished': Icons.chair,
    'Kitchen': Icons.kitchen,
    'AC': Icons.ac_unit,
    'WiFi': Icons.wifi,
    'Security': Icons.security,
    'Gas': Icons.local_fire_department,
    'Water': Icons.water_drop,
    'Servant': Icons.person,
    'Basement': Icons.foundation,
    'Balcony': Icons.balcony,
    'Terrace': Icons.deck,
    'Sea': Icons.waves,
    'Creek': Icons.water,
    'Hill': Icons.landscape,
    'Park': Icons.park,
    'Mosque': Icons.mosque,
    'School': Icons.school,
    'Hospital': Icons.local_hospital,
    'Market': Icons.shopping_bag,
    'Road': Icons.add_road,
    'Corner': Icons.crop_square,
    'Investment': Icons.trending_up,
    'Rent': Icons.payments,
    'Smart': Icons.phone_android,
    'Cinema': Icons.movie,
  };

  IconData getIcon(String amenity) {
    for (final entry in amenityIcons.entries) {
      if (amenity.toLowerCase().contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    return Icons.check_circle_outline;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (_, sc) => Container(
        decoration: BoxDecoration(
          color: C.card(d),
          borderRadius:
          const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          controller: sc,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Row(children: [
                    const Icon(Icons.star_rounded,
                        color: C.gold, size: 24),
                    const SizedBox(width: 8),
                    Text('Features & Amenities',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: C.txt(d))),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: p.amenities
                        .map((a) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: C.surf(d),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: C.green1.withOpacity(0.2)),
                      ),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(getIcon(a),
                                size: 16, color: C.green1),
                            const SizedBox(width: 8),
                            Text(a,
                                style: TextStyle(
                                    color: C.txt(d),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                          ]),
                    ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 30),
              ]),
        ),
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════
//  DETAIL SCREEN
// ════════════════════════════════════════════════════════════
class _DetailScreen extends StatefulWidget {
  final Prop prop;
  const _DetailScreen({required this.prop});
  @override
  State<_DetailScreen> createState() => _DetailState();
}

class _DetailState extends State<_DetailScreen> {
  bool _descExpanded = false;

  @override
  void initState() {
    super.initState();
    G.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.prop;
    final d = G.isDark;
    final fav = G.isFav(p.id);
    return Scaffold(
      backgroundColor: C.bg(d),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: C.green1,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.arrow_back, color: Colors.white)),
          ),
          actions: [
            GestureDetector(
              onTap: () => _shareSheet(context, p, d),
              child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.share_outlined,
                      color: Colors.white, size: 20)),
            ),
            GestureDetector(
              onTap: () => G.toggleFav(p.id),
              child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                      fav ? Icons.favorite : Icons.favorite_outline,
                      color: fav ? Colors.redAccent : Colors.white,
                      size: 20)),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(children: [
              Image.network(p.img,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported,
                          size: 80, color: Colors.grey))),
              Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.remove_red_eye,
                          color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text('${p.views} views',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11)),
                    ]),
                  )),
            ]),
          ),
        ),
        SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                            child: Text(p.title,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: C.txt(d)))),
                        _Badge(p.type,
                            p.type == 'Sale' ? C.green1 : C.green3),
                      ]),
                      if (p.featured) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: C.gold.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: C.gold.withOpacity(0.4))),
                          child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: C.gold, size: 14),
                                SizedBox(width: 4),
                                Text('Featured Property',
                                    style: TextStyle(
                                        color: C.gold,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ]),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(children: [
                        const Icon(Icons.location_on,
                            color: C.green3, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                            child: Text(p.loc,
                                style: TextStyle(
                                    color: C.sub(d), fontSize: 14))),
                      ]),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          if (p.area != null)
                            _InfoTag(
                                Icons.square_foot, '${p.area} Marla', d),
                          if (p.facing != null)
                            _InfoTag(Icons.explore,
                                '${p.facing} Facing', d),
                          if (p.furnishing != null)
                            _InfoTag(Icons.chair, p.furnishing!, d),
                          if (p.constructionYear != null)
                            _InfoTag(Icons.construction,
                                'Built ${p.constructionYear}', d),
                          if (p.possessionStatus != null &&
                              p.cat == 'Plot')
                            _InfoTag(Icons.check_circle,
                                p.possessionStatus!, d,
                                color: C.green3),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [C.green1, C.green2]),
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(children: [
                          const Icon(Icons.payments,
                              color: Colors.white70, size: 26),
                          const SizedBox(width: 12),
                          Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text('Price',
                                    style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12)),
                                Text(p.price,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white)),
                              ]),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(p.cat,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 14),
                      if (p.cat == 'Plot')
                        GestureDetector(
                          onTap: () =>
                              _showPlotFeatures(context, p, d),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: C.surf(d),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: C.green1.withOpacity(0.3)),
                            ),
                            child: Row(children: [
                              const Icon(Icons.landscape,
                                  color: C.green1, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text('Plot Features & Details',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: C.txt(d),
                                              fontSize: 14)),
                                      Text(
                                          '${p.plotFeatures.length} features available — tap to view',
                                          style: TextStyle(
                                              color: C.sub(d),
                                              fontSize: 12)),
                                    ]),
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 14, color: C.green1),
                            ]),
                          ),
                        )
                      else
                        Row(children: [
                          if (p.beds > 0)
                            Expanded(
                                child: GestureDetector(
                                  onTap: () => _showStatRooms(
                                      context, p, 'beds', d),
                                  child: _StatBox(Icons.bed, '${p.beds}',
                                      'Beds', d,
                                      tappable: true),
                                )),
                          if (p.baths > 0)
                            Expanded(
                                child: GestureDetector(
                                  onTap: () => _showStatRooms(
                                      context, p, 'baths', d),
                                  child: _StatBox(Icons.bathtub,
                                      '${p.baths}', 'Baths', d,
                                      tappable: true),
                                )),
                          if (p.halls > 0)
                            Expanded(
                                child: GestureDetector(
                                  onTap: () => _showStatRooms(
                                      context, p, 'halls', d),
                                  child: _StatBox(Icons.meeting_room,
                                      '${p.halls}', 'Halls', d,
                                      tappable: true),
                                )),
                          Expanded(
                              child: _StatBox(Icons.home_work,
                                  p.cat[0], p.cat, d)),
                        ]),
                      const SizedBox(height: 8),
                      if (p.cat != 'Plot')
                        Center(
                          child: Text(
                              '💡 Tap Beds / Baths / Halls to see room photos',
                              style: TextStyle(
                                  color: C.sub(d),
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic)),
                        ),
                      const SizedBox(height: 16),
                      if (p.amenities.isNotEmpty) ...[
                        GestureDetector(
                          onTap: () =>
                              _showAmenities(context, p, d),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                                color: C.card(d),
                                borderRadius:
                                BorderRadius.circular(14),
                                border: Border.all(
                                    color:
                                    C.green1.withOpacity(0.2))),
                            child: Row(children: [
                              const Icon(Icons.star_rounded,
                                  color: C.gold, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text('Features & Amenities',
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.w700,
                                                color: C.txt(d),
                                                fontSize: 14)),
                                        Text(
                                            p.amenities
                                                .take(3)
                                                .join(' • ') +
                                                (p.amenities.length > 3
                                                    ? ' +${p.amenities.length - 3} more'
                                                    : ''),
                                            style: TextStyle(
                                                color: C.sub(d),
                                                fontSize: 11),
                                            maxLines: 1,
                                            overflow:
                                            TextOverflow.ellipsis),
                                      ])),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 14, color: C.green1),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Text('Description',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: C.txt(d))),
                      const SizedBox(height: 8),
                      AnimatedCrossFade(
                        firstChild: Text(p.desc,
                            style: TextStyle(
                                color: C.sub(d),
                                fontSize: 14,
                                height: 1.7),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis),
                        secondChild: Text(p.desc,
                            style: TextStyle(
                                color: C.sub(d),
                                fontSize: 14,
                                height: 1.7)),
                        crossFadeState: _descExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                      GestureDetector(
                        onTap: () => setState(
                                () => _descExpanded = !_descExpanded),
                        child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                                _descExpanded
                                    ? 'Kam dikhaein ▲'
                                    : 'Ziada padhein ▼',
                                style: const TextStyle(
                                    color: C.green1,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13))),
                      ),
                      const SizedBox(height: 18),
                      if (p.rooms.isNotEmpty) ...[
                        Text('Room Photos 📷',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: C.txt(d))),
                        const SizedBox(height: 12),
                        ...p.rooms.map((r) => _RoomCard(r, d: d)),
                        const SizedBox(height: 8),
                      ],
                      _buildSimilar(p, d),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: C.surf(d),
                            borderRadius: BorderRadius.circular(14)),
                        child: Row(children: [
                          const Icon(Icons.compare_arrows,
                              color: C.green1),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text('Compare karo',
                                  style: TextStyle(
                                      color: C.txt(d),
                                      fontWeight: FontWeight.w600))),
                          GestureDetector(
                            onTap: () => G.toggleCompare(p.id),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                  color: G.inCompare(p.id)
                                      ? C.red
                                      : C.green1,
                                  borderRadius:
                                  BorderRadius.circular(10)),
                              child: Text(
                                  G.inCompare(p.id) ? 'Remove' : 'Add',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 18),
                      Text('Owner Se Contact Karo',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: C.txt(d))),
                      const SizedBox(height: 12),
                      _CBtn(Icons.phone_outlined, 'Call Karo', p.phone,
                          C.green1,
                              () => _snack(context, 'Calling ${p.phone}', C.green1)),
                      const SizedBox(height: 10),
                      _CBtn(Icons.chat_outlined, 'WhatsApp Karo',
                          p.phone, C.wa,
                              () => _snack(context,
                              'WhatsApp kholne ki koshish...', C.wa)),
                      const SizedBox(height: 10),
                      _CBtn(Icons.email_outlined, 'Email Karo',
                          p.email, C.blue,
                              () => _snack(
                              context, 'Email: ${p.email}', C.blue)),
                      const SizedBox(height: 30),
                    ]))),
      ]),
    );
  }

  Widget _buildSimilar(Prop p, bool d) {
    final similar = allProps
        .where((x) =>
    x.id != p.id && x.cat == p.cat && x.type == p.type)
        .take(3)
        .toList();
    if (similar.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Similar Properties',
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: C.txt(d))),
      const SizedBox(height: 10),
      SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: similar.length,
          itemBuilder: (ctx, i) {
            final s = similar[i];
            return GestureDetector(
              onTap: () {
                G.addRecent(s.id);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => _DetailScreen(prop: s)));
              },
              child: Container(
                width: 170,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                    color: C.card(d),
                    borderRadius: BorderRadius.circular(14)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14)),
                          child: Image.network(s.img,
                              height: 110,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                  height: 110,
                                  color: Colors.grey[300]))),
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(s.title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: C.txt(d)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                Text(s.price,
                                    style: const TextStyle(
                                        color: C.green1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11)),
                              ])),
                    ]),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 16),
    ]);
  }

  void _shareSheet(BuildContext ctx, Prop p, bool d) {
    showModalBottomSheet(
        context: ctx,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: C.card(d),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24))),
          child:
          Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('Property Share Karo',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: C.txt(d))),
            const SizedBox(height: 20),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SBtn(Icons.message, 'WhatsApp', C.wa, () {
                    Navigator.pop(ctx);
                    _snack(ctx, 'WhatsApp pe share ho raha hai...',
                        C.wa);
                  }),
                  _SBtn(Icons.copy, 'Link Copy', C.green1, () {
                    Navigator.pop(ctx);
                    _snack(ctx, 'Link copy ho gayi!', C.green1);
                  }),
                  _SBtn(Icons.sms_outlined, 'SMS', C.blue, () {
                    Navigator.pop(ctx);
                    _snack(
                        ctx, 'SMS bheja ja raha hai...', C.blue);
                  }),
                  _SBtn(Icons.more_horiz, 'Aur', Colors.grey, () {
                    Navigator.pop(ctx);
                    _snack(ctx, 'Share...', Colors.grey);
                  }),
                ]),
            const SizedBox(height: 16),
          ]),
        ));
  }
}

// ════════════════════════════════════════════════════════════
//  INFO TAG WIDGET
// ════════════════════════════════════════════════════════════
class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool d;
  final Color? color;
  const _InfoTag(this.icon, this.label, this.d, {this.color});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: (color ?? C.green1).withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
          color: (color ?? C.green1).withOpacity(0.25)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: color ?? C.green1),
      const SizedBox(width: 5),
      Text(label,
          style: TextStyle(
              color: color ?? C.green1,
              fontSize: 11,
              fontWeight: FontWeight.w600)),
    ]),
  );
}

class _StatBox extends StatelessWidget {
  final IconData i;
  final String v, l;
  final bool d;
  final bool tappable;
  const _StatBox(this.i, this.v, this.l, this.d, {this.tappable = false});
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          color: tappable ? C.green1.withOpacity(0.08) : C.surf(d),
          borderRadius: BorderRadius.circular(12),
          border: tappable
              ? Border.all(color: C.green1.withOpacity(0.3), width: 1)
              : null),
      child: Column(children: [
        Icon(i, color: C.green1, size: 20),
        const SizedBox(height: 4),
        Text(v,
            style:
            TextStyle(fontWeight: FontWeight.w800, color: C.txt(d))),
        Text(l, style: TextStyle(color: C.sub(d), fontSize: 10)),
        if (tappable)
          const Text('tap',
              style: TextStyle(
                  color: C.green1,
                  fontSize: 9,
                  fontWeight: FontWeight.w600)),
      ]));
}

class _RoomCard extends StatelessWidget {
  final RoomImg r;
  final bool d;
  const _RoomCard(this.r, {required this.d});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => _showRoomDetail(context, r, d),
    child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4))
            ]),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(children: [
              Image.network(r.url,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported,
                          size: 50, color: Colors.grey))),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent
                              ])),
                      child: Row(children: [
                        Expanded(
                          child: Text(r.label,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const Icon(Icons.open_in_full,
                            color: Colors.white70, size: 16),
                      ]))),
            ]))),
  );
}

class _CBtn extends StatelessWidget {
  final IconData i;
  final String l, sl;
  final Color c;
  final VoidCallback t;
  const _CBtn(this.i, this.l, this.sl, this.c, this.t);
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: t,
      child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: c.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ]),
          child: Row(children: [
            Icon(i, color: Colors.white, size: 24),
            const SizedBox(width: 14),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  Text(sl,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12)),
                ]),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white60, size: 14),
          ])));
}

class _SBtn extends StatelessWidget {
  final IconData i;
  final String l;
  final Color c;
  final VoidCallback t;
  const _SBtn(this.i, this.l, this.c, this.t);
  @override
  Widget build(BuildContext context) =>
      GestureDetector(onTap: t, child: Column(children: [
        Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
                color: c.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14)),
            child: Icon(i, color: c, size: 26)),
        const SizedBox(height: 6),
        Text(l,
            style: TextStyle(
                color: c,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      ]));
}

// ════════════════════════════════════════════════════════════
//  SAVED SCREEN
// ════════════════════════════════════════════════════════════
class _SavedScreen extends StatefulWidget {
  const _SavedScreen();
  @override
  State<_SavedScreen> createState() => _SavedState();
}

class _SavedState extends State<_SavedScreen> {
  @override
  void initState() {
    super.initState();
    G.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final d = G.isDark;
    final favs = allProps.where((p) => G.isFav(p.id)).toList();
    return Scaffold(
      backgroundColor: C.bg(d),
      appBar: AppBar(
        backgroundColor: C.green1,
        elevation: 0,
        title: Row(children: [
          const Icon(Icons.favorite, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text('Saved (${favs.length})',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
        ]),
      ),
      body: favs.isEmpty
          ? _Empty(Icons.favorite_border, 'Koi saved property nahi',
          'Dil se pasand aaye toh ❤️ dabao', d)
          : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: favs.length,
          itemBuilder: (_, i) => _PropCard(
              prop: favs[i],
              d: d,
              onTap: () => _push(context, _DetailScreen(prop: favs[i])))),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  RECENT SCREEN
// ════════════════════════════════════════════════════════════
class _RecentScreen extends StatefulWidget {
  const _RecentScreen();
  @override
  State<_RecentScreen> createState() => _RecentState();
}

class _RecentState extends State<_RecentScreen> {
  @override
  void initState() {
    super.initState();
    G.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final d = G.isDark;
    final recents = G.recents
        .map((id) => allProps.firstWhere((p) => p.id == id,
        orElse: () => allProps.first))
        .toList();
    return Scaffold(
      backgroundColor: C.bg(d),
      appBar: AppBar(
        backgroundColor: C.green1,
        elevation: 0,
        title: const Row(children: [
          Icon(Icons.history, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text('Recently Viewed',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
        ]),
        actions: [
          if (recents.isNotEmpty)
            TextButton(
                onPressed: G.clearRecents,
                child: const Text('Clear',
                    style:
                    TextStyle(color: Colors.white70, fontSize: 13)))
        ],
      ),
      body: recents.isEmpty
          ? _Empty(Icons.history_outlined, 'Koi viewed property nahi',
          'Properties dekho — yahan dikh jaengi', d)
          : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: recents.length,
          itemBuilder: (_, i) =>
              _RecentTile(prop: recents[i], idx: i, d: d)),
    );
  }
}

class _RecentTile extends StatelessWidget {
  final Prop prop;
  final int idx;
  final bool d;
  const _RecentTile(
      {required this.prop, required this.idx, required this.d});
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => _push(context, _DetailScreen(prop: prop)),
      child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: C.card(d),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3))
              ]),
          child: Row(children: [
            Stack(children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(prop.img,
                      width: 80,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 72,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported,
                              color: Colors.grey)))),
              Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                          color: C.green1, shape: BoxShape.circle),
                      child: Center(
                          child: Text('${idx + 1}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold))))),
            ]),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prop.title,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: C.txt(d)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Text(prop.loc,
                          style: TextStyle(color: C.sub(d), fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 5),
                      Text(prop.price,
                          style: const TextStyle(
                              color: C.green1,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ])),
            Icon(Icons.arrow_forward_ios, size: 13, color: C.sub(d)),
          ])));
}

// ════════════════════════════════════════════════════════════
//  COMPARE SCREEN
// ════════════════════════════════════════════════════════════
class _CompareScreen extends StatelessWidget {
  final List<String> ids;
  const _CompareScreen({required this.ids});
  @override
  Widget build(BuildContext context) {
    final d = G.isDark;
    final props =
    ids.map((id) => allProps.firstWhere((p) => p.id == id)).toList();
    if (props.length < 2) {
      return Scaffold(
          appBar: AppBar(title: const Text('Compare')),
          body: const Center(child: Text('Select 2 properties')));
    }
    final a = props[0];
    final b = props[1];
    return Scaffold(
      backgroundColor: C.bg(d),
      appBar: AppBar(
        backgroundColor: C.green1,
        title: const Text('Compare ⚖️',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
              onPressed: () => G.clearCompare(),
              child: const Text('Clear',
                  style: TextStyle(color: Colors.white70)))
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: _CHead(a, d)),
              Container(
                  width: 1,
                  color: C.green1.withOpacity(0.2),
                  margin: const EdgeInsets.symmetric(horizontal: 8)),
              Expanded(child: _CHead(b, d)),
            ]),
            const SizedBox(height: 20),
            _CRow('🏷️ Type', a.type, b.type, d),
            _CRow('🏠 Category', a.cat, b.cat, d),
            _CRow('📍 Location', a.loc, b.loc, d),
            _CRow('💰 Price', a.price, b.price, d, hi: true),
            _CRow('🛏️ Bedrooms', '${a.beds}', '${b.beds}', d, num: true),
            _CRow('🚿 Bathrooms', '${a.baths}', '${b.baths}', d, num: true),
            _CRow('🛋️ Halls', '${a.halls}', '${b.halls}', d, num: true),
            _CRow('📸 Room Photos', '${a.rooms.length}',
                '${b.rooms.length}', d,
                num: true),
            _CRow('👁️ Views', '${a.views}', '${b.views}', d, num: true),
            if (a.area != null || b.area != null)
              _CRow('📐 Area (Marla)', '${a.area ?? "N/A"}',
                  '${b.area ?? "N/A"}', d),
            if (a.furnishing != null || b.furnishing != null)
              _CRow('🛋 Furnishing', a.furnishing ?? 'N/A',
                  b.furnishing ?? 'N/A', d),
            if (a.facing != null || b.facing != null)
              _CRow('🧭 Facing', a.facing ?? 'N/A', b.facing ?? 'N/A', d),
            _CRow('⭐ Amenities', '${a.amenities.length}',
                '${b.amenities.length}', d,
                num: true),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                  child: _CBtn(
                      Icons.phone_outlined,
                      'Call A',
                      a.phone,
                      C.green1,
                          () => _snack(
                          context, 'Calling ${a.phone}', C.green1))),
              const SizedBox(width: 10),
              Expanded(
                  child: _CBtn(
                      Icons.phone_outlined,
                      'Call B',
                      b.phone,
                      C.green3,
                          () => _snack(
                          context, 'Calling ${b.phone}', C.green3))),
            ]),
          ])),
    );
  }
}

class _CHead extends StatelessWidget {
  final Prop p;
  final bool d;
  const _CHead(this.p, this.d);
  @override
  Widget build(BuildContext context) => Column(children: [
    ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(p.img,
            height: 110,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
                height: 110,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported,
                    color: Colors.grey)))),
    const SizedBox(height: 8),
    Text(p.title,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: C.txt(d)),
        maxLines: 2,
        textAlign: TextAlign.center),
  ]);
}

class _CRow extends StatelessWidget {
  final String lbl, a, b;
  final bool d, hi, num;
  const _CRow(this.lbl, this.a, this.b, this.d,
      {this.hi = false, this.num = false});
  @override
  Widget build(BuildContext context) {
    Color? ac, bc;
    if (num) {
      final av = int.tryParse(a) ?? 0, bv = int.tryParse(b) ?? 0;
      if (av > bv) {
        ac = C.green3;
        bc = C.red;
      } else if (bv > av) {
        ac = C.red;
        bc = C.green3;
      }
    }
    return Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: C.card(d), borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                  color: C.green1.withOpacity(0.08),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12))),
              child: Text(lbl,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: C.txt(d)))),
          Row(children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(a,
                        style: TextStyle(
                            fontSize: 13,
                            color: ac ?? (hi ? C.green1 : C.txt(d)),
                            fontWeight: hi
                                ? FontWeight.w700
                                : FontWeight.w500),
                        textAlign: TextAlign.center))),
            Container(
                width: 1,
                height: 30,
                color: C.green1.withOpacity(0.1)),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(b,
                        style: TextStyle(
                            fontSize: 13,
                            color: bc ?? (hi ? C.green1 : C.txt(d)),
                            fontWeight: hi
                                ? FontWeight.w700
                                : FontWeight.w500),
                        textAlign: TextAlign.center))),
          ]),
        ]));
  }
}

// ════════════════════════════════════════════════════════════
//  ADD PROPERTY SCREEN
// ════════════════════════════════════════════════════════════
class _AddScreen extends StatefulWidget {
  const _AddScreen();
  @override
  State<_AddScreen> createState() => _AddState();
}

class _AddState extends State<_AddScreen> {
  final _fk = GlobalKey<FormState>();
  final _tc = TextEditingController(),
      _lc = TextEditingController(),
      _pc = TextEditingController(),
      _phc = TextEditingController(),
      _ec = TextEditingController(),
      _dc = TextEditingController(),
      _uc = TextEditingController(),
      _ac = TextEditingController();

  String _type = 'Sale', _cat = 'House', _city = 'Lahore';
  int _beds = 2, _baths = 1, _halls = 1;
  bool _urlMode = false;
  String _selImg = _stockPhotos[0];
  int _step = 0;

  final _cities = [
    'Lahore',
    'Karachi',
    'Islamabad',
    'Rawalpindi',
    'Faisalabad',
    'Multan',
    'Peshawar',
    'Quetta'
  ];

  @override
  void initState() {
    super.initState();
    G.addListener(() => setState(() {}));
  }

  String get _previewImg =>
      _urlMode && _uc.text.trim().isNotEmpty
          ? _uc.text.trim()
          : _selImg;

  double _parsePrice(String s) {
    final x = s
        .toLowerCase()
        .replaceAll(',', '')
        .replaceAll('pkr', '')
        .replaceAll(' ', '');
    if (x.contains('crore') || x.contains('cr')) {
      return (double.tryParse(
          x.replaceAll(RegExp(r'[^0-9.]'), '')) ??
          1) *
          10000000;
    }
    if (x.contains('lakh') || x.contains('lac') || x.contains('l')) {
      return (double.tryParse(
          x.replaceAll(RegExp(r'[^0-9.]'), '')) ??
          1) *
          100000;
    }
    if (x.contains('mo') || x.contains('month')) {
      return double.tryParse(
          x.replaceAll(RegExp(r'[^0-9.]'), '')) ??
          20000;
    }
    return double.tryParse(x.replaceAll(RegExp(r'[^0-9.]'), '')) ??
        100000;
  }

  void _submit() {
    if (!_fk.currentState!.validate()) return;
    final np = Prop(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      title: _tc.text.trim(),
      loc: '${_lc.text.trim()}, $_city',
      price: _pc.text.trim(),
      type: _type,
      cat: _cat,
      phone: _phc.text.trim(),
      email: _ec.text.trim().isEmpty
          ? 'owner@nestiq.pk'
          : _ec.text.trim(),
      desc: _dc.text.trim(),
      img: _previewImg,
      beds: _beds,
      baths: _baths,
      halls: _halls,
      pv: _parsePrice(_pc.text.trim()),
      area: int.tryParse(_ac.text.trim()),
      city: _city,
    );
    allProps.insert(0, np);

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          backgroundColor: G.isDark
              ? const Color(0xFF1C2A35)
              : Colors.white,
          title: const Row(children: [
            Icon(Icons.check_circle, color: C.green3, size: 30),
            SizedBox(width: 10),
            Text('Listed! 🎉')
          ]),
          content: Text(
              '"${np.title}" successfully list ho gayi!\n\nExplore tab mein pehli position par dikh rahi hai.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _reset();
                },
                child: Text('Aur List Karo',
                    style: TextStyle(color: C.sub(G.isDark)))),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done ✓',
                    style: TextStyle(
                        color: C.green1,
                        fontWeight: FontWeight.bold))),
          ],
        ));
  }

  void _reset() {
    _tc.clear();
    _lc.clear();
    _pc.clear();
    _phc.clear();
    _ec.clear();
    _dc.clear();
    _uc.clear();
    _ac.clear();
    setState(() {
      _type = 'Sale';
      _cat = 'House';
      _city = 'Lahore';
      _beds = 2;
      _baths = 1;
      _halls = 1;
      _urlMode = false;
      _selImg = _stockPhotos[0];
      _step = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final d = G.isDark;
    return Scaffold(
      backgroundColor: C.bg(d),
      appBar: AppBar(
        backgroundColor: C.green1,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Property List Karo',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
              onPressed: _reset,
              child: const Text('Reset',
                  style:
                  TextStyle(color: Colors.white60, fontSize: 13)))
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
              value: (_step + 1) / 3,
              backgroundColor: Colors.white24,
              color: C.gold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _fk,
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    3,
                        (i) => Container(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _step ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: i <= _step ? C.green1 : C.surf(d),
                          borderRadius: BorderRadius.circular(4)),
                    ))),
            const SizedBox(height: 4),
            Center(
                child: Text(
                    [
                      '📸 Step 1: Photo & Type',
                      '🏠 Step 2: Details',
                      '📞 Step 3: Contact'
                    ][_step],
                    style: TextStyle(
                        color: C.sub(d),
                        fontSize: 12,
                        fontWeight: FontWeight.w600))),
            const SizedBox(height: 16),
            if (_step == 0) ..._buildStep0(d),
            if (_step == 1) ..._buildStep1(d),
            if (_step == 2) ..._buildStep2(d),
            const SizedBox(height: 20),
            Row(children: [
              if (_step > 0)
                Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _step--),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: C.green1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      child: const Text('← Wapas',
                          style: TextStyle(
                              color: C.green1, fontWeight: FontWeight.bold)),
                    )),
              if (_step > 0) const SizedBox(width: 12),
              Expanded(
                  child: ElevatedButton(
                    onPressed:
                    _step < 2 ? () => setState(() => _step++) : _submit,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: C.green1,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 5),
                    child: Text(
                        _step < 2
                            ? 'Agla Step →'
                            : 'Property List Karo ✓',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  )),
            ]),
            const SizedBox(height: 30),
          ]),
        ),
      ),
    );
  }

  List<Widget> _buildStep0(bool d) => [
    _Lbl('Property Photo *', d),
    const SizedBox(height: 8),
    ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(_previewImg,
            height: 165,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
                height: 165,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image,
                    size: 60, color: Colors.grey)))),
    const SizedBox(height: 10),
    Row(children: [
      Expanded(
          child: _modeBtn(
              '📷 Gallery', !_urlMode, () => setState(() => _urlMode = false))),
      const SizedBox(width: 8),
      Expanded(
          child: _modeBtn('🔗 Paste URL', _urlMode,
                  () => setState(() => _urlMode = true))),
    ]),
    const SizedBox(height: 10),
    if (!_urlMode) ...[
      Text('Stock photo choose karo:',
          style: TextStyle(color: C.sub(d), fontSize: 12)),
      const SizedBox(height: 8),
      SizedBox(
          height: 76,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _stockPhotos.length,
              itemBuilder: (_, i) {
                final on = _selImg == _stockPhotos[i];
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selImg = _stockPhotos[i]),
                  child: Container(
                      width: 94,
                      height: 72,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color:
                              on ? C.green1 : Colors.transparent,
                              width: 3)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(children: [
                            Image.network(_stockPhotos[i],
                                width: 94,
                                height: 72,
                                fit: BoxFit.cover),
                            if (on)
                              Container(
                                  color:
                                  C.green1.withOpacity(0.28),
                                  child: const Center(
                                      child: Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                          size: 24))),
                          ]))),
                );
              })),
    ] else ...[
      _FField(
          ctrl: _uc,
          hint: 'https://images.unsplash.com/...',
          icon: Icons.image,
          d: d,
          req: false,
          onChange: (_) => setState(() {})),
      const SizedBox(height: 4),
      Text('Koi bhi image URL paste karo',
          style: TextStyle(color: C.sub(d), fontSize: 11)),
    ],
    const SizedBox(height: 18),
    _Lbl('Listing Type *', d),
    const SizedBox(height: 8),
    Row(children: [
      'Sale',
      'Rent'
    ].map((t) {
      final on = _type == t;
      return Expanded(
          child: GestureDetector(
              onTap: () => setState(() => _type = t),
              child: Container(
                  margin:
                  EdgeInsets.only(right: t == 'Sale' ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: on ? C.green1 : C.card(d),
                      borderRadius: BorderRadius.circular(12),
                      border:
                      Border.all(color: on ? C.green1 : C.border(d))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            on
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            size: 16,
                            color: on ? Colors.white : C.sub(d)),
                        const SizedBox(width: 6),
                        Text(t,
                            style: TextStyle(
                                color: on ? Colors.white : C.txt(d),
                                fontWeight: FontWeight.bold)),
                      ]))));
    }).toList()),
    const SizedBox(height: 16),
    _Lbl('Property Type *', d),
    const SizedBox(height: 8),
    Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          for (final e in [
            ('House', Icons.house),
            ('Apartment', Icons.apartment),
            ('Plot', Icons.landscape),
            ('Shop', Icons.storefront)
          ])
            GestureDetector(
              onTap: () => setState(() => _cat = e.$1),
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                      color:
                      _cat == e.$1 ? C.green1 : C.card(d),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: _cat == e.$1
                              ? C.green1
                              : C.border(d))),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(e.$2,
                        size: 14,
                        color: _cat == e.$1
                            ? Colors.white
                            : C.sub(d)),
                    const SizedBox(width: 5),
                    Text(e.$1,
                        style: TextStyle(
                            color: _cat == e.$1
                                ? Colors.white
                                : C.txt(d),
                            fontWeight: _cat == e.$1
                                ? FontWeight.bold
                                : FontWeight.normal)),
                  ])),
            ),
        ]),
  ];

  List<Widget> _buildStep1(bool d) => [
    _Lbl('Title *', d),
    _FField(
        ctrl: _tc,
        hint: '5 Marla House DHA Phase 5',
        icon: Icons.title,
        d: d),
    const SizedBox(height: 12),
    _Lbl('City *', d),
    const SizedBox(height: 8),
    Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          color: C.card(d),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: C.border(d))),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _city,
            isExpanded: true,
            dropdownColor: C.card(d),
            style: TextStyle(color: C.txt(d), fontSize: 14),
            items: _cities
                .map((c) =>
                DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _city = v ?? 'Lahore'),
          )),
    ),
    const SizedBox(height: 12),
    _Lbl('Area / Street *', d),
    _FField(
        ctrl: _lc,
        hint: 'Phase 5, Block A, Street 12',
        icon: Icons.location_on,
        d: d),
    const SizedBox(height: 12),
    _Lbl('Price *', d),
    _FField(
        ctrl: _pc,
        hint: 'PKR 50 Lakh  ya  PKR 35,000/mo',
        icon: Icons.payments,
        d: d),
    const SizedBox(height: 12),
    _Lbl('Area in Marla (Optional)', d),
    _FField(
        ctrl: _ac,
        hint: '5',
        icon: Icons.square_foot,
        d: d,
        req: false,
        kt: TextInputType.number),
    const SizedBox(height: 12),
    if (_cat == 'House' || _cat == 'Apartment') ...[
      _Lbl('Rooms *', d),
      const SizedBox(height: 10),
      Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: C.card(d),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: C.border(d))),
          child: Column(children: [
            _counter(
                '🛏️ Bedrooms',
                _beds,
                d,
                    () => setState(
                        () { if (_beds > 0) _beds--; }),
                    () => setState(
                        () { if (_beds < 10) _beds++; })),
            Divider(
                height: 14,
                color: Colors.grey.withOpacity(0.2)),
            _counter(
                '🚿 Bathrooms',
                _baths,
                d,
                    () => setState(
                        () { if (_baths > 0) _baths--; }),
                    () => setState(
                        () { if (_baths < 10) _baths++; })),
            Divider(
                height: 14,
                color: Colors.grey.withOpacity(0.2)),
            _counter(
                '🛋️ Halls',
                _halls,
                d,
                    () => setState(
                        () { if (_halls > 0) _halls--; }),
                    () => setState(
                        () { if (_halls < 5) _halls++; })),
          ])),
      const SizedBox(height: 12),
    ],
    _Lbl('Description *', d),
    TextFormField(
        controller: _dc,
        maxLines: 4,
        style: TextStyle(color: C.txt(d)),
        decoration: InputDecoration(
            hintText: 'Ghar ki detail likhein...',
            filled: true,
            fillColor: C.card(d),
            hintStyle: TextStyle(color: C.sub(d)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: C.border(d))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: C.border(d))),
            focusedBorder: const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(12)),
                borderSide:
                BorderSide(color: C.green1, width: 2))),
        validator: (v) => (v == null || v.isEmpty)
            ? 'Description zaroor likhein'
            : null),
  ];

  List<Widget> _buildStep2(bool d) => [
    _Lbl('Preview 👀', d),
    const SizedBox(height: 8),
    Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: C.green1.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: C.green1.withOpacity(0.2))),
        child: Row(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(_previewImg,
                  width: 60,
                  height: 54,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      width: 60,
                      height: 54,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey)))),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        _tc.text.isEmpty ? 'Title here' : _tc.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: C.txt(d),
                            fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(
                        '$_city${_lc.text.isNotEmpty ? ', ${_lc.text}' : ''}',
                        style:
                        TextStyle(color: C.sub(d), fontSize: 11)),
                    Text(
                        _pc.text.isEmpty ? 'Price here' : _pc.text,
                        style: const TextStyle(
                            color: C.green1,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ])),
          Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: _type == 'Sale' ? C.green1 : C.green3,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(_type,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold))),
        ])),
    const SizedBox(height: 20),
    _Lbl('Phone *', d),
    _FField(
        ctrl: _phc,
        hint: '+92 300 0000000',
        icon: Icons.phone,
        d: d,
        kt: TextInputType.phone),
    const SizedBox(height: 12),
    _Lbl('Email (Optional)', d),
    _FField(
        ctrl: _ec,
        hint: 'email@gmail.com',
        icon: Icons.email,
        d: d,
        req: false,
        kt: TextInputType.emailAddress),
    const SizedBox(height: 12),
    Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: C.surf(d),
            borderRadius: BorderRadius.circular(12)),
        child:
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.info_outline, color: C.green1, size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(
                  'Property list karne se aap confirm karte hain ke yeh information sahi hai. Galat info report ki ja sakti hai.',
                  style: TextStyle(
                      color: C.sub(d),
                      fontSize: 11,
                      height: 1.5))),
        ])),
  ];

  Widget _modeBtn(String label, bool on, VoidCallback tap) =>
      GestureDetector(
          onTap: tap,
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                  color: on ? C.green1 : C.surf(G.isDark),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(label,
                      style: TextStyle(
                          color: on ? Colors.white : C.sub(G.isDark),
                          fontWeight: FontWeight.w600,
                          fontSize: 13)))));

  Widget _counter(String lbl, int val, bool d, VoidCallback dec,
      VoidCallback inc) =>
      Row(children: [
        Text(lbl,
            style: TextStyle(
                color: C.txt(d),
                fontWeight: FontWeight.w500,
                fontSize: 14)),
        const Spacer(),
        GestureDetector(
            onTap: dec,
            child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: C.surf(d),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: C.border(d))),
                child: const Icon(Icons.remove,
                    size: 16, color: C.green1))),
        Container(
            width: 40,
            alignment: Alignment.center,
            child: Text('$val',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: C.txt(d)))),
        GestureDetector(
            onTap: inc,
            child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: C.green1,
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.add,
                    size: 16, color: Colors.white))),
      ]);
}

// ════════════════════════════════════════════════════════════
//  PROFILE SCREEN
// ════════════════════════════════════════════════════════════
class _ProfileScreen extends StatefulWidget {
  const _ProfileScreen();
  @override
  State<_ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<_ProfileScreen> {
  @override
  void initState() {
    super.initState();
    G.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final d = G.isDark;
    final myProps =
    allProps.where((p) => p.id.startsWith('u_')).toList();

    return Scaffold(
      backgroundColor: C.bg(d),
      body: SingleChildScrollView(
          child: Column(children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).padding.top + 20,
                  20,
                  30),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [C.green1, C.green2])),
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('My Profile',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800)),
                      GestureDetector(
                          onTap: G.toggleDark,
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                  G.isDark
                                      ? Icons.light_mode
                                      : Icons.dark_mode,
                                  color: Colors.white,
                                  size: 20))),
                    ]),
                const SizedBox(height: 20),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15)
                      ]),
                  child:
                  const Icon(Icons.person, size: 44, color: C.green1),
                ),
                const SizedBox(height: 12),
                const Text('Nestiq User',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                Text('No Agent • No Commission',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                _StatCard('❤️', '${G.favorites.length}', 'Saved', d),
                const SizedBox(width: 10),
                _StatCard('👁️', '${G.recents.length}', 'Viewed', d),
                const SizedBox(width: 10),
                _StatCard('🏠', '${myProps.length}', 'Listed', d),
              ]),
            ),
            if (myProps.isNotEmpty) ...[
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Meri Listings',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: C.txt(d))))),
              ...myProps.map((p) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  child: _MyListingTile(prop: p, d: d))),
              const SizedBox(height: 8),
            ],
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text('Settings',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: C.txt(d))),
            ),
            _SettingTile(Icons.dark_mode, 'Dark Mode', d,
                trailing: Switch(
                    value: G.isDark,
                    onChanged: (_) => G.toggleDark(),
                    activeThumbColor: C.green1)),
            _SettingTile(Icons.notifications_outlined, 'Notifications', d,
                trailing: Switch(
                    value: true,
                    onChanged: (_) {},
                    activeThumbColor: C.green1)),
            _SettingTile(Icons.language, 'Language: Urdu/English', d),
            _SettingTile(Icons.share, 'App Share Karo', d,
                onTap: () => _snack(
                    context, 'App share kar rahe hain...', C.green1)),
            _SettingTile(Icons.info_outline, 'App ke baare mein', d,
                onTap: () => _showAbout(context, d)),
            _SettingTile(Icons.delete_outline, 'Recents Clear Karo', d,
                onTap: () {
                  G.clearRecents();
                  _snack(context, 'Recents clear ho gaye!', C.green1);
                }, color: C.red),
            const SizedBox(height: 30),
          ])),
    );
  }

  void _showAbout(BuildContext ctx, bool d) {
    showDialog(
        context: ctx,
        builder: (_) => AlertDialog(
          backgroundColor: C.card(d),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Row(children: [
            const Icon(Icons.home_work_rounded, color: C.green1),
            const SizedBox(width: 8),
            Text('Nestiq', style: TextStyle(color: C.txt(d)))
          ]),
          content: Text(
              'Version 2.1\nNo Agent. No Commission. Just Home.\n\nPakistan ka best real estate app. Direct owner se milain.\n\n✨ New: Tap Beds/Baths/Halls for room photos!',
              style: TextStyle(color: C.sub(d), height: 1.5)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK',
                    style: TextStyle(color: C.green1)))
          ],
        ));
  }
}

class _StatCard extends StatelessWidget {
  final String emoji, val, label;
  final bool d;
  const _StatCard(this.emoji, this.val, this.label, this.d);
  @override
  Widget build(BuildContext context) => Expanded(
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
              color: C.card(d),
              borderRadius: BorderRadius.circular(14)),
          child: Column(children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(val,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: C.txt(d))),
            Text(label,
                style: TextStyle(color: C.sub(d), fontSize: 12)),
          ])));
}

class _MyListingTile extends StatelessWidget {
  final Prop prop;
  final bool d;
  const _MyListingTile({required this.prop, required this.d});
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: C.card(d), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(prop.img,
                width: 56,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 50,
                    color: Colors.grey[300]))),
        const SizedBox(width: 10),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(prop.title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: C.txt(d)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(prop.price,
                      style: const TextStyle(
                          color: C.green1,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ])),
        Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: C.green3.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8)),
            child: const Text('Active',
                style: TextStyle(
                    color: C.green3,
                    fontSize: 11,
                    fontWeight: FontWeight.w600))),
      ]));
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool d;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? color;
  const _SettingTile(this.icon, this.label, this.d,
      {this.onTap, this.trailing, this.color});
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
              color: C.card(d),
              borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Icon(icon, color: color ?? C.green1, size: 22),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style: TextStyle(
                        color: color ?? C.txt(d),
                        fontWeight: FontWeight.w500,
                        fontSize: 14))),
            trailing ??
                Icon(Icons.arrow_forward_ios,
                    size: 13, color: C.sub(d)),
          ])));
}

// ════════════════════════════════════════════════════════════
//  HELPERS
// ════════════════════════════════════════════════════════════
class _Empty extends StatelessWidget {
  final IconData i;
  final String h, s;
  final bool d;
  const _Empty(this.i, this.h, this.s, this.d);
  @override
  Widget build(BuildContext context) => Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(i, size: 88, color: C.sub(d)),
            const SizedBox(height: 16),
            Text(h,
                style: TextStyle(
                    color: C.sub(d),
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(s, style: TextStyle(color: C.sub(d), fontSize: 13)),
          ]));
}

class _Lbl extends StatelessWidget {
  final String t;
  final bool d;
  const _Lbl(this.t, this.d);
  @override
  Widget build(BuildContext context) => Text(t,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: C.txt(d)));
}

class _FField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final IconData icon;
  final bool d, req;
  final TextInputType kt;
  final ValueChanged<String>? onChange;
  const _FField(
      {required this.ctrl,
        required this.hint,
        required this.icon,
        required this.d,
        this.req = true,
        this.kt = TextInputType.text,
        this.onChange});
  @override
  Widget build(BuildContext context) => TextFormField(
      controller: ctrl,
      keyboardType: kt,
      onChanged: onChange,
      style: TextStyle(color: C.txt(d)),
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: C.sub(d)),
          prefixIcon: Icon(icon, color: C.green1),
          filled: true,
          fillColor: C.card(d),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: C.border(d))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: C.border(d))),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: C.green1, width: 2))),
      validator: req
          ? (v) => (v == null || v.isEmpty)
          ? 'Yeh field zaroor bharein'
          : null
          : null);
}

void _push(BuildContext ctx, Widget w) => Navigator.push(
    ctx,
    PageRouteBuilder(
        pageBuilder: (_, a, __) => SlideTransition(
            position: Tween<Offset>(
                begin: const Offset(1, 0), end: Offset.zero)
                .animate(CurvedAnimation(
                parent: a, curve: Curves.easeOutCubic)),
            child: w),
        transitionDuration: const Duration(milliseconds: 300)));

void _snack(BuildContext ctx, String msg, Color color) =>
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10))));

String _pFmt(int v) {
  if (v >= 10000000) {
    return 'PKR ${(v / 10000000).toStringAsFixed(1)} Cr';
  }
  if (v >= 100000) {
    return 'PKR ${(v / 100000).toStringAsFixed(0)} L';
  }
  if (v >= 1000) return 'PKR ${(v / 1000).toStringAsFixed(0)}K';
  return 'PKR $v';
}