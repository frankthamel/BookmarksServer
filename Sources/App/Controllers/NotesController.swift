import Fluent
import Vapor

struct NotesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let notes = routes.grouped("notes")
        
        notes.get(use: self.index)
        notes.post(use: self.create)
        notes.group(":noteID") { note in
            note.get(use: self.getOne)
            note.put(use: self.update)
            note.delete(use: self.delete)
        }
        
        notes.post("bulk", use: self.bulkCreate)
        notes.put("bulk", use: self.bulkUpdate)
        notes.delete("bulk", use: self.bulkDelete)
    }

    @Sendable
    func index(req: Request) async throws -> [NoteDTO] {
        try await Note.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func getOne(req: Request) async throws -> NoteDTO {
        guard let note = try await Note.find(req.parameters.get("noteID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return note.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> NoteDTO {
        let note = try req.content.decode(NoteDTO.self).toModel()
        try await note.save(on: req.db)
        return note.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> UpdateResponseDTO {
        guard let note = try await Note.find(req.parameters.get("noteID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedNote = try req.content.decode(NoteDTO.self)
        note.text = updatedNote.text
        note.highlightColor = updatedNote.highlightColor
        note.$bookmark.id = updatedNote.bookmarkId
        
        try await note.save(on: req.db)
        return UpdateResponseDTO(id: note.id!)
    }

    @Sendable
    func delete(req: Request) async throws -> DeleteResponseDTO {
        guard let note = try await Note.find(req.parameters.get("noteID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let noteID = note.id!
        try await note.delete(on: req.db)
        return DeleteResponseDTO(id: noteID)
    }

    @Sendable
    func bulkCreate(req: Request) async throws -> BulkCreateResponseDTO {
        let dtos = try req.content.decode([NoteDTO].self)
        let notes = dtos.map { $0.toModel() }
        try await notes.create(on: req.db)
        let ids = notes.compactMap { $0.id }
        return BulkCreateResponseDTO(ids: ids)
    }

    @Sendable
    func bulkUpdate(req: Request) async throws -> BulkUpdateResponseDTO {
        let updates = try req.content.decode([NoteDTO].self)
        var updatedNotes: [Note] = []
        
        for update in updates {
            guard let note = try await Note.find(update.id, on: req.db) else {
                continue
            }
            note.text = update.text
            note.highlightColor = update.highlightColor
            note.$bookmark.id = update.bookmarkId
            try await note.save(on: req.db)
            updatedNotes.append(note)
        }
        
        let ids = updatedNotes.compactMap { $0.id }
        return BulkUpdateResponseDTO(ids: ids)
    }

    @Sendable
    func bulkDelete(req: Request) async throws -> BulkDeleteResponseDTO {
        let ids = try req.content.decode([UUID].self)
        try await Note.query(on: req.db)
            .filter(\.$id ~~ ids)
            .delete()
        return BulkDeleteResponseDTO(ids: ids)
    }
} 
