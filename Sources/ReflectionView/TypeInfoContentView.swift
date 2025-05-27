//
//  TypeInfoContentView.swift
//
//
//  Created by p-x9 on 2024/03/30.
//  
//

import Foundation
import SwiftUI

import Reflection

struct TypeInfoContentView: View {
    let element: Reflection.Element
    @Environment(\.reflectionViewConfig) var config

    @Environment(\.reflectionViewConfig.itemLimitForExpansion)
    var itemLimitForExpansion

    init(_ element: Reflection.Element) {
        self.element = element
    }

    var body: some View {
        switch element {
        case let .list(elements):
            ListContent(
                type: nil,
                key: nil,
                elements,
                showTypeInfoOnly: true,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .dict(elements):
            DictContent(
                type: nil,
                key: nil,
                elements,
                showTypeInfoOnly: true,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .nested(elements):
            NestedContent(
                type: nil,
                key: nil,
                elements,
                showTypeInfoOnly: true,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .keyed(key, element: .list(elements)):
            ListContent(
                type: nil,
                key: key,
                elements,
                showTypeInfoOnly: true,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .keyed(key, element: .dict(elements)):
            DictContent(
                type: nil,
                key: key,
                elements,
                showTypeInfoOnly: true,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .keyed(key, element: .nested(elements)):
            NestedContent(
                type: nil,
                key: key,
                elements,
                showTypeInfoOnly: true,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .keyed(key, element: .typed(type, .nested(elements))):
            NestedContent(
                type: shorthandName(of: type),
                key: key,
                elements,
                showTypeInfoOnly: true,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .keyed(key, element: .typed(type, .list(elements))):
            ListContent(
                type: shorthandName(of: type),
                key: key,
                elements,
                showTypeInfoOnly: true,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .keyed(key, element: .typed(type, .dict(elements))):
            DictContent(
                type: shorthandName(of: type),
                key: key,
                elements,
                showTypeInfoOnly: true,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .typed(type, element: .nested(elements)):
            NestedContent(
                type: shorthandName(of: type),
                key: nil,
                elements,
                showTypeInfoOnly: true,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .typed(type, element: .list(elements)):
            ListContent(
                type: shorthandName(of: type),
                key: nil,
                elements,
                showTypeInfoOnly: true,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .typed(type, element: .dict(elements)):
            DictContent(
                type: shorthandName(of: type),
                key: nil,
                elements,
                showTypeInfoOnly: true,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .typed(type, element):
            TypedContent(shorthandName(of: type)) {
                TypeInfoContentView(element)
            }

        case let .keyed(key, element):
            KeyedContent(key) {
                TypeInfoContentView(element)
            }
        default:
            EmptyView()
        }
    }
}

