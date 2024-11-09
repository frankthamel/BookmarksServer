//import Fluent
//import Vapor
//
//struct StatusesController: RouteCollection {
//    func boot(routes: RoutesBuilder) throws {
//        let statuses = routes.grouped("statuses")
//        
//        statuses.get(use: self.index)
//        statuses.post(use: self.create)
//        statuses.group(":statusID") { status in
//            status.get(use: self.getOne)
//            status.put(use: self.update)
//            status.delete(use: self.delete)
//        }
//        
//        statuses.post("bulk", use: bulkCreate)
//        statuses.put("bulk", use: self.bulkUpdate)
//        statuses.delete("bulk", use: self.bulkDelete)
//    }
//
//    @Sendable
//    func index(req: Request) async throws -> [StatusDTO] {
//        try await Status.query(on: req.db).all().map { try await $0.toDTO() }
//    }
//
//    @Sendable
//    func getOne(req: Request) async throws -> StatusDTO {
//        guard let status = try await Status.find(req.parameters.get("statusID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        return try await status.toDTO()
//    }
//
//    @Sendable
//    func create(req: Request) async throws -> StatusDTO {
//        let status = try req.content.decode(StatusDTO.self).toModel()
//        try await status.save(on: req.db)
//        return try await status.toDTO()
//    }
//
//    @Sendable
//    func update(req: Request) async throws -> StatusDTO {
//        guard let status = try await Status.find(req.parameters.get("statusID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        
//        let updatedStatus = try req.content.decode(StatusDTO.self)
//        status.title = updatedStatus.title
//        status.colorHash = updatedStatus.colorHash
//        
//        try await status.save(on: req.db)
//        return try await status.toDTO()
//    }
//
//    @Sendable
//    func delete(req: Request) async throws -> HTTPStatus {
//        guard let status = try await Status.find(req.parameters.get("statusID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        try await status.delete(on: req.db)
//        return .noContent
//    }
//
//    @Sendable
//    func bulkCreate(req: Request) async throws -> [StatusDTO] {
//        let dtos = try req.content.decode([StatusDTO].self)
//        let statuses = dtos.map { $0.toModel() }
//        try await statuses.create(on: req.db)
//        return try await statuses.map { try await $0.toDTO() }
//    }
//
//    @Sendable
//    func bulkUpdate(req: Request) async throws -> [StatusDTO] {
//        let updates = try req.content.decode([StatusDTO].self)
//        var updatedStatuses: [Status] = []
//        
//        for update in updates {
//            guard let status = try await Status.find(update.id, on: req.db) else {
//                continue
//            }
//            status.title = update.title
//            status.colorHash = update.colorHash
//            try await status.save(on: req.db)
//            updatedStatuses.append(status)
//        }
//        
//        return try await updatedStatuses.map { try await $0.toDTO() }
//    }
//
//    @Sendable
//    func bulkDelete(req: Request) async throws -> HTTPStatus {
//        let ids = try req.content.decode([UUID].self)
//        try await Status.query(on: req.db)
//            .filter(\.$id ~~ ids)
//            .delete()
//        return .noContent
//    }
//} 
