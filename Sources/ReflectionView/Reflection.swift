//
//  Reflection.swift
//
//
//  Created by p-x9 on 2024/02/07.
//  
//

import Foundation
import MagicMirror

struct Reflection {
    let value: Any
    let mirror: MagicMirror

    init(_ value: Any) {
        self.value = value
        self.mirror = .init(reflecting: value)
    }
}

extension Reflection: CustomStringConvertible {
    private var tab: String { "  " }
    var description: String {
        var ret = "<\(mirror.subjectType)> "

        switch value {
        case let v as any FixedWidthInteger:
            return ret + ": 0x" + String(v, radix: 16)
        case _ as any Numeric:
            return ret + ": \(value)"
        case _ as String:
            return ret + ": \"\(value)\""
        case _ as Bool:
            return ret + ": \(value)"
        default: break
        }

        ret += "{"

        for case let (label?, value) in mirror.children {
            ret += "\n\(tab)" + label + ": "

            var childDescription: String
            switch value {
            case let v as any FixedWidthInteger:
                childDescription = "0x" + String(v, radix: 16)
            case _ as any Numeric: childDescription = "\(value)"
            case _ as String: childDescription = "\"\(value)\""
            case _ as Bool: childDescription = "\(value)"
            default:
                let reflection = Reflection(value)
                let description = reflection
                    .description
                    .components(separatedBy: .newlines)
                    .enumerated()
                    .map { $0 > 0 ? "\(tab)" + $1 : $1 }
                    .joined(separator: "\n")
                childDescription = description
            }

            ret += childDescription
        }

        ret += "\n}"

        return ret
    }
}
