import Fluent
import Vapor

struct ProjectsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let projects = routes.grouped("projects")
        
        projects.get(use: self.index)
        projects.post(use: self.create)
        projects.group(":projectID") { project in
            project.get(use: self.getOne)
            project.put(use: self.update)
            project.delete(use: self.delete)
        }
        
        projects.post("bulk", use: self.bulkCreate)
        projects.put("bulk", use: self.bulkUpdate)
        projects.delete("bulk", use: self.bulkDelete)
    }

    @Sendable
    func index(req: Request) async throws -> [ProjectDTO] {
        try await Project.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func getOne(req: Request) async throws -> ProjectDTO {
        guard let project = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return project.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> ProjectDTO {
        let project = try req.content.decode(ProjectDTO.self).toModel()
        try await project.save(on: req.db)
        return project.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> UpdateResponseDTO {
        guard let project = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedProject = try req.content.decode(ProjectDTO.self)
        project.title = updatedProject.title
        project.iconName = updatedProject.iconName
        project.colorHash = updatedProject.colorHash
        
        try await project.save(on: req.db)
        return UpdateResponseDTO(id: project.id!)
    }

    @Sendable
    func delete(req: Request) async throws -> DeleteResponseDTO {
        guard let project = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let projectID = project.id!
        try await project.delete(on: req.db)
        return DeleteResponseDTO(id: projectID)
    }

    @Sendable
    func bulkCreate(req: Request) async throws -> BulkCreateResponseDTO {
        let dtos = try req.content.decode([ProjectDTO].self)
        let projects = dtos.map { $0.toModel() }
        try await projects.create(on: req.db)
        let ids = projects.compactMap { $0.id }
        return BulkCreateResponseDTO(ids: ids)
    }

    @Sendable
    func bulkUpdate(req: Request) async throws -> BulkUpdateResponseDTO {
        let updates = try req.content.decode([ProjectDTO].self)
        var updatedProjects: [Project] = []
        
        for update in updates {
            guard let project = try await Project.find(update.id, on: req.db) else {
                continue
            }
            project.title = update.title
            project.iconName = update.iconName
            project.colorHash = update.colorHash
            try await project.save(on: req.db)
            updatedProjects.append(project)
        }
        
        let ids = updatedProjects.compactMap { $0.id }
        return BulkUpdateResponseDTO(ids: ids)
    }

    @Sendable
    func bulkDelete(req: Request) async throws -> BulkDeleteResponseDTO {
        let ids = try req.content.decode([UUID].self)
        try await Project.query(on: req.db)
            .filter(\.$id ~~ ids)
            .delete()
        return BulkDeleteResponseDTO(ids: ids)
    }
}
