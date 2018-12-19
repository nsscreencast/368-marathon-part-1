import Routing
import Vapor
import FluentPostgreSQL

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get("_setup") { req -> Future<String> in
        let project = Project(title: "test project", description: "test description")
        return project.create(on: req).map { project in
            return "Created project \(project.id!)"
        }
    }
}
