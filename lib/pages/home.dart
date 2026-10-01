import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/product.dart';

const kAccent = Color(0xFFFF4655);
const kBg = Color(0xFF0F1923);
const kPanel = Color(0xFF1B2733);
const kInk = Color(0xFFECE8E1);
const kMuted = Color(0xFF8B97A3);
const kLine = Color(0xFF2C3B4A);

class _Cat {
  final String name;
  final IconData icon;
  const _Cat(this.name, this.icon);
}

const _all = 'ทั้งหมด';
const _cats = [
  _Cat(_all, Icons.apps_rounded),
  _Cat('Vandal', Icons.gps_fixed),
  _Cat('Phantom', Icons.filter_tilt_shift),
  _Cat('Ghost', Icons.bolt),
  _Cat('Sheriff', Icons.star_border_rounded),
  _Cat('Operator', Icons.my_location),
  _Cat('Melee', Icons.flash_on),
];

String _baht(double v) => '฿${v.toStringAsFixed(0)}';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _search = TextEditingController();
  String _category = _all;

  // ชื่อสกินตั้งจากลักษณะภาพ แก้เป็นชื่อจริงได้ที่นี่ (image = ไฟล์ใน assets/images/)
  final List<Product> products = [
    Product(id: '1', name: 'Dragon Vandal', price: 799, category: 'Vandal', stock: 3, image: 'assets/images/1.png'),
    Product(id: '2', name: 'Pastel Vandal', price: 599, category: 'Vandal', stock: 5, image: 'assets/images/2.png'),
    Product(id: '3', name: 'Crimson Claw Vandal', price: 699, category: 'Vandal', stock: 4, image: 'assets/images/3.png'),
    Product(id: '4', name: 'Champions Gold Vandal', price: 899, category: 'Vandal', stock: 2, image: 'assets/images/4.png'),
    Product(id: '5', name: 'Pink Pearl Vandal', price: 649, category: 'Vandal', stock: 4, image: 'assets/images/5.png'),
    Product(id: '6', name: 'Ember Thorn Vandal', price: 749, category: 'Vandal', stock: 3, image: 'assets/images/6.png'),
    Product(id: '7', name: 'Overdrive Phantom', price: 599, category: 'Phantom', stock: 6, image: 'assets/images/7.png'),
    Product(id: '8', name: 'Neon Camo Phantom', price: 549, category: 'Phantom', stock: 5, image: 'assets/images/8.png'),
    Product(id: '9', name: 'Red Star Phantom', price: 699, category: 'Phantom', stock: 4, image: 'assets/images/9.png'),
    Product(id: '10', name: 'Neon Shadow Ghost', price: 299, category: 'Ghost', stock: 6, image: 'assets/images/10.png'),
    Product(id: '11', name: 'Frost Blade Ghost', price: 349, category: 'Ghost', stock: 5, image: 'assets/images/11.png'),
    Product(id: '12', name: 'Copper Sheriff', price: 399, category: 'Sheriff', stock: 0, image: 'assets/images/12.png'),
    Product(id: '13', name: 'Sakura Sheriff', price: 449, category: 'Sheriff', stock: 3, image: 'assets/images/13.png'),
    Product(id: '14', name: 'Mono Operator', price: 649, category: 'Operator', stock: 4, image: 'assets/images/14.png'),
    Product(id: '15', name: 'Gold Rush Operator', price: 849, category: 'Operator', stock: 2, image: 'assets/images/15.png'),
    Product(id: '16', name: 'Cyber Pulse Operator', price: 799, category: 'Operator', stock: 3, image: 'assets/images/16.png'),
    Product(id: '17', name: 'Twin Kunai', price: 999, category: 'Melee', stock: 2, image: 'assets/images/17.png'),
    Product(id: '18', name: 'Sun Fan', price: 1199, category: 'Melee', stock: 2, image: 'assets/images/18.png'),
    Product(id: '19', name: 'Crimson Katana', price: 1499, category: 'Melee', stock: 1, image: 'assets/images/19.png'),
    Product(id: '20', name: 'Lotus Fan', price: 1299, category: 'Melee', stock: 2, image: 'assets/images/20.png'),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Product> get _visible {
    final q = _search.text.trim().toLowerCase();
    return products
        .where((p) =>
            (_category == _all || p.category == _category) &&
            p.name.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _buy(Product p) async {
    final change = await showDialog<double>(
      context: context,
      builder: (_) => PaymentDialog(product: p),
    );
    if (change == null || !mounted) return;
    setState(() => p.stock--);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        icon: const Icon(Icons.check_circle, color: Color(0xFF2E9E5B), size: 48),
        title: const Text('ชำระเงินสำเร็จ'),
        content: Text(
          change > 0
              ? 'รับสกิน: ${p.name}\nเงินทอน ${_baht(change)}'
              : 'รับสกิน: ${p.name}',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('ตกลง')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final narrow = width < 720;
    final pad = max(20.0, (width - 1200) / 2);
    final list = _visible;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(narrow),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(pad, 20, pad, 0),
                    sliver: SliverToBoxAdapter(child: _categories()),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(pad, 24, pad, 12),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Text(
                            _category == _all ? 'สกินทั้งหมด' : _category,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kInk),
                          ),
                          const Spacer(),
                          Text('${list.length} รายการ', style: const TextStyle(color: kMuted)),
                        ],
                      ),
                    ),
                  ),
                  if (list.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(48),
                        child: Center(
                          child: Text('ไม่พบสกิน ลองเปลี่ยนคำค้นหาหรือหมวดหมู่',
                              style: TextStyle(color: kMuted)),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(pad, 0, pad, 32),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 1.05,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => _ProductCard(p: list[i], onBuy: () => _buy(list[i])),
                          childCount: list.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(bool narrow) {
    return Container(
      color: kPanel,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(4)),
            child: const Icon(Icons.storefront_rounded, color: Colors.white),
          ),
          if (!narrow) ...[
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ValoMarket',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kInk)),
                Text('Skin • Vending • Anytime', style: TextStyle(fontSize: 12, color: kMuted)),
              ],
            ),
          ],
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _search,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'ค้นหาสกิน...',
                      prefixIcon: const Icon(Icons.search, color: kMuted),
                      filled: true,
                      fillColor: kBg,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const _Clock(),
        ],
      ),
    );
  }

  Widget _categories() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: _cats.map((c) {
        final selected = c.name == _category;
        return ChoiceChip(
          selected: selected,
          onSelected: (_) => setState(() => _category = c.name),
          avatar: Icon(c.icon, size: 20, color: selected ? Colors.white : kAccent),
          label: Text(c.name),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : kInk,
          ),
          showCheckmark: false,
          selectedColor: kAccent,
          backgroundColor: kPanel,
          side: BorderSide(color: selected ? kAccent : kLine),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        );
      }).toList(),
    );
  }

}

class _ProductCard extends StatelessWidget {
  final Product p;
  final VoidCallback onBuy;
  const _ProductCard({required this.p, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    final inStock = p.stock > 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kPanel,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: kLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: const Color(0xFF0B121A), borderRadius: BorderRadius.circular(4)),
              child: Image.asset(
                p.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined, color: kMuted, size: 40),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(p.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, color: kInk)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(_baht(p.price),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kAccent)),
              const Spacer(),
              Text(inStock ? 'เหลือ ${p.stock}' : 'หมด',
                  style: TextStyle(fontSize: 12, color: inStock ? kMuted : Colors.red)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: inStock ? onBuy : null,
              style: FilledButton.styleFrom(
                backgroundColor: kAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: Text(inStock ? 'ซื้อเลย' : 'สกินหมด'),
            ),
          ),
        ],
      ),
    );
  }
}

/// นาฬิกา + วันที่ (พ.ศ.) มุมขวาบน
class _Clock extends StatefulWidget {
  const _Clock();

  @override
  State<_Clock> createState() => _ClockState();
}

class _ClockState extends State<_Clock> {
  static const _months = [
    'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
    'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.',
  ];
  DateTime _now = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final time = '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';
    final date = '${_now.day} ${_months[_now.month - 1]} ${_now.year + 543}';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.schedule, color: kInk),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(time, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kInk)),
            Text(date, style: const TextStyle(fontSize: 12, color: kMuted)),
          ],
        ),
      ],
    );
  }
}

/// หน้าจ่ายเงิน: เงินสด / QR Code
/// pop ค่า = เงินทอน (QR = 0), pop null = ยกเลิก
class PaymentDialog extends StatefulWidget {
  final Product product;
  const PaymentDialog({super.key, required this.product});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  bool _qr = false;
  double _cash = 0;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final remaining = p.price - _cash;
    final enough = remaining <= 0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(p.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kInk)),
                  ),
                  Text(_baht(p.price),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kAccent)),
                ],
              ),
              const SizedBox(height: 16),
              SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: false, icon: Icon(Icons.payments_outlined), label: Text('เงินสด')),
                  ButtonSegment(value: true, icon: Icon(Icons.qr_code_2), label: Text('QR Code')),
                ],
                selected: {_qr},
                onSelectionChanged: (s) => setState(() => _qr = s.first),
              ),
              const SizedBox(height: 20),
              if (_qr) ..._qrView(p) else ..._cashView(p, remaining, enough),
              const SizedBox(height: 8),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _cashView(Product p, double remaining, bool enough) {
    return [
      const Text('เลือกจำนวนเงินที่หยอด', style: TextStyle(color: kMuted)),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [20.0, 50.0, 100.0, 500.0, 1000.0]
            .map((v) => OutlinedButton(
                  onPressed: () => setState(() => _cash += v),
                  child: Text('+${v.toStringAsFixed(0)}'),
                ))
            .toList(),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(4)),
        child: Column(
          children: [
            _row('รับเงินแล้ว', _baht(_cash)),
            const SizedBox(height: 6),
            enough
                ? _row('เงินทอน', _baht(-remaining), color: const Color(0xFF2E9E5B))
                : _row('ต้องใส่เพิ่ม', _baht(remaining), color: Colors.red),
          ],
        ),
      ),
      if (_cash > 0)
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () => setState(() => _cash = 0), child: const Text('ล้างเงินที่ใส่')),
        ),
      const SizedBox(height: 8),
      FilledButton(
        onPressed: enough ? () => Navigator.pop(context, -remaining) : null,
        child: const Text('ยืนยันการซื้อ'),
      ),
    ];
  }

  List<Widget> _qrView(Product p) {
    return [
      Center(
        child: Container(
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: kLine),
          ),
          child: CustomPaint(painter: _QrPainter(int.tryParse(p.id) ?? 1)),
        ),
      ),
      const SizedBox(height: 12),
      Text('สแกนเพื่อชำระ ${_baht(p.price)}',
          textAlign: TextAlign.center, style: const TextStyle(color: kMuted)),
      const SizedBox(height: 16),
      FilledButton(onPressed: () => Navigator.pop(context, 0.0), child: const Text('ชำระเงินแล้ว')),
    ];
  }

  Widget _row(String label, String value, {Color color = kInk}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: kMuted)),
        const Spacer(),
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

/// QR จำลองสำหรับทดสอบหน้าตา (ยังสแกนไม่ได้จริง)
/// ของจริงให้เปลี่ยนเป็น qr_flutter + payload PromptPay
class _QrPainter extends CustomPainter {
  final int seed;
  const _QrPainter(this.seed);
  static const n = 25;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / n;
    final paint = Paint()..color = kInk;
    final rnd = Random(seed);
    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        final inTL = x < 8 && y < 8;
        final inTR = x >= n - 8 && y < 8;
        final inBL = x < 8 && y >= n - 8;
        bool on;
        if (inTL || inTR || inBL) {
          final lx = x < 8 ? x : x - (n - 8);
          final ly = y < 8 ? y : y - (n - 8);
          on = lx < 7 &&
              ly < 7 &&
              (lx == 0 || lx == 6 || ly == 0 || ly == 6 || (lx >= 2 && lx <= 4 && ly >= 2 && ly <= 4));
        } else {
          on = rnd.nextBool();
        }
        if (on) canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell + 0.5, cell + 0.5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrPainter old) => old.seed != seed;
}