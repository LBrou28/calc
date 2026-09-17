# Calc

A simple, single-page Flutter calculator with addition, subtraction,
multiplication, division, decimals, sign changes, backspace, and clear.
Operations are evaluated left to right, like a basic pocket calculator.
Division by zero displays `Error`; entering a number starts again.

## Setup and run

Install Flutter **3.47.1** (stable), then run:

```sh
flutter pub get
flutter run -d chrome
```

This project includes a web runner. The calculator UI is written entirely in
Flutter. For another platform, generate its runner with `flutter create
--platforms=android,ios,windows .` using the required native development tools.

## Test: add 2 + 2 and check 4

```sh
flutter test
```

The first widget test starts the app, checks the initial display, taps **2 → + →
2 → =**, and asserts that the result display contains **4**. Other tests cover
arithmetic, clear, decimal input, backspace, and recovery from division by zero.

To try it manually, start the app and tap the same four buttons.

## Automated build

Every push and pull request runs `.github/workflows/flutter.yml` on GitHub
Actions. It installs Flutter and dependencies, checks formatting, analyzes the
code, runs the tests, builds the release web app, and uploads a `calc-web`
artifact. It can also be run from the Actions tab using **Run workflow**.

To build locally:

```sh
flutter analyze
flutter test --coverage
flutter build web --release
```

The output is in `build/web`. Serve that directory with an HTTP server;
opening `index.html` directly as a file is not supported.

Flutter's [web build documentation](https://docs.flutter.dev/platform-integration/web/building)
describes the runner and release output.
