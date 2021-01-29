//
//  Video.swift
//  TVApp
//
//  Created by 윤준수 on 2021/01/27.
//

import Foundation

struct Video: Codable {
    let displayTitle: String
    let channel: Channel
    let live: Live?
    let clip: Clip?
    let createTime: String
    let videoType: VideoType
    var visitCount: Int {
        return channel.visitCount
    }

    var thumbnailUrl: String {
        if let live = live {
            return live.thumbnailUrl
        } else if let clip = clip {
            return clip.thumbnailUrl
        }
        return ""
    }

    var contentInfo: String {
        if let live = live {
            return "🎧\(live.playCount)"
        } else if let clip = clip {
            return Convert.durationToString(duration: clip.duration)
        }
        return ""
    }
    var id: Int{
        if let live = live {
            return live.id
        } else if let clip = clip {
            return clip.id
        }
        return -1
    }

    struct Live: Codable {
        let playCount, duration, id: Int
        let thumbnailUrl: String
    }

    struct Clip: Codable {
        let duration, id: Int
        let thumbnailUrl: String
    }

    enum VideoType: String, Codable {
        case LIVE
        case CLIP
    }
}
