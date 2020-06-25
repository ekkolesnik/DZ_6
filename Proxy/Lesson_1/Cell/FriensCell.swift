//
//  FriensCell.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 07.02.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class FriensCell: UITableViewCell {
    
    @IBOutlet weak var FriendsLabel: UILabel!
   
    @IBOutlet weak var ImagePic: UIImageView!
    
    @IBOutlet weak var ViewImage: UIView!
    
    var id = 0
    
    var firstName = ""
    var lastName = ""
    
    //возвращение  нормального состояния ячейки при переиспользовании
    override func prepareForReuse() {
        super.prepareForReuse()
        ImagePic.image = nil
        FriendsLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //добавляем GestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageOnTap))
        ViewImage.addGestureRecognizer(tapGesture)
        ViewImage.isUserInteractionEnabled = true
        
        ViewImage.layer.cornerRadius = ViewImage.frame.height / 2
        
        ViewImage.layer.shadowColor = UIColor.black.cgColor
        ViewImage.layer.shadowOpacity = 0.7
        ViewImage.layer.shadowRadius = 6
        ViewImage.layer.shadowOffset = .zero
        
        ImagePic.layer.cornerRadius = ImagePic.frame.height / 2
        
    }
    
    //функ-я обработки нажатия на иконку пользователя
    @objc func imageOnTap(){
        
        UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
            self.ViewImage.transform = .init(scaleX: 0.9, y: 0.9)
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, animations: {
            self.ViewImage.transform = .init(scaleX: 1, y: 1)
        })
        
    }
    
}
