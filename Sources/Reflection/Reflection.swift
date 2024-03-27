//
//  Reflection.swift
//
//
//  Created by p-x9 on 2024/02/07.
//  
//

import Foundation
import MagicMirror

public  struct Reflection {
    public let value: Any
    public let mirror: MagicMirror

    public var structured: Element {
        parse()
    }

    public init(_ value: Any) {
        self.value = value
        self.mirror = .init(reflecting: value)
    }
}

extension Reflection: CustomStringConvertible {
    public var description: String {
        structured.description
    }
}

extension Reflection {
    public indirect enum Element {
        case string(String)
        case hex(any FixedWidthInteger)
        case number(any Numeric)
        case bool(Bool)

        case list([Element])
        case dict([(Element, Element)])
        case nested([Element])

        case typed(type: String, element: Element)
        case keyed(key: String, element: Element)
    }
}

extension Reflection.Element: CustomStringConvertible {
    private var tabWidth: Int { 4 }

    public var description: String {
        switch self {
        case let .string(v):
            return "\"\(v)\""

        case let .hex(v):
            return "0x" + String(v, radix: 16)

        case let .number(v):
            return "\(v)"

        case let .bool(v):
            return "\(v)"

        case let .list(elements):
            if elements.isEmpty { return "[]" }
            return """
            [
            \(elements.map({ $0.description.tabbed(tabWidth) }).joined(separator: "\n"))
            ]
            """

        case let .dict(elements):
            if elements.isEmpty { return "[:]" }
            return """
            [
            \(elements.map({ $0.0.description.tabbed(tabWidth) + ":\n" + $0.1.description.tabbed(2 * tabWidth) }).joined(separator: "\n"))
            ]
            """

        case let .nested(elements):
            if elements.isEmpty { return "{}" }
            return """
            {
            \(elements.map({ $0.description.tabbed(tabWidth) }).joined(separator: "\n"))
            }
            """

        case let .typed(type, element):
            return "<\(type)> \(element)"

        case let .keyed(key, element):
            return "\(key): \(element)"
        }
    }
}

extension Reflection {
    private func parse() -> Element {
        let type = "\(mirror.subjectType)"
        var element: Element?

        switch value {
        case let v as any FixedWidthInteger:
            element = .hex(v)
        case let v as any Numeric:
            element = .number(v)
        case let v as String:
            element = .string(v)
        case let v as Bool:
            element = .bool(v)
        case let v as Dictionary<AnyHashable, Any>:
            let elements =  v.map {
                (Reflection($0.key).parse(), Reflection($0.value).parse())
            }
            element = .dict(elements)
        case let v as Array<Any>:
            let elements =  v.map {
                Reflection($0).parse()
            }
            element = .list(elements)
        default: break
        }

        if let element {
            return .typed(type: type, element: element)
        }

        var nestedElements: [Element] = []

        for case let (key?, value) in mirror.children {
            let element: Element
            switch value {
            case let v as any FixedWidthInteger:
                element = .hex(v)
            case let v as any Numeric:
                element = .number(v)
            case let v as String:
                element = .string(v)
            case let v as Bool:
                element = .bool(v)
            case let v as Dictionary<AnyHashable, Any>:
                let elements =  v.map {
                    (Reflection($0.key).parse(), Reflection($0.value).parse())
                }
                element = .dict(elements)
            case let v as Array<Any>:
                let elements =  v.map {
                    Reflection($0).parse()
                }
                element = .list(elements)
            default:
                let reflection = Reflection(value)
                element = reflection.parse()
            }

            nestedElements.append(
                .keyed(key: key, element: element)
            )
        }

        return .typed(
            type: type,
            element: .nested(nestedElements)
        )
    }
}
