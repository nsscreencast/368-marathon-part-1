import Foundation
import Files

let args = CommandLine.arguments

guard args.count == 3 else {
    print("USAGE: marathon run AddMigration <command> <name>")
    exit(1)
}

let command = args[1]
let name = args[2]

let validCommands = ["migration", "model"]

guard validCommands.contains(command) else {
    print("Unrecognized command \(command). Valid commands are: \(validCommands)")
    exit(1)
}

let folder = Folder.current
// for debugging in Xcode, use a hard coded path
// let folder = try Folder(path: "/Users/ben/Desktop/marathon/tracker")
let appFolder = try folder.subfolder(atPath: "Sources/App")

let migrationsFolder = try appFolder.createSubfolderIfNeeded(withName: "Migrations")

let migrationFiles = migrationsFolder.files

var maxNumber: Int = 0
for file in migrationFiles {
    let scanner = Scanner(string: file.nameExcludingExtension)
    var number: Int = 0
    if scanner.scanInt(&number) && number > maxNumber {
        maxNumber = number
    }
}

func modelMigrationTemplate(_ name: String) -> String {
    return """
    import Vapor
    import FluentPostgreSQL
    
    extension \(name) : Migration {
        static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
            return PostgreSQLDatabase.create(self, on: conn) { builder in
                builder.uuidPrimaryKey()
    
                builder.timestampFields()
    
            }
        }
    }
    
    """
}

func plainMigrationTemplate(_ name: String) -> String {
    return """
    import Vapor
    import FluentPostgreSQL
    
    struct \(name) : PostgreSQLMigration {
        static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
    
        }
        
        static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
    
        }
    }
    
    """
}

let migrationNumber = maxNumber + 1
let suffix = command == "model" ? "_model" : ""
let filename = String(format: "%03d_%@%@.swift", migrationNumber, name, suffix)

let template = (command == "model" ? modelMigrationTemplate : plainMigrationTemplate)(name)
print(template)
