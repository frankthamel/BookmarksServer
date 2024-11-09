import Fluent
import Vapor

struct TagDTO: Content {
    var id: UUID?
    var title: String
    var colorHash: String
    var projectId: UUID
    
    // Nested relationship (for responses)
    var project: ProjectDTO?
    
    func toModel() -> Tag {
        let tag = Tag()
        tag.id = self.id
        tag.title = self.title
        tag.colorHash = self.colorHash
        tag.$project.id = self.projectId
        return tag
    }
} 