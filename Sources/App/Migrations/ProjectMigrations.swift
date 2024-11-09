import Fluent
    
enum ProjectMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("projects")
                .id()
                .field(FieldKeys.Project.v1.title, .string, .required)
                .field(FieldKeys.Project.v1.iconName, .string, .required)
                .field(FieldKeys.Project.v1.colorHash, .string, .required)
                .field(FieldKeys.Project.v1.createdAt, .datetime)
                .field(FieldKeys.Project.v1.updatedAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("projects").delete()
        }
    }
}
