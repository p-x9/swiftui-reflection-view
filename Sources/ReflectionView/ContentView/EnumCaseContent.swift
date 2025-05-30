//
//  EnumCaseContent.swift
//  ReflectionView
//
//  Created by p-x9 on 2025/05/30
//  
//

import Foundation
import SwiftUI
import Reflection

struct EnumCaseContent: View {
    let type: String?
    let key: String?
    let name: String
    let values: [Reflection.Element]
    let canDisplayOneline: Bool
    let showTypeInfoOnly: Bool

    @State var isExpanded = false
    @Environment(\.reflectionViewConfig) var config

    init(
        type: String?,
        key: String?,
        name: String,
        _ values: [Reflection.Element],
        canDisplayOneline: Bool,
        showTypeInfoOnly: Bool = false,
        isExpanded: Bool = false
    ) {
        self.type = type
        self.key = key
        self.name = name
        self.values = values
        self.canDisplayOneline = canDisplayOneline
        self.showTypeInfoOnly = showTypeInfoOnly
        self._isExpanded = .init(initialValue: isExpanded)
    }

    var body: some View {
        if values.isEmpty {
            simpleCaseView
        } else {
            VStack {
                HStack(spacing: 0) {
                    if let key {
                        Text("\(key):")
                            .padding(.trailing, 2)
                    }
                    if let type {
                        Text("\(type)")
                            .foregroundColor(config.typeColor)
                    }
                    Text("." + name)
                        .foregroundColor(config.constantColor)
                    leftParen
                    if !isExpanded && !canDisplayOneline {
                        Text("...")
                            .background(Color.universal(.systemGray).opacity(0.3))
                            .cornerRadius(3.0)
                        rightParen
                        ItemCountLabel(values.count)
                    }
                    if canDisplayOneline {
                        valuesView
                        rightParen
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture { withAnimation { isExpanded.toggle() } }

                if isExpanded && !canDisplayOneline {
                    valuesView
                    HStack {
                        rightParen
                        Spacer()
                    }
                }
            }
        }
    }

    @ViewBuilder
    var valuesView: some View {
        if canDisplayOneline {
            HStack {
                _valuesView
            }
        } else {
            VStack {
                _valuesView
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
            }
        }
    }

    var _valuesView: some View {
        ForEach(values.indices, id: \.self) { index in
            if showTypeInfoOnly{
                TypeInfoContentView(values[index])
            } else {
                ReflectionContentView(values[index])
            }
        }
    }

    var leftParen: some View {
        Text("(")
            .foregroundColor(.universal(.systemGray))
    }

    var rightParen: some View {
        Text(")")
            .foregroundColor(.universal(.systemGray))
    }

    var simpleCaseView: some View {
        HStack(spacing: 0) {
            if let key {
                Text("\(key):")
                    .padding(.trailing, 2)
            }
            if let type {
                Text("\(type)")
                    .foregroundColor(config.typeColor)
            }
            Text("." + name)
                .foregroundColor(config.constantColor)
        }
    }
}
