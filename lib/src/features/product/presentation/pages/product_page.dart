import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_ca/src/core/blocs/network/network_bloc.dart';
import 'package:flutter_bloc_ca/src/core/blocs/network/network_event.dart';
import 'package:flutter_bloc_ca/src/core/blocs/network/network_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';


import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/blocs/translate/translate_bloc.dart';
import '../../../../core/constants/list_translation_locale.dart';
import '../../../../routes/app_route_path.dart';
import '../../../../widgets/dialog_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../../../../widgets/snackbar_widget.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../bloc/product/product_bloc.dart';
import '../widgets/product_list_tile.dart';

class ProductsPage extends StatefulWidget {
  final UserEntity user;
  const ProductsPage({
    super.key,
    required this.user,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
 
  late Timer _timer;

  @override
  void initState() {

    context.read<NetworkBloc>().add(NetworkCheckEvent());

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      context.read<NetworkBloc>().add(NetworkCheckEvent());
    });

    super.initState();
  }



  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _changeLanguage(BuildContext context, String languageCode) {
    final translationBloc = context.read<TranslateBloc>();
    if (languageCode == "id") {
      context.setLocale(englishLocale);
      translationBloc.add(TrEnglishEvent());
    } else {
      // context.setLocale(indonesiaLocale);
      // trBloc.add(TrIndonesiaEvent());
    }
    context.read<ProductBloc>().add(
          GetProductListEvent(),
        );
  }

  void _changeTheme(BuildContext context) {
    final themeBloc = context.read<ThemeBloc>();
    if (themeBloc.state.isDarkMode) {
      themeBloc.add(LightThemeEvent());
    } else {
      themeBloc.add(DarkThemeEvent());
    }
  }

  void _logout(BuildContext context) {
    showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (_) => AppDialog(title: "pesan_keluar".tr()),
    ).then(
      (value) => value ?? false
          ? context.read<AuthBloc>().add(AuthLogoutEvent())
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt<AuthBloc>(),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthLogoutLoadingState) {
                  showDialog(
                    context: context,
                    builder: (_) => const AppLoadingWidget(),
                  );
                } else if (state is AuthLogoutSuccessState) {
                  context.goNamed(AppRoute.login.name);
                  appSnackBar(context, Colors.green, state.message);
                } else if (state is AuthLogoutFailureState) {
                  context.pop();
                  appSnackBar(context, Colors.red, state.message);
                }
              },
            ),
            BlocListener<NetworkBloc, NetworkState>(
              listener: (context, state) {
                if (state is NetworkConnectedState) {
                  appSnackBar(context, Colors.green, "ada_internet".tr());

                  context.read<ProductBloc>().add(GetProductListEvent());

                } else if (state is NetworkDisconnectedState) {
                  appSnackBar(context, Colors.red, "tidak_ada_internet".tr());
                }
              },
            )
          ],
          child: Scaffold(
            appBar: AppBar(
              title: Text("hai".tr(args: [widget.user.username ?? ""])),
              leading: BlocBuilder<TranslateBloc, TranslateState>(
                builder: (_, state) {
                  return IconButton(
                    onPressed: () {
                      _changeLanguage(context, state.languageCode);
                    },
                    icon: Text(state.previousCountryCode),
                    splashRadius: 20.r,
                  );
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _logout(context);
                  },
                  splashRadius: 20.r,
                  icon: const Icon(Icons.logout),
                  color: Colors.white,
                )
              ],
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30.w),
                  child: FloatingActionButton(
                    heroTag: "theme",
                    onPressed: () {
                      _changeTheme(context);
                    },
                    child: Icon(
                      context.read<ThemeBloc>().state.isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                    ),
                  ),
                ),
                FloatingActionButton.extended(
                  heroTag: "add_product",
                  onPressed: () => context.pushNamed(
                    AppRoute.createProduct.name,
                    extra: context,
                  ),
                  label: Text(
                    "tambah_produk".tr(),
                    style: TextStyle(
                      color: context.read<ThemeBloc>().state.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async{
                context.read<ProductBloc>().add(GetProductListEvent());
              },
              child: const ProductDataWidget(),
            ),
          ),
        ));
  }
}
