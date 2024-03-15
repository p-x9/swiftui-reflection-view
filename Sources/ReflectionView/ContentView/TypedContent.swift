//
//  TypedContent.swift
//
//
//  Created by p-x9 on 2024/03/15.
//  
//

import Foundation
import SwiftUI

struct TypedContent<Content: View>: View {
    let type: String
    let content: Content

    @Environment(\.reflectionViewConfig) var config

    init(_ type: String, @ViewBuilder content: () -> Content) {
        self.type = type
        self.content = content()
    }

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(type)
                .foregroundColor(config.typeColor)
            Text(" ")
            content
        }
    }
}
