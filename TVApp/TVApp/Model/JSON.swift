//
//  Json.swift
//  TVApp
//
//  Created by 윤준수 on 2021/01/27.
//

import Foundation
import UIKit

class JSON {
    static func parsingVideoJson(from: String) -> [Video] {
        let decoder = JSONDecoder()
        var videos: [Video] = []
        guard let videoJson = NSDataAsset(name: from) else { return videos }
        do {
            videos = try decoder.decode([Video].self, from: videoJson.data)
        } catch {
            print(error.localizedDescription)
        }
        return videos
    }
}
