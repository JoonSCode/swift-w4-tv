//
//  FavoriteManager.swift
//  TVApp
//
//  Created by 윤준수 on 2021/01/29.
//

import Foundation

class FavoriteManager {
    static let instance = FavoriteManager()
    private var favorites: [Favorite] = []
    var count: Int {
        return favorites.count
    }

    private init() {}

    func add(favorite: Favorite) {
        favorites.append(favorite)
    }

    func remove(favorite: Favorite) {
        guard let index = favorites.firstIndex(where: { $0.title == favorite.title }) else { return }
        favorites.remove(at: index)
    }

    subscript(at: Int) -> Favorite {
        return favorites[at]
    }
}
