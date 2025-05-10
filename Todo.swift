import Foundation

enum Priority: String, Codable, CaseIterable {
    case low = "Düşük"
    case medium = "Orta"
    case high = "Yüksek"
}

enum Category: String, Codable, CaseIterable {
    case personal = "Kişisel"
    case work = "İş"
    case shopping = "Alışveriş"
    case health = "Sağlık"
    case other = "Diğer"
}

struct Todo: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var priority: Priority
    var category: Category
    var dueDate: Date?
    var notes: String?
    
    init(title: String,
         isCompleted: Bool = false,
         priority: Priority = .medium,
         category: Category = .personal,
         dueDate: Date? = nil,
         notes: String? = nil) {
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = Date()
        self.priority = priority
        self.category = category
        self.dueDate = dueDate
        self.notes = notes
    }
} 
