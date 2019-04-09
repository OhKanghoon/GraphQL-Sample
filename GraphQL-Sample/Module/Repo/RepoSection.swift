//
//  RepoSection.swift
//  GraphQL-Sample
//
//  Created by Kanghoon on 09/04/2019.
//  Copyright © 2019 Vingle. All rights reserved.
//

import Foundation
import Differentiator

enum RepoSection {
    case repo([RepoSectionItem])
}

extension RepoSection: AnimatableSectionModelType {
    var identity: String {
        switch self {
        case .repo: return "repo"
        }
    }
    
    var items: [RepoSectionItem] {
        switch self {
        case .repo(let items):
            return items
        }
    }
    
    init(original: RepoSection, items: [RepoSectionItem]) {
        switch original {
        case .repo: self = .repo(items)
        }
    }
}

enum RepoSectionItem {
    case repo(Repository)
}

extension RepoSectionItem: IdentifiableType {
    
    var identity: String {
        switch self {
        case .repo(let repo): return repo.id
        }
    }
}

extension RepoSectionItem: Equatable {
    
    static func == (lhs: RepoSectionItem, rhs: RepoSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
