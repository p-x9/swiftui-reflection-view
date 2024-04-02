//
//  DictContent.swift
//
//
//  Created by p-x9 on 2024/03/15.
//  
//

import Foundation
import SwiftUI
import Reflection

struct DictContent: View {
    let type: String?
    let key: String?
    let elements: [(key: Reflection.Element, value: Reflection.Element)]
    let showTypeInfoOnly: Bool

    @State var isExpanded = false
    @Environment(\.reflectionViewConfig) var config

    init(
        type: String?,
        key: String?,
        _ elements: [(Reflection.Element, Reflection.Element)],
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
        if elements.isEmpty || (showTypeInfoOnly && !elements.canShowChildTypeInfo) {
            emptyView
        } else {
            VStack {
                HStack(spacing: 2) {
                    if let key {
                        Text("\(key):")
                    }
                    if let type {
                        Text("\(type)")
                            .foregroundColor(config.typeColor)
                    }
                    leftSquare
                    if !isExpanded {
                        Text("...")
                            .background(Color.universal(.systemGray).opacity(0.3))
                            .cornerRadius(3.0)
                        rightSquare
                        ItemCountLabel(showTypeInfoOnly ? 1 : elements.count)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture { withAnimation { isExpanded.toggle() } }
                if isExpanded {
                    elementsView
                    HStack {
                        rightSquare
                        Spacer()
                    }
                }
            }
        }
    }

    @ViewBuilder
    var elementsView: some View {
        let keys = elements.map(\.key)
        let values = elements.map(\.value)
        if showTypeInfoOnly,
           let key = keys.first, let value = values.first {
            VStack {
                HStack(spacing: 0) {
                    TypeInfoContentView(key)
                        .padding(.leading, 16)
                    colon
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                TypeInfoContentView(value)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 32)
            }
        } else {
            VStack {
                ForEach(elements.indices, id: \.self) { index in
                    VStack {
                        HStack(spacing: 0) {
                            ReflectionContentView(elements[index].key)
                                .padding(.leading, 16)
                            colon
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        ReflectionContentView(elements[index].value)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 32)
                    }
                }
            }
        }
    }

    var leftSquare: some View {
        Text("[")
            .foregroundColor(.universal(.systemGray))
    }

    var rightSquare: some View {
        Text("]")
            .foregroundColor(.universal(.systemGray))
    }

    var colon: some View {
        Text(":")
            .foregroundColor(.universal(.systemGray))
    }

    var emptyView: some View {
        HStack(spacing: 2) {
            if let key {
                Text("\(key):")
            }
            if let type {
                Text(type)
                    .foregroundColor(config.typeColor)
            }
            if !showTypeInfoOnly {
                Text("[:]")
                    .foregroundColor(.universal(.systemGray))
            }
        }
    }
}

extension [(key: Reflection.Element, value: Reflection.Element)] {
    fileprivate var canShowChildTypeInfo: Bool {
        guard !isEmpty else { return false }
        let keys = map(\.key)
        let values = map(\.value)
        return keys.isSameType && values.isSameType
    }
}
