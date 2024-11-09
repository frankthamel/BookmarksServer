import Fluent

enum TypeMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("bookmarkTypes")
                .id()
                .field(FieldKeys.BookmarkType.v1.title, .string, .required)
                .field(FieldKeys.BookmarkType.v1.colorHash, .string, .required)
                .field(FieldKeys.BookmarkType.v1.iconName, .string, .required)
                .field(FieldKeys.BookmarkType.v1.createdAt, .datetime)
                .field(FieldKeys.BookmarkType.v1.updatedAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("bookmarkTypes").delete()
        }
    }
}
