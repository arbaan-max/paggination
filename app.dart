import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/bloc/authentication/authentication_bloc.dart';
import 'package:store/bloc/authentication/sign_in_bloc.dart';
import 'package:store/bloc/cash_handover/cash_handover_bloc.dart';
import 'package:store/bloc/driver/driver_bloc.dart';
import 'package:store/bloc/item/item_bloc.dart';
import 'package:store/bloc/mapper/mapper_bloc.dart';
import 'package:store/bloc/order/order_bloc.dart';
import 'package:store/bloc/return_request/return_request_bloc.dart';
import 'package:store/bloc/store/store_bloc.dart';
import 'package:store/bloc/store/store_status_bloc.dart';
import 'package:store/bloc/theme/theme_bloc.dart';
import 'package:store/bloc/toggle_items/toggle_history/toggle_history_bloc.dart';
import 'package:store/bloc/toggle_items/toggle_items_bloc.dart';
import 'package:store/core/route/app_router.dart';
import 'package:store/core/utils/color_scheme.dart';
import 'package:store/core/utils/constants.dart';
import 'package:store/core/utils/extenstions.dart';
import 'package:store/data/repository/auth_repository.dart';
import 'package:store/data/repository/driver_repository.dart';
import 'package:store/data/repository/item_repository.dart';
import 'package:store/data/repository/mapper_repository.dart';
import 'package:store/data/repository/order_repository.dart';
import 'package:store/data/repository/return_request_repository.dart';
import 'package:store/data/repository/store_reposotory.dart';
import 'package:store/data/repository/toggled_items_repo.dart';
import 'package:store/data/services/auth_service.dart';
import 'package:store/data/services/driver_service.dart';
import 'package:store/data/services/item_service.dart';
import 'package:store/data/services/mapper_service.dart';
import 'package:store/data/services/order_service.dart';
import 'package:store/data/services/return_request_service.dart';
import 'package:store/data/services/store_service.dart';
import 'package:store/data/services/toggle_items_service.dart';

/// [Application] is the entry point of the application.
/// It creates the [MaterialApp] and when the application starts it starts the [runApp] function.
/// it also added all the [BlocProvider] to the application.
class Application extends StatelessWidget {
  const Application({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        ),
        BlocProvider<StoreBloc>(
          create: (context) => StoreBloc(),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<SignInBloc>(
          create: (context) => SignInBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            storeBloc: BlocProvider.of<StoreBloc>(context),
            authRepository: AuthRepositoryImpl(
              authService: AuthService(
                dio: Dio(),
              ),
            ),
          ),
        ),
        BlocProvider<StoreStatusBloc>(
          create: (context) => StoreStatusBloc(
            storeBloc: BlocProvider.of<StoreBloc>(context),
            storeRepository: StoreRepositoryImpl(
              storeService: StoreService(
                dio: Dio(),
              ),
            ),
          ),
        ),

        /// cashhanderbloc
        BlocProvider<CashHandoverBloc>(
          // lazy: false,
          create: (context) => CashHandoverBloc(
            repository: StoreRepositoryImpl(
              storeService: StoreService(
                dio: Dio(),
              ),
            ),
          )
            ..add(const GetAllHandoverCashEvent())
            ..add(const GetAllFloatingCashEvent()),
        ),
        BlocProvider<DriverBloc>(
          // lazy: false,
          create: (context) => DriverBloc(
            cashHandoverBloc: BlocProvider.of<CashHandoverBloc>(context),
            driverRepository: DriverRepositoryImpl(
              driverService: DriverService(
                dio: Dio(),
              ),
            ),
          ),
        ),
        BlocProvider<OrderBloc>(
          // lazy: false,
          create: (context) => OrderBloc(
            orderRepository: OrderRepositoryImpl(
              orderService: OrderService(
                dio: Dio(),
              ),
            ),
          ),
        ),

        /// mappers
        BlocProvider<MapperBloc>(
          // lazy: false,
          create: (context) => MapperBloc(
            mapperRepository: MapperRepositoryImpl(
              mapperService: MapperService(
                dio: Dio(),
              ),
            ),
          )..add(MapperFetchEvent()),
        ),
        BlocProvider<ItemBloc>(
          // lazy: false,
          create: (context) => ItemBloc(
            itemRepository: ItemRepositoryImpl(
              itemService: ItemService(
                dio: Dio(),
              ),
            ),
          ),
        ),

        /// return request
        BlocProvider<ReturnRequestBloc>(
          create: (context) => ReturnRequestBloc(
            repository: ReturnRequestRepositoryImpl(
              service: ReturnRequestService(
                dio: Dio(),
              ),
            ),
          )..add(const FetchReturnRequests()),
        ),

        /// Toggled History Items
        BlocProvider<ToggleHistoryBloc>(
            create: (context) => ToggleHistoryBloc(
                  repository: ToggledItemsReposImpl(
                    service: ToggleItemsService(dio: Dio()),
                  ),
                )),

        /// Get All toggle Items
        BlocProvider<ToggleItemsBloc>(
          create: (context) => ToggleItemsBloc(
            repository: ToggledItemsReposImpl(
              service: ToggleItemsService(dio: Dio()),
            ),
          ),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            routerConfig: AppRouter(
              authenticationBloc: context.watch<AuthenticationBloc>(),
            ).router,
            title: kAppName,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: lightColorScheme,
              primarySwatch: kPrimaryColor.toMaterialColor(),
              useMaterial3: true,
              fontFamily: kFontFamily,
              snackBarTheme: const SnackBarThemeData(
                behavior: SnackBarBehavior.floating,
                contentTextStyle: TextStyle(fontFamily: kFontFamily),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: darkColorScheme,
              primarySwatch: kPrimaryColor.toMaterialColor(),
              useMaterial3: true,
              fontFamily: kFontFamily,
              snackBarTheme: const SnackBarThemeData(
                behavior: SnackBarBehavior.floating,
                contentTextStyle: TextStyle(fontFamily: kFontFamily),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
