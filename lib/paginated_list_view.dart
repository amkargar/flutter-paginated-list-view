import 'package:flutter/material.dart';

class PaginatedListView extends StatefulWidget {
  const PaginatedListView({
    super.key,
    required this.datas,
    required this.itemBuilder,
    this.loadingWidget = const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    ),
    this.pageSize = 10,
    this.waitDuration = const Duration(milliseconds: 300),
  });

  // All datas
  final List<String> datas;
  // Item builder widget
  final Widget Function(int index) itemBuilder;
  // Loading widget
  final Widget loadingWidget;
  // Items in each page
  final int pageSize;
  // Time to wait to load new datas
  final Duration waitDuration;

  @override
  State<PaginatedListView> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView> {
  /// Current page
  int currentPage = 0;

  /// Last page
  late int lastPage;

  /// Is last page
  bool isLastPage = false;

  /// Is first page
  bool isFirstPage = true;

  /// Scroll controller that detect the scroll behavior to load page datas
  final ScrollController _scrollController = ScrollController();

  /// Should show the progress indicator
  bool isLoading = false;

  /// All our datas
  final List<List> paginatedDatas = List.empty(growable: true);

  /// Current page datas
  List currentDatas = [];

  /// Paginate the datas and put each page data in a list and add them to the [paginatedDatas] list
  void paginate() {
    for (int i = 0; i < widget.datas.length; i += widget.pageSize) {
      List sublist = widget.datas.sublist(
        i,
        i + widget.pageSize < widget.datas.length ? i + widget.pageSize : widget.datas.length,
      );
      paginatedDatas.add(sublist);
    }
  }

  /// Listen to the scroll and check if new datas need to be loaded
  Future<void> _scrollListener() async {
    // Reached the bottom of the list, add the next page
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Is not loading and is not the last page
      if (!isLoading && lastPage != currentPage + 1) {
        // Add the next page datas to the current datas
        await addNextPage();
        // handle the next data load conflict
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent - 1);
      }
    }
  }

  /// Go to the given [page]
  Future<void> goToPage(int page) async {
    setState(() {
      // Start show loading
      isLoading = true;
    });

    /// Simulating the given delay for demonstration purposes
    await Future.delayed(widget.waitDuration);

    setState(() {
      // Stop show loading
      isLoading = false;

      // set the currentDatas according to the given page
      currentDatas = paginatedDatas[page];
    });
  }

  // Go to the next page
  Future<void> goToNextPage() async {
    // Is not the last page
    if (!isLastPage) {
      // Go to the next page
      currentPage += 1;
      goToPage(currentPage);
    }
  }

  // Go to the previous page
  Future<void> goToPreviousPage() async {
    // Is not the first page
    if (!isFirstPage) {
      // Go to the previous page
      currentPage -= 1;
      goToPage(currentPage);
    }
  }

  // Add next page datas to the current page datas
  Future<void> addNextPage() async {
    setState(() {
      // Start show loading
      isLoading = true;
    });

    // Simulating given delay for demonstration purposes
    await Future.delayed(widget.waitDuration);

    setState(() {
      // Stop show loading
      isLoading = false;

      // Add next page datas to the current page datas
      currentPage += 1;
      currentDatas += paginatedDatas[currentPage];
    });
  }

  @override
  void initState() {
    super.initState();

    // Specifies the number of the last page
    lastPage = (widget.datas.length / widget.pageSize).ceil();

    // Paginates the datas
    paginate();

    // Set current datas to the first page
    currentDatas = paginatedDatas[0];

    // Add listener for scroll controller
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // dispose the scrollController
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: currentDatas.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < currentDatas.length) {
          return widget.itemBuilder(index);
        } else {
          return widget.loadingWidget;
        }
      },
    );
  }
}
