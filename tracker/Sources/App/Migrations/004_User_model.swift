import Vapor
import FluentPostgreSQL

extension User : Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(self, on: conn) { builder in
            builder.uuidPrimaryKey()

            builder.timestampFields()

        }
    }
}
