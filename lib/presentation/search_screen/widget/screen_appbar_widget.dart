import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/search_screen/search_bloc/search_bloc.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final VoidCallback onFilterPressed;

  const SearchAppBar({
    super.key,
    required this.searchController,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.zPrimaryColor, width: 1.3),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),

      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      backgroundColor: AppColors.zBackGround,
      title: Row(
        children: [
          Expanded(
            child: Container(
              height: 63,
              decoration: BoxDecoration(
                color: AppColors.zBackGround,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: AppColors.zPrimaryColor, width: 1.2),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Container(
                    child: Lottie.asset(
                      'assets/images/Animation - search-w1000-h1000.json',
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                      repeat: false,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search by brand, model, etc...",
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                        isDense: true,
                        fillColor: AppColors.zBackGround,
                      ),
                      onChanged: (query) {
                        context.read<SearchBloc>().add(
                          SearchQueryChanged(query),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: (){
                        onFilterPressed();
                      },
                      child: Container(
                        child: Lottie.asset(
                          'assets/images/Animation - filter-w560-h560.json',
                          height: 40,
                          width: 40,
                          fit: BoxFit.contain,
                          repeat: false,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
