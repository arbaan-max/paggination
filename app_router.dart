import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:store/bloc/authentication/authentication_bloc.dart';
import 'package:store/core/route/routes.dart';
import 'package:store/data/models/driver.dart';
import 'package:store/data/models/order.dart';
import 'package:store/data/models/store.dart';
import 'package:store/view/screens/auth/sign_in.dart';
import 'package:store/view/screens/drivers/driver_order_details.dart';
import 'package:store/view/screens/home/home.dart';
import 'package:store/view/screens/home/invoice.dart';
import 'package:store/view/screens/home/profile.dart';
import 'package:store/view/screens/home/qr.dart';
import 'package:store/view/screens/return_request/craete_return_request.dart';
import 'package:store/view/screens/return_request/resolve_return_request.dart';
import 'package:store/view/screens/return_request/return_requests.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class AppRouter {
  final AuthenticationBloc authenticationBloc;
  late final GoRouter _router;
  GoRouter get router => _router;
  AppRouter({required this.authenticationBloc}) {
    _router = GoRouter(
      initialLocation: initialRoute,
      refreshListenable: authenticationBloc,
      redirect: (context, state) {
        final isSignInRoute = signInRoute == state.matchedLocation;
        final isAuthenticated =
            authenticationBloc.state == AuthenticationState.authenticated;
        if (!isAuthenticated && !isSignInRoute) {
          return signInRoute;
        } else if (isAuthenticated && isSignInRoute) {
          return initialRoute;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: initialRoute,
          name: initialRoute,
          builder: (context, state) {
            if (kIsWeb) {
              return const Scaffold(
                body: ResolveReturnRequestPage(),
              );
            }
            return const HomePage();
          },
          routes: [
            GoRoute(
              path: profileRoute,
              name: profileRoute,
              builder: (context, state) => const ProfilePage(),
            ),
            GoRoute(
              path: driverDetailsRoute,
              name: driverDetailsRoute,
              builder: (context, state) => DriverDetailsPage(
                driver: state.extra as Driver,
              ),
            ),
            GoRoute(
              path: qrRoute,
              name: qrRoute,
              builder: (context, state) => const QRPage(),
              routes: [
                GoRoute(
                  path: printORRoute,
                  name: printORRoute,
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>;
                    return PrintORPage(
                      store: extra['store'] as Store,
                      json: extra['json'] as String,
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: invoiceRoute,
              name: invoiceRoute,
              builder: (context, state) => InvoicePage(
                order: state.extra as Order,
              ),
            ),

            /// return request
            GoRoute(
              path: createReturnRequestRoute,
              name: createReturnRequestRoute,
              redirect: (context, state) {
                final query = state.queryParameters;
                final order = query['order']?.toString() ?? '';
                if (order.isEmpty) {
                  return initialRoute;
                }
                return null;
              },
              builder: (context, state) {
                final query = state.queryParameters;
                final order = query['order']?.toString() ?? '';
                return CreateReturnRequestPage(
                  order: order,
                );
              },
            ),

            /// return requests
            GoRoute(
              path: returnRequestRoute,
              name: returnRequestRoute,
              builder: (context, state) => const ReturnRequestPage(),
            ),

            /// resolve return request
            GoRoute(
              path: resolveReturnRequestRoute,
              name: resolveReturnRequestRoute,
              builder: (context, state) {
                return const ResolveReturnRequestPage();
              },
            ),
          ],
        ),
        GoRoute(
          path: signInRoute,
          name: signInRoute,
          builder: (context, state) => const SignInPage(),
        ),
      ],
    );
  }
}
