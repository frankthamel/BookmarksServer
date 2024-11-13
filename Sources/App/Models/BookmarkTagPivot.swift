import Fluent
import Foundation

// Pivot model for many-to-many relationship between Bookmark and Tag
final class BookmarkTagPivot: Model {
    static let schema = "bookmark_tag_pivot"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.BookmarkTagPivot.v1.bookmarkId)
    var bookmark: Bookmark
    
    @Parent(key: FieldKeys.BookmarkTagPivot.v1.tagId)
    var tag: Tag
    
    init() { }
    
    init(id: UUID? = nil, bookmark: Bookmark, tag: Tag) throws {
        self.id = id
        self.$bookmark.id = try bookmark.requireID()
        self.$tag.id = try tag.requireID()
    }
}
