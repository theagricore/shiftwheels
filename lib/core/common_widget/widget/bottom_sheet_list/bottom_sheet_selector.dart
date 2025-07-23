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
                      );
                    },
                  ),
                ),
              );
            },
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: containerColor, 
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isDisabled
                ? (isDarkMode ? AppColors.zSecondBackground : AppColors.zfontColor) 
                : (isDarkMode ? AppColors.zSecondBackground : AppColors.zfontColor), 
            width: 1.0,
          ),
        ),
        child: Center(
          child: ListTile(
            title: Text(
              displayText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDisabled ? disabledTextColor : textColor,
                  ),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_down,
              color: isDisabled ? disabledTextColor : textColor, 
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ),
    );
  }
}