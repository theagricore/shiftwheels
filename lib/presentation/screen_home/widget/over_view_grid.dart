import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class OverviewGrid extends StatelessWidget {
  final String transmission;
  final int kmDriven;
  final int noOfOwners;
  final String fuelType;
  final bool isWeb;

  const OverviewGrid({
    super.key,
    required this.transmission,
    required this.kmDriven,
    required this.noOfOwners,
    required this.fuelType,
    this.isWeb = false,
  });

  Widget _buildDetailItem(String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.zWhite.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.zWhite.withOpacity(0.2), width: 1),
      ),
      padding: EdgeInsets.all(isWeb ? 16 : 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon, 
                size: isWeb ? 24 : 20, 
                color: AppColors.zWhite.withOpacity(0.9)
              ),
              SizedBox(width: isWeb ? 10 : 8),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isWeb ? 18 : 16,
                  color: AppColors.zWhite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: isWeb ? 3.0 : 2.5,
      crossAxisSpacing: isWeb ? 20 : 16,
      mainAxisSpacing: isWeb ? 20 : 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildDetailItem(transmission, Icons.settings),
        _buildDetailItem("$kmDriven km", Icons.speed),
        _buildDetailItem(
          noOfOwners == 1 ? "1st Owner" : "$noOfOwners Owners",
          Icons.person,
        ),
        _buildDetailItem(fuelType, Icons.local_gas_station),
      ],
    );
  }
}