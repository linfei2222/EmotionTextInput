//
//  EmoticonView.swift
//  InteractiveClassPlatform
//
//  Created by linfeiCommon on 2020/1/13.
//  Copyright © 2020 Codyy. All rights reserved.
//

import Foundation
import UIKit

class EmoticonView: UIView {
    //collectView cell size default is 50.0,50.0
//    var collectViewCellSize = CGSize.init(width: 50.0, height: 50.0)
//    var itemSize: CGSize? {
//        willSet {
//            collectViewCellSize = newValue ?? CGSize.init(width: 50.0, height: 50.0)
//        }
//    }
    weak var delegate: EmoticonProtocol?
    //default is 7
    var horizontalCellCount = 7
    var horizontalCount: Int? {
        willSet {
            horizontalCellCount = newValue ?? 7
        }
    }
    //default is 4
    var verticalCellCount = 4
    var verticalCount: Int? {
        willSet {
            verticalCellCount = newValue ?? 4
        }
    }
    //default is 0.0,10.0,0.0,10.0
    var sectionInset = UIEdgeInsets.init(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    var collectViewSectionInset: UIEdgeInsets? {
        willSet {
            sectionInset = newValue ?? UIEdgeInsets.init(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        }
    }
    //default is 10.0
    var pageControlHeight: CGFloat = 10.0
    var pageHeight: CGFloat? {
        willSet {
            pageControlHeight = newValue ?? 10.0
        }
    }
    //default is CGSize.init(width: 32.0, height: 32.0)
    var imageShowSize: CGSize = CGSize.init(width: 32.0, height: 32.0)
    var imageSize: CGSize? {
        willSet {
            imageShowSize = newValue ?? CGSize.init(width: 32.0, height: 32.0)
            collectionView?.reloadData()
        }
    }
    var deleteImage: UIImage?
    
    var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var collectionView: EmoticonCollectionView?
    var pageControlView: PageControlView?
    var collectionModelList: [EmoticonModel] = []
    
    convenience init(frame: CGRect, bundlePath path: String, plistPath plist: String) {
        self.init(frame: frame)
        initLoadView(bundlePath: path, plistPath: plist)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLoadView(bundlePath path: String, plistPath plist: String) {
        initBundleImages(bundlePath: path, plistPath: plist)
        refreshCollectionView()
        collectionView = EmoticonCollectionView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.frameWidth(), height: self.frameHeight() - pageControlHeight), collectionViewLayout: flowLayout)
        collectionView?.register(EmoticonCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "EmoticonCollectionViewCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        addSubview(collectionView!)
        pageControlView = PageControlView.init(frame: CGRect.init(x: 0.0, y: collectionView!.frameBottom(), width: self.frameWidth(), height: pageControlHeight))
        let pageModelCount = verticalCellCount * horizontalCellCount - 1
        pageControlView?.pageControlCount = collectionModelList.count / pageModelCount + (collectionModelList.count % pageModelCount > 0 ? 1 : 0)
        addSubview(pageControlView!)
    }
    
    func initBundleImages(bundlePath path: String, plistPath plist: String) {
        guard let plistDic: NSDictionary = NSDictionary.init(contentsOfFile: plist) else {
            return
        }
        guard let  array = plistDic["emoticons"] as? Array<Dictionary<String, Any>> else {
            return
        }
        let emoticonsList:[EmoticonModel] = array.map { (obj) in
            var model = (DecoderStruct.decode(EmoticonModel.self, param: obj) ?? EmoticonModel.init())
            model.pathUrl = UIImage.urlForImageNamed(name: ((model.png as NSString).deletingPathExtension as NSString).lastPathComponent, ofType: (model.png as NSString).pathExtension, inDirectory: (model.png as NSString).deletingLastPathComponent, inBundle: Bundle.init(path: path)!)
            return model
        }
        self.collectionModelList = emoticonsList
    }
    
    func refreshCollectionView() {
        let itemWidth = (self.frameWidth() - sectionInset.left - sectionInset.right) / CGFloat(horizontalCellCount)
        let itemHeight = (self.frameHeight() - sectionInset.top - sectionInset.bottom - pageControlHeight) / CGFloat(verticalCellCount)
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize.init(width: itemWidth, height: itemHeight)
        flowLayout.minimumLineSpacing = 0.0;
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.sectionInset = sectionInset
    }
}

extension EmoticonView:UICollectionViewDelegate, UICollectionViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frameWidth())
        self.pageControlView?.pageLocation = page
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let pageModelCount = verticalCellCount * horizontalCellCount - 1
        return collectionModelList.count / pageModelCount + (collectionModelList.count % pageModelCount > 0 ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return verticalCellCount * horizontalCellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EmoticonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmoticonCollectionViewCell", for: indexPath) as! EmoticonCollectionViewCell
        cell.setImageViewSize(size: self.imageShowSize)
        let pageModelCount = verticalCellCount * horizontalCellCount - 1
        if indexPath.row == pageModelCount {
            cell.setIsDelete(delete: true)
            cell.setEmoticonModel(model: nil, delete: deleteImage)
        } else {
            cell.setIsDelete(delete: false)
            cell.setEmoticonModel(model: itemEmoticonModel(indexPath: indexPath))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pageModelCount = verticalCellCount * horizontalCellCount - 1
        if indexPath.row == pageModelCount {
            //delete
            self.delegate?.emoticonInputDidTapBackspace()
        } else {
            guard let model = itemEmoticonModel(indexPath: indexPath) else {
                return
            }
            self.delegate?.emoticonInputDidTapText(text: model.display)
        }
    }
    
    //transfrom model vertical to horizontal,indexPath.row % verticalCellCount * horizontalCellCount + indexPath.row / verticalCellCount
    func itemEmoticonModel(indexPath: IndexPath) -> EmoticonModel? {
        let pageModelCount = verticalCellCount * horizontalCellCount - 1
        let location = indexPath.row % verticalCellCount * horizontalCellCount + indexPath.row / verticalCellCount + pageModelCount * indexPath.section
        if location > (collectionModelList.count - 1) {
            return nil
        } else {
            return collectionModelList[location]
        }
    }
}
