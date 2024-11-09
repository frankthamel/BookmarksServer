import Fluent
    
enum TagMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("tags")
                .id()
                .field(FieldKeys.Tag.v1.title, .string, .required)
                .field(FieldKeys.Tag.v1.colorHash, .string, .required)
                .field(FieldKeys.Tag.v1.projectId, .uuid)
                .foreignKey(FieldKeys.Tag.v1.projectId, references: "projects", "id")
                .field(FieldKeys.Tag.v1.createdAt, .datetime)
                .field(FieldKeys.Tag.v1.updatedAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("tags").delete()
        }
    }
}
