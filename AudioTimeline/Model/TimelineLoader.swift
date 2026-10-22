import Foundation

/// A timeline loaded from disk, tagged with the file it came from.
struct LoadedTimeline: Identifiable, Hashable {
    var fileName: String
    var file: TimelineFile

    var id: String { fileName }
}

enum TimelineLoader {
    /// Decodes a single timeline from raw JSON data.
    static func decode(_ data: Data) throws -> TimelineFile {
        try JSONDecoder().decode(TimelineFile.self, from: data)
    }

    /// Loads every `*.json` timeline bundled with the app, sorted by file name.
    /// Files that fail to decode are skipped and reported in `failures`.
    static func loadBundled(from bundle: Bundle = .main) -> (timelines: [LoadedTimeline], failures: [String: Error]) {
        let urls = bundle.urls(forResourcesWithExtension: "json", subdirectory: nil) ?? []
        var timelines: [LoadedTimeline] = []
        var failures: [String: Error] = [:]
        for url in urls.sorted(by: { $0.lastPathComponent < $1.lastPathComponent }) {
            let name = url.deletingPathExtension().lastPathComponent
            do {
                let file = try decode(Data(contentsOf: url))
                timelines.append(LoadedTimeline(fileName: name, file: file))
            } catch {
                failures[name] = error
            }
        }
        return (timelines, failures)
    }
}
