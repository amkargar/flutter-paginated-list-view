class Pagination {
  List datas = [];

  Pagination(List data, int itemsPerPage) {
    for (int i = 0; i < data.length; i += itemsPerPage) {
      List sublist = data.sublist(
        i,
        i + itemsPerPage < data.length ? i + itemsPerPage : data.length,
      );
      datas.add(sublist);
    }
  }
}
