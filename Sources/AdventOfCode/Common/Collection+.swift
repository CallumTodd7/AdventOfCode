//
//  Collection+.swift
//  
//
//  Created by Callum Todd on 04/12/2022.
//

import Foundation

extension Collection {
    func commonItems<T>() -> Set<T> where Element == Set<T>, T: Hashable {
        let first = self.first!
        let rest = self.dropFirst()
        return rest.reduce(into: first, { $0.formIntersection($1) })
    }
}
