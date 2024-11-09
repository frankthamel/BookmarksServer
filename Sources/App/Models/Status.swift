import Fluent
import struct Foundation.UUID
import Foundation

final class Status: Model, @unchecked Sendable {
    static let schema = "statuses"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.Status.v1.title)
    var title: String
    
    @Field(key: FieldKeys.Status.v1.colorHash)
    var colorHash: String
    
    @Timestamp(key: FieldKeys.Status.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.Status.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    // Relationships
    @Children(for: \.$status)
    var bookmarks: [Bookmark]
    
    init() { }
    
    init(
        id: UUID? = nil,
        title: String,
        colorHash: String
    ) {
        self.id = id
        self.title = title
        self.colorHash = colorHash
    }
    
    func toDTO() -> StatusDTO {
        return StatusDTO(
            id: self.id,
            title: self.title,
            colorHash: self.colorHash
        )
    }
}