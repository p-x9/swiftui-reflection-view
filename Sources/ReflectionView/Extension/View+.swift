//
//  View+.swift
//
//
//  Created by p-x9 on 2024/03/15.
//  
//

import Foundation
import SwiftUI

extension View {
    public func reflectionConfig(_ config: Config) -> some View {
        self.environment(\.reflectionViewConfig, config)
    }

    public func reflectionItemLimit(_ limit: Int) -> some View {
        self.environment(\.reflectionViewConfig.itemLimitForExpansion, limit)
    }
}

extension View {
    func set<T>(_ value: T, for keyPath: WritableKeyPath<Self, T>) -> Self {
        var new = self
        new[keyPath: keyPath] = value
        return new
    }
}
