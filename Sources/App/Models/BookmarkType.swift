import Fluent
import struct Foundation.UUID
import Foundation

final class BookmarkType: Model, @unchecked Sendable {
    static let schema = "bookmarkTypes"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.BookmarkType.v1.title)
    var title: String
    
    @Field(key: FieldKeys.BookmarkType.v1.colorHash)
    var colorHash: String
    
    @Field(key: FieldKeys.BookmarkType.v1.iconName)
    var iconName: String
    
    @Timestamp(key: FieldKeys.BookmarkType.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.BookmarkType.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    // Relationships
    @Children(for: \.$bookmarkType)
    var bookmarks: [Bookmark]
    
    init() { }
    
    init(
        id: UUID? = nil,
        title: String,
        colorHash: String,
        iconName: String
    ) {
        self.id = id
        self.title = title
        self.colorHash = colorHash
        self.iconName = iconName
    }
    
    func toDTO() -> BookmarkTypeDTO {
        return BookmarkTypeDTO(
            id: self.id,
            title: self.title,
            colorHash: self.colorHash,
            iconName: self.iconName
        )
    }
}
