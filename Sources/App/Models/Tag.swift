import Fluent
import struct Foundation.UUID
import Foundation

final class Tag: Model, @unchecked Sendable {
    static let schema = "tags"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.Tag.v1.title)
    var title: String
    
    @Field(key: FieldKeys.Tag.v1.colorHash)
    var colorHash: String
    
    @Timestamp(key: FieldKeys.Tag.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.Tag.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    // Relationships
    @Parent(key: FieldKeys.Tag.v1.projectId)
    var project: Project
    
    @Siblings(through: BookmarkTagPivot.self, from: \.$tag, to: \.$bookmark)
    var bookmarks: [Bookmark]
    
    init() { }
    
    init(
        id: UUID? = nil,
        title: String,
        colorHash: String,
        projectId: UUID
    ) {
        self.id = id
        self.title = title
        self.colorHash = colorHash
        self.$project.id = projectId
    }
    
    func toDTO() -> TagDTO {
        TagDTO(
            id: self.id,
            title: self.title,
            colorHash: self.colorHash,
            projectId: self.$project.id
        )
    }
}
