//
//  RepoViewController.swift
//  GraphQL-Sample
//
//  Created by Kanghoon on 10/01/2019.
//  Copyright © 2019 Vingle. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import RxOptional
import AsyncDisplayKit

class RepoViewController: UIViewController {
    
    // MARK: Properties
    lazy var searchBarNode = SearchBarNode()
    lazy var tableNode = ASTableNode()
    
    let viewModel: RepoViewModel
    var batchContext: ASBatchContext?
    
    let disposeBag = DisposeBag()
    
    init(viewModel: RepoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: Set up
    private func setupUI() {
        title = "Github Repo Search"
        
        tableNode.delegate = self
        tableNode.dataSource = self
        
        self.view.addSubview(searchBarNode.view)
        self.view.addSubview(tableNode.view)
        
        searchBarNode.view.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalToSuperview()
            }
            make.leading.trailing.equalToSuperview()
        }
        tableNode.view.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.top.equalTo(self.searchBarNode.view.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        self.tableNode.onDidLoad({ [weak self] _ in
            self?.tableNode.view.separatorStyle = .none
            self?.tableNode.view.alwaysBounceVertical = true
        })
    }
    
    private func bindViewModel() {
        searchBarNode.searchBar?
            .rx.text
            .orEmpty
            .filterEmpty()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .map { SearchRequest(query: $0) }
            .bind(to: viewModel.searchRelay)
            .disposed(by: disposeBag)
        
        viewModel.repoList
            .filterNil()
            .subscribe(onNext: { [weak self] list in
                self?.batchContext?.completeBatchFetching(true)
                self?.tableNode.reloadData()
            }).disposed(by: disposeBag)
    }
}

extension RepoViewController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repoList.value?.items.count ?? 0
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        guard let items = viewModel.repoList.value?.items,
            indexPath.row < items.count
            else { return ASCellNode() }
        let repo = items[indexPath.row]
        let cellNode = RepoCellNode(repo: repo)
        return cellNode
    }
}

extension RepoViewController: ASTableDelegate {
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return viewModel.repoList.value?.after != nil
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        guard let repoList = viewModel.repoList.value else { return }
        self.batchContext = context
        viewModel.searchRelay
            .accept(SearchRequest(query: repoList.query,
                                  after: repoList.after))
    }
}
