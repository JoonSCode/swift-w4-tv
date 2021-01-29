//
//  ContentManager.swift
//  TVApp
//
//  Created by 윤준수 on 2021/01/27.
//

import Foundation

class VideoManager {
    static let instance = VideoManager()

    private var originalContents: [Video] = []
    var originalCount: Int {
        return originalContents.count
    }

    private var liveContents: [Video] = []
    var liveCount: Int {
        return liveContents.count
    }

    private init() {
        originalContents = JSON.parsingVideoJson(from: "original")
        liveContents = JSON.parsingVideoJson(from: "live")
    }

    func getOriginalContent(at: Int) -> Video {
        return originalContents[at]
    }

    func getLiveContent(at: Int) -> Video {
        return liveContents[at]
    }

    func setLiveContents(liveContents: [Video]) {
        self.liveContents = liveContents
    }

    func setOriginalContents(originalContents: [Video]) {
        self.originalContents = originalContents
    }
}
