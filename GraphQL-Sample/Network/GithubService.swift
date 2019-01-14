//
//  GithubService.swift
//  GraphQL-Sample
//
//  Created by Kanghoon on 14/01/2019.
//  Copyright © 2019 Vingle. All rights reserved.
//

import Foundation
import RxSwift

class GithubService {
    
    typealias Repository = SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository
    
    static let shared = GithubService()
    
    func searchRepositories(request: SearchRequest) -> Single<List<Repository>> {
        let query = request.query
        let after = request.after
        return VApollo.shared
            .fetch(query: SearchRepositoriesQuery(query: query,
                                                  first: 10,
                                                  after: after))
            .map { List<Repository>(query: query,
                                    items: $0.search.edges?.compactMap { $0?.node?.asRepository } ?? [],
                                    after: $0.search.pageInfo.endCursor) }
    }
}
