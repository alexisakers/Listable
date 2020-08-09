//
//  ListView.LayoutManager.swift
//  Listable
//
//  Created by Kyle Van Essen on 5/3/20.
//

import Foundation


extension ListView
{
    final class LayoutManager
    {
        unowned let collectionView : UICollectionView
                
        private(set) var collectionViewLayout : CollectionViewLayout
        
        init(layout collectionViewLayout : CollectionViewLayout, collectionView : UICollectionView)
        {
            self.collectionViewLayout = collectionViewLayout
            self.collectionView = collectionView
        }
        
        func set(layout : LayoutDescription, animated : Bool, completion : @escaping () -> ())
        {
            if self.collectionViewLayout.layoutDescription.configuration.isSameLayoutType(as: layout.configuration) {
                self.collectionViewLayout.layoutDescription = layout
                
                let shouldRebuild = self.collectionViewLayout.layoutDescription.configuration.shouldRebuild(layout: self.collectionViewLayout.layout)
                
                if shouldRebuild {
                    self.collectionViewLayout.setNeedsRebuild()
                }
            } else {
                self.collectionViewLayout = CollectionViewLayout(
                    delegate: self.collectionViewLayout.delegate,
                    layoutDescription: layout,
                    appearance: self.collectionViewLayout.appearance,
                    behavior: self.collectionViewLayout.behavior
                )
                
                self.collectionView.setCollectionViewLayout(self.collectionViewLayout, animated: animated) { _ in
                    completion()
                }
            }
        }
    }
}
