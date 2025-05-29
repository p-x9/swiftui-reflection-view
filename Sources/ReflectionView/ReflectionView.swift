import SwiftUI
import SwiftUIColor
import Reflection

public struct ReflectionView: View {
    let reflection: Reflection

    @Environment(\.font) var font
    @Environment(\.reflectionViewConfig) var config

    public init(_ value: Any) {
        self.reflection = .init(value)
    }

    public var body: some View {
        let structured = reflection.structured
        HStack {
            ReflectionContentView(structured, isRoot: true)
        }
        .padding()
    }
}

#Preview {
    let value = Text("hello")
    return ScrollView {
        ReflectionView(value)
    }
}
