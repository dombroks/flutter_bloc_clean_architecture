enum AppRoute {
  auth(path: "/auth"),
  login(path: "login"),
  register(path: "register"),
  product(path: "/product/:user_id/:email/:username"),
  createProduct(path: "/product/add"),
  updateProduct(path: "/product/update/:product_id/:product_name/:product_price");

  final String path;
  const AppRoute({required this.path});
}
