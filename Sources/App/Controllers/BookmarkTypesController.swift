//import Fluent
//import Vapor
//
//struct BookmarkTypesController: RouteCollection {
//    func boot(routes: RoutesBuilder) throws {
//        let bookmarkTypes = routes.grouped("bookmarkTypes")
//        
//        bookmarkTypes.get(use: self.index)
//        bookmarkTypes.post(use: self.create)
//        bookmarkTypes.group(":typeID") { bookmarkType in
//            bookmarkType.get(use: self.getOne)
//            bookmarkType.put(use: self.update)
//            bookmarkType.delete(use: self.delete)
//        }
//        
//        bookmarkTypes.post("bulk", use: self.bulkCreate)
//        bookmarkTypes.put("bulk", use: self.bulkUpdate)
//        bookmarkTypes.delete("bulk", use: self.bulkDelete)
//    }
//
//    @Sendable
//    func index(req: Request) async throws -> [TypeDTO] {
//        try await BookmarkType.query(on: req.db).all().map { try await $0.toDTO() }
//    }
//
//    @Sendable
//    func getOne(req: Request) async throws -> TypeDTO {
//        guard let bookmarkType = try await BookmarkType.find(req.parameters.get("typeID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        return try await bookmarkType.toDTO()
//    }
//
//    @Sendable
//    func create(req: Request) async throws -> TypeDTO {
//        let bookmarkType = try req.content.decode(TypeDTO.self).toModel()
//        try await bookmarkType.save(on: req.db)
//        return try await bookmarkType.toDTO()
//    }
//
//    @Sendable
//    func update(req: Request) async throws -> TypeDTO {
//        guard let bookmarkType = try await BookmarkType.find(req.parameters.get("typeID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        
//        let updatedType = try req.content.decode(TypeDTO.self)
//        bookmarkType.title = updatedType.title
//        bookmarkType.colorHash = updatedType.colorHash
//        bookmarkType.iconName = updatedType.iconName
//        
//        try await bookmarkType.save(on: req.db)
//        return try await bookmarkType.toDTO()
//    }
//
//    @Sendable
//    func delete(req: Request) async throws -> HTTPStatus {
//        guard let bookmarkType = try await BookmarkType.find(req.parameters.get("typeID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        try await bookmarkType.delete(on: req.db)
//        return .noContent
//    }
//
//    @Sendable
//    func bulkCreate(req: Request) async throws -> [TypeDTO] {
//        let dtos = try req.content.decode([TypeDTO].self)
//        let bookmarkTypes = dtos.map { $0.toModel() }
//        try await bookmarkTypes.create(on: req.db)
//        return try await bookmarkTypes.map { try await $0.toDTO() }
//    }
//
//    @Sendable
//    func bulkUpdate(req: Request) async throws -> [TypeDTO] {
//        let updates = try req.content.decode([TypeDTO].self)
//        var updatedTypes: [BookmarkType] = []
//        
//        for update in updates {
//            guard let bookmarkType = try await BookmarkType.find(update.id, on: req.db) else {
//                continue
//            }
//            bookmarkType.title = update.title
//            bookmarkType.colorHash = update.colorHash
//            bookmarkType.iconName = update.iconName
//            try await bookmarkType.save(on: req.db)
//            updatedTypes.append(bookmarkType)
//        }
//        
//        return try await updatedTypes.map { try await $0.toDTO() }
//    }
//
//    @Sendable
//    func bulkDelete(req: Request) async throws -> HTTPStatus {
//        let ids = try req.content.decode([UUID].self)
//        try await BookmarkType.query(on: req.db)
//            .filter(\.$id ~~ ids)
//            .delete()
//        return .noContent
//    }
//} 
