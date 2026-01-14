enum StateStatus {
  initial,
  loading,
  refreshing,
  paginating,
  success,
  empty,
  error,
}

extension StateStatusX on StateStatus {
  bool get isInitial => this == StateStatus.initial;
  bool get isLoading => this == StateStatus.loading;
  bool get isRefreshing => this == StateStatus.refreshing;
  bool get isPaginating => this == StateStatus.paginating;
  bool get isSuccess => this == StateStatus.success;
  bool get isEmpty => this == StateStatus.empty;
  bool get isError => this == StateStatus.error;

  bool get isBusy =>
      isLoading || isRefreshing || isPaginating;
}
