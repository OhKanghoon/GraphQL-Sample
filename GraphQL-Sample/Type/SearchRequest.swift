//
//  SearchRequest.swift
//  GraphQL-Sample
//
//  Created by Kanghoon on 14/01/2019.
//  Copyright © 2019 Vingle. All rights reserved.
//

import Foundation

struct SearchRequest {
    let query: String
    let after: String?
    
    init(query: String, after: String? = nil) {
        self.query = query
        self.after = after
    }
}

extension SearchRequest: Equatable {
    static func == (lhs: SearchRequest, rhs: SearchRequest) -> Bool {
        guard lhs.query == rhs.query,
            lhs.after == rhs.after else { return false }
        return true
    }
}
