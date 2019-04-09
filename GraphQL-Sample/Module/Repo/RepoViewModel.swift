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
    
    // Input
    let searchRelay = PublishRelay<SearchRequest>()
    
    // Output
    let sections = BehaviorRelay<[RepoSection]?>(value: nil)
    let repoList = BehaviorRelay<List<Repository>?>(value: nil)
    
    let disposeBag = DisposeBag()
    
    init(githubService: GithubServiceType) {
        searchRelay
            .distinctUntilChanged()
            .flatMapLatest { githubService.searchRepositories(request: $0)
                .catchError { _ in return .never() }
            }
            .scan(nil) { (old, new) -> List<Repository> in
                guard let old = old,
                    old.query == new.query else { return new }
                return .init(query: new.query,
                             items: old.items + new.items,
                             after: new.after)
            }
            .bind(to: repoList)
            .disposed(by: disposeBag)
        
        repoList.filterNil()
            .map { $0.items.map(RepoSectionItem.repo) }
            .map { [RepoSection.repo($0)] }
            .bind(to: sections)
            .disposed(by: disposeBag)
    }
}
