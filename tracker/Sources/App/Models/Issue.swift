import Vapor
import FluentPostgreSQL

final class Issue : UUIDModel, TimestampModel {
    static var name: String = "issues"
    
    enum Status : String, PostgreSQLEnum {
        case open
        case closed
        case wontFix
    }

    var id: UUID?
    var createdAt: Date?
    var updatedAt: Date?
    
    var subject: String
    var body: String
    var status: Status = .open
    
    var projectId: Int
}

extension Issue : Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(self, on: conn) { builder in
            
            builder.uuidPrimaryKey()
            
            builder.field(for: \.subject, type: .varchar(500))
            builder.field(for: \.body)
            builder.field(for: \.status, type: .varchar(100))
            
            builder.timestampFields()
            
        }
    }

}
