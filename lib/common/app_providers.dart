import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../providers/launch_provider.dart';

/// It's a list of providers that are used in the app
class AppProviders {
  static final List<SingleChildWidget> _providers = [
    ChangeNotifierProvider(create: (context) => LaunchProvider())
  ];

  static get providers => _providers;
}
