import Fluent
import Vapor

struct TagsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tags = routes.grouped("tags")
        
        tags.get(use: self.index)
        tags.post(use: self.create)
        tags.group(":tagID") { tag in
            tag.get(use: self.getOne)
            tag.put(use: self.update)
            tag.delete(use: self.delete)
        }
        
        tags.post("bulk", use: self.bulkCreate)
        tags.put("bulk", use: self.bulkUpdate)
        tags.delete("bulk", use: self.bulkDelete)
    }

    @Sendable
    func index(req: Request) async throws -> [TagDTO] {
        try await Tag.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func getOne(req: Request) async throws -> TagDTO {
        guard let tag = try await Tag.find(req.parameters.get("tagID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return tag.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> TagDTO {
        let tag = try req.content.decode(TagDTO.self).toModel()
        try await tag.save(on: req.db)
        return tag.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> UpdateResponseDTO {
        guard let tag = try await Tag.find(req.parameters.get("tagID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedTag = try req.content.decode(TagDTO.self)
        tag.title = updatedTag.title
        tag.colorHash = updatedTag.colorHash
        tag.$project.id = updatedTag.projectId
        
        try await tag.save(on: req.db)
        return UpdateResponseDTO(id: tag.id!)
    }

    @Sendable
    func delete(req: Request) async throws -> DeleteResponseDTO {
        guard let tag = try await Tag.find(req.parameters.get("tagID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let tagID = tag.id!
        try await tag.delete(on: req.db)
        return DeleteResponseDTO(id: tagID)
    }

    @Sendable
    func bulkCreate(req: Request) async throws -> BulkCreateResponseDTO {
        let dtos = try req.content.decode([TagDTO].self)
        let tags = dtos.map { $0.toModel() }
        try await tags.create(on: req.db)
        let ids = tags.compactMap { $0.id }
        return BulkCreateResponseDTO(ids: ids)
    }

    @Sendable
    func bulkUpdate(req: Request) async throws -> BulkUpdateResponseDTO {
        let updates = try req.content.decode([TagDTO].self)
        var updatedTags: [Tag] = []
        
        for update in updates {
            guard let tag = try await Tag.find(update.id, on: req.db) else {
                continue
            }
            tag.title = update.title
            tag.colorHash = update.colorHash
            tag.$project.id = update.projectId
            try await tag.save(on: req.db)
            updatedTags.append(tag)
        }
        
        let ids = updatedTags.compactMap { $0.id }
        return BulkUpdateResponseDTO(ids: ids)
    }

    @Sendable
    func bulkDelete(req: Request) async throws -> BulkDeleteResponseDTO {
        let ids = try req.content.decode([UUID].self)
        try await Tag.query(on: req.db)
            .filter(\.$id ~~ ids)
            .delete()
        return BulkDeleteResponseDTO(ids: ids)
    }
} 
