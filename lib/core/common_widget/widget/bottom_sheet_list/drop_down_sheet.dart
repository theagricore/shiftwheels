import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class DropdownSheet<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemText;
  final void Function(T) onSelected;
  final bool isLoading;
  final String? error;
  final bool isWeb;

  const DropdownSheet({
    super.key,
    required this.title,
    required this.items,
    required this.itemText,
    required this.onSelected,
    this.isLoading = false,
    this.error,
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final backgroundColor = isDark ? AppColors.zBackGround : Colors.white;
    final textColor = isDark ? AppColors.zWhite : AppColors.zfontColor;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: EdgeInsets.all(isWeb ? 20.0 : 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 8.0 : 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: isWeb ? 20 : 22,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: isWeb ? 22 : 24, color: textColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: AppColors.zfontColor.withOpacity(0.2)),
          const SizedBox(height: 12),
          if (error != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                error!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.zred,
                  fontSize: isWeb ? 14 : 16,
                ),
              ),
            )
          else if (isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.zPrimaryColor,
                  ),
                ),
              ),
            )
          else if (items.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  'No items available',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: textColor.withOpacity(0.7),
                    fontSize: isWeb ? 16 : 18,
                  ),
                ),
              ),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * (isWeb ? 0.5 : 0.8),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: isWeb ? 6.0 : 8.0,
                      horizontal: isWeb ? 4.0 : 8.0,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          onSelected(item);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: isWeb ? 14.0 : 10.0,
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.zfontColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            itemText(item),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: textColor,
                              fontSize: isWeb ? 16 : 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}