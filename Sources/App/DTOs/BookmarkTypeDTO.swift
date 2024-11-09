import Fluent
import Vapor

struct BookmarkTypeDTO: Content {
    var id: UUID?
    var title: String
    var colorHash: String
    var iconName: String
    
    func toModel() -> BookmarkType {
        let bookmarkType = BookmarkType()
        bookmarkType.id = self.id
        bookmarkType.title = self.title
        bookmarkType.colorHash = self.colorHash
        bookmarkType.iconName = self.iconName
        return bookmarkType
    }
} 
