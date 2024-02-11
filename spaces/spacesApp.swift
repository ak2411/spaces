//
//  spacesApp.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/10/24.
//

import SwiftUI

@main
struct spacesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
