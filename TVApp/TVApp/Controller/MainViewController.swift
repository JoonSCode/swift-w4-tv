//
//  ViewController.swift
//  TVApp
//
//  Created by 윤준수 on 2021/01/25.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet var videoTypeSegmentControl: UISegmentedControl!
    @IBOutlet var videoCollectionView: UICollectionView!
    private let videoManager = VideoManager.instance
    private let favoriteManager = FavoriteManager.instance
    private var videoType: Video.VideoType = .CLIP
    private var cellSize = CGSize()
    private var clickTime = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        calculateCellSize(viewWidth: nil)
        videoCollectionView.reloadData()
        becomeFirstResponder()
    }

    func initView() {
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self

        videoTypeSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        videoTypeSegmentControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2 / 3).isActive = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        calculateCellSize(viewWidth: size.width)
        videoCollectionView.reloadData()
    }

    @IBAction func changeSegment(_: Any) {
        videoType = videoType == .CLIP ? .LIVE : .CLIP
        videoCollectionView.reloadData()
    }

    func calculateCellSize(viewWidth: CGFloat?) {
        var width = (viewWidth ?? UIScreen.main.bounds.width) - 20
        var height: CGFloat
        if isPhone() {
            if UIDevice.current.orientation.isLandscape {
                width /= 2
            }
        } else {
            if UIDevice.current.orientation.isLandscape {
                width /= 3
            } else {
                width /= 2
            }
        }
        height = width * 0.75
        cellSize = CGSize(width: width, height: height)
    }

    func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone ? true : false
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        clickTime = Date()

        print("리스폰더체인")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        print("뗌")
        print(clickTime.distance(to: Date()))
        if clickTime.distance(to: Date()) < 2 { return }
        guard let touchPoint = touches.first?.location(in: videoCollectionView) else { return }
        guard let index = videoCollectionView.indexPathForItem(at: touchPoint) else { return }
//        guard let cell = videoCollectionView.cellForItem(at: index) as? VideoCollectionViewCell else { return }
        let video = videoType == .CLIP ? videoManager.getOriginalContent(at: index.item) : videoManager.getLiveContent(at: index.item)
        favoriteManager.add(favorite: Favorite(title: video.displayTitle, subTitle: "\(video.channel.name) (\(video.id))"))
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return videoType == Video.VideoType.CLIP ? videoManager.originalCount : videoManager.liveCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath)
        guard let videoCell = cell as? VideoCollectionViewCell else { return cell }
        let video = videoType == .CLIP ? videoManager.getOriginalContent(at: indexPath.item) : videoManager.getLiveContent(at: indexPath.item)
        setCell(target: videoCell, by: video)
        return videoCell
    }

    func setCell(target: VideoCollectionViewCell, by: Video) {
        let viewCount = "▶︎ \(Convert.getStringNumToCommaFormat(number: by.visitCount))"
        let creatTime = "• \(Convert.getDistFromCurrentTime(time: by.createTime))"
        let thumbnail = UIImage(named: by.thumbnailUrl)

        if videoType == .CLIP {
            target.hideLiveBadge()
        } else {
            target.showLiveBadge()
        }

        target.setTitle(title: by.displayTitle)
        target.setThumbnail(thumbnail: thumbnail)
        target.setChannelName(channelName: by.channel.name)
        target.setViewCount(viewCount: viewCount)
        target.setCreateTime(createTime: creatTime)
        target.setContentInfo(contentInfo: by.contentInfo)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 5
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 5
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return cellSize
    }
}

extension Notification.Name {
    static let contentsChanged = Notification.Name("contentsChanged")
}
