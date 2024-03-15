//
//  Config.swift
//
//
//  Created by p-x9 on 2024/03/15.
//  
//

import Foundation
import SwiftUI

public struct Config {
    let keywordColor: Color
    let stringColor: Color
    let numberColor: Color
    let typeColor: Color
}

extension Config {
    public static var `default`: Config {
        .init(
            keywordColor: .init("default/keyword", bundle: .module),
            stringColor: .init("default/string", bundle: .module),
            numberColor: .init("default/number", bundle: .module),
            typeColor: .init("default/type", bundle: .module)
        )
    }
}

public struct ReflectionViewConfigKey: EnvironmentKey {
    public typealias Value = Config

    public static var defaultValue: Config {
        .default
    }
}

extension EnvironmentValues {
    public var reflectionViewConfig: Config {
        get {
            self[ReflectionViewConfigKey.self]
        }
        set {
            self[ReflectionViewConfigKey.self] = newValue
        }
    }
}
