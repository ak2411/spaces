//
//  FirebaseSpace.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/28/24.
//

import FirebaseFirestoreSwift
import Foundation

struct FirebaseSpace: Identifiable, Codable, Equatable {
    var id = UUID().uuidString
    var orientation: SIMD3<Float>
    var position: SIMD3<Float>
    var scale: SIMD3<Float>
    var name: String
}
