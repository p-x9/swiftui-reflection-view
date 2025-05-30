//
//  Util.swift
//  ReflectionView
//
//  Created by p-x9 on 2025/05/31
//  
//

import Foundation

func optionalType(of type: Any.Type) -> Any.Type {
    _openExistential(type, do: _optionalType(_:))
}

func _optionalType<T>(_ type: T.Type) -> Any.Type {
    Optional<T>.self
}
