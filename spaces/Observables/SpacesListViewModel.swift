//
//  SpacesListViewModel.swift
//  spaces
//
//  Created by Angelica Kosasih on 3/2/24.
//
import FirebaseFirestore
import Foundation
import SwiftUI

class SpacesListViewModel: ObservableObject {
    @Published
    var spaces = [StickerScene]()

    @MainActor
    func listenToItems() {
        // TODO: support different ways to order, more logical to order by recently edited
        Firestore.firestore().collection("spaces").order(by: "name").limit(toLast: 100).addSnapshotListener { snapshot, error in
            guard let snapshot else {
                print("Error fetching snapshot: \(error?.localizedDescription ?? "error")")
                return
            }
            let docs = snapshot.documents
            let items = docs.compactMap {
                try? $0.data(as: StickerScene.self)
            }

            withAnimation {
                self.spaces = items
            }
        }
    }
}
