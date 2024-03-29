//
//  NestedContent.swift
//
//
//  Created by p-x9 on 2024/03/15.
//  
//

import Foundation
import SwiftUI
import Reflection

struct NestedContent: View {
    let type: String?
    let key: String?
    let elements: [Reflection.Element]
    let showTypeInfoOnly: Bool

    @State var isExpanded = false
    @Environment(\.reflectionViewConfig) var config

    init(
        type: String?,
        key: String?,
        _ elements: [Reflection.Element],
        showTypeInfoOnly: Bool = false,
        isExpanded: Bool = false
    ) {
        self.type = type
        self.key = key
        self.elements = elements
        self.showTypeInfoOnly = showTypeInfoOnly
        self._isExpanded = .init(initialValue: isExpanded)
    }

    var body: some View {
        if elements.isEmpty {
            emptyView
        } else {
            VStack {
                HStack(spacing: 2) {
                    if let key {
                        Text("\(key): ")
                    }
                    if let type {
                        Text("\(type) ")
                            .foregroundColor(config.typeColor)
                    }
                    leftBrace
                    if !isExpanded {
                        Text("...")
                            .background(Color.universal(.systemGray).opacity(0.3))
                            .cornerRadius(3.0)
                        rightBrace
                        ItemCountLabel(elements.count)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture { withAnimation { isExpanded.toggle() } }

                if isExpanded {
                    elementsView
                    HStack {
                        rightBrace
                        Spacer()
                    }
                }
            }
        }
    }

    var elementsView: some View {
        VStack {
            ForEach(elements.indices, id: \.self) { index in
                if showTypeInfoOnly{
                    TypeInfoContentView(elements[index])
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                } else {
                    ReflectionContentView(elements[index])
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                }
            }
        }
    }

    var leftBrace: some View {
        Text("{")
            .foregroundColor(.universal(.systemGray))
    }

    var rightBrace: some View {
        Text("}")
            .foregroundColor(.universal(.systemGray))
    }

    var emptyView: some View {
        HStack {
            if let key {
                Text(key)
            }
            Text("{}")
                .foregroundColor(.universal(.systemGray))
        }
    }
}
