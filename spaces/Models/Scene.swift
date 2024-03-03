//
//  Scene.swift
//  spaces
//
//  Created by Angelica Kosasih on 3/1/24.
//

import Foundation

struct InitQuatValues: Codable {
    var real: Float
    var imag: SIMD3<Float>
}

struct StickerPose: Codable {
    var id = UUID().uuidString
    var stickerId: String
    var translation: SIMD3<Float>
    var rotation: InitQuatValues
    var scale: SIMD3<Float>

    init(translation: SIMD3<Float>, real: Float, imag: SIMD3<Float>, scale: SIMD3<Float>, stickerId: String) {
        self.translation = translation
        self.rotation = InitQuatValues(real: real, imag: imag)
        self.scale = scale
        self.stickerId = stickerId
    }
}

struct StickerScene: Identifiable, Equatable, Codable {
    static func == (lhs: StickerScene, rhs: StickerScene) -> Bool {
        lhs.name == rhs.name
    }

    var id = UUID().uuidString
    var name: String
    var description: String
    var models: [StickerPose]

    init(name: String, description: String) {
        self.name = name
        self.description = description
        self.models = []
    }
}
