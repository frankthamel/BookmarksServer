import Vapor

struct BulkCreateResponseDTO: Content {
    let ids: [UUID]
} 