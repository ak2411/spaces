//
//  Scene.swift
//  spaces
//
//  Created by Angelica Kosasih on 3/1/24.
//

import Foundation

struct InitQuatValues: Encodable, Decodable {
    var real: Float
    var imag: SIMD3<Float>
}

struct StickerPose: Encodable, Decodable {
    var id = UUID().uuidString
    var translation: SIMD3<Float>
    var rotation: InitQuatValues
    var scale: SIMD3<Float>

    init(translation: SIMD3<Float>, real: Float, imag: SIMD3<Float>, scale: SIMD3<Float>) {
        self.translation = translation
        self.rotation = InitQuatValues(real: real, imag: imag)
        self.scale = scale
    }
}

struct StickerScene: Identifiable, Equatable, Encodable, Decodable {
    static func == (lhs: StickerScene, rhs: StickerScene) -> Bool {
        lhs.name == rhs.name
    }

    var id = UUID().uuidString
    var name: String
    var models: [StickerPose]

    init(name: String) {
        self.name = name
        self.models = []
    }
}
