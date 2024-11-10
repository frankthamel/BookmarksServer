import Fluent
import Vapor

struct BookmarkTypesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let bookmarkTypes = routes.grouped("bookmarkTypes")
        
        bookmarkTypes.get(use: self.index)
        bookmarkTypes.post(use: self.create)
        bookmarkTypes.group(":typeID") { bookmarkType in
            bookmarkType.get(use: self.getOne)
            bookmarkType.put(use: self.update)
            bookmarkType.delete(use: self.delete)
        }
        
        bookmarkTypes.post("bulk", use: self.bulkCreate)
        bookmarkTypes.put("bulk", use: self.bulkUpdate)
        bookmarkTypes.delete("bulk", use: self.bulkDelete)
    }

    @Sendable
    func index(req: Request) async throws -> [BookmarkTypeDTO] {
        try await BookmarkType.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func getOne(req: Request) async throws -> BookmarkTypeDTO {
        guard let bookmarkType = try await BookmarkType.find(req.parameters.get("typeID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return bookmarkType.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> BookmarkTypeDTO {
        let bookmarkType = try req.content.decode(BookmarkTypeDTO.self).toModel()
        try await bookmarkType.save(on: req.db)
        return bookmarkType.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> UpdateResponseDTO {
        guard let bookmarkType = try await BookmarkType.find(req.parameters.get("typeID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedType = try req.content.decode(BookmarkTypeDTO.self)
        bookmarkType.title = updatedType.title
        bookmarkType.colorHash = updatedType.colorHash
        bookmarkType.iconName = updatedType.iconName
        
        try await bookmarkType.save(on: req.db)
        return UpdateResponseDTO(id: bookmarkType.id!)
    }

    @Sendable
    func delete(req: Request) async throws -> DeleteResponseDTO {
        guard let bookmarkType = try await BookmarkType.find(req.parameters.get("typeID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let typeID = bookmarkType.id!
        try await bookmarkType.delete(on: req.db)
        return DeleteResponseDTO(id: typeID)
    }

    @Sendable
    func bulkCreate(req: Request) async throws -> BulkCreateResponseDTO {
        let dtos = try req.content.decode([BookmarkTypeDTO].self)
        let bookmarkTypes = dtos.map { $0.toModel() }
        try await bookmarkTypes.create(on: req.db)
        let ids = bookmarkTypes.compactMap { $0.id }
        return BulkCreateResponseDTO(ids: ids)
    }

    @Sendable
    func bulkUpdate(req: Request) async throws -> BulkUpdateResponseDTO {
        let updates = try req.content.decode([BookmarkTypeDTO].self)
        var updatedTypes: [BookmarkType] = []
        
        for update in updates {
            guard let bookmarkType = try await BookmarkType.find(update.id, on: req.db) else {
                continue
            }
            bookmarkType.title = update.title
            bookmarkType.colorHash = update.colorHash
            bookmarkType.iconName = update.iconName
            try await bookmarkType.save(on: req.db)
            updatedTypes.append(bookmarkType)
        }
        
        let ids = updatedTypes.compactMap { $0.id }
        return BulkUpdateResponseDTO(ids: ids)
    }

    @Sendable
    func bulkDelete(req: Request) async throws -> BulkDeleteResponseDTO {
        let ids = try req.content.decode([UUID].self)
        try await BookmarkType.query(on: req.db)
            .filter(\.$id ~~ ids)
            .delete()
        return BulkDeleteResponseDTO(ids: ids)
    }
}
