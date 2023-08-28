import 'package:flutter/material.dart';
import 'package:paginated_list_view/paginated_list_view.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final List lists = List.generate(110, (index) => 'item #$index');

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListMenu(),
    );
  }
}

class ListMenu extends StatelessWidget {
  const ListMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paginated list view')),
      body: Center(
        child: PaginatedListView(
          datas: List.generate(50000, (index) => 'Item $index'),
          itemBuilder: (index) {
            return Container(
              height: 50,
              color: index.isEven
                  ? Theme.of(context).colorScheme.primary.withAlpha(100)
                  : Theme.of(context).colorScheme.primary.withAlpha(50),
              child: Center(child: Text('item #$index')),
            );
          },
          loadingWidget: const Center(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: SizedBox(
              width: 150,
              child: LinearProgressIndicator(),
            ),
          )),
          pageSize: 10,
          waitDuration: const Duration(milliseconds: 500),
        ),
      ),
    );
  }
}
