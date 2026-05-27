import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/connectivity_service.dart';
import '../../providers/product_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/pos_provider.dart';
import '../../providers/report_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../products/products_screen.dart';
import '../inventory/inventory_screen.dart';
import '../pos/pos_screen.dart';
import '../customers/customers_screen.dart';
import '../ledger/ledger_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_screen.dart';
import '../backup/backup_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> _dashboardData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final productProvider = context.read<ProductProvider>();
    final customerProvider = context.read<CustomerProvider>();
    final posProvider = context.read<POSProvider>();
    final reportProvider = context.read<ReportProvider>();

    await Future.wait([
      productProvider.loadProducts(),
      productProvider.loadCategories(),
      customerProvider.loadCustomers(),
      posProvider.loadTodaySales(),
      posProvider.loadRecentSales(),
    ]);

    _dashboardData = await reportProvider.getDashboardSummary();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dashboardBg,
      drawer: const AppDrawer(currentIndex: 0),
      appBar: AppBar(
        backgroundColor: AppTheme.dashboardAppBar,
        elevation: 0,
        shadowColor: AppTheme.dashboardAccent.withValues(alpha: 0.1),
        surfaceTintColor: Colors.transparent,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(Icons.menu, color: AppTheme.dashboardAccent),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.dashboardAccent, Color(0xFF667EEA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.store, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mobile Shop',
                    style: TextStyle(
                      color: Color(0xFF1A202C),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'POS System',
                    style: TextStyle(color: Color(0xFF718096), fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Consumer<ConnectivityService>(
            builder: (context, connectivity, _) => Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: connectivity.isOnline
                    ? AppTheme.dashboardAccent.withValues(alpha: 0.1)
                    : AppTheme.errorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    connectivity.isOnline ? Icons.cloud_done : Icons.cloud_off,
                    size: 16,
                    color: connectivity.isOnline
                        ? AppTheme.dashboardAccent
                        : AppTheme.errorColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    connectivity.isOnline ? 'Synced' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: connectivity.isOnline
                          ? AppTheme.dashboardAccent
                          : AppTheme.errorColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: AppTheme.dashboardAccent),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppTheme.dashboardAccent))
          : RefreshIndicator(
        color: AppTheme.dashboardAccent,
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Sales Summary ──
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today's Overview",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A202C),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const ReportsScreen())),
                          icon: const Icon(Icons.analytics_outlined, size: 18),
                          label: const Text('Reports'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.dashboardAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Hero Sales Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.dashboardAccent, Color(0xFF667EEA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.dashboardAccent.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Sales Today',
                                  style: TextStyle(color: Colors.white70, fontSize: 14)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_dashboardData['todayTransactions'] ?? 0} Orders',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'PKR ${(_dashboardData['todaySales'] ?? 0.0).toStringAsFixed(0)}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('This Month',
                                          style: TextStyle(color: Colors.white70, fontSize: 11)),
                                      const SizedBox(height: 4),
                                      Text(
                                        'PKR ${(_dashboardData['monthSales'] ?? 0.0).toStringAsFixed(0)}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(width: 1, height: 30, color: Colors.white30),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Monthly Orders',
                                            style: TextStyle(color: Colors.white70, fontSize: 11)),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${_dashboardData['monthTransactions'] ?? 0}',
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Stat Cards
                    Row(
                      children: [
                        Expanded(child: _buildStatCard('Products',
                            '${_dashboardData['productCount'] ?? 0}',
                            Icons.inventory_2_outlined, AppTheme.inventoryAccent)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('Low Stock',
                            '${_dashboardData['lowStockCount'] ?? 0}',
                            Icons.warning_amber_outlined, AppTheme.warningColor)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('Customers',
                            '${_dashboardData['customerCount'] ?? 0}',
                            Icons.people_outline, AppTheme.customersAccent)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Quick Actions ──
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quick Actions',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A202C))),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildMainActionButton(
                              'New Sale', 'Start selling',
                              Icons.point_of_sale, AppTheme.posAccent, const POSScreen()),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                              'Products', Icons.inventory_2_outlined,
                              AppTheme.productsAccent, const ProductsScreen()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildActionButton(
                            'Inventory', Icons.warehouse_outlined,
                            AppTheme.inventoryAccent, const InventoryScreen())),
                        const SizedBox(width: 12),
                        Expanded(child: _buildActionButton(
                            'Customers', Icons.people_outline,
                            AppTheme.customersAccent, const CustomersScreen())),
                        const SizedBox(width: 12),
                        Expanded(child: _buildActionButton(
                            'Ledger', Icons.receipt_long_outlined,
                            AppTheme.ledgerAccent, const LedgerScreen())),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildActionButton(
                            'Reports', Icons.bar_chart,
                            AppTheme.reportsAccent, const ReportsScreen())),
                        const SizedBox(width: 12),
                        Expanded(child: _buildActionButton(
                            'Backup', Icons.cloud_upload_outlined,
                            AppTheme.backupAccent, const BackupScreen())),
                        const SizedBox(width: 12),
                        Expanded(child: _buildActionButton(
                            'Settings', Icons.settings_outlined,
                            AppTheme.settingsAccent, const SettingsScreen())),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Recent Transactions ──
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Recent Transactions',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A202C))),
                        TextButton(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const ReportsScreen())),
                          child: Text('View All',
                              style: TextStyle(color: AppTheme.dashboardAccent)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Consumer<POSProvider>(
                      builder: (context, posProvider, _) {
                        final sales = posProvider.recentSales.take(5).toList();
                        if (sales.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: AppTheme.dashboardBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Column(
                                children: [
                                  Icon(Icons.receipt_long_outlined,
                                      size: 48, color: Color(0xFFCBD5E1)),
                                  SizedBox(height: 12),
                                  Text('No transactions yet',
                                      style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                                  SizedBox(height: 4),
                                  Text('Start a new sale to see transactions here',
                                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sales.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final sale = sales[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(
                                  color: AppTheme.dashboardAccent.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.receipt_outlined,
                                    color: AppTheme.dashboardAccent, size: 22),
                              ),
                              title: Text(sale.invoiceNumber,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A202C))),
                              subtitle: Text(sale.customerName ?? 'Walk-in Customer',
                                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('PKR ${sale.totalAmount.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A202C))),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: sale.isPaid
                                          ? AppTheme.successColor.withValues(alpha: 0.1)
                                          : AppTheme.warningColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      sale.isPaid ? 'Paid' : 'Due',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: sale.isPaid ? AppTheme.successColor : AppTheme.warningColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => const POSScreen())),
        backgroundColor: AppTheme.posAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Sale',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildMainActionButton(
      String label, String subtitle, IconData icon, Color color, Widget screen) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, Widget screen) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}