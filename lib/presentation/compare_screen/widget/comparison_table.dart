import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';

class ComparisonTable extends StatelessWidget {
  final List<AdWithUserModel> selectedCars;

  const ComparisonTable({super.key, required this.selectedCars});

  @override
  Widget build(BuildContext context) {
    if (selectedCars.length != 2) {
      return Container(); 
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final tableBackgroundColor = isDarkMode ? AppColors.zDarkCardBackground : AppColors.zWhite;
    final headerColor = isDarkMode ? AppColors.zDarkBackground : AppColors.zGrey.shade100;
    final borderColor = isDarkMode ? AppColors.zDarkCardBorder : AppColors.zGrey.shade300;
    final textColor = isDarkMode ? AppColors.zDarkPrimaryText : AppColors.zLightPrimaryText;
    final valueColor = isDarkMode ? AppColors.zDarkSecondaryText : AppColors.zLightSecondaryText;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: tableBackgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Table(
        border: TableBorder.all(color: borderColor, width: 1.0),
        columnWidths: const {
          0: FixedColumnWidth(130),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: headerColor),
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Specification',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  '${selectedCars[0].ad.brand} ${selectedCars[0].ad.model}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  '${selectedCars[1].ad.brand} ${selectedCars[1].ad.model}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          ...[
            {
              'key': 'Brand',
              'value1': selectedCars[0].ad.brand.isNotEmpty ? selectedCars[0].ad.brand : 'N/A',
              'value2': selectedCars[1].ad.brand.isNotEmpty ? selectedCars[1].ad.brand : 'N/A',
            },
            {
              'key': 'Model',
              'value1': selectedCars[0].ad.model.isNotEmpty ? selectedCars[0].ad.model : 'N/A',
              'value2': selectedCars[1].ad.model.isNotEmpty ? selectedCars[1].ad.model : 'N/A',
            },
            {'key': 'Year', 'value1': selectedCars[0].ad.year.toString(), 'value2': selectedCars[1].ad.year.toString()},
            {
              'key': 'Fuel Type',
              'value1': selectedCars[0].ad.fuelType.isNotEmpty ? selectedCars[0].ad.fuelType : 'N/A',
              'value2': selectedCars[1].ad.fuelType.isNotEmpty ? selectedCars[1].ad.fuelType : 'N/A',
            },
            {
              'key': 'Transmission',
              'value1':
                  selectedCars[0].ad.transmissionType.isNotEmpty ? selectedCars[0].ad.transmissionType : 'N/A',
              'value2':
                  selectedCars[1].ad.transmissionType.isNotEmpty ? selectedCars[1].ad.transmissionType : 'N/A',
            },
            {
              'key': 'KM Driven',
              'value1': '${selectedCars[0].ad.kmDriven} km',
              'value2': '${selectedCars[1].ad.kmDriven} km',
            },
            {
              'key': 'No. of Owners',
              'value1': selectedCars[0].ad.noOfOwners.toString(),
              'value2': selectedCars[1].ad.noOfOwners.toString(),
            },
            {
              'key': 'Price',
              'value1': '\$${selectedCars[0].ad.price.toStringAsFixed(2)}',
              'value2': '\$${selectedCars[1].ad.price.toStringAsFixed(2)}',
            },

            {
              'key': 'Posted Date',
              'value1': selectedCars[0].ad.postedDate.toLocal().toString().split(' ')[0],
              'value2': selectedCars[1].ad.postedDate.toLocal().toString().split(' ')[0],
            },
          ].map((row) {
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    row['key']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    row['value1'] ?? 'N/A', 
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: valueColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    row['value2'] ?? 'N/A', 
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: valueColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
