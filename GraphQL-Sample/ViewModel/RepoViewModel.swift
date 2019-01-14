//
//  RepoViewModel.swift
//  GraphQL-Sample
//
//  Created by Kanghoon on 10/01/2019.
//  Copyright © 2019 Vingle. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

class RepoViewModel {
    
    typealias Repository = SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository
    
    struct Const {
        static let count = 10
    }
    
    let searchRelay = PublishRelay<SearchRequest>()
    
    let since = BehaviorRelay<String?>(value: nil)
    let repoList = BehaviorRelay<List<Repository>?>(value: nil)
    
    let disposeBag = DisposeBag()
    
    init() {
        searchRelay
            .distinctUntilChanged()
            .flatMapLatest { GithubService.shared.searchRepositories(request: $0) }
            .scan(nil) { (old, new) -> List<Repository> in
                guard let old = old,
                    old.query == new.query else { return new }
                return .init(query: new.query,
                             items: old.items + new.items,
                             after: new.after)
            }
            .bind(to: repoList)
            .disposed(by: disposeBag)
    }
}
