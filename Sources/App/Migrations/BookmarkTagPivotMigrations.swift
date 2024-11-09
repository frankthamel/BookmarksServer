import Fluent

enum BookmarkTagPivotMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("bookmark_tag_pivot")
                .id()
                .field(FieldKeys.BookmarkTagPivot.v1.bookmarkId, .uuid, .required, .references("bookmarks", "id"))
                .field(FieldKeys.BookmarkTagPivot.v1.tagId, .uuid, .required, .references("tags", "id"))
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("bookmark_tag_pivot").delete()
        }
    }
    
    struct v2: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("bookmark_tag_pivot")
                .deleteField(FieldKeys.BookmarkTagPivot.v1.bookmarkId)
                .deleteField(FieldKeys.BookmarkTagPivot.v1.tagId)
                .field(FieldKeys.BookmarkTagPivot.v1.bookmarkId, .uuid, .references("bookmarks", "id", onDelete: .cascade))
                .field(FieldKeys.BookmarkTagPivot.v1.tagId, .uuid, .references("tags", "id", onDelete: .cascade))
                .update()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("bookmark_tag_pivot")
                .deleteField(FieldKeys.BookmarkTagPivot.v1.bookmarkId)
                .deleteField(FieldKeys.BookmarkTagPivot.v1.tagId)
                .field(FieldKeys.BookmarkTagPivot.v1.bookmarkId, .uuid, .required, .references("bookmarks", "id"))
                .field(FieldKeys.BookmarkTagPivot.v1.tagId, .uuid, .required, .references("tags", "id"))
                .update()
        }
    }
}
