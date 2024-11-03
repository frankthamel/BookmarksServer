# BookmarksServer

**BookmarksServer** is a simple RESTful API backend built with the [Vapor](https://vapor.codes) framework in Swift. This server allows you to manage bookmarks, including functionalities for creating, reading, updating, deleting, and marking bookmarks as favorite. This project is built purely for learning purposes and does not include any user authentication; all endpoints are public.

## Features

- **Fetch all bookmarks**: Retrieve a list of all stored bookmarks.
- **Fetch a single bookmark**: Retrieve details for a specific bookmark.
- **Create a new bookmark**: Add a new bookmark to the collection.
- **Update a bookmark**: Modify an existing bookmark.
- **Delete a bookmark**: Remove a bookmark from the collection.
- **Favorite a bookmark**: Mark a bookmark as a favorite.

## Requirements

- Swift 5.5+
- Vapor 4
- PostgreSQL

## Installation

1. **Clone the Repository**

```bash
git clone https://github.com/frankthamel/BookmarksServer.git
cd BookmarksServer
```

2. **Run the Server**

```bash
vapor serve
```