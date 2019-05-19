//
//  DummyCollectionView.swift
//  AsyncAwaitDemo
//
//  Created by Alex Beattie on 5/19/19.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit
class DummyCollectionView: UICollectionViewController {
    
    var cellId = "cellId"
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .yellow
        collectionView.register(DummyCell.self, forCellWithReuseIdentifier: cellId)
    
        Service.shared.fetchAuthToken { (s) in
            let authToken = s.AuthToken
//            print(s[0])
            self.collectionView.reloadData()
        }
//        Service.shared.fetchAuthToken { (s) in
//            print("SIMPLE:\(s)")
//            self.collectionView.reloadData()
//        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        return cell
    }
}
