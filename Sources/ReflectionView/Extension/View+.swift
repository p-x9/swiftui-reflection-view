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
}
