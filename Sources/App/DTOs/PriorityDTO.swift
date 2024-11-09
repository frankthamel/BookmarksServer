import Fluent
import Vapor

struct PriorityDTO: Content {
    var id: UUID?
    var title: String
    var colorHash: String
    var iconName: String
    
    func toModel() -> Priority {
        let priority = Priority()
        priority.id = self.id
        priority.title = self.title
        priority.colorHash = self.colorHash
        priority.iconName = self.iconName
        return priority
    }
} 