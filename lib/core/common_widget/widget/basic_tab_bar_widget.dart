import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class BasicTabBarWidget extends StatefulWidget {
  final List<String> tabTitles;
  final List<Widget> tabViews;
  final double? tabGap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const BasicTabBarWidget({
    super.key,
    required this.tabTitles,
    required this.tabViews,
    this.tabGap = 8.0,
    this.margin,
    this.borderRadius,
  }) : assert(tabTitles.length == tabViews.length);

  @override
  State<BasicTabBarWidget> createState() => _BasicTabBarWidgetState();
}

class _BasicTabBarWidgetState extends State<BasicTabBarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabTitles.length,
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: widget.margin ?? const EdgeInsets.all(16),
          child: Row(
            children: [
              for (int i = 0; i < widget.tabTitles.length; i++)
                _buildTabButton(i),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabViews,
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(int index) {
    final isSelected = _tabController.index == index;
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
          right: index < widget.tabTitles.length - 1 ? widget.tabGap! : 0,
        ),
        child: Material(
          color: isSelected ? AppColors.zPrimaryColor : AppColors.zGrey,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          child: InkWell(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            onTap: () => _tabController.animateTo(index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.center,
              child: Text(
                widget.tabTitles[index],
                style: TextStyle(
                  color: isSelected ? AppColors.zWhite : AppColors.zblack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}