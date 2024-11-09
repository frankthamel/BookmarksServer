//
//  BulkDeleteResponseDTO.swift
//  BookmarksServer
//
//  Created by Frank Thamel on 09/11/2024.
//

import Vapor

struct BulkDeleteResponseDTO: Content {
    let ids: [UUID]
}
