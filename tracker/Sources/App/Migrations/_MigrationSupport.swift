/* This file is generated. Do not edit. */
import Vapor
import FluentPostgreSQL

extension MigrationConfig {
    mutating func runAutoMigrations() {
        add(migration: EnableUUIDExtension.self, database: .psql)
        add(migration: User.self, database: .psql)
        add(model: User.self, database: .psql)        
    }
}
