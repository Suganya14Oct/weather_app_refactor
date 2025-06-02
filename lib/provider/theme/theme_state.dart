
part of 'theme_provider.dart';

enum AppTheme {
  light, dark
}

class ThemeState {
  final AppTheme appTheme;
  ThemeState({this.appTheme = AppTheme.light});

  factory ThemeState.initial() {
    return ThemeState();
  }

  @override
  List<Object> get props => [appTheme];

  @override
  String toString() => 'ThemeState(appTheme: $appTheme)';

  ThemeState copyWith({
    AppTheme? appTheme
  }) {
    return ThemeState(appTheme: appTheme ?? this.appTheme);
  }

}