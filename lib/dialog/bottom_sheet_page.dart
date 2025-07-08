import 'package:flutter/material.dart';

class BottomSheetPage extends Page<void> {
  final Widget child;

  BottomSheetPage({required this.child})
    : super(key: ValueKey('BottomSheetPage'));

  @override
  Route<void> createRoute(BuildContext context) {
    return _BottomSheetRoute(child: child, settings: this);
  }
}

class _BottomSheetRoute extends PageRoute<void> {
  final Widget child;

  _BottomSheetRoute({required this.child, required RouteSettings settings})
    : super(settings: settings);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String get barrierLabel => 'BottomSheet';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get maintainState => false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: Center(
        child: Material(borderRadius: BorderRadius.circular(12), child: child),
      ),
    );
  }
}
