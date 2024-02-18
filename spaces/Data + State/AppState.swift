//
//  AppState.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/17/24.
//

import Foundation

@Observable
@MainActor
public class AppState {
    var phase: AppPhase = .startingUp
    
    @discardableResult
    public func addEntityToSpace(sticker: Sticker) -> Entity {
        
        root.addChild()
    }
}
