//
//  BannerCycleView.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/2/24.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class BannerCycleView: UIView {
    
    var placeHolderImage: UIImage? {
        didSet {
            self.cycleImageView.placeHolderImage = placeHolderImage
        }
    }

    var banners: [Banner] = [Banner]() {
        didSet {
            self.removeTimer()
            if banners.count > 0 {
                self.indicatorView.totalCount = banners.count
                self.indicatorView.currentIndex = 0
                self.indicatorView.isHidden = banners.count <= 1
                self.updateSubViews()
                self.cycleImageView.banners = banners
                if banners.count > 1 {
                    self.beginTimer()
                }
            }
        }
    }
    
    var firstPageDelayCount: Int = 0
    
    var respondSelect: ((_ banner: Banner) -> ())?
    
    func performNext() {
        if firstPageDelayCount > 0 {
            firstPageDelayCount -= 1
        } else {
            self.cycleImageView.performNext()
        }
    }
    
    lazy var cycleImageView: BannerCycleImageView = {
        let one = BannerCycleImageView()
        one.respondChange = { [weak self] index, bannerIndex in
            self?.textLabel.text = self?.banners[bannerIndex].desc
            self?.indicatorView.currentIndex = bannerIndex
        }
        one.respondSelect = { [weak self] banner in
            if banner.hasUrl() {
                self?.respondSelect?(banner)
            }
        }
        one.respondWillBeginDragging = { [weak self] in
            self?.removeTimer()
        }
        one.respondDidEndDragging = { [weak self] in
            self?.beginTimer()
        }
        return one
    }()
    lazy var textLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrWhite
        one.font = UIFont.systemFont(ofSize: 17)
        return one
    }()
    lazy var bottomView: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBlack
        one.alpha = 0.5
        return one
    }()
    lazy var indicatorView: BannerCycleIndicatorView = {
        let one = BannerCycleIndicatorView()
        return one
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(self.cycleImageView)
        self.addSubview(self.bottomView)
        self.addSubview(self.textLabel)
        self.addSubview(self.indicatorView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateSubViews()
    }
    
    private func updateSubViews() {
        let bottomH: CGFloat = 30
        let winW: CGFloat = self.bounds.width
        let winH: CGFloat = self.bounds.height
        self.cycleImageView.frame = self.bounds
        self.bottomView.frame = CGRect(x: 0, y: winH - bottomH, width: winW, height: bottomH)
        do {
            let size = self.indicatorView.getFixSize()
            let x = winW - 5 - size.width - 5
            let y = winH - bottomH + (bottomH - size.height) / 2
            self.indicatorView.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
        }
        self.textLabel.frame = CGRect(x: 12.5, y: winH - bottomH, width: self.indicatorView.frame.minX - 5 - 12.5, height: bottomH)
    }
    
    
    // timer
    private var timer: QXTimer?
    func removeTimer() {
        timer?.remove()
        timer = nil
    }
    func beginTimer() {
        let timer = QXTimer(duration: 3)
        timer.loop = { [weak self] t in
            self?.performNext()
        }
        self.timer = timer
    }
}

class BannerCycleImageView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var placeHolderImage: UIImage?

    var banners: [Banner] = [Banner]() {
        didSet {
            if banners.count > 1 {
                self.collectionView.reloadData()
                let offset = self.bannerIndexFor(collectionViewIndex: self.halfCount)
                self.scrollTo(index: halfCount - offset, animated: false)
                self.collectionView.isScrollEnabled = true
            } else {
                self.collectionView.reloadData()
                self.collectionView.contentOffset = CGPoint.zero
                self.collectionView.isScrollEnabled = false
            }
        }
    }
    
    var respondSelect: ((_ banner: Banner) -> ())?
    var respondChange: ((_ index: Int, _ bannerIndex: Int) -> ())?
    var respondWillBeginDragging: (() -> ())?
    var respondDidEndDragging: (() -> ())?
    
    func performNext() {
        var index = self.collectionViewIndex + 1
        if index >= (self.halfCount + self.halfCount / 2) {
            index = self.halfCount
        }
        self.scrollTo(index: index, animated: true)
    }
    func scrollTo(index: Int, animated: Bool) {
        self.collectionViewIndex = index
        let indexPath = IndexPath(item: self.collectionViewIndex, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        self.respondChange?(self.collectionViewIndex, self.bannerIndexFor(collectionViewIndex: self.collectionViewIndex))
    }
    
    private var collectionViewIndex: Int = 0
    
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let one = UICollectionViewFlowLayout()
        one.itemSize = CGSize(width: 100, height: 100)
        one.minimumInteritemSpacing = 0
        one.minimumLineSpacing = 0
        one.scrollDirection = .horizontal
        return one
    }()
    fileprivate lazy var collectionView: UICollectionView = {
        let one = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        one.backgroundColor = UIColor.clear
        one.dataSource = self
        one.delegate = self
        one.isPagingEnabled = true
        one.bounces = false
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        one.register(BannerCycleImageCell.self, forCellWithReuseIdentifier: "BannerCycleImageCell")
        return one
    }()
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(self.collectionView)
        self.collectionView.isScrollEnabled = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
        self.flowLayout.itemSize = self.bounds.size
    }

    private func bannerIndexFor(collectionViewIndex: Int) -> Int {
        if collectionViewIndex == 0 || banners.count == 0 {
            return 0
        }
        return collectionViewIndex % banners.count
    }
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    let halfCount: Int = 999
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if banners.count <= 0 {
            return 0
        }
        return halfCount * 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCycleImageCell", for: indexPath) as! BannerCycleImageCell
        let bannerIndex = self.bannerIndexFor(collectionViewIndex: indexPath.item)
        cell.placeHolderImage = self.placeHolderImage
        cell.banner = banners[bannerIndex]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bannerIndex = bannerIndexFor(collectionViewIndex: indexPath.item)
        let banner = banners[bannerIndex]
        self.respondSelect?(banner)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let w = self.bounds.size.width
        if w <= 0 { return }
        self.collectionViewIndex = Int(offset / w + 0.5)
        self.respondChange?(self.collectionViewIndex, self.bannerIndexFor(collectionViewIndex: self.collectionViewIndex))
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.respondWillBeginDragging?()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.respondDidEndDragging?()
    }
}

class BannerCycleTextView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var banners: [Banner] = [Banner]() {
        didSet {
            collectionView.reloadData()
            let offset = self.bannerIndexFor(collectionViewIndex: self.halfCount)
            self.scrollTo(index: halfCount - offset, animated: false)
        }
    }

    func scrollTo(index: Int, animated: Bool) {
        self.collectionViewIndex = index
        let indexPath = IndexPath(item: self.collectionViewIndex, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }
    
    private var collectionViewIndex: Int = 0
    
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let one = UICollectionViewFlowLayout()
        one.itemSize = CGSize.zero
        one.minimumInteritemSpacing = 0
        one.minimumLineSpacing = 0
        one.scrollDirection = .horizontal
        return one
    }()
    fileprivate lazy var collectionView: UICollectionView = {
        let one = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        one.backgroundColor = UIColor.clear
        one.dataSource = self
        one.delegate = self
        one.isPagingEnabled = true
        one.bounces = false
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        one.register(BannerCycleTextCell.self, forCellWithReuseIdentifier: "BannerCycleTextCell")
        return one
    }()
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(self.collectionView)
        self.isUserInteractionEnabled = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
        self.flowLayout.itemSize = self.bounds.size
    }
    
    private func bannerIndexFor(collectionViewIndex: Int) -> Int {
        if collectionViewIndex == 0 || banners.count == 0 {
            return 0
        }
        return collectionViewIndex % banners.count
    }
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    let halfCount: Int = 999
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if banners.count <= 0 {
            return 0
        }
        return halfCount * 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCycleTextCell", for: indexPath) as! BannerCycleTextCell
        let bannerIndex = bannerIndexFor(collectionViewIndex: indexPath.item)
        cell.banner = banners[bannerIndex]
        return cell
    }
}

class BannerCycleIndicatorView: UIView {
    
    static let maxCount: Int = 9
    static let dotSize: CGSize = CGSize(width: 12, height: 12)

    var currentIndex: Int = 0 {
        didSet {
            self.updateSubViews()
        }
    }
    var totalCount: Int = 0
    
    func getFixSize() -> CGSize {
        return CGSize(width: BannerCycleIndicatorView.dotSize.width * CGFloat(totalCount), height: BannerCycleIndicatorView.dotSize.height)
    }
    private lazy var dotViews: [UIImageView] = {
        var one = [UIImageView]()
        for _ in 0..<BannerCycleIndicatorView.maxCount {
            let dotView = UIImageView()
            one.append(dotView)
        }
        return one
    }()
    required init() {
        super.init(frame: CGRect.zero)
        for dotView in self.dotViews {
            self.addSubview(dotView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func updateSubViews() {
        for i in 0..<self.totalCount {
            if i < self.dotViews.count {
                let dotView = dotViews[i]
                dotView.frame = CGRect(
                    x: CGFloat(i) * BannerCycleIndicatorView.dotSize.width,
                    y: 0,
                    width: BannerCycleIndicatorView.dotSize.width,
                    height: BannerCycleIndicatorView.dotSize.height
                )
                if i == self.currentIndex {
                    dotView.image = UIImage(named: "iconCirclerRed")
                } else {
                    dotView.image = UIImage(named: "iconCirclerWhite")
                }
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateSubViews()
    }
}

class BannerCycleImageCell: UICollectionViewCell {
    
    var placeHolderImage: UIImage?
    
    var banner: Banner! {
        didSet {
            imageView.image = self.placeHolderImage
            if let str = banner.picture {
                if let url = URL(string: str) {
                    if let placeHolderImage = placeHolderImage {
                        self.imageView.sd_setImage(with: url, placeholderImage: placeHolderImage)
                    } else {
                        self.imageView.sd_setImage(with: url)
                    }
                }
            }
        }
    }
    lazy var imageView: UIImageView = {
        let one = UIImageView()
        return one
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.contentView.bounds
    }
}

class BannerCycleTextCell: UICollectionViewCell {
    var banner: Banner! {
        didSet {
            label.text = banner.desc
        }
    }
    lazy var label: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.black
        one.font = UIFont.systemFont(ofSize: 14)
        return one
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = self.contentView.bounds
    }
}
