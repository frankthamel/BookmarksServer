import Fluent
import Vapor

struct StatusDTO: Content {
    var id: UUID?
    var title: String
    var colorHash: String
    
    func toModel() -> Status {
        let status = Status()
        status.id = self.id
        status.title = self.title
        status.colorHash = self.colorHash
        return status
    }
} 