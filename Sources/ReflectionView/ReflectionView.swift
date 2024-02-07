import SwiftUI
import SwiftUIColor

public struct ReflectionView: View {
    let reflection: Reflection

    @Environment(\.font) var font

    public init(_ value: Any) {
        self.reflection = .init(value)
    }

    public var body: some View {
        HStack {
            Text(reflection.description)
                .font(font ?? .system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
        .background(Color.iOS(.secondarySystemFill))
        .cornerRadius(8)
    }
}

#Preview {
    let value = Text("hello")
    return ScrollView {
        ReflectionView(value)
    }
}
