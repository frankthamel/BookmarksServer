//import Fluent
//import Vapor
//
//struct TagsController: RouteCollection {
//    func boot(routes: RoutesBuilder) throws {
//        let tags = routes.grouped("tags")
//        
//        tags.get(use: self.index)
//        tags.post(use: self.create)
//        tags.group(":tagID") { tag in
//            tag.get(use: self.getOne)
//            tag.put(use: self.update)
//            tag.delete(use: self.delete)
//        }
//        
//        tags.post("bulk", use: bulkCreate)
//        tags.put("bulk", use: self.bulkUpdate)
//        tags.delete("bulk", use: self.bulkDelete)
//    }
//
//    @Sendable
//    func index(req: Request) async throws -> [TagDTO] {
//        try await Tag.query(on: req.db).all().map { try await $0.toDTO() }
//    }
//
//    @Sendable
//    func getOne(req: Request) async throws -> TagDTO {
//        guard let tag = try await Tag.find(req.parameters.get("tagID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        return try await tag.toDTO()
//    }
//
//    @Sendable
//    func create(req: Request) async throws -> TagDTO {
//        let tag = try req.content.decode(TagDTO.self).toModel()
//        try await tag.save(on: req.db)
//        return try await tag.toDTO()
//    }
//
//    @Sendable
//    func update(req: Request) async throws -> TagDTO {
//        guard let tag = try await Tag.find(req.parameters.get("tagID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        
//        let updatedTag = try req.content.decode(TagDTO.self)
//        tag.title = updatedTag.title
//        tag.colorHash = updatedTag.colorHash
//        tag.$project.id = updatedTag.projectId
//        
//        try await tag.save(on: req.db)
//        return try await tag.toDTO()
//    }
//
//    @Sendable
//    func delete(req: Request) async throws -> HTTPStatus {
//        guard let tag = try await Tag.find(req.parameters.get("tagID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        try await tag.delete(on: req.db)
//        return .noContent
//    }
//
//    @Sendable
//    func bulkCreate(req: Request) async throws -> [TagDTO] {
//        let dtos = try req.content.decode([TagDTO].self)
//        let tags = dtos.map { $0.toModel() }
//        try await tags.create(on: req.db)
//        return try await tags.map { try await $0.toDTO() }
//    }
//
//    @Sendable
//    func bulkUpdate(req: Request) async throws -> [TagDTO] {
//        let updates = try req.content.decode([TagDTO].self)
//        var updatedTags: [Tag] = []
//        
//        for update in updates {
//            guard let tag = try await Tag.find(update.id, on: req.db) else {
//                continue
//            }
//            tag.title = update.title
//            tag.colorHash = update.colorHash
//            tag.$project.id = update.projectId
//            try await tag.save(on: req.db)
//            updatedTags.append(tag)
//        }
//        
//        return try await updatedTags.map { try await $0.toDTO() }
//    }
//
//    @Sendable
//    func bulkDelete(req: Request) async throws -> HTTPStatus {
//        let ids = try req.content.decode([UUID].self)
//        try await Tag.query(on: req.db)
//            .filter(\.$id ~~ ids)
//            .delete()
//        return .noContent
//    }
//} 
