import SwiftUI

@available(watchOS 8.0, *)
@available(iOS 15.0, *)

struct PositionReader: ViewModifier {
    let index: Int

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: PreferenceGeometryKey.self,
                        value: [
                            PreferenceGeometryPositionModel(
                                id: index,
                                absolutePosition: geometry.frame(in: .global).origin.y)
                        ]
                    )
                }
            }
    }
}

public struct PreferenceGeometryPositionModel: Equatable {
    public let id: Int
    public let absolutePosition: Double
}

struct PreferenceGeometryKey: PreferenceKey {
    static var defaultValue: [PreferenceGeometryPositionModel] = []
    static func reduce(value: inout [PreferenceGeometryPositionModel],
                       nextValue: () -> [PreferenceGeometryPositionModel]) {
        value.append(contentsOf: nextValue())
    }
}

@available(watchOS 8.0, *)
@available(iOS 15.0, *)
public extension View {
    public func readGeometryPosition(index: Int) -> some View {
        self.modifier(PositionReader(index: index))
    }

    public func catchPosition(completion: @escaping ([PreferenceGeometryPositionModel]) -> Void) -> some View {
        self.onPreferenceChange(PreferenceGeometryKey.self) { preferences in
            completion(preferences)
        }
    }
}
