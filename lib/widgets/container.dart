import 'package:flutter/material.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/indicator.dart';
import 'package:market/widgets/notify.dart';
import 'package:market/widgets/refresh_indicator.dart';

class MsContainer extends StatefulWidget {
  final bool loading;
  final bool serverError;
  final bool connectError;
  final Widget child;
  final VoidCallback? action;
  final Widget? loadingWidget;

  final String? serverErrorText;
  final String? connectErrorText;

  const MsContainer({
    super.key,
    required this.loading,
    required this.serverError,
    required this.connectError,
    this.action,
    required this.child,
    this.serverErrorText,
    this.connectErrorText,
    this.loadingWidget,
  });

  @override
  State<MsContainer> createState() => _MsContainerState();
}

class _MsContainerState extends State<MsContainer> {
  String serverErrorText = '';
  String connectErrorText = '';

  @override
  void initState() {
    super.initState();
    serverErrorText = widget.serverErrorText ?? App().serverError;
    connectErrorText = widget.connectErrorText ?? App().connectError;
  }

  @override
  Widget build(BuildContext context) {
    return (widget.loading)
        ? (widget.loadingWidget) ?? const MsIndicator()
        : (widget.connectError)
        ? MsNotify(heading: connectErrorText, action: widget.action)
        : (widget.serverError)
        ? MsNotify(heading: serverErrorText, action: widget.action)
        : MsRefreshIndicator(
            onRefresh: () async {
              widget.action?.call();
              return Future.value();
            },
            child: widget.child,
          );
  }
}
