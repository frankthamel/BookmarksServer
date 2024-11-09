import Vapor
import Fluent

enum FieldKeys {
    enum Bookmark {
        enum v1 {
            static var title: FieldKey { "title" }
            static var link: FieldKey { "link" }
            static var dueDate: FieldKey { "due_date" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var projectId: FieldKey { "project_id" }
            static var statusId: FieldKey { "status_id" }
            static var priorityId: FieldKey { "priority_id" }
            static var typeId: FieldKey { "type_id" }
        }
    }
    
    enum Tag {
        enum v1 {
            static var title: FieldKey { "title" }
            static var colorHash: FieldKey { "color_hash" }
            static var projectId: FieldKey { "project_id" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
        }
    }
    
    enum Project {
        enum v1 {
            static var title: FieldKey { "title" }
            static var iconName: FieldKey { "icon_name" }
            static var colorHash: FieldKey { "color_hash" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
        }
    }
    
    enum Note {
        enum v1 {
            static var text: FieldKey { "text" }
            static var highlightColor: FieldKey { "highlight_color" }
            static var bookmarkId: FieldKey { "bookmark_id" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
        }
    }
    
    enum Status {
        enum v1 {
            static var title: FieldKey { "title" }
            static var colorHash: FieldKey { "color_hash" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
        }
    }
    
    enum Priority {
        enum v1 {
            static var title: FieldKey { "title" }
            static var colorHash: FieldKey { "color_hash" }
            static var iconName: FieldKey { "icon_name" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
        }
    }
    
    enum BookmarkType {
        enum v1 {
            static var title: FieldKey { "title" }
            static var colorHash: FieldKey { "color_hash" }
            static var iconName: FieldKey { "icon_name" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
        }
    }
    
    enum BookmarkTagPivot {
        enum v1 {
            static var bookmarkId: FieldKey { "bookmark_id" }
            static var tagId: FieldKey { "tag_id" }
        }
    }
} 
