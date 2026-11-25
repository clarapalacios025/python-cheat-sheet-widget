import SwiftUI
import WidgetKit

private struct CheatSheetEntry: TimelineEntry {
    let date: Date
    let topic: String
    let explanation: String
    let example: String
}

private struct DailyTopic {
    let title: String
    let explanation: String
    let example: String
}

private let dailyTopics = [
    DailyTopic(title: "Variables", explanation: "Give a name to a value so you can use it later.", example: "name = 'Clara'"),
    DailyTopic(title: "Print", explanation: "Show a message or value on the screen.", example: "print('Hello!')"),
    DailyTopic(title: "If statements", explanation: "Run code only when a condition is true.", example: "if score > 10:\n    print('You win!')"),
    DailyTopic(title: "Lists", explanation: "Keep several values together in order.", example: "games = ['Mario', 'Kirby']"),
    DailyTopic(title: "For loops", explanation: "Repeat code once for each item in a collection.", example: "for game in games:\n    print(game)"),
    DailyTopic(title: "Functions", explanation: "Save reusable steps under a name.", example: "def greet(name):\n    print('Hi, ' + name)"),
    DailyTopic(title: "Dictionaries", explanation: "Store related values using keys and values.", example: "player = {'name': 'Clara'}"),
]

private struct CheatSheetProvider: TimelineProvider {
    func placeholder(in context: Context) -> CheatSheetEntry {
        entry(for: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (CheatSheetEntry) -> Void) {
        completion(entry(for: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CheatSheetEntry>) -> Void) {
        let now = Date.now
        let today = Calendar.current.startOfDay(for: now)
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? now.addingTimeInterval(86_400)
        completion(Timeline(entries: [entry(for: now)], policy: .after(nextDay)))
    }

    private func entry(for date: Date) -> CheatSheetEntry {
        let day = Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 1
        let topic = dailyTopics[(day - 1) % dailyTopics.count]
        return CheatSheetEntry(
            date: date,
            topic: topic.title,
            explanation: topic.explanation,
            example: topic.example
        )
    }
}

private struct CheatSheetWidgetView: View {
    let entry: CheatSheetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("PYTHON OF THE DAY", systemImage: "sparkle")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.secondary)

            Text(entry.topic)
                .font(.title3.weight(.bold))
                .lineLimit(1)

            Text(entry.explanation)
                .font(.caption)
                .lineLimit(2)

            Text(entry.example)
                .font(.system(.caption, design: .monospaced))
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
                .lineLimit(2)

            Spacer(minLength: 0)
        }
        .padding()
        .containerBackground(.background, for: .widget)
    }
}

@main
struct PythonCheatSheetWidget: Widget {
    let kind = "PythonCheatSheetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CheatSheetProvider()) { entry in
            CheatSheetWidgetView(entry: entry)
        }
        .configurationDisplayName("Python Cheat Sheet")
        .description("Learn one Python idea each day on your Mac.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

