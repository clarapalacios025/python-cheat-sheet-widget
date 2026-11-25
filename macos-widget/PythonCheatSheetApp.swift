import AppKit
import Combine
import SwiftUI

private struct Lesson: Identifiable, Hashable {
    let title: String
    let category: String
    let explanation: String
    let example: String
    let takeaway: String

    var id: String { title }
}

private struct LessonGroup: Identifiable {
    let category: String
    let lessons: [Lesson]

    var id: String { category }
}

private let lessons: [Lesson] = [
    Lesson(
        title: "Print and comments",
        category: "Getting started",
        explanation: "Use print() to show something on the screen. A comment is a note for people reading your code; Python skips it.",
        example: "print('Hello, world!')\n\n# Python ignores this note",
        takeaway: "Text inside quotes is shown as text. A comment starts with #."
    ),
    Lesson(
        title: "Variables",
        category: "Getting started",
        explanation: "A variable gives a name to a value so your program can use it later.",
        example: "name = 'Clara'\nage = 36\n\nprint(name)\nprint(age)",
        takeaway: "Use = to assign a value. Python figures out the value's type for you."
    ),
    Lesson(
        title: "Text and numbers",
        category: "Getting started",
        explanation: "Text is called a string. Whole numbers are integers, and numbers with a decimal point are floats.",
        example: "message = 'I am learning Python'\ncount = 3\nprice = 2.50",
        takeaway: "Strings need quotes. Integers and floats do not."
    ),
    Lesson(
        title: "Getting input",
        category: "Getting started",
        explanation: "input() pauses the program and lets someone type a response. The response is returned as text.",
        example: "name = input('What is your name? ')\nprint('Hello, ' + name)",
        takeaway: "Even if someone types a number, input() gives your program a string."
    ),
    Lesson(
        title: "Changing a type",
        category: "Getting started",
        explanation: "Convert a value when you need to use it as a different kind of data, such as changing typed text into a number.",
        example: "age_text = input('How old are you? ')\nage = int(age_text)\nprint(age + 1)",
        takeaway: "int() makes a whole number. float() makes a decimal number. str() makes text."
    ),
    Lesson(
        title: "Math operators",
        category: "Making decisions",
        explanation: "Math operators let Python calculate. The % operator gives the remainder after division.",
        example: "print(4 + 2)   # 6\nprint(4 - 2)   # 2\nprint(4 * 2)   # 8\nprint(5 % 2)   # 1",
        takeaway: "+ adds, - subtracts, * multiplies, / divides, and % gives the remainder."
    ),
    Lesson(
        title: "If statements",
        category: "Making decisions",
        explanation: "An if statement lets your program choose what to do based on whether a condition is true.",
        example: "temperature = 75\n\nif temperature > 70:\n    print('It is warm')\nelse:\n    print('It is cool')",
        takeaway: "The colon starts the code block. Indentation shows which lines belong inside it."
    ),
    Lesson(
        title: "Comparisons",
        category: "Making decisions",
        explanation: "Comparison operators check how two values relate. The result is either True or False.",
        example: "age = 18\nprint(age == 18)  # True\nprint(age != 18)  # False\nprint(age >= 18)  # True",
        takeaway: "Use == to compare values. A single = assigns a value to a variable."
    ),
    Lesson(
        title: "Lists",
        category: "Collections",
        explanation: "A list stores several values in order. Each item has a position, and counting starts at 0.",
        example: "games = ['Mario', 'Kirby', 'WoW']\nprint(games[0])\ngames.append('Stardew Valley')",
        takeaway: "Use square brackets for a list. append() adds an item to the end."
    ),
    Lesson(
        title: "For loops",
        category: "Repeating code",
        explanation: "A for loop runs the same indented code once for each item in a collection.",
        example: "names = ['Pip', 'Moss', 'Pebble']\n\nfor name in names:\n    print(name)",
        takeaway: "The loop variable (name) holds the current item each time through the loop."
    ),
    Lesson(
        title: "While loops",
        category: "Repeating code",
        explanation: "A while loop repeats as long as its condition stays true. Make sure the loop can eventually stop.",
        example: "count = 1\n\nwhile count <= 3:\n    print(count)\n    count += 1",
        takeaway: "If the condition never becomes false, the loop will keep running."
    ),
    Lesson(
        title: "Functions",
        category: "Reusable code",
        explanation: "A function is a named set of steps. Define it once, then call it whenever you need those steps.",
        example: "def greet(name):\n    print('Hello, ' + name)\n\ngreet('Clara')",
        takeaway: "def starts a function definition. The indented lines are the function's steps."
    ),
    Lesson(
        title: "Dictionaries",
        category: "Collections",
        explanation: "A dictionary stores related information as key and value pairs. Each key points to its value.",
        example: "player = {\n    'name': 'Clara',\n    'level': 5,\n}\n\nprint(player['name'])",
        takeaway: "Use a key in square brackets to look up its value."
    ),
]

@main
struct PythonCheatSheetApp: App {
    var body: some Scene {
        WindowGroup {
            CheatSheetHomeView()
                .frame(minWidth: 760, minHeight: 520)
        }
        .windowResizability(.automatic)
    }
}

private struct CheatSheetHomeView: View {
    @StateObject private var model = CheatSheetViewModel()

    private var filteredLessons: [Lesson] {
        guard !model.searchText.isEmpty else { return lessons }
        return lessons.filter {
            $0.title.localizedCaseInsensitiveContains(model.searchText)
                || $0.category.localizedCaseInsensitiveContains(model.searchText)
                || $0.explanation.localizedCaseInsensitiveContains(model.searchText)
                || $0.example.localizedCaseInsensitiveContains(model.searchText)
        }
    }

    private var selectedLesson: Lesson? {
        filteredLessons.first { $0.id == model.selectedLessonID } ?? filteredLessons.first
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $model.selectedLessonID) {
                ForEach(groupedLessons) { group in
                    Section(group.category) {
                        ForEach(group.lessons) { lesson in
                            Text(lesson.title)
                                .tag(lesson.id)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Python Basics")
            .searchable(text: $model.searchText, prompt: "Search topics")
            .frame(minWidth: 220)
        } detail: {
            if let lesson = selectedLesson {
                LessonDetailView(lesson: lesson, copied: $model.copied) {
                    copyExample(lesson.example)
                }
                .id(lesson.id)
            } else {
                ContentUnavailableView.search(text: model.searchText)
            }
        }
        .onChange(of: model.searchText) { _, _ in
            if let first = filteredLessons.first {
                model.selectedLessonID = first.id
            }
        }
    }

    private var groupedLessons: [LessonGroup] {
        let categories = Array(NSOrderedSet(array: filteredLessons.map(\.category))) as? [String] ?? []
        return categories.map { category in
            LessonGroup(category: category, lessons: filteredLessons.filter { $0.category == category })
        }
    }

    private func copyExample(_ example: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(example, forType: .string)
        model.copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            model.copied = false
        }
    }
}

private final class CheatSheetViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedLessonID = lessons.first?.id
    @Published var copied = false
}

private struct LessonDetailView: View {
    let lesson: Lesson
    @Binding var copied: Bool
    let copyExample: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(lesson.category.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)

                    Text(lesson.title)
                        .font(.largeTitle.weight(.bold))

                    Text(lesson.explanation)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Label("Example", systemImage: "chevron.left.forwardslash.chevron.right")
                            .font(.headline)
                        Spacer()
                        Button(action: copyExample) {
                            Label(copied ? "Copied" : "Copy code", systemImage: copied ? "checkmark" : "doc.on.doc")
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(14)

                    Divider()

                    Text(lesson.example)
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(18)
                }
                .background(.quaternary.opacity(0.55), in: RoundedRectangle(cornerRadius: 12))

                Label {
                    Text(lesson.takeaway)
                        .fixedSize(horizontal: false, vertical: true)
                } icon: {
                    Image(systemName: "lightbulb")
                        .foregroundStyle(.yellow)
                }
                .font(.body)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.background, in: RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.quaternary))
            }
            .frame(maxWidth: 720, alignment: .leading)
            .padding(32)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
