//
//  DummyCell.swift
//  AsyncAwaitDemo
//
//  Created by Alex Beattie on 5/19/19.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit

class DummyCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .purple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
