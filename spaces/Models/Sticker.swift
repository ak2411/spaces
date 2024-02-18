//
//  Sticker.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/15/24.
//

import FirebaseFirestoreSwift
import Foundation

struct Sticker: Identifiable, Codable, Equatable {
    var id = UUID().uuidString
    var name:String
    var usdzLink: String?
    var usdzURL: URL? {
        guard let usdzLink else { return nil }
        return URL(string: usdzLink)
    }
    // use Apple's quicklook to generate a thumbnail of the sticker
    var thumbnailLink: String?
    var thumbnailURL: URL? {
        guard let thumbnailLink else { return nil }
        return URL(string: thumbnailLink)
    }
}
