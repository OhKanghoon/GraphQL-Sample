//
//  VApollo.swift
//  GraphQL-Sample
//
//  Created by Kanghoon on 11/01/2019.
//  Copyright © 2019 Vingle. All rights reserved.
//

import Foundation
import RxSwift
import Apollo
import RxApolloClient

class VApollo {
    
    static let shared = VApollo()
    
    let client: ApolloClient
    
    init() {
        let configuration: URLSessionConfiguration = .default
        // TODO: Add your token
//        configuration.httpAdditionalHeaders = ["Authorization": ""]
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        let url = URL(string: "https://api.github.com/graphql")!
        client = ApolloClient(networkTransport: HTTPNetworkTransport(url: url,
                                                                     configuration: configuration))
    }
    
    func fetch<Query: GraphQLQuery>(query: Query,
                                    cachePolicy: CachePolicy = .returnCacheDataElseFetch,
                                    queue: DispatchQueue = DispatchQueue.main) -> Observable<Query.Data> {
        return self.client.rx
            .fetch(query: query,
                   cachePolicy: cachePolicy,
                   queue: queue)
    }
    
    func watch<Query: GraphQLQuery>(query: Query,
                                    cachePolicy: CachePolicy = .returnCacheDataElseFetch,
                                    queue: DispatchQueue = DispatchQueue.main) -> Observable<Query.Data> {
        return self.client.rx
            .watch(query: query,
                   cachePolicy: cachePolicy,
                   queue: queue)
    }
    
    func perform<Mutation: GraphQLMutation>(mutation: Mutation,
                                            queue: DispatchQueue = DispatchQueue.main) -> Observable<Mutation.Data> {
        return self.client.rx
            .perform(mutation: mutation,
                     queue: queue)
    }
}
