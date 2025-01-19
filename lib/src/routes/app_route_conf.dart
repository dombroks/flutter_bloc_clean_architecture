import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_ca/src/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:go_router/go_router.dart';

import 'app_route_path.dart';
import 'routes.dart';

class AppRouteConf {
  GoRouter get router => _router;

  late final _router = GoRouter(
    initialLocation: AppRoute.auth.path,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoute.auth.path,
        name: AppRoute.auth.name,
        builder: (_, __) => const AuthPage(),
        routes: [
          GoRoute(
            path: AppRoute.login.path,
            name: AppRoute.login.name,
            builder: (_, __) => const LoginPage(),
          ),
          GoRoute(
            path: AppRoute.register.path,
            name: AppRoute.register.name,
            builder: (_, __) => const RegisterPage(),
          ),
        ],
      ),
      ShellRoute(
          builder: (_, __, child) {
            return BlocProvider(
                create: (_) => getIt<ProductBloc>(), child: child);
          },
          routes: [
            GoRoute(
              path: AppRoute.product.path,
              name: AppRoute.product.name,
              builder: (_, state) {
                final params = state.pathParameters;
                final user = UserEntity(
                  username: params["username"],
                  email: params["email"],
                  userId: params["user_id"],
                );

                return ProductsPage(user: user);
              },
            ),
            GoRoute(
              path: AppRoute.createProduct.path,
              name: AppRoute.createProduct.name,
              builder: (context, state) {
                //final context = state.extra as BuildContext;

                return const CreateProductPage();
              },
            ),
            GoRoute(
              path: AppRoute.updateProduct.path,
              name: AppRoute.updateProduct.name,
              builder: (_, state) {
                //final context = state.extra as BuildContext;
                final params = state.pathParameters;

                final product = UpdateProductParams(
                  productId: params["product_id"] ?? "",
                  name: params["product_name"] ?? "",
                  price: int.tryParse(params["product_price"] ?? "") ?? 0,
                );

                return UpdateProductPage(
                  productParams: product,
                );
              },
            ),
          ]),
    ],
  );
}
