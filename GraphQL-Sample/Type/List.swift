//
//  List.swift
//  GraphQL-Sample
//
//  Created by Kanghoon on 14/01/2019.
//  Copyright © 2019 Vingle. All rights reserved.
//

import Foundation

struct List<Element> {
    
    let query: String
    var items: [Element]
    var after: String?
    
    init(query: String, items: [Element], after: String? = nil) {
        self.query = query
        self.items = items
        self.after = after
    }
}
