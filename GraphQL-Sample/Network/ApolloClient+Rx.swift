//
//  ApolloClient+Rx.swift
//  GraphQL-Sample
//
//  Created by Kanghoon on 14/01/2019.
//  Copyright © 2019 Vingle. All rights reserved.
//

import Foundation
import Apollo
import RxSwift

enum ApolloError: Error {
    case gqlErrors([GraphQLError])
}

extension ApolloClient: ReactiveCompatible { }

extension Reactive where Base: ApolloClient {
    
    public func fetch<Query: GraphQLQuery>(query: Query,
                                           cachePolicy: CachePolicy = .returnCacheDataElseFetch,
                                           queue: DispatchQueue = DispatchQueue.main) -> Observable<Query.Data> {
        return Observable.create { observer in
            let cancellable = self.base
                .fetch(query: query,
                       cachePolicy: cachePolicy,
                       queue: queue,
                       resultHandler: { (result, error) in
                        if let error = error {
                            observer.onError(error)
                        } else if let errors = result?.errors {
                            observer.onError(ApolloError.gqlErrors(errors))
                        } else if let data = result?.data {
                            observer.onNext(data)
                            observer.onCompleted()
                        } else {
                            observer.onCompleted()
                        }
                })
            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
    
    public func watch<Query: GraphQLQuery>(query: Query,
                                           cachePolicy: CachePolicy = .returnCacheDataElseFetch,
                                           queue: DispatchQueue = DispatchQueue.main) -> Observable<Query.Data> {
        return Observable.create { observer in
            let cancellable = self.base
                .watch(query: query,
                       cachePolicy: cachePolicy,
                       queue: queue,
                       resultHandler: { (result, error) in
                        if let error = error {
                            observer.onError(error)
                        } else if let errors = result?.errors {
                            observer.onError(ApolloError.gqlErrors(errors))
                        } else if let data = result?.data {
                            observer.onNext(data)
                            observer.onCompleted()
                        }
                })
            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
    
    public func perform<Mutation: GraphQLMutation>(mutation: Mutation,
                                                   queue: DispatchQueue = DispatchQueue.main) -> Observable<Mutation.Data> {
        return Observable.create { observer in
            let cancellable = self.base
                .perform(mutation: mutation,
                         queue: queue,
                         resultHandler: { (result, error) in
                            if let error = error {
                                observer.onError(error)
                            } else if let errors = result?.errors {
                                observer.onError(ApolloError.gqlErrors(errors))
                            } else if let data = result?.data {
                                observer.onNext(data)
                                observer.onCompleted()
                            } else {
                                observer.onCompleted()
                            }
                })
            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
}


