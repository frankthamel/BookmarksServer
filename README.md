# BookmarksServer

**BookmarksServer** is a simple RESTful API backend built with the [Vapor](https://vapor.codes) framework in Swift. This server allows you to manage bookmarks, including functionalities for creating, reading, updating, deleting, and marking bookmarks as favorite. This project is built purely for learning purposes and does not include any user authentication; all endpoints are public.

## Features

- **Fetch all bookmarks**: Retrieve a paginated list of all stored bookmarks.
- **Fetch a single bookmark**: Retrieve details for a specific bookmark.
- **Create a new bookmark**: Add a new bookmark to the collection.
- **Update a bookmark**: Modify an existing bookmark.
- **Delete a bookmark**: Remove a bookmark from the collection.
- **Favorite a bookmark**: Mark a bookmark as a favorite.
- **Bulk operations**: Perform create, update, and delete operations on multiple bookmarks at once.
- **Manage tags**: Create, read, update, and delete tags associated with bookmarks.
- **Manage bookmark types**: Create, read, update, and delete bookmark types.
- **Manage projects**: Create, read, update, and delete projects associated with bookmarks.
- **Manage priorities**: Create, read, update, and delete priorities for bookmarks.
- **Manage notes**: Create, read, update, and delete notes attached to bookmarks.
- **Manage statuses**: Create, read, update, and delete statuses for bookmarks.
- **Pagination**: All list endpoints support pagination for efficient data retrieval.

## Requirements

- Swift 5.5+
- Vapor 4
- Docker

## Installation

1. **Clone the Repository**

```bash
git clone https://github.com/frankthamel/BookmarksServer.git
```

2. **Start the DB**

- Open a new terminal tab.
- cd BookmarksServer

```bash
docker compose up db
```

3. **Run the Server**

- Open a new terminal tab.
- cd BookmarksServer

```bash
vapor run
```
