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
    public let value: Any?
    public let mirror: MagicMirror?

    public var structured: Element {
        parse()
    }

    public init(_ value: Any?) {
        self.value = value
        if let value {
            self.mirror = .init(reflecting: value)
        } else {
            self.mirror = nil
        }
    }
}

extension Reflection: CustomStringConvertible {
    public var description: String {
        structured.description
    }

    public var typeDescription: String {
        structured.typeDescription
    }
}

extension Reflection {
    public indirect enum Element {
        case `nil`
        case string(String)
        case hex(any FixedWidthInteger)
        case number(any Numeric)
        case bool(Bool)

        case type(Any.Type)

        case list([Element])
        case dict([(Element, Element)])

        case enumCase(String, [Element])

        case nested([Element])

        case typed(type: Any.Type, element: Element)
        case keyed(key: String, element: Element)
    }
}

extension Reflection.Element: CustomStringConvertible {
    private var tabWidth: Int { 4 }

    public var description: String {
        switch self {
        case .nil:
            return "nil"

        case let .string(v):
            return "\"\(v)\""

        case let .hex(v):
            return "0x" + String(v, radix: 16)

        case let .number(v):
            return "\(v)"

        case let .bool(v):
            return "\(v)"

        case let .type(type):
            return String(reflecting: type).strippedSwiftModulePrefix.strippedCModulePrefix.replacedToCommonSyntaxSugar + ".self"

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

        case let .enumCase(label, values):
            if values.isEmpty { return ".\(label)" }
            if canDisplayOneline {
                return ".\(label)(\(values.map(\.description).joined(separator: ", ")))"
            }
            return """
            .\(label)(
            \(values.map({ $0.description.tabbed(tabWidth) }).joined(separator: "\n"))
            )
            """

        case let .nested(elements):
            if elements.isEmpty { return "{}" }
            return """
            {
            \(elements.map({ $0.description.tabbed(tabWidth) }).joined(separator: "\n"))
            }
            """

        case let .typed(type, element):
            return "<\(shorthandName(of: type))> \(element)"

        case let .keyed(key, element):
            return "\(key): \(element)"
        }
    }
}

extension Reflection {
    private func parse(omitRootType: Bool = false) -> Element {
        guard let mirror,
              let value else {
            return .nil
        }

        let type = mirror.subjectType
        let typeName: String = name(of: type)

        var element: Element?

        switch value {
        case let v as Optional<Any> where typeName.hasPrefix("Optional<"):
            if case let .some(wrapped) = v {
                let element = Reflection(wrapped).parse()
                if case let.typed(type, element) = element {
                    return .typed(type: optionalType(of: type), element: element)
                }
                return element
            } else {
                element = .nil
            }
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
                (Reflection($0.key.base).parse(), Reflection($0.value).parse())
            }
            element = .dict(elements)
        case let v as Array<Any>:
            let elements =  v.map {
                Reflection($0).parse()
            }
            element = .list(elements)
        case let v as Any.Type:
            element = .type(v)
        case let v as NSNumber:
            element = .number(v.decimalValue)
        default: break
        }

        if let element {
            if omitRootType {
                return element
            } else {
                return .typed(type: type, element: element)
            }
        }

        if mirror.displayStyle == .enum {
            let enumCase: Element = {
                if let (label, tuple) = mirror.children.first {
                    let mirror = MagicMirror(reflecting: tuple)
                    if mirror.displayStyle == .tuple {
                        let values: [Element] = mirror
                            .children
                            .map {
                                let element = Reflection($0.value).parse()
                                if let label = $0.label {
                                    return .keyed(key: label, element: element)
                                }
                                return element
                            }
                        return .enumCase(label ?? "", values)
                    } else {
                        return .enumCase(label ?? "", [Reflection(tuple).parse()])
                    }
                } else {
                    return .enumCase("\(value)", [])
                }
            }()

            if omitRootType {
                return enumCase
            } else {
                return .typed(type: type, element: enumCase)
            }
        }

        var nestedElements: [Element] = []

        for case let (key?, value) in mirror.recursiveChildren {
            let element = Reflection(value).parse()
            nestedElements.append(
                .keyed(key: key, element: element)
            )
        }

        if omitRootType {
            return .nested(nestedElements)
        } else {
            return .typed(
                type: type,
                element: .nested(nestedElements)
            )
        }
    }
}

extension Reflection.Element {
    public var typeDescription: String {
        switch self {
        case let .nested(elements):
            if elements.isEmpty { return "{}" }
            return """
            {
            \(elements.map({ $0.typeDescription.tabbed(tabWidth) }).joined(separator: "\n"))
            }
            """

        case let .typed(type, element):
            return "\(shorthandName(of: type)) \(element.typeDescription)"

        case let .keyed(key, element):
            return "\(key): \(element.typeDescription)"

        default:
            return ""
        }
    }
}

extension Reflection.Element {
    package var canDisplayOneline: Bool {
        switch self {
        case let .list(elements): elements.isEmpty
        case let .dict(pairs): pairs.isEmpty
        case let .enumCase(_, values): values.allSatisfy(\.canDisplayOneline)
        case let .nested(elements): elements.isEmpty
        case let .typed(type: _, element: element): element.canDisplayOneline
        case let .keyed(key: _, element: element): element.canDisplayOneline
        default: true
        }
    }
}

extension Sequence where Element == Reflection.Element {
    public var isSameType: Bool {
        guard let root = first(where: { _ in true }) else {
            return true
        }
        return allSatisfy {
            $0.typeDescription == root.typeDescription
        }
    }
}

package func name(of type: Any.Type) -> String {
    String(reflecting: type)
        .strippedSwiftModulePrefix
        .strippedCModulePrefix
}

package func shorthandName(of type: Any.Type) -> String {
    name(of: type)
        .replacedToCommonSyntaxSugar
}
