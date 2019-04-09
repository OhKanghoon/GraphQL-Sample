//
//  RepoViewController.swift
//  GraphQL-Sample
//
//  Created by Kanghoon on 10/01/2019.
//  Copyright © 2019 Vingle. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional
import AsyncDisplayKit
import RxDataSources_Texture

class RepoViewController: ASViewController<ASDisplayNode> {
    
    // MARK: - Properties
    
    lazy var searchBarNode = SearchBarNode()
    lazy var tableNode: ASTableNode = {
        let node = ASTableNode()
        node.style.flexGrow = 1.0
        node.style.flexShrink = 0.0
        node.leadingScreensForBatching = 2.5
        node.onDidLoad({ [weak self] _ in
            self?.tableNode.view.separatorStyle = .none
            self?.tableNode.view.alwaysBounceVertical = true
            self?.tableNode.view.keyboardDismissMode = .onDrag
        })
        return node
    }()
    
    let viewModel: RepoViewModel
    var batchContext: ASBatchContext?
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - Initialization
    
    init(viewModel: RepoViewModel) {
        self.viewModel = viewModel
        super.init(node: .init())
        self.node.automaticallyManagesSubnodes = true
        self.node.automaticallyRelayoutOnSafeAreaChanges = true
        self.node.layoutSpecBlock = { [weak self] (_, sizeRange) -> ASLayoutSpec in
            return self?.layoutSpecThatFits(sizeRange) ?? ASLayoutSpec()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rxState()
        rxAction()
    }
    
    // MARK: - Rx
    
    private func rxState() {
        let dataSource = RxASTableSectionedAnimatedDataSource<RepoSection>(
            configureCell: { (_, _, _, sectionItem) -> ASCellNode in
                switch sectionItem {
                case .repo(let repo):
                    return RepoCellNode(repo: repo)
                }
        })
        
        viewModel.sections
            .filterNil()
            .do(onNext: { [weak self] _ in
                self?.batchContext?.completeBatchFetching(true)
            })
            .bind(to: tableNode.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func rxAction() {
        searchBarNode.searchBar?
            .rx.text
            .orEmpty
            .filterEmpty()
            .distinctUntilChanged()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .map { SearchRequest(query: $0) }
            .bind(to: viewModel.searchRelay)
            .disposed(by: disposeBag)
        
        tableNode.rx.willBeginBatchFetch.asObservable()
            .withLatestFrom(viewModel.repoList) { ($0, $1) }
            .subscribe(onNext: { [weak self] context, repoList in
                guard let repoList = repoList,
                    repoList.after != nil else {
                        context.completeBatchFetching(true)
                        return
                }
                self?.batchContext = context
                self?.viewModel.searchRelay
                    .accept(SearchRequest(query: repoList.query,
                                          after: repoList.after))
            }).disposed(by: disposeBag)
    }
    
    // MARK: - LayoutSpec
    
    private func layoutSpecThatFits(_ constraintedSize: ASSizeRange) -> ASLayoutSpec {
        let contentStackLayout = ASStackLayoutSpec(direction: .vertical,
                                                   spacing: 0,
                                                   justifyContent: .start,
                                                   alignItems: .start,
                                                   children: [searchBarNode,
                                                              tableNode])
        return ASInsetLayoutSpec(insets: node.safeAreaInsets, child: contentStackLayout)
    }
}
