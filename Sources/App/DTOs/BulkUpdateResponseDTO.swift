//
//  BulkUpdateResponseDTO.swift
//  BookmarksServer
//
//  Created by Frank Thamel on 09/11/2024.
//

import Vapor

struct BulkUpdateResponseDTO: Content {
    let ids: [UUID]
}
