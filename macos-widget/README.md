# Python Cheat Sheet for Mac

This is a native SwiftUI app with a WidgetKit extension. It is separate from the Dino app and 30-day Python bootcamp.

## Project files

- `PythonCheatSheetApp.swift` holds the searchable Mac cheat sheet.
- `PythonCheatSheetWidget.swift` holds the small and medium desktop widget.
- `Widget-Info.plist` identifies the WidgetKit extension.
- `PythonCheatSheet.xcodeproj` contains the app and widget targets.

Edit the Swift files in VS Code. To build and add the widget to the Mac widget gallery, open `PythonCheatSheet.xcodeproj` in Xcode, build and run the app once, then add **Python Cheat Sheet** from the widget gallery.

The widget rotates through beginner Python topics once per day. The full app has searchable lessons grouped by topic, short explanations, code examples, and a copy button.
