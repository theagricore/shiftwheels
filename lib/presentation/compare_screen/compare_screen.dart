import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/compare_screen/compare_bloc/compare_bloc.dart';
import 'package:shiftwheels/presentation/compare_screen/widget/comparison_view_widget.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return BlocProvider(
      create:
          (context) =>
              CompareBloc()..add(LoadFavoritesForComparison(currentUserId)),
      child: const _CompareContent(),
    );
  }
}

class _CompareContent extends StatelessWidget {
  const _CompareContent();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode ? AppColors.zDarkPrimaryText : AppColors.zLightPrimaryText;

    return Scaffold(
      body: BlocConsumer<CompareBloc, CompareState>(
        listener: (context, state) {
          if (state is ComparisonSaved || state is PdfGenerated) {
            _showSuccessDialog(context, state);
          }
        },
        builder:
            (context, state) =>
                _buildContentBasedOnState(context, state, textColor),
      ),
    );
  }

  Widget _buildContentBasedOnState(
    BuildContext context,
    CompareState state,
    Color textColor,
  ) {
    if (state is CompareInitial || state is CompareLoading) {
      return _buildLoadingView();
    } else if (state is CompareError) {
      return _buildErrorView(context, state);
    } else if (state is FavoritesLoadedForComparison) {
      return ComparisonViewWidget(state: state);
    }
    // Default case: handled by BlocConsumer listener for success states
    return const SizedBox();
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: AppColors.zPrimaryColor,
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, CompareError state) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final errorTextColor = isDarkMode ? AppColors.zred : Colors.red;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: errorTextColor, size: 60),
            const SizedBox(height: 20),
            Text(
              state.message,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: errorTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildRetryButton(context),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, CompareState state) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode ? AppColors.zDarkPrimaryText : AppColors.zLightPrimaryText;
    final message =
        state is ComparisonSaved
            ? 'Comparison saved successfully!'
            : 'PDF generated and shared successfully!';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => AlertDialog(
            backgroundColor:
                isDarkMode ? AppColors.zDarkCardBackground : AppColors.zWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: AppColors.zGreen, size: 60),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: textColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
           
          ),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return BasicElevatedAppButton(
      onPressed: () {
        final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        context.read<CompareBloc>().add(LoadFavoritesForComparison(userId));
      },
      title: 'Retry',
    );
  }

  
}

