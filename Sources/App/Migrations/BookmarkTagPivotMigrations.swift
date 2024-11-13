import Fluent

enum BookmarkTagPivotMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("bookmark_tag_pivot")
                .id()
                .field(FieldKeys.BookmarkTagPivot.v1.bookmarkId, .uuid, .required, .references("bookmarks", "id", onDelete: .cascade))
                .field(FieldKeys.BookmarkTagPivot.v1.tagId, .uuid, .required, .references("tags", "id", onDelete: .cascade))
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("bookmark_tag_pivot").delete()
        }
    }
}
