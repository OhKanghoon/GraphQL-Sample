//
//  SearchBarNode.swift
//  GraphQL-Sample
//
//  Created by Kanghoon on 11/01/2019.
//  Copyright © 2019 Vingle. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class SearchBarNode: ASDisplayNode {
    
    var searchBar: UISearchBar? {
        return self.view as? UISearchBar
    }
    
    override init() {
        super.init()
        self.setViewBlock {
            let bar: UISearchBar = .init(frame: .zero)
            bar.placeholder = "Search"
            bar.searchBarStyle = .minimal
            return bar
        }
        self.style.height = .init(unit: .points, value: 44)
        self.backgroundColor = .white
    }
}
