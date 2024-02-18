//
//  StickersListViewModel.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/15/24.
//
import FirebaseFirestore
import Foundation
import SwiftUI


class StickersListViewModel: ObservableObject {
        @Published var stickers = [Sticker]()
    @MainActor
    func listenToItems() {
        Firestore.firestore().collection("stickers").order(by: "name").limit(toLast: 100).addSnapshotListener { snapshot, error in
            guard let snapshot else {
                print("Error fetching snapshot: \(error?.localizedDescription ?? "error")")
                return
            }
            let docs = snapshot.documents
            let items = docs.compactMap {
                try? $0.data(as: Sticker.self)
            }
            
            withAnimation {
                self.stickers = items
            }
        }
    }
}
