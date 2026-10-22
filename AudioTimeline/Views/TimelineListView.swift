import SwiftUI

/// Root screen: lists the bundled timelines and drills into their periods and events.
struct TimelineListView: View {
    private let loaded = TimelineLoader.loadBundled()

    var body: some View {
        NavigationStack {
            List {
                ForEach(loaded.timelines) { timeline in
                    NavigationLink(value: timeline) {
                        VStack(alignment: .leading) {
                            Text(timeline.file.displayTitle).font(.headline)
                            Text(timeline.fileName).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
                if !loaded.failures.isEmpty {
                    Section("Failed to load") {
                        ForEach(loaded.failures.keys.sorted(), id: \.self) { name in
                            Text(name).foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Timelines")
            .navigationDestination(for: LoadedTimeline.self) { timeline in
                TimelineDetailView(timeline: timeline)
            }
        }
    }
}

/// Shows a timeline's periods, subdivisions, and events as nested sections.
struct TimelineDetailView: View {
    let timeline: LoadedTimeline

    var body: some View {
        List {
            ForEach(timeline.file.timeline, id: \.self) { period in
                Section {
                    ForEach(period.subdivisions ?? [], id: \.self) { subdivision in
                        DisclosureGroup {
                            ForEach(subdivision.events ?? [], id: \.self) { event in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(event.name).font(.subheadline.bold())
                                    Text(event.time.formatted).font(.caption).foregroundStyle(.secondary)
                                    Text(event.description).font(.caption)
                                }
                            }
                        } label: {
                            VStack(alignment: .leading) {
                                Text(subdivision.name)
                                Text("\(subdivision.startTime.formatted) – \(subdivision.endTime.formatted)")
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("\(period.period) · \(period.category)")
                }
            }
        }
        .navigationTitle(timeline.file.displayTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension TimePoint {
    /// Short display string, e.g. "44 BCE", "312 CE", "4600 Ma".
    var formatted: String {
        let number = value.formatted(.number.grouping(.never))
        switch unit {
        case "year":
            return value < 0 ? "\((-value).formatted(.number.grouping(.never))) BCE" : "\(number) CE"
        case "million_years_ago":
            return "\(number) Ma"
        default:
            return "\(number) \(unit)"
        }
    }
}

#Preview {
    TimelineListView()
}
