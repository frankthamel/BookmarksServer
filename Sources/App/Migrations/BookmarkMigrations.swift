import Fluent

enum BookmarkMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("bookmarks")
                .id()
                .field(FieldKeys.Bookmark.v1.title, .string, .required)
                .field(FieldKeys.Bookmark.v1.link, .string, .required)
                .field(FieldKeys.Bookmark.v1.dueDate, .datetime)
                .field(FieldKeys.Bookmark.v1.createdAt, .datetime)
                .field(FieldKeys.Bookmark.v1.updatedAt, .datetime)
                .field(FieldKeys.Bookmark.v1.projectId, .uuid)
                .field(FieldKeys.Bookmark.v1.statusId, .uuid)
                .field(FieldKeys.Bookmark.v1.priorityId, .uuid)
                .field(FieldKeys.Bookmark.v1.typeId, .uuid)
                .foreignKey(FieldKeys.Bookmark.v1.projectId, references: "projects", "id")
                .foreignKey(FieldKeys.Bookmark.v1.statusId, references: "statuses", "id")
                .foreignKey(FieldKeys.Bookmark.v1.priorityId, references: "priorities", "id")
                .foreignKey(FieldKeys.Bookmark.v1.typeId, references: "bookmarkTypes", "id")
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("bookmarks").delete()
        }
    }
}

