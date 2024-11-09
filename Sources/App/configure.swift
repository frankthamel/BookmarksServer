import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add(CreateTodo())
    app.migrations.add(ProjectMigrations.v1())
    app.migrations.add(StatusMigrations.v1())
    app.migrations.add(PriorityMigrations.v1())
    app.migrations.add(TypeMigrations.v1())
    app.migrations.add(BookmarkMigrations.v1())
    app.migrations.add(NoteMigrations.v2())
    app.migrations.add(TagMigrations.v1())
    app.migrations.add(BookmarkTagPivotMigrations.v1())
    
    app.migrations.add(BookmarkTagPivotMigrations.v2())
    
    try await app.autoMigrate()
    
    // register routes
    try routes(app)
}
