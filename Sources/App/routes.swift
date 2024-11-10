import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: BookmarksController())
    try app.register(collection: ProjectsController())
    try app.register(collection: TagsController())
    try app.register(collection: NotesController())
    try app.register(collection: PrioritiesController())
    try app.register(collection: StatusesController())
    try app.register(collection: BookmarkTypesController())
}
