//
//  Vector.swift
//  Raptor
//
//  Created by Jordan Davis on 4/24/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

class Vector {
    var x: Float = 0.0
    var y: Float = 0.0
    
    convenience init() {
        self.init(0.0, 0.0)
    }
    
    init (_ px: Float, _ py: Float) {
        x = px
        y = py
    }

}


func add(v1: Vector, v2: Vector) -> Vector{
    return Vector(v1.x + v2.x, v1.y + v2.y)
}

func scalarMultiply(v: Vector, s: Float) -> Vector{
    return Vector(v.x * s , v.y * s)
}