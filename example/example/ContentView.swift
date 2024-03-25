//
//  ContentView.swift
//  example
//
//  Created by Evgeniy Timofeev on 25.03.2024.
//

import SwiftUI
import Side_Fading_appearing

struct CellView {
    let id: Int
    let emoji: String
}

enum ContentType {
    case single(CellView)
    case double(CellView, CellView)
}

struct ContentView: View {
    var content: [ContentType] {
        cells()
    }
    @State var cellCondition: [Int: Bool] = [:]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(content.indices, id: \.self) { index in
                    switch content[index] {
                    case .single(let model):
                        cell(model)
                    case let .double(model, model2):
                        HStack {
                            cell(model)
                            cell(model2)
                        }
                    }
                }
            }
        }
        .catchPosition { preferences in
            withAnimation(.smooth) {
                preferences.forEach {
                    let cellPosition: Double = $0.absolutePosition
                    cellCondition[$0.id] = cellPosition <= 700 && cellPosition >= 50
                }
            }
        }
    }
    
    func isCellAppeared(_ index: Int) -> Bool {
        guard let condition = cellCondition[index] else {return false}
        return condition
    }
    
    func cell(_ model: CellView) -> some View {
        RoundedRectangle(cornerRadius: 25.0)
            .frame(width: UIScreen.main.bounds.width / 2, height: 100)
            .overlay(Text("\(model.emoji)"))
            .readGeometryPosition(index: model.id)
            .offset(x: isCellAppeared(model.id) ? 0 : -500)
    }
    
    func cells() -> [ContentType] {
        var container: [ContentType] = []
        var index = 0
        while index < 100 {
            if index + 1 < 100 {
                container.append(.double(
                    CellView(id: index, emoji: String(Character(UnicodeScalar(index + 0x1f600)!))),
                    CellView(id: index + 1, emoji: String(Character(UnicodeScalar((index + 1) + 0x1f600)!)))
                ))
                index += 2
            }
            
            if index < 100 {
                container.append(.single(CellView(id: index, emoji: String(Character(UnicodeScalar(index + 0x1f600)!)))))
                index += 1
            }
        }
        return container
    }
}

#Preview {
    ContentView()
}
