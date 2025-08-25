//
//  MagicMirror+.swift
//  ReflectionView
//
//  Created by p-x9 on 2025/08/25
//  
//

import MagicMirror

extension MagicMirror {
    var recursiveChildren: Children {
        if let superclassMirror {
            AnyCollection(
                [superclassMirror.recursiveChildren, children].joined()
            )
        } else {
            children
        }
    }
}
