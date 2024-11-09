import Fluent
import Vapor

struct ProjectDTO: Content {
    var id: UUID?
    var title: String
    var iconName: String
    var colorHash: String
    
    // Nested relationships (for responses)
    var bookmarks: [BookmarkDTO]?
    var tags: [TagDTO]?
    
    func toModel() -> Project {
        let project = Project()
        project.id = self.id
        project.title = self.title
        project.iconName = self.iconName
        project.colorHash = self.colorHash
        return project
    }
} 