part of sizer;

/// Provides `Context`, `Orientation`, and `ScreenType` parameters to the builder function
typedef ResponsiveBuilderType = Widget Function(
  BuildContext,
  Orientation,
  ScreenType,
);

/// A widget that gets the device's details like orientation and constraints
/// Usage: Wrap MaterialApp with this widget
class Sizer extends StatefulWidget {
  const Sizer({
    Key? key,
    required this.builder,
    this.maxMobileWidth = 599,
    this.maxTabletWidth,
  }) : super(key: key);

  /// Builds the widget whenever the orientation changes
  final ResponsiveBuilderType builder;

  /// This is the breakpoint used to determine whether the device is
  /// a mobile device or a tablet.
  ///
  /// If the `MediaQuery`'s width **in portrait mode** is less than or equal
  /// to `maxMobileWidth`, the device is in a mobile device
  final double maxMobileWidth;

  /// By default, the `ScreenType` can only be mobile or tablet. If this is set,
  /// the `ScreenType` can be desktop as well
  ///
  /// This is the breakpoint used to determine whether the device is
  /// a tablet or a desktop.
  ///
  /// If the `MediaQuery`'s width **in portrait mode** is
  /// less than or equal to `maxTabletWidth`, the device is in a tablet device
  final double? maxTabletWidth;

  @override
  State<Sizer> createState() => _SizerState();
}

class _SizerState extends State<Sizer> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        Device.setScreenSize(
          context,
          constraints,
          orientation,
          widget.maxMobileWidth,
          widget.maxTabletWidth,
        );

        if (size.width == 0 ||
            size.height == 0 ||
            constraints.maxWidth == 0 ||
            constraints.maxHeight == 0) {
          return const SizedBox();
        }

        return widget.builder(context, orientation, Device.screenType);
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
