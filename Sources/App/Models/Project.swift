import Fluent
import struct Foundation.UUID
import Foundation

final class Project: Model, @unchecked Sendable {
    static let schema = "projects"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.Project.v1.title)
    var title: String
    
    @Field(key: FieldKeys.Project.v1.iconName)
    var iconName: String
    
    @Field(key: FieldKeys.Project.v1.colorHash)
    var colorHash: String
    
    @Timestamp(key: FieldKeys.Project.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.Project.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    // Relationships
    @Children(for: \.$project)
    var bookmarks: [Bookmark]
    
    @Children(for: \.$project)
    var tags: [Tag]
    
    init() { }
    
    init(
        id: UUID? = nil,
        title: String,
        iconName: String,
        colorHash: String
    ) {
        self.id = id
        self.title = title
        self.iconName = iconName
        self.colorHash = colorHash
    }
    
    func toDTO() -> ProjectDTO {
        ProjectDTO(
            id: self.id,
            title: self.title,
            iconName: self.iconName,
            colorHash: self.colorHash,
            bookmarks: bookmarks.map { $0.toDTO() },
            tags: tags.map { $0.toDTO() }
        )
    }
}
