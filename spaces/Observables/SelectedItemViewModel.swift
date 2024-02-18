//
//  SelectedItemViewModel.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/16/24.
//

import Foundation

class SelectedItemViewModel: ObservableObject {
    @Published var selectedItem: Sticker? = nil
    
    init(selectedItem: Sticker? = nil) {
        self.selectedItem = selectedItem
    }
}
