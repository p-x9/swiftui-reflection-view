//
//  TypeInfoView.swift
//
//
//  Created by p-x9 on 2024/03/30.
//  
//

import SwiftUI
import SwiftUIColor
import Reflection

public struct TypeInfoView: View {
    let reflection: Reflection

    @Environment(\.font) var font
    @Environment(\.reflectionViewConfig) var config

    public init(_ value: Any) {
        self.reflection = .init(value)
    }

    public var body: some View {
        let structured = reflection.structured

        HStack {
            TypeInfoContentView(structured)
        }
        .padding()
    }
}

#Preview {
    let value = Text("hello")
    return ScrollView {
        TypeInfoView(value)
    }
}
