import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/widget/search_feald_widget.dart';
import 'package:shiftwheels/presentation/add_post/get_location_bloc/get_location_bloc.dart';

class PopUpSearchScreenWidget extends StatelessWidget {
  const PopUpSearchScreenWidget({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchFealdWidget(
          controller: _searchController,
          hintText: 'Search for a location',
          onChanged: (query) {
            if (query.isNotEmpty) {
              context.read<GetLocationBloc>().add(SearchLocationEvent(query));
            }
          },
        ),
        const SizedBox(height: 16),
        BlocBuilder<GetLocationBloc, GetLocationState>(
          builder: (context, state) {
            if (state is GetLocationSearchResults) {
              if (state.locations.isEmpty) {
                return Center(child: Text('No locations found'));
              }
              return SizedBox(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: state.locations.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final location = state.locations[index];
                    return InkWell(
                      onTap: () {
                        context.read<GetLocationBloc>().add(
                          LocationSelectedEvent(location),
                        );
                        Navigator.pop(context);
                      },

                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Icon(
                              Icons.location_on_outlined,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              location.address ?? 'Unknown address',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is GetLocationLoading) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Searching locations...',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
