import Fluent
import Vapor

struct BookmarkDTO: Content {
    var id: UUID?
    var title: String
    var link: String
    var dueDate: Date?
    var createdAt: Date?
    var updatedAt: Date?
    
    // Relationships
    var projectId: UUID
    var statusId: UUID
    var priorityId: UUID
    var typeId: UUID
    var tagIds: [UUID]
    var noteIds: [UUID]
    
    // Nested relationships (for responses)
    var project: ProjectDTO?
    var status: StatusDTO?
    var priority: PriorityDTO?
    var bookmarkType: BookmarkTypeDTO?
    var tags: [TagDTO]?
    var notes: [NoteDTO]?

    func toModel() -> Bookmark {
        let bookmark = Bookmark()
        bookmark.id = self.id
        bookmark.title = self.title
        bookmark.link = self.link
        bookmark.dueDate = self.dueDate
        bookmark.$project.id = self.projectId
        bookmark.$status.id = self.statusId
        bookmark.$priority.id = self.priorityId
        bookmark.$bookmarkType.id = self.typeId
        return bookmark
    }
} 
