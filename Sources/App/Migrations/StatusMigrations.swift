import Fluent

enum StatusMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("statuses")
                .id()
                .field(FieldKeys.Status.v1.title, .string, .required)
                .field(FieldKeys.Status.v1.colorHash, .string, .required)
                .field(FieldKeys.Status.v1.createdAt, .datetime)
                .field(FieldKeys.Status.v1.updatedAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("statuses").delete()
        }
    }
}
