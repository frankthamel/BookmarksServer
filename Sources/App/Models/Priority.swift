import Fluent
import struct Foundation.UUID
import Foundation

final class Priority: Model, @unchecked Sendable {
    static let schema = "priorities"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.Priority.v1.title)
    var title: String
    
    @Field(key: FieldKeys.Priority.v1.colorHash)
    var colorHash: String
    
    @Field(key: FieldKeys.Priority.v1.iconName)
    var iconName: String
    
    @Timestamp(key: FieldKeys.Priority.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.Priority.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    // Relationships
    @Children(for: \.$priority)
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
    
    func toDTO() -> PriorityDTO {
        return PriorityDTO(
            id: self.id,
            title: self.title,
            colorHash: self.colorHash,
            iconName: self.iconName
        )
    }
}