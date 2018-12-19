import Vapor
import FluentPostgreSQL

final class User : UUIDModel, TimestampModel {
    static var name: String = "users"
    
    var id: UUID?
    
    var createdAt: Date?
    var updatedAt: Date?
    
}
