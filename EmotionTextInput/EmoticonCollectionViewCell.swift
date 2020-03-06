//
//  EmoticonCollectionViewCell.swift
//  InteractiveClassPlatform
//
//  Created by linfeiCommon on 2020/1/17.
//  Copyright © 2020 Codyy. All rights reserved.
//

import Foundation
import UIKit

class EmoticonCollectionViewCell: UICollectionViewCell {
    var emoticonModel: EmoticonModel?
    var isDelate: Bool = false
    
    var imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView.frame = self.bounds
        self.contentView.addSubview(self.imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageViewSize(size: CGSize) {
        imageView.setFrameSize(size)
        imageView.center = self.contentView.center
    }
    
    func setEmoticonModel(model: EmoticonModel?, delete deleteImage: UIImage? = nil) {
        self.emoticonModel = model
        updateContent(deleteImage)
    }
    
    func setIsDelete(delete: Bool) {
        self.isDelate = delete
    }
    
    func updateContent(_ deleteImage: UIImage?) {
        if self.isDelate {
            if deleteImage == nil {
                self.imageView.image = nil
                return
            }
            self.imageView.image = deleteImage
        } else {
            if emoticonModel == nil || emoticonModel?.pathUrl == nil  {
                self.imageView.image = nil
                return
            }
            UIImage.emoticonNamed(emoticonModel!.pathUrl!, complete: {[weak self] (image) in
                self?.imageView.image = image
            })
        }
    }
}
