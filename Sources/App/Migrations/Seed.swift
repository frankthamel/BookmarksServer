//
//  File.swift
//  BookmarksServer
//
//  Created by Frank Thamel on 11/11/2024.
//

import Fluent

struct Seed: AsyncMigration {
    
    func prepare(on db: Database) async throws {
        // Create Projects
        let projects = [
            Project(title: "Swift", iconName: "swift-icon", colorHash: "#F05138"),
            Project(title: "SwiftUI", iconName: "swiftui-icon", colorHash: "#007AFF"),
        ]
        try await projects.create(on: db)
        
        // Create Bookmark Types
        let bookmarkTypes = [
            BookmarkType(title: "Read", colorHash: "#FF9500", iconName: "book-icon"),
            BookmarkType(title: "Watch", colorHash: "#FF2D55", iconName: "video-icon"),
            BookmarkType(title: "Listen", colorHash: "#5856D6", iconName: "audio-icon")
        ]
        try await bookmarkTypes.create(on: db)
        
        // Create Tags
        let tags = [
            Tag(title: "Swift", colorHash: "#F05138", projectId: projects[0].id!),
            Tag(title: "SwiftUI", colorHash: "#007AFF", projectId: projects[1].id!),
            Tag(title: "GCD", colorHash: "#FF9500", projectId: projects[0].id!),
            Tag(title: "CI/CD", colorHash: "#34C759", projectId: projects[0].id!),
            Tag(title: "GraphQL", colorHash: "#FF2D55", projectId: projects[0].id!),
            Tag(title: "Animation", colorHash: "#5856D6", projectId: projects[0].id!)
        ]
        
        for tag in tags {
            try await tag.create(on: db)
        }
        
        
        // Create Priorities
        let priorities = [
            Priority(title: "Low", colorHash: "#FFCC00", iconName: "low-icon"),
            Priority(title: "Medium", colorHash: "#FF9500", iconName: "medium-icon"),
            Priority(title: "High", colorHash: "#FF3B30", iconName: "high-icon")
        ]
        try await priorities.create(on: db)
        
        // Create Statuses
        let statuses = [
            Status(title: "To Do", colorHash: "#FFCC00"),
            Status(title: "In Progress", colorHash: "#FF9500"),
            Status(title: "Done", colorHash: "#34C759")
        ]
        try await statuses.create(on: db)
        
        // Create Bookmarks with sample notes
        let bookmarks = [
            Bookmark(title: "Swift Documentation", link: "https://swift.org/documentation/", projectId: projects[0].id!, statusId: statuses[0].id!, priorityId: priorities[0].id!, typeId: bookmarkTypes[0].id!),
            Bookmark(title: "SwiftUI Tutorials", link: "https://developer.apple.com/tutorials/swiftui", projectId: projects[1].id!, statusId: statuses[1].id!, priorityId: priorities[1].id!, typeId: bookmarkTypes[1].id!),
            Bookmark(title: "iOS 17 Features Overview", link: "https://developer.apple.com/ios/", projectId: projects[0].id!, statusId: statuses[2].id!, priorityId: priorities[2].id!, typeId: bookmarkTypes[2].id!),
            Bookmark(title: "Xcode Tips and Tricks", link: "https://developer.apple.com/xcode/", projectId: projects[0].id!, statusId: statuses[0].id!, priorityId: priorities[0].id!, typeId: bookmarkTypes[0].id!),
            Bookmark(title: "Concurrency in Swift", link: "https://swift.org/documentation/concurrency/", projectId: projects[0].id!, statusId: statuses[1].id!, priorityId: priorities[1].id!, typeId: bookmarkTypes[1].id!),
            Bookmark(title: "SwiftUI Animations", link: "https://developer.apple.com/documentation/swiftui/animation", projectId: projects[1].id!, statusId: statuses[2].id!, priorityId: priorities[2].id!, typeId: bookmarkTypes[2].id!),
            Bookmark(title: "GraphQL with Swift", link: "https://graphql.org/swift/", projectId: projects[0].id!, statusId: statuses[0].id!, priorityId: priorities[0].id!, typeId: bookmarkTypes[0].id!),
            Bookmark(title: "CI/CD for iOS Apps", link: "https://developer.apple.com/documentation/ci_cd", projectId: projects[0].id!, statusId: statuses[1].id!, priorityId: priorities[1].id!, typeId: bookmarkTypes[1].id!),
            Bookmark(title: "GCD in Depth", link: "https://developer.apple.com/documentation/dispatch", projectId: projects[0].id!, statusId: statuses[2].id!, priorityId: priorities[2].id!, typeId: bookmarkTypes[2].id!),
            Bookmark(title: "Advanced SwiftUI", link: "https://developer.apple.com/documentation/swiftui", projectId: projects[1].id!, statusId: statuses[0].id!, priorityId: priorities[0].id!, typeId: bookmarkTypes[0].id!)
        ]
        
        for bookmark in bookmarks {
            try await bookmark.create(on: db)
        }
        
        
        // Create sample notes for bookmarks
        let notes = [
            Note(text: "Check out the new concurrency features", bookmarkId: bookmarks[0].id!),
            Note(text: "Explore the new layout system", bookmarkId: bookmarks[1].id!),
            Note(text: "Review the latest iOS 17 features", bookmarkId: bookmarks[2].id!),
            Note(text: "Learn Xcode shortcuts", bookmarkId: bookmarks[3].id!),
            Note(text: "Understand Swift concurrency", bookmarkId: bookmarks[4].id!),
            Note(text: "Implement SwiftUI animations", bookmarkId: bookmarks[5].id!),
            Note(text: "Integrate GraphQL in Swift", bookmarkId: bookmarks[6].id!),
            Note(text: "Set up CI/CD pipelines", bookmarkId: bookmarks[7].id!),
            Note(text: "Master GCD techniques", bookmarkId: bookmarks[8].id!),
            Note(text: "Deep dive into SwiftUI", bookmarkId: bookmarks[9].id!)
        ]
        
        try await notes.create(on: db)
        
        // Associate tags with bookmarks
        for bookmark in bookmarks {
            let tag = tags.randomElement()!
            try await bookmark.$tags.attach(tag, on: db)
        }
    }
    
    func revert(on db: Database) async throws {
        // Delete all seeded data
        try await Note.query(on: db).delete()
        try await Bookmark.query(on: db).delete()
        try await Status.query(on: db).delete()
        try await Priority.query(on: db).delete()
        try await Tag.query(on: db).delete()
        try await BookmarkType.query(on: db).delete()
        try await Project.query(on: db).delete()
    }
}
