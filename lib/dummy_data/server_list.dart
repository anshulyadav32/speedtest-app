class Server {
  Server({
    required this.state,
    required this.country,
    required this.host,
    required this.counter,
  });
  final String state;
  final String country;
  final String host;
  final int counter;
}

List<Server> serverList = [];
