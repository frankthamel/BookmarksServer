import Fluent
import struct Foundation.UUID
import Foundation

final class Bookmark: Model, @unchecked Sendable {
    static let schema = "bookmarks"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: FieldKeys.Bookmark.v1.title)
    var title: String
    
    @Field(key: FieldKeys.Bookmark.v1.link)
    var link: String
    
    @OptionalField(key: FieldKeys.Bookmark.v1.dueDate)
    var dueDate: Date?
    
    @Timestamp(key: FieldKeys.Bookmark.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.Bookmark.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    // Relationships
    @Parent(key: FieldKeys.Bookmark.v1.projectId)
    var project: Project
    
    @Parent(key: FieldKeys.Bookmark.v1.statusId)
    var status: Status
    
    @Parent(key: FieldKeys.Bookmark.v1.priorityId)
    var priority: Priority
    
    @Parent(key: FieldKeys.Bookmark.v1.typeId)
    var bookmarkType: BookmarkType
    
    @Siblings(through: BookmarkTagPivot.self, from: \.$bookmark, to: \.$tag)
    var tags: [Tag]
    
    @Children(for: \.$bookmark)
    var notes: [Note]

    init() { }

    init(
        id: UUID? = nil,
        title: String,
        link: String,
        dueDate: Date? = nil,
        projectId: UUID,
        statusId: UUID,
        priorityId: UUID,
        typeId: UUID
    ) {
        self.id = id
        self.title = title
        self.link = link
        self.dueDate = dueDate
        self.$project.id = projectId
        self.$status.id = statusId
        self.$priority.id = priorityId
        self.$bookmarkType.id = typeId
    }
    
    func toDTO() -> BookmarkDTO {
        BookmarkDTO(
            id: self.id,
            title: self.title,
            link: self.link,
            dueDate: self.dueDate,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt,
            projectId: self.$project.id,
            statusId: self.$status.id,
            priorityId: self.$priority.id,
            typeId: self.$bookmarkType.id,
            tagIds: self.tags.map { $0.id! },
            noteIds: self.notes.map { $0.id! },
            status: self.status.toDTO(),
            priority: self.priority.toDTO(),
            bookmarkType: self.bookmarkType.toDTO(),
            tags: self.tags.map { $0.toDTO()},
            notes: self.notes.map { $0.toDTO()}
        )
    }
}

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
