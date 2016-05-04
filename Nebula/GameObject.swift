//
//  GameObject.swift
//  Nebula
//
//  Created by Jordan Davis on 5/1/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import Foundation


//MARK: - Game Object classes
class GameObject: Sprite {
    var startTime: Double = 0.0
    var endTime: Double = 0.0
    var path: [Vector] = []
    var needsDeleted: Bool = false
    var _canShoot: Double = 0.0
    
    
    
    //MARK: - MOVES
    //0 = Top -> Bottom - straight
    //1 = Right -> Left - straight
    //2 = Left -> Right - stright
    //3 = Left -> Middle -> Return Left
    //4 = Right -> Middle -> Return Right
    //5 = V Dive - TopLeft -> Middle -> TopRight
    //6 = V Dive - TopRight -> Middle -> TopLeft
    //7 = Diagonal Dive - TopLeft -> Middle -> TopRight
    //8 = Diagonal Dive - TopRight -> Middle -> TopLeft
    //9 C from right
    //10 C from left
    //11 S from left
    //12 S from right
    func generateRandomPath(direction: Int){
        let location = Vector(self.position.x , self.position.y)
        if(direction == 0){
            while (location.y > -1.1 - self.height){ // Top -> Bottom Stright
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + shake, location.y  - self._movementSpeed)
                self.path.append(p)
                location.y -= self._movementSpeed
            }
        } else if (direction == 1){ // Right -> Left - Stright
            while (location.x > -0.7){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x - self._movementSpeed, location.y + shake)
                self.path.append(p)
                location.x -= self._movementSpeed
            }
            
        } else if (direction == 2){ //Left -> Right - Straight
            while (location.x < 0.7){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + self._movementSpeed, location.y + shake)
                self.path.append(p)
                location.x += self._movementSpeed
            }
            
        } else if (direction == 3){// Left -> Middle -> Return Left
            while (location.x < -0.09){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + self._movementSpeed, location.y + shake)
                self.path.append(p)
                location.x += self._movementSpeed
            }
            while (location.x > -0.7){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x - self._movementSpeed, location.y + shake)
                self.path.append(p)
                location.x -= self._movementSpeed
            }
        } else if (direction == 4){ //Right -> Middle -> Return Right
            while (location.x > 0.09){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x - self._movementSpeed + shake, location.y)
                self.path.append(p)
                location.x -= self._movementSpeed
            }
            while (location.x < 0.7){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + self._movementSpeed + shake, location.y)
                self.path.append(p)
                location.x += self._movementSpeed
            }
            
        } else if (direction == 5){ // V Dive - TopLeft -> Middle -> TopRight
            while (location.x < 0.0){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + self._movementSpeed + shake, location.y - self._movementSpeed + shake )
                self.path.append(p)
                location.x += self._movementSpeed
                location.y -= self._movementSpeed
            }
            while (location.x < 0.7 && location.y < 1.1){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + self._movementSpeed + shake, location.y + self._movementSpeed + shake )
                self.path.append(p)
                location.x += self._movementSpeed
                location.y += self._movementSpeed
            }
        } else if (direction == 6){ // V Dive - TopRight -> Middle -> TopLeft
            while (location.x > 0.0 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x - self._movementSpeed + shake, location.y - self._movementSpeed + shake )
                self.path.append(p)
                location.x -= self._movementSpeed
                location.y -= self._movementSpeed
            }
            while (location.x > -0.7 && location.y < 1.1){
                let shake:Float = 0 // (Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x - self._movementSpeed + shake, location.y + self._movementSpeed + shake )
                self.path.append(p)
                location.x -= self._movementSpeed
                location.y += self._movementSpeed
            }
        } else if (direction == 7) { //Diagonal Dive TopLeft -> Right
            while (location.x < 0.0 || !(location.y <= -0.25)){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + self._movementSpeed + shake, location.y - self._movementSpeed + shake )
                self.path.append(p)
                location.x += self._movementSpeed
                location.y -= self._movementSpeed
            }
            while (location.x < 0.7 && location.y < 1.1){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + self._movementSpeed + shake, location.y + self._movementSpeed + shake )
                self.path.append(p)
                location.x += self._movementSpeed
                location.y += self._movementSpeed
            }
        } else if (direction == 8){ // Diagonal Dive - TopRight -> Middle -> TopLeft
            while (location.x > 0.0 || !(location.y <= -0.25) ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x - self._movementSpeed + shake, location.y - self._movementSpeed + shake )
                self.path.append(p)
                location.x -= self._movementSpeed
                location.y -= self._movementSpeed
            }
            while (location.x > -0.7 && location.y < 1.1){
                let shake:Float = 0 // (Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x - self._movementSpeed + shake, location.y + self._movementSpeed + shake )
                self.path.append(p)
                location.x -= self._movementSpeed
                location.y += self._movementSpeed
            }
        } else if (direction == 9){ // C Right -> Middle -> Down -> Right
            while (location.x > 0.1 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x - self._movementSpeed + shake, location.y + shake)
                self.path.append(p)
                location.x -= self._movementSpeed
            }
            while (location.y > 0.1){
                let shake:Float = 0 // (Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + shake, location.y - self._movementSpeed + shake )
                self.path.append(p)
                location.y -= self._movementSpeed
            }
            while (location.x < 0.7 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + self._movementSpeed + shake, location.y + shake)
                self.path.append(p)
                location.x += self._movementSpeed
            }
        } else if (direction == 10){ // C Left -> Middle -> Down -> Left
            while (location.x < -0.1 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + self._movementSpeed + shake, location.y + shake)
                self.path.append(p)
                location.x += self._movementSpeed
            }
            while (location.y > 0.1){
                let shake:Float = 0 // (Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + shake, location.y - self._movementSpeed + shake )
                self.path.append(p)
                location.y -= self._movementSpeed
            }
            while (location.x > -0.7 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x - self._movementSpeed + shake, location.y + shake)
                self.path.append(p)
                location.x -= self._movementSpeed
            }
            
        } else if (direction == 11){ // S Left -> Right -> Down -> Left -> Down -> Repeat
            while (location.x < 0.4 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + self._movementSpeed + shake, location.y + shake)
                self.path.append(p)
                location.x += self._movementSpeed
            }
            var drop = location.y - 0.2
            while (location.y > drop){
                let shake:Float = 0 // (Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + shake, location.y - self._movementSpeed + shake )
                self.path.append(p)
                location.y -= self._movementSpeed
            }
            while (location.x > -0.4 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x - self._movementSpeed + shake, location.y + shake)
                self.path.append(p)
                location.x -= self._movementSpeed
            }
            drop = location.y - 0.2
            while (location.y > drop){
                let shake:Float = 0 // (Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + shake, location.y - self._movementSpeed + shake )
                self.path.append(p)
                location.y -= self._movementSpeed
            }
            while (location.x < 0.4 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + self._movementSpeed + shake, location.y + shake)
                self.path.append(p)
                location.x += self._movementSpeed
            }
            drop = location.y - 0.2
            while (location.y > drop){
                let shake:Float = 0 // (Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + shake, location.y - self._movementSpeed + shake )
                self.path.append(p)
                location.y -= self._movementSpeed
            }
            while (location.x > -0.4 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x - self._movementSpeed + shake, location.y + shake)
                self.path.append(p)
                location.x -= self._movementSpeed
            }
            drop = location.y - 0.2
            while (location.y > drop){
                let shake:Float = 0 // (Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + shake, location.y - self._movementSpeed + shake )
                self.path.append(p)
                location.y -= self._movementSpeed
            }
            while (location.x < 0.7 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + self._movementSpeed + shake, location.y + shake)
                self.path.append(p)
                location.x += self._movementSpeed
            }
        } else if (direction == 12){ // S From Right -> Left -> Down -> Right -> Down -> Repeat
            while (location.x > -0.4 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x - self._movementSpeed + shake, location.y + shake)
                self.path.append(p)
                location.x -= self._movementSpeed
            }
            var drop = location.y - 0.2
            while (location.y > drop){
                let shake:Float = 0 // (Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + shake, location.y - self._movementSpeed + shake )
                self.path.append(p)
                location.y -= self._movementSpeed
            }
            while (location.x < 0.4 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + self._movementSpeed + shake, location.y + shake)
                self.path.append(p)
                location.x += self._movementSpeed
            }
            drop = location.y - 0.2
            while (location.y > drop){
                let shake:Float = 0 // (Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + shake, location.y - self._movementSpeed + shake )
                self.path.append(p)
                location.y -= self._movementSpeed
            }
            while (location.x > -0.4 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x - self._movementSpeed + shake, location.y + shake)
                self.path.append(p)
                location.x -= self._movementSpeed
            }
            drop = location.y - 0.2
            while (location.y > drop){
                let shake:Float = 0 // (Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + shake, location.y - self._movementSpeed + shake )
                self.path.append(p)
                location.y -= self._movementSpeed
            }
            while (location.x < 0.4 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + self._movementSpeed + shake, location.y + shake)
                self.path.append(p)
                location.x += self._movementSpeed
            }
            drop = location.y - 0.2
            while (location.y > drop){
                let shake:Float = 0 // (Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x + shake, location.y - self._movementSpeed + shake )
                self.path.append(p)
                location.y -= self._movementSpeed
            }
            while (location.x > -0.7 ){
                let shake: Float = 0.0 //(Float(drand48() / 100) - 0.5 / 100) * 0.5
                let p = Vector(location.x - self._movementSpeed + shake, location.y + shake)
                self.path.append(p)
                location.x -= self._movementSpeed
            }
            
        }
            
        else {
            self.path.append(Vector(-2.0,-2.0))
            print("Path doesnt exit  \(direction)")
        }
    }
    
}
