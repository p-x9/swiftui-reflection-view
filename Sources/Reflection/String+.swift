//
//  String+.swift
//
//
//  Created by p-x9 on 2024/03/15.
//  
//

import Foundation

extension String {
    func tabbed(_ width: Int = 4) -> String {
        components(separatedBy: .newlines)
            .map { String(repeating: " ", count: width) + $0 }
            .joined(separator: "\n")
    }
}
