import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(
    create: (_) => AuthNotifier(),
  ),
];
