//import Fluent
//import Vapor
//
//struct PrioritiesController: RouteCollection {
//    func boot(routes: RoutesBuilder) throws {
//        let priorities = routes.grouped("priorities")
//        
//        priorities.get(use: self.index)
//        priorities.post(use: self.create)
//        priorities.group(":priorityID") { priority in
//            priority.get(use: self.getOne)
//            priority.put(use: self.update)
//            priority.delete(use: self.delete)
//        }
//        
//        priorities.post("bulk", use: bulkCreate)
//        priorities.put("bulk", use: self.bulkUpdate)
//        priorities.delete("bulk", use: self.bulkDelete)
//    }
//
//    @Sendable
//    func index(req: Request) async throws -> [PriorityDTO] {
//        try await Priority.query(on: req.db).all().map { try await $0.toDTO() }
//    }
//
//    @Sendable
//    func getOne(req: Request) async throws -> PriorityDTO {
//        guard let priority = try await Priority.find(req.parameters.get("priorityID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        return try await priority.toDTO()
//    }
//
//    @Sendable
//    func create(req: Request) async throws -> PriorityDTO {
//        let priority = try req.content.decode(PriorityDTO.self).toModel()
//        try await priority.save(on: req.db)
//        return try await priority.toDTO()
//    }
//
//    @Sendable
//    func update(req: Request) async throws -> PriorityDTO {
//        guard let priority = try await Priority.find(req.parameters.get("priorityID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        
//        let updatedPriority = try req.content.decode(PriorityDTO.self)
//        priority.title = updatedPriority.title
//        priority.colorHash = updatedPriority.colorHash
//        priority.iconName = updatedPriority.iconName
//        
//        try await priority.save(on: req.db)
//        return try await priority.toDTO()
//    }
//
//    @Sendable
//    func delete(req: Request) async throws -> HTTPStatus {
//        guard let priority = try await Priority.find(req.parameters.get("priorityID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        try await priority.delete(on: req.db)
//        return .noContent
//    }
//
//    @Sendable
//    func bulkCreate(req: Request) async throws -> [PriorityDTO] {
//        let dtos = try req.content.decode([PriorityDTO].self)
//        let priorities = dtos.map { $0.toModel() }
//        try await priorities.create(on: req.db)
//        return try await priorities.map { try await $0.toDTO() }
//    }
//
//    @Sendable
//    func bulkUpdate(req: Request) async throws -> [PriorityDTO] {
//        let updates = try req.content.decode([PriorityDTO].self)
//        var updatedPriorities: [Priority] = []
//        
//        for update in updates {
//            guard let priority = try await Priority.find(update.id, on: req.db) else {
//                continue
//            }
//            priority.title = update.title
//            priority.colorHash = update.colorHash
//            priority.iconName = update.iconName
//            try await priority.save(on: req.db)
//            updatedPriorities.append(priority)
//        }
//        
//        return try await updatedPriorities.map { $0.toDTO() }
//    }
//
//    @Sendable
//    func bulkDelete(req: Request) async throws -> HTTPStatus {
//        let ids = try req.content.decode([UUID].self)
//        try await Priority.query(on: req.db)
//            .filter(\.$id ~~ ids)
//            .delete()
//        return .noContent
//    }
//} 
