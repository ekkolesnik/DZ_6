//
//  HeartLike.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 16.02.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class HeartLikeControl: UIControl{
    
    public var likeBool: Bool = false
    
    var likeCount: UILabel?
    var likeImage: UIImageView?
    var count: Int = 0
    
    override init (frame: CGRect){
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        gesture.numberOfTouchesRequired = 1
        addGestureRecognizer(gesture)
        likeCount = UILabel(frame:CGRect(x: 0, y: 5, width: 10, height: 23))
        likeCount?.text = String(count)
        likeCount?.textColor = .red
        self.addSubview(likeCount!)
        
        likeImage = UIImageView(image: UIImage(named: "LikeEmpty")!)
        likeImage?.frame = CGRect(x: 20, y: 0, width: 25, height: 27)

        self.addSubview(likeImage!)
    }

    @objc func likeTapped(){
        likeBool.toggle()
        likeImage?.image = likeBool ? UIImage(named: "LikeFull") : UIImage(named: "LikeEmpty")
        likeCount?.textColor = likeBool ? .black : .red
           if likeBool == true {
                   likeCount?.text = String(count+1)
           } else {
                    likeCount?.text = String(count)
           }
           setNeedsDisplay()
           sendActions(for: .valueChanged)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.autoreverse], animations: {
            self.likeImage!.transform = .init(rotationAngle: 6)
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, animations: {
            self.likeImage!.transform = .init(scaleX: 1, y: 1)
        })
        
    }
}
