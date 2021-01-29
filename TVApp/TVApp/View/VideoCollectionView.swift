//
//  VideoCollectionView.swift
//  TVApp
//
//  Created by 윤준수 on 2021/01/29.
//

import UIKit

class VideoCollectionView: UICollectionView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.next?.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.next?.touchesEnded(touches, with: event)
    }
}
