import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_guard/bloc/store/in_active_items/in_active_items_bloc.dart';
import 'package:store_guard/service/model/store_model.dart';

class InActiveItemsPage extends StatefulWidget {
  const InActiveItemsPage({super.key, required this.model});
  final StoreDetail model;

  @override
  State<InActiveItemsPage> createState() => _InActiveItemsPageState();
}

class _InActiveItemsPageState extends State<InActiveItemsPage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<InActiveItemsBloc>().add(GetAllInActiveItems(
          id: widget.model.storeId ?? 0,
          refresh: true,
        ));
    scrollFunction();
  }

  scrollFunction() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !context.read<InActiveItemsBloc>().state.isLoading &&
          !context.read<InActiveItemsBloc>().state.hasReachedMax) {
        context.read<InActiveItemsBloc>().add(GetAllInActiveItems(
              id: widget.model.storeId ?? 0,
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InActiveItemsBloc, InActiveItemsState>(
      listener: (context, state) {
        if (state.error.isNotEmpty == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final loading = state.isLoading;
        final itemsData = state.inActiveItemsData;
        if (loading && itemsData.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!loading && itemsData.isEmpty) {
          return const Center(
            child: Text('No Items Found!'),
          );
        } else if (itemsData.isNotEmpty) {
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    context.read<InActiveItemsBloc>().add(GetAllInActiveItems(
                          id: widget.model.storeId ?? 0,
                          refresh: true,
                        ));
                    return Future<void>.value();
                  },
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: itemsData.length + 1,
                      clipBehavior: Clip.none,
                      itemBuilder: (context, index) {
                        if (index < itemsData.length) {
                          final data = itemsData[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 8),
                            child: Card(
                              elevation: 2,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Text(
                                    '${index + 1}',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  title: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.scaleDown,
                                    child: Text(data.name ?? ''),
                                  ),
                                  subtitle: Text("${data.itemId ?? 0}"),
                                  trailing: const Icon(
                                    Icons.circle,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          if (loading) {
                            return const SizedBox(
                              height: 100,
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                        )),
                                    SizedBox(width: 5),
                                    Text("Loading..."),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox(height: 100);
                          }
                        }
                      }),
                ),
              ),
            ],
          );
        }
        return const Center(
          child: Text('Something Went Wrong'),
        );
      },
    );
  }
}
