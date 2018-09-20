//
//  CenteredFlowLayout.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 7/30/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import UIKit

class CenteredFlowLayout : UICollectionViewFlowLayout {
    
    var myItemSize : CGSize?
    
    override init() {
        super.init()
        self.scrollDirection = .horizontal
    }
    
    init(with itemSize: CGSize) {
        super.init()
        self.scrollDirection = .horizontal
        self.itemSize = itemSize
        self.minimumLineSpacing = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override var collectionViewContentSize: CGSize
    {
        // Only support single section for now.
        // Only support Horizontal scroll
        let count = self.collectionView?.dataSource?.collectionView(self.collectionView!, numberOfItemsInSection: 0)

        let canvasSize = self.collectionView?.frame.size;
        var contentSize = canvasSize
        if (self.scrollDirection == .horizontal)
        {
            let rowCount = ((canvasSize?.height)! - self.itemSize.height) / (self.itemSize.height + self.minimumInteritemSpacing) + 1;
            let columnCount = ((canvasSize?.width)! - self.itemSize.width) / (self.itemSize.width + self.minimumLineSpacing) + 1;
            let page = ceilf(Float(count!) / Float(rowCount * columnCount));
            contentSize?.width = CGFloat(page) * canvasSize!.width;
        }

        return contentSize!;
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)
        attributes?.frame = self.frameForItem(at: indexPath)
        return attributes
    }
    
    func frameForItem(at indexPath: IndexPath) -> CGRect{
        let canvasSize = self.collectionView?.frame.size;
        
        let rowCount = ((canvasSize?.height)! - self.itemSize.height) / (self.itemSize.height + self.minimumInteritemSpacing) + 1;
        let itemHeight = self.itemSize.height
        let interimSpacing = self.minimumInteritemSpacing
        let columnCount = ((canvasSize?.width)! - self.itemSize.width) / (self.itemSize.width + self.minimumLineSpacing) + 1;
        
        let pageMarginX = ((canvasSize?.width)! - columnCount * self.itemSize.width) + self.minimumLineSpacing// - (columnCount > 1 ? (columnCount - 1) * self.minimumLineSpacing : 0)) / 2.0
        let pageMarginY = CGFloat(15.0)//((canvasSize?.height)! - rowCount * self.itemSize.height - (rowCount > 1 ? (rowCount - 1) * self.minimumInteritemSpacing : 0)) / 2.0
        
        let page = indexPath.row / Int((rowCount * columnCount));
        let remainder = indexPath.row - page * Int(rowCount * columnCount);
        let row = remainder / Int(columnCount);
        let column = remainder - row * Int(columnCount);
        
        var cellFrame = CGRect.zero;
        cellFrame.origin.x = pageMarginX + CGFloat(column) * (self.itemSize.width + self.minimumLineSpacing);
        cellFrame.origin.y = pageMarginY + CGFloat(row) * (self.itemSize.height + self.minimumInteritemSpacing);
        cellFrame.size.width = self.itemSize.width;
        cellFrame.size.height = self.itemSize.height;
        
        if (self.scrollDirection == .horizontal)
        {
            cellFrame.origin.x += CGFloat(page) * (canvasSize?.width)!;
        }
        
        return cellFrame;
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        let originAttrs = super.layoutAttributesForElements(in: rect)
        var attrs = [UICollectionViewLayoutAttributes]();

        for (_, attr) in (originAttrs?.enumerated())! {
            let idxPath = attr.indexPath;
            let itemFrame = self.frameForItem(at: idxPath);
            if itemFrame.intersects(rect)
            {
                let attr = self.layoutAttributesForItem(at:idxPath);
                attrs.append(attr!)
            }
        }
        return attrs;
    }
    
}
