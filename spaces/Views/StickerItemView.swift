//
//  StickerItemView.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/17/24.
//

import Foundation
import SwiftUI
import RealityKit

struct InstantiatedStickerItemView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var selectedVM: SelectedItemViewModel
    
    @StateObject var vm = StickerItemViewModel()
    
    // 3d rotation
    @State var angle: Angle = .degrees(0)
    @State var startAngle: Angle?
    
    @State var axis: (CGFloat, CGFloat, CGFloat) = (.zero, .zero, .zero)
    @State var startAxis: (CGFloat, CGFloat, CGFloat)?
    
    // ScaleEffect
    @State var scale: Double = 2
    @State var startScale: Double?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RealityView { _ in
            } update: { content in
                if vm.model == nil &&
                    !content.entities.isEmpty {
                    content.entities.removeAll()
                }
                if let entity = vm.model {
                    if let currentEntity = content.entities.first, entity == currentEntity {
                        return
                    }
                    content.entities.removeAll()
                    content.add(entity)
                }
            }
            .rotation3DEffect(angle, axis: axis)
            .scaleEffect(scale)
            .simultaneousGesture(DragGesture()
                .onChanged{ value in
                    if let startAngle, let startAxis {
                        let _angle = sqrt(pow(value.translation.width, 2) + pow(value.translation.height, 2)) + startAngle.degrees
                        let axisX = ((-value.translation.height + startAxis.0) / CGFloat(_angle))
                        let axisY = ((value.translation.width + startAxis.1) / CGFloat(_angle))
                        angle = Angle(degrees: Double(_angle))
                        axis = (axisX, axisY, 0)
                    } else {
                        startAngle = angle
                        startAxis = axis
                    }
                }.onEnded{ value in
                    startAngle = angle
                    startAxis = axis
                }
            )
            .simultaneousGesture(MagnifyGesture()
                .onChanged { value in
                    if let startScale {
                        scale = max(1, min(3, value.magnification * startScale))
                    } else {
                        startScale = scale
                    }
                }.onEnded{value in
                    startScale = scale
                })
            .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
            
            VStack {
                Text(vm.sticker?.name ?? "default")
            }.zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
        }
        .onAppear {
            guard let sticker = selectedVM.selectedItem else { return }
            vm.onStickerDeleted = { dismiss() }
            vm.listenToItem(sticker)
        }
    }
}

#Preview {
    @StateObject var selectedVM = SelectedItemViewModel(selectedItem: .init(id: "WmR8UCiVa45qRxesGBaP", name: ""))
    return InstantiatedStickerItemView().environmentObject(selectedVM)
}
