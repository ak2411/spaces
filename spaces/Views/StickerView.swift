//
//  StickerView.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/15/24.
//
import RealityKit
import SwiftUI

struct StickerView: View {
    @StateObject var vm = StickersListViewModel()
    
    private let gridItems: [GridItem] =
    [.init(.adaptive(minimum: 240), spacing: 16)]
    
    
    var body: some View {
        Text("Stickers").font(.largeTitle).padding()
        ScrollView {
            LazyVGrid(columns: gridItems) {
                ForEach(vm.stickers) { sticker in
                    StickerItemView(sticker: sticker).onDrag{NSItemProvider()}
                }
            }.padding(.vertical)
        }
        .onAppear { vm.listenToItems() }
    }
}

struct StickerItemView: View {
    let sticker: Sticker
    
    @EnvironmentObject var selectedVM: SelectedItemViewModel
    @Environment(\.openWindow) var openWindow

    var body: some View {
        Button {
            selectedVM.selectedItem = sticker
            openWindow(id: "InstantiatedStickerItemView")
        } label: {
            VStack {
                ZStack {
                    if let usdzURL = sticker.usdzURL {
                        Model3D(url: usdzURL) { phase in
                            switch phase {
                            case .success(let model):
                                model.resizable().aspectRatio(contentMode: .fit)
                            case .failure:
                                Text("Failed to retrieve model")
                            default: ProgressView()
                            }
                        }
                    } else {
                        // add default rectangle
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(Color.gray.opacity(0.3))
                        Text("Mystery")
                    }
                }
                .frame(width:160, height: 160)
                .padding(.bottom, 32)
                Text(sticker.name)
            }
            .frame(width: 240, height: 240)
            .padding(32)
        }
        .buttonStyle(.borderless)
        .buttonBorderShape(.roundedRectangle(radius: 20))
    }.onAppear {
        appState.phase = .editSpace
    }
}

#Preview {
    StickerView()
}
