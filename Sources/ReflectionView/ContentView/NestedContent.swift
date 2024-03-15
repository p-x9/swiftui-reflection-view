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

    @State var isExpanded = false
    @Environment(\.reflectionViewConfig) var config

    init(type: String?, key: String?, _ elements: [Reflection.Element], isExpanded: Bool = false) {
        self.type = type
        self.key = key
        self.elements = elements
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
                        rightBrace
                        Text("\(elements.count) items")
                            .foregroundColor(.universal(.systemGray))
                            .scaleEffect(0.8)
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
                ReflectionContentView(elements[index])
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
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
