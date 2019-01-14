//
//  RepoCellNode.swift
//  GraphQL-Sample
//
//  Created by Kanghoon on 10/01/2019.
//  Copyright © 2019 Vingle. All rights reserved.
//

import Foundation
import AsyncDisplayKit

final class RepoCellNode: ASCellNode {
    
    typealias Repository = SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository
    
    struct Const {
        static let imageSize: CGSize = .init(width: 60, height: 60)
        static let spacing: CGFloat = 8
    }
    
    lazy var imageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.style.preferredSize = Const.imageSize
        node.shouldCacheImage = true
        return node
    }()
    
    lazy var titleNode: ASTextNode = {
        let node = ASTextNode()
        node.style.flexShrink = 1.0
        return node
    }()
    
    init(repo: Repository) {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        imageNode.setURL(URL(string: repo.owner.avatarUrl), resetToDefault: true)
        titleNode.attributedText = NSAttributedString(string: repo.name,
                                                      attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                                   .foregroundColor: UIColor.black])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                 spacing: Const.spacing,
                                                 justifyContent: .start,
                                                 alignItems: .center,
                                                 children: [imageNode,
                                                            titleNode])
        return ASInsetLayoutSpec(insets: .zero, child: contentStackSpec)
    }
}

