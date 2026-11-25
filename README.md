# Python Cheat Sheet Widget

A native macOS app and desktop widget for quick Python reminders, built with SwiftUI and WidgetKit.

- **The app** has searchable lessons grouped by topic, short explanations, code examples, and a copy button.
- **The widget** sits on your desktop and rotates through a beginner Python topic each day.

## Project layout

| Path | What it is |
| --- | --- |
| `macos-widget/PythonCheatSheetApp.swift` | The searchable cheat sheet app |
| `macos-widget/PythonCheatSheetWidget.swift` | The small and medium desktop widget |
| `macos-widget/PythonCheatSheet.xcodeproj` | Xcode project with the app and widget targets |
| `cheat_sheet.py` | A Python version of the cheat sheet for the terminal |

## Running it

1. Open `macos-widget/PythonCheatSheet.xcodeproj` in Xcode.
2. Build and run the app once.
3. Right-click your desktop, choose **Edit Widgets**, and add **Python Cheat Sheet**.

To try the terminal version, run `python3 cheat_sheet.py`.

## Built with

Swift, SwiftUI, WidgetKit, Python
