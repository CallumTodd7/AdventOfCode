//
//  Vector.swift
//  
//
//  Created by Callum Todd on 10/12/2022.
//

import Foundation

struct Vector2<Scalar: Hashable>: Hashable {
    var x: Scalar
    var y: Scalar
    
    init(x: Scalar, y: Scalar) {
        self.x = x
        self.y = y
    }
    
    init(_ value: Scalar) {
        self.x = value
        self.y = value
    }
}

extension Vector2 where Scalar: Numeric, Scalar: Strideable, Scalar: Hashable {
    init() {
        self.init(0)
    }
    
    static func +(_ a: Self, _ b: Self) -> Self {
        return .init(x: a.x + b.x, y: a.y + b.y)
    }
    
    static func +(_ a: Self, _ b: Scalar) -> Self {
        return .init(x: a.x + b, y: a.y + b)
    }
    
    static func +(_ a: Scalar, _ b: Self) -> Self {
        return .init(x: a + b.x, y: a + b.y)
    }
    
    static func +=(_ a: inout Self, _ b: Self) {
        a = a + b
    }
    
    static func -(_ a: Self, _ b: Self) -> Self {
        return .init(x: a.x - b.x, y: a.y - b.y)
    }
    
    static func -(_ a: Self, _ b: Scalar) -> Self {
        return .init(x: a.x - b, y: a.y - b)
    }
    
    static func -(_ a: Scalar, _ b: Self) -> Self {
        return .init(x: a - b.x, y: a - b.y)
    }
    
    static func -=(_ a: inout Self, _ b: Self) {
        a = a + b
    }
    
    func clampped(min: Self, max: Self) -> Self {
        precondition(min.x <= max.x && min.y <= max.y, "Min value needs to be larger than Max value")
        return Vector2(
            x: self.x < min.x ? min.x : self.x > max.x ? max.x : self.x,
            y: self.y < min.y ? min.y : self.y > max.y ? max.y : self.y
        )
    }
}
