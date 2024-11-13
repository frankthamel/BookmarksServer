import Fluent

enum NoteMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("notes")
                .id()
                .field(FieldKeys.Note.v1.text, .string, .required)
                .field(FieldKeys.Note.v1.highlightColor, .string)
                .field(FieldKeys.Note.v1.bookmarkId, .uuid)
                .foreignKey(FieldKeys.Note.v1.bookmarkId, references: "bookmarks", "id", onDelete: .cascade)
                .field(FieldKeys.Note.v1.createdAt, .datetime)
                .field(FieldKeys.Note.v1.updatedAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("notes").delete()
        }
    }
}
