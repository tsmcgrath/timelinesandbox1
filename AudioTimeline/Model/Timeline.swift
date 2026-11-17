import Foundation

// Swift mirror of the timeline JSON format documented in docs/schema/timeline_schema_doc_v1.1.md.
// Keep these types in sync with the schema doc when either changes.

/// A whole timeline file: optional metadata plus one or more major periods.
struct TimelineFile: Codable, Hashable {
    /// Required by schema v1.1, but older sample files predate it.
    var metadata: TimelineMetadata?
    var timeline: [Period]
}

struct TimelineMetadata: Codable, Hashable {
    var id: String
    var title: String
    var source: String
    var author: String
    var generatedByAI: Bool
    var model: String?
    var dateCreated: String

    enum CodingKeys: String, CodingKey {
        case id, title, source, author, model
        case generatedByAI = "generated_by_ai"
        case dateCreated = "date_created"
    }
}

/// A point in time, e.g. `{ "unit": "year", "value": -44 }` or `{ "unit": "million_years_ago", "value": 4600 }`.
/// Units are left as raw strings; normalizing them is part of the distance-mapping feature.
struct TimePoint: Codable, Hashable {
    var unit: String
    var value: Double
}

struct Period: Codable, Hashable {
    var category: String
    var period: String
    var startTime: TimePoint
    var endTime: TimePoint
    var subdivisions: [Subdivision]?

    enum CodingKeys: String, CodingKey {
        case category, period, subdivisions
        case startTime = "start_time"
        case endTime = "end_time"
    }
}

struct Subdivision: Codable, Hashable {
    var name: String
    var startTime: TimePoint
    var endTime: TimePoint
    var events: [Event]?

    enum CodingKeys: String, CodingKey {
        case name, events
        case startTime = "start_time"
        case endTime = "end_time"
    }
}

struct Event: Codable, Hashable {
    var name: String
    var time: TimePoint
    var description: String
    /// 0.0 (least) to 1.0 (most important).
    var relativeImportance: Double?

    enum CodingKeys: String, CodingKey {
        case name, time, description
        case relativeImportance = "relative_importance"
    }
}

extension TimelineFile {
    /// Best human-readable name: metadata title, else the first period's name.
    var displayTitle: String {
        metadata?.title ?? timeline.first?.period ?? "Untitled Timeline"
    }
}
