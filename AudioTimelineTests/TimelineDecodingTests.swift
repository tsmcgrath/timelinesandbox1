import Foundation
import Testing
@testable import AudioTimeline

struct TimelineDecodingTests {
    @Test func allBundledTimelinesDecode() {
        let loaded = TimelineLoader.loadBundled() // tests run hosted in the app, so .main is the app bundle
        #expect(loaded.failures.isEmpty, "Failed: \(loaded.failures)")
        #expect(loaded.timelines.count >= 3)
    }

    @Test func decodesMetadataAndOptionalFields() throws {
        let json = """
        {
          "metadata": {
            "id": "550e8400-e29b-41d4-a716-446655440000",
            "title": "Test",
            "author": "Tester",
            "source": "AI-generated",
            "generated_by_ai": true,
            "date_created": "2026-01-26"
          },
          "timeline": [{
            "category": "Historical",
            "period": "P",
            "start_time": { "unit": "year", "value": -44 },
            "end_time": { "unit": "year", "value": 14 },
            "subdivisions": [{
              "name": "S",
              "start_time": { "unit": "year", "value": -44 },
              "end_time": { "unit": "year", "value": 14 },
              "events": [{ "name": "E", "time": { "unit": "year", "value": -44 }, "description": "D", "relative_importance": 0.5 }]
            }]
          }]
        }
        """
        let file = try TimelineLoader.decode(Data(json.utf8))
        #expect(file.metadata?.generatedByAI == true)
        #expect(file.displayTitle == "Test")
        #expect(file.timeline[0].subdivisions?[0].events?[0].relativeImportance == 0.5)
        #expect(file.timeline[0].startTime.formatted == "44 BCE")
    }
}
