import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/reserva_provider.dart';

class EstadisticasScreen extends StatelessWidget {
  const EstadisticasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reservaProv = Provider.of<ReservaProvider>(context);

    // Filter successful orders for statistics
    final reservas = reservaProv.reservas.where((r) => r.estado == 'CONFIRMADA' || r.estado == 'ENTREGADO').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Ventas por Mes', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  barGroups: _generateGroups(reservas),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
                          return Text(titles[value.toInt()]);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text('Distribución de Ingresos', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: _generateSections(reservas),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateGroups(List list) {
    // Simplified logic to group by month
    // In a real app, you'd aggregate totals per month
    return List.generate(6, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(toY: (i + 1) * 100.0, color: Colors.blue),
        ],
      );
    });
  }

  List<PieChartSectionData> _generateSections(List list) {
    // Simplified logic
    return [
      PieChartSectionData(value: 40, title: 'Sillas', color: Colors.red, radius: 50),
      PieChartSectionData(value: 30, title: 'Mesas', color: Colors.green, radius: 50),
      PieChartSectionData(value: 30, title: 'Otros', color: Colors.orange, radius: 50),
    ];
  }
}
