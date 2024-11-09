import Fluent

enum PriorityMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("priorities")
                .id()
                .field(FieldKeys.Priority.v1.title, .string, .required)
                .field(FieldKeys.Priority.v1.colorHash, .string, .required)
                .field(FieldKeys.Priority.v1.iconName, .string, .required)
                .field(FieldKeys.Priority.v1.createdAt, .datetime)
                .field(FieldKeys.Priority.v1.updatedAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("priorities").delete()
        }
    }
}
