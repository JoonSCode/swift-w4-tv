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
    private var videoType: Video.VideoType = .CLIP
    private var cellSize = CGSize()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        calculateCellSize(viewWidth: nil)
//        videoCollectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadContents(_:)), name: .contentsChanged, object: nil)
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
//        videoCollectionView.reloadData()
        NotificationCenter.default.post(name: .contentsChanged, object: nil)
    }

    @IBAction func changeSegment(_: Any) {
        videoType = videoType == .CLIP ? .LIVE : .CLIP
//        videoCollectionView.reloadData()
        NotificationCenter.default.post(name: .contentsChanged, object: nil)
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
            }
            else{
                width /= 2
            }
        }
        height = width * 0.75
        cellSize = CGSize(width: width, height: height)
    }

    func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone ? true : false
    }

    @objc func reloadContents(_: Notification) {
        videoCollectionView.reloadData()
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
        }
        else {
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
