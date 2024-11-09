import Fluent
import Vapor

struct BookmarksController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let bookmarks = routes.grouped("bookmarks")
        
        // Single item operations
        bookmarks.get(use: self.index)
        bookmarks.post(use: self.create)
        bookmarks.group(":bookmarkID") { bookmark in
            bookmark.get(use: self.getOne)
            bookmark.put(use: self.update)
            bookmark.delete(use: self.delete)
        }
        
        // Bulk operations
        bookmarks.post("bulk", use: self.bulkCreate)
        bookmarks.put("bulk", use: self.bulkUpdate)
        bookmarks.delete("bulk", use: self.bulkDelete)
    }
    
    @Sendable
    func index(req: Request) async throws -> [BookmarkDTO] {
        let data = try await Bookmark.query(on: req.db)
            .with(\.$project)
            .with(\.$tags)
            .with(\.$notes)
            .with(\.$status)
            .with(\.$priority)
            .with(\.$bookmarkType)
            .all()
        return data.map { $0.toDTO() }
    }
    
    @Sendable
    func getOne(req: Request) async throws -> BookmarkDTO {
        guard let bookmark = try await Bookmark
            .find(req.parameters.get("bookmarkID"), on: req.db)
        else {
            throw Abort(.notFound)
        }
        
        let data = try await Bookmark.query(on: req.db)
            .filter(\.$id == bookmark.id ?? UUID())
            .with(\.$project)
            .with(\.$tags)
            .with(\.$notes)
            .with(\.$status)
            .with(\.$priority)
            .with(\.$bookmarkType)
            .first()
        
        guard let response = data?.toDTO() else {
            throw Abort(.notFound)
        }
        
        return response
    }
    
    @Sendable
    func create(req: Request) async throws -> BookmarkDTO {
        let bookmarkDTO = try req.content.decode(BookmarkDTO.self)
        let bookmark = bookmarkDTO.toModel()
        try await bookmark.create(on: req.db)
        
        if let noteDTOs = bookmarkDTO.notes {
            var noteModels: [Note] = []
            
            for noteDTO in noteDTOs {
                var mutableNoteDTO = noteDTO
                mutableNoteDTO.bookmarkId = bookmark.id ?? UUID()
                noteModels.append(mutableNoteDTO.toModel())
            }
            
            try await noteModels.create(on: req.db)
        }
        
        // Fetch the newly created bookmark with its relationships
        guard let createdBookmark = try await Bookmark.query(on: req.db)
            .filter(\.$id == bookmark.id!)
            .with(\.$project)
            .with(\.$tags)
            .with(\.$notes)
            .with(\.$status)
            .with(\.$priority)
            .with(\.$bookmarkType)
            .first()
        else {
            throw Abort(.notFound)
        }
        
        return createdBookmark.toDTO()
    }
    
    @Sendable
    func update(req: Request) async throws -> UpdateResponseDTO {
        guard let bookmark = try await Bookmark.find(req.parameters.get("bookmarkID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedBookmark = try req.content.decode(BookmarkDTO.self)
        bookmark.title = updatedBookmark.title
        bookmark.link = updatedBookmark.link
        // Update other fields as needed
        
        try await bookmark.save(on: req.db)
        return UpdateResponseDTO(id: bookmark.id!)
    }
    
    @Sendable
    func delete(req: Request) async throws -> DeleteResponseDTO {
        guard let bookmark = try await Bookmark.find(req.parameters.get("bookmarkID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let bookmarkID = bookmark.id!
        try await bookmark.delete(on: req.db)
        return DeleteResponseDTO(id: bookmarkID)
    }
    
    @Sendable
    func bulkCreate(req: Request) async throws -> BulkCreateResponseDTO {
        let dtos = try req.content.decode([BookmarkDTO].self)
        var bookmarks: [Bookmark] = []
        var noteModels: [Note] = []

        for dto in dtos {
            let bookmark = dto.toModel()
            try await bookmark.create(on: req.db)
            
            bookmarks.append(bookmark)
            
            if let noteDTOs = dto.notes {
                for noteDTO in noteDTOs {
                    var mutableNoteDTO = noteDTO
                    mutableNoteDTO.bookmarkId = bookmark.id ?? UUID()
                    noteModels.append(mutableNoteDTO.toModel())
                }
            }
        }
        
        try await noteModels.create(on: req.db)

        let ids = bookmarks.compactMap { $0.id }
        return BulkCreateResponseDTO(ids: ids)
    }
    
    @Sendable
    func bulkUpdate(req: Request) async throws -> BulkUpdateResponseDTO {
        let updates = try req.content.decode([BookmarkDTO].self)
        var updatedBookmarks: [Bookmark] = []
        
        for update in updates {
            guard let bookmark = try await Bookmark.find(update.id, on: req.db) else {
                continue
            }
            bookmark.title = update.title
            bookmark.link = update.link
            // Update other fields as needed
            try await bookmark.save(on: req.db)
            updatedBookmarks.append(bookmark)
        }
        
        let ids = updatedBookmarks.compactMap { $0.id }
        return BulkUpdateResponseDTO(ids: ids)
    }
    
    @Sendable
    func bulkDelete(req: Request) async throws -> BulkDeleteResponseDTO {
        let ids = try req.content.decode([UUID].self)
        try await Bookmark.query(on: req.db)
            .filter(\.$id ~~ ids)
            .delete(force: true)
        return BulkDeleteResponseDTO(ids: ids)
    }
}
