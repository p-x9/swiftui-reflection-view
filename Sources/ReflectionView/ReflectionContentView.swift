//
//  ReflectionContentView.swift
//
//
//  Created by p-x9 on 2024/03/15.
//  
//

import Foundation
import SwiftUI
import Reflection

struct ReflectionContentView: View {
    let element: Reflection.Element
    let isRoot: Bool
    @Environment(\.reflectionViewConfig) var config

    @Environment(\.reflectionViewConfig.itemLimitForExpansion)
    var itemLimitForExpansion

    init(_ element: Reflection.Element, isRoot: Bool = false) {
        self.element = element
        self.isRoot = isRoot
    }

    var body: some View {
        switch element {
        case .nil:
            Text("nil")
                .foregroundColor(config.keywordColor)

        case let .string(v):
            Text("\"\(v)\"")
                .foregroundColor(config.stringColor)

        case let .hex(v):
            Text("0x" + String(v, radix: 16))
                .foregroundColor(config.numberColor)

        case let .number(v):
            let string = "\(v)"
            Text(string)
                .foregroundColor(config.numberColor)

        case let .bool(v):
            Text(v.description)
                .foregroundColor(config.keywordColor)

        case let .type(v):
            HStack(spacing: 0) {
                Text(typeName(of: v))
                    .foregroundColor(config.typeColor)
                Text(".")
                Text("self")
                    .foregroundColor(config.keywordColor)
            }

        case let .list(elements):
            ListContent(
                type: nil,
                key: nil,
                elements,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .dict(elements):
            DictContent(
                type: nil,
                key: nil,
                elements,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .enumCase(name, values):
            EnumCaseContent(
                type: nil,
                key: nil,
                name: name,
                values,
                canDisplayOneline: element.canDisplayOneline,
                isExpanded: values.count <= itemLimitForExpansion
            )

        case let .nested(elements):
            NestedContent(
                type: nil,
                key: nil,
                elements,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .keyed(key, element: .list(elements)):
            ListContent(
                type: nil,
                key: key,
                elements,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .keyed(key, element: .dict(elements)):
            DictContent(
                type: nil,
                key: key,
                elements,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .keyed(key, element: .enumCase(name, values)):
            EnumCaseContent(
                type: nil,
                key: key,
                name: name,
                values,
                canDisplayOneline: element.canDisplayOneline,
                isExpanded: values.count <= itemLimitForExpansion
            )

        case let .keyed(key, element: .nested(elements)):
            NestedContent(
                type: nil,
                key: key,
                elements,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .keyed(key, element: .typed(type, .nested(elements))):
            NestedContent(
                type: typeName(of: type),
                key: key,
                elements,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .keyed(key, element: .typed(type, .list(elements))):
            ListContent(
                type: typeName(of: type),
                key: key,
                elements,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .keyed(key, element: .typed(type, .dict(elements))):
            DictContent(
                type: typeName(of: type),
                key: key,
                elements,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .keyed(key, element: .typed(type, .enumCase(name, values))):
            EnumCaseContent(
                type: typeName(of: type),
                key: key,
                name: name,
                values,
                canDisplayOneline: element.canDisplayOneline,
                isExpanded: values.count <= itemLimitForExpansion
            )

        case let .typed(type, element: .nested(elements)):
            NestedContent(
                type: typeName(of: type),
                key: nil,
                elements,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .typed(type, element: .list(elements)):
            ListContent(
                type: typeName(of: type),
                key: nil,
                elements,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .typed(type, element: .dict(elements)):
            DictContent(
                type: typeName(of: type),
                key: nil,
                elements,
                isExpanded: elements.count <= itemLimitForExpansion
            )

        case let .typed(type, element: .enumCase(name, values)):
            EnumCaseContent(
                type: typeName(of: type),
                key: nil,
                name: name,
                values,
                canDisplayOneline: element.canDisplayOneline,
                isExpanded: values.count <= itemLimitForExpansion
            )

        case let .typed(type, element):
            TypedContent(typeName(of: type)) {
                ReflectionContentView(element)
            }

        case let .keyed(key, element):
            KeyedContent(key) {
                ReflectionContentView(element)
            }
        }
    }
}

extension ReflectionContentView {
    func typeName(of type: Any.Type) -> String {
        if isRoot {
            name(of: type)
                .replacedToOptionalSyntaxSugar
        } else {
            shorthandName(of: type)
        }
    }
}
