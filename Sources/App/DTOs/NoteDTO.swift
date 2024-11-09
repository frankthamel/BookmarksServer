import Fluent
import Vapor

struct NoteDTO: Content {
    var id: UUID?
    var text: String
    var highlightColor: String?
    var bookmarkId: UUID
    
    // Nested relationship (for responses)
    var bookmark: BookmarkDTO?
    
    func toModel() -> Note {
        let note = Note()
        note.id = self.id
        note.text = self.text
        note.highlightColor = self.highlightColor
        note.$bookmark.id = self.bookmarkId
        return note
    }
} 