//
//  SauceCollectionViewController.swift
//  TabTool
//
//  Created by Lukas Stabe on 12.04.16.
//  Copyright © 2016 2C. All rights reserved.
//

import UIKit

open class SauceCollectionViewController: UICollectionViewController, DataSourceContainer {
    let dataSource: DataSource

    public init(collectionViewLayout layout: UICollectionViewLayout, dataSource: DataSource) {
        self.dataSource = dataSource
        super.init(collectionViewLayout: layout)
        dataSource.container = self
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        guard let collectionView = self.collectionView
            else { fatalError("can't deal with no collection view in collection vc") }

        collectionView.dataSource = dataSource

        dataSource.registerReusableViewsWith(collectionView)
    }

    public func containingViewController() -> UIViewController? {
        return self
    }

    public var collectionViewIfLoaded: UICollectionView? {
        guard isViewLoaded else { return nil }
        return collectionView
    }

    public func dataSource(_ dataSource: DataSource, performed action: DataSourceAction) {
        guard isViewLoaded, let c = collectionView else { return }

        switch action {
        case .insert(let p):
            c.insertItems(at: p)
        case .delete(let p):
            c.deleteItems(at: p)
        case .reload(let p):
            c.reloadItems(at: p)
        case .move(from: let f, to: let t):
            c.moveItem(at: f, to: t)

        case .reloadSections(let s):
            let i = NSMutableIndexSet()
            s.forEach(i.add(_:))
            c.reloadSections(i as IndexSet)
        case .insertSection(let i):
            c.insertSections(IndexSet(integer: i))
        case .deleteSection(let i):
            c.deleteSections(IndexSet(integer: i))
        case .moveSection(from: let f, to: let t):
            c.moveSection(f, toSection: t)

        case .batch(let changes):
            c.performBatchUpdates(changes, completion: nil)
        }
    }
}
