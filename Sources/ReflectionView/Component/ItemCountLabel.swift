//
//  ItemCountLabel..swift
//
//
//  Created by p-x9 on 2024/03/16.
//  
//

import Foundation
import SwiftUI
import SwiftUIColor

struct ItemCountLabel: View {
    let count: Int

    init(_ count: Int) {
        self.count = count
    }

    var body: some View {
        Text("\(count) items")
            .foregroundColor(.universal(.systemGray))
            .scaleEffect(0.8)
    }
}
