import Foundation

struct EntryItem: Identifiable, Codable, Equatable {
    var id: UUID
    var dateAdded: Date
    var bodyArea: String
    var severity: String
    var healingDay: String
    var notes: String

    init(id: UUID = UUID(), dateAdded: Date = Date(), bodyArea: String, severity: String, healingDay: String, notes: String) {
        self.id = id
        self.dateAdded = dateAdded
        self.bodyArea = bodyArea
        self.severity = severity
        self.healingDay = healingDay
        self.notes = notes
    }

    static func blank() -> EntryItem {
        EntryItem(bodyArea: "", severity: "", healingDay: "", notes: "")
    }
}
