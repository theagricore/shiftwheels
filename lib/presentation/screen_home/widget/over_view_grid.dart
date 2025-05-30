import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class OverviewGrid extends StatelessWidget {
  final String transmission;
  final int kmDriven;
  final int noOfOwners;
  final String fuelType;

  const OverviewGrid({
    super.key,
    required this.transmission,
    required this.kmDriven,
    required this.noOfOwners,
    required this.fuelType,
  });

  Widget _buildDetailItem(String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.zWhite, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 15,),
            Icon(icon, size: 20, color: AppColors.zWhite),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.zWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2.7,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildDetailItem(transmission, Icons.settings),
        _buildDetailItem("$kmDriven km", Icons.speed),
        _buildDetailItem(
          noOfOwners == 1 ? "1st Owner" : "$noOfOwners Owner",
          Icons.person,
        ),
        _buildDetailItem(fuelType, Icons.local_gas_station),
      ],
    );
  }
}
