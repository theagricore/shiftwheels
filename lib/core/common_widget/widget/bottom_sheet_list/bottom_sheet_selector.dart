import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/widget/bottom_sheet_list/app_bottom_sheet.dart';
import 'package:shiftwheels/core/common_widget/widget/bottom_sheet_list/drop_down_sheet.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

typedef FetchEventBuilder = void Function(BuildContext context);
typedef BlocSelectorBuilder<T> = List<T> Function(dynamic state);
typedef ErrorSelector = String? Function(dynamic state);
typedef LoadingSelector = bool Function(dynamic state);

class BottomSheetSelector<T> extends StatelessWidget {
  final String title;
  final String displayText;
  final bool isDisabled;
  final FetchEventBuilder onTapFetchEvent;
  final Bloc selectorBloc;
  final BlocSelectorBuilder<T> itemsSelector;
  final String Function(T) itemText;
  final void Function(T) onItemSelected;
  final LoadingSelector loadingSelector;
  final ErrorSelector errorSelector;
  final bool isWeb;

  const BottomSheetSelector({
    super.key,
    required this.title,
    required this.displayText,
    required this.onTapFetchEvent,
    required this.selectorBloc,
    required this.itemsSelector,
    required this.itemText,
    required this.onItemSelected,
    required this.loadingSelector,
    required this.errorSelector,
    this.isDisabled = false,
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color containerColor =
        isDarkMode ? AppColors.zSecondBackground : AppColors.zWhite; 
    final Color textColor =
        isDarkMode ? AppColors.zWhite : AppColors.zfontColor;
    final Color disabledTextColor =
        isDarkMode ? AppColors.zfontColor : AppColors.zfontColor;

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              onTapFetchEvent(context);
              AppBottomSheet.display(
                context,
                BlocProvider.value(
                  value: selectorBloc,
                  child: BlocBuilder(
                    bloc: selectorBloc,
                    builder: (context, state) {
                      return DropdownSheet<T>(
                        title: title,
                        items: itemsSelector(state),
                        itemText: itemText,
                        onSelected: (T item) {
                          onItemSelected(item);
                        },
                        isLoading: loadingSelector(state),
                        error: errorSelector(state),
                        isWeb: isWeb,
                      );
                    },
                  ),
                ),
                isWeb: isWeb,
              );
            },
      child: Container(
        height: isWeb ? 50 : 60,
        decoration: BoxDecoration(
          color: containerColor, 
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDisabled
                ? (isDarkMode ? AppColors.zSecondBackground.withOpacity(0.4) : AppColors.zfontColor.withOpacity(0.4)) 
                : (isDarkMode ? AppColors.zSecondBackground : AppColors.zfontColor), 
            width: 1.5,
          ),
        ),
        child: Center(
          child: ListTile(
            title: Text(
              displayText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDisabled ? disabledTextColor.withOpacity(0.6) : textColor,
                    fontSize: isWeb ? 14 : 16,
                  ),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_down,
              color: isDisabled ? disabledTextColor.withOpacity(0.6) : textColor, 
              size: isWeb ? 20 : 24,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: isWeb ? 12 : 16),
          ),
        ),
      ),
    );
  }
}