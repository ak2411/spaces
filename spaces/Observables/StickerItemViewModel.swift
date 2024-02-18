//
//  StickerItemViewModel.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/17/24.
//

import Foundation
import RealityKit
import FirebaseFirestore
import FirebaseStorage


// TODO: What does the cacheURL return? my guess is it is a local url pointing to the real url?
class StickerItemViewModel: ObservableObject {
    @Published var sticker: Sticker?
    @Published var model: ModelEntity?
    @Published var usdzFileURL: URL?
    
    var onStickerDeleted: (() -> Void)? = nil
    
    func listenToItem(_ sticker: Sticker) {
        self.sticker = sticker
        Firestore.firestore().collection("stickers")
            .document(sticker.id)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self, let snapshot else {
                    print("error fetching snapshot \(error?.localizedDescription ?? "error")")
                    return
                }
                
                if !snapshot.exists {
                    print("snapshot doesn't exist")
                    self.onStickerDeleted?()
                    return
                }
                
                self.sticker = try? snapshot.data(as: Sticker.self)
                if let usdzURL = sticker.usdzURL {
                    Task { await self.fetchFileURL(usdzURL: usdzURL) }
                } else {
                    self.model = nil
                    self.usdzFileURL = nil
                }
        }
    }
    
    @MainActor
    func fetchFileURL(usdzURL: URL) async {
        guard let url = usdzURL.usdzFileCacheURL else { return }
        if let usdzFileURL, usdzFileURL.lastPathComponent == url.lastPathComponent {
            return
        }
        
        do {
            // if the cache url does not have the entity yet, write it to that location
            if !FileManager.default.fileExists(atPath: url.absoluteString) {
                _ = try await Storage.storage().reference(forURL: usdzURL.absoluteString)
                    .writeAsync(toFile: url)
            }
            // create the entity
            let entity = try await ModelEntity(contentsOf: url)
            // want a unique id for the specific sticker model
            entity.name = sticker?.usdzURL?.absoluteString ?? ""
            entity.generateCollisionShapes(recursive: true)
            // needed for gesture stuff
            entity.components.set(InputTargetComponent())
            
            self.usdzFileURL = url
            self.model = entity
        } catch {
            self.usdzFileURL = nil
            self.model  = nil
        }
    }
}
