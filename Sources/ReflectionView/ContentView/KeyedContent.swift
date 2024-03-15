//
//  KeyedContent.swift
//
//
//  Created by p-x9 on 2024/03/15.
//  
//

import Foundation
import SwiftUI

struct KeyedContent<Content: View>: View {
    let key: String
    let content: Content

    init(_ key: String, @ViewBuilder content: () -> Content) {
        self.key = key
        self.content = content()
    }

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(key)
            Text(": ")
            content
        }
    }
}
