//
//  Convert.swift
//  TVApp
//
//  Created by 윤준수 on 2021/01/27.
//

import Foundation

class Convert {
    static func getStringNumToCommaFormat(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }

    static func getDistFromCurrentTime(time: String) -> String {
        var distance: String = ""
        guard let createTime = time.toDate(format: "yyyy-MM-dd HH:mm:ss") else { return distance }
        let dateDistance = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: createTime, to: Date())
        if let day = dateDistance.day {
            if day != 0 {
                distance = "\(day)일 전"
            }
            return distance
        }
        if let hour = dateDistance.hour {
            if hour != 0 {
                distance = "\(hour)시간 전"
            }
            return distance
        }
        if let minute = dateDistance.minute {
            if minute != 0 {
                distance = "\(minute)분 전"
            }
            return distance
        }
        if let second = dateDistance.second {
            if second != 0 {
                distance = "\(second)초 전"
            }
            return distance
        }
        return distance
    }

    static func durationToString(duration: Int) -> String {
        let hour = duration / 60
        let minute = duration % 60
        return "\(hour):\(minute)"
    }
}
