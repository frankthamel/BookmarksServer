import Fluent
import struct Foundation.UUID
import Foundation

final class Note: Model, @unchecked Sendable {
    static let schema = "notes"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.Note.v1.text)
    var text: String
    
    @OptionalField(key: FieldKeys.Note.v1.highlightColor)
    var highlightColor: String?
    
    @Timestamp(key: FieldKeys.Note.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.Note.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    // Relationships
    @Parent(key: FieldKeys.Note.v1.bookmarkId)
    var bookmark: Bookmark
    
    init() { }
    
    init(
        id: UUID? = nil,
        text: String,
        highlightColor: String? = nil,
        bookmarkId: UUID
    ) {
        self.id = id
        self.text = text
        self.highlightColor = highlightColor
        self.$bookmark.id = bookmarkId
    }
    
    func toDTO() -> NoteDTO {
        return NoteDTO(
            id: self.id,
            text: self.text,
            highlightColor: self.highlightColor,
            bookmarkId: self.$bookmark.id
        )
    }
}
