//
//  Game.swift
//  Nebula
//
//  Created by Jordan Davis on 4/29/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import GLKit


class Game {
    
    //MARK: - DATA MEMBERS
    var _paused: Bool = false
    var _gameOver: Bool = false
    var _gameEnemy: [GameObject] = []
    var _gameMyBullets: [GameObject] = []
    var _gameEnemyBullets: [GameObject] = []
    var _gameCollisions: [GameObject] = []
    
    var _score = 0
    var _highScores: [Int] = [0,0,0,0,0]
    var _highScoresNames: [String] = ["n/a","n/a","n/a","n/a","n/a"]
    var _ranking = -1
    var _setBoss1 = false
    var _setBoss2 = false
    var _setBoss3 = false

    var _animation = 0.0
    var _moveLevel = 0.0
    var _time: Double = 0.0
    var _canShoot: Double = 0.0
    var _enemyCanShoot: Double = 2.0
    var _level = 1
    var _myShip: Sprite? = nil
    var levelOneNeedsSetup = true
    var levelTwoNeedsSetup = false
    var levelThreeNeedsSetup = false
    var showBossSheild = false
    var bossDefeated = false
    var loadNextLevel = false
    var bossLife = 300
    var myLife = 100
    var showLevelMessage = true
    var endLevelWaitTime = 0.0
    
    
    var score: Int{ //Dont let the score reach one million
        get {
            if(_score > 999999){
                _score = 999999
            }
            return _score}
    }
    
    //MARK: - SCORES
    
    //checks if score belongs to high score
    //if it does, it adds it to the list
    func addNewScore() -> Bool {
        var winner = false
        if (_score > _highScores[0]){
            _highScores.insert(_score, atIndex: 0)
            _ranking = 1
        } else if (_score > _highScores[1]){
            _highScores.insert(_score, atIndex: 1)
            _ranking = 2
        } else if (_score > _highScores[2]){
            _highScores.insert(_score, atIndex: 2)
            _ranking = 3
        } else if (_score > _highScores[3]){
            _highScores.insert(_score, atIndex: 3)
            _ranking = 4
        } else if(_score > _highScores[4]){
            _highScores.insert(_score, atIndex: 4)
            _ranking = 5
        }
        
        if(_highScores.count > 5){
            _highScores.removeLast()
            winner = true
            writeToFile()
        }
        
        
        return winner
    }
    
    //adds new username to high scores list
    func addNewName(name: String) {
        if (_ranking == 1){
            _highScoresNames.insert(name, atIndex: 0)
        } else if (_ranking == 2){
            _highScoresNames.insert(name, atIndex: 1)
        } else if (_ranking == 3){
            _highScoresNames.insert(name, atIndex: 2)
        } else if (_ranking == 4){
            _highScoresNames.insert(name, atIndex: 3)
        } else if(_ranking == 5){
            _highScoresNames.insert(name, atIndex: 4)
        }
        
        if(_highScoresNames.count > 5){
            _highScoresNames.removeLast()
            writeToFile()
        }
        
    }
    
    //updates score for current level
    private func increaseScore() {
        if(_level == 1){
            _score += 10
        } else if (_level == 2){
            _score += 100
        } else if(_level == 3){
            _score += 1000
        }
    }
    
    //damages players sheild and live
    private func decreaseLife(){
         myLife -= 10
        if(myLife <= 0){
            _gameOver = true
        }
    }
    
    private func decreaseBossLife(){
        if(_level == 1){
            bossLife -= 30
        } else if (_level == 2){
            bossLife -= 20
        } else if (_level == 3 ){
            bossLife -= 10
            if(bossLife == 0){
                _gameOver = true
            }
        }
    }

    //MARK: - UPDATES
    
    //updates the location of all current enemy ships
    //If no path remains, removes sprite
    //If endTime expires, removes sprite
    //If object destroyed, removes object
    private func updateGameEnemyLocations(){
        var everyOther = false
        for enemy in _gameEnemy {
            if(objectsCollide(_myShip!, enemy: enemy)){
                if(enemy.endTime != -100){
                    enemy.needsDeleted = true
                    enemy.endTime = 0
                    createCollision(enemy.position.x , y: enemy.position.y, size: 0.2)
                    decreaseLife()
                }
            }
            if(_time >= enemy.startTime && _time < enemy.endTime) {
                if(enemy.path.count > 0) {
                    let newLocationX = enemy.path.first?.x
                    let newLocationY = enemy.path.first?.y
                    enemy.position.x = newLocationX!
                    enemy.position.y = newLocationY!
                    if(everyOther){ // only half enemies shoot
                        setEnemyShot(enemy)
                    }
                    everyOther = !everyOther
                    enemy.path.removeFirst()
                }
            }else if(_time >= enemy.startTime && enemy.endTime == -100){
                if (enemy.position.y > 0.6){    //boss ship enter
                    if(enemy.path.count > 0){
                        let newLocationX = enemy.path.first?.x
                        let newLocationY = enemy.path.first?.y
                        enemy.position.x = newLocationX!
                        enemy.position.y = newLocationY!
                        enemy.path.removeFirst()
                    }
                } else {
                    //move Boss ship left / right (follows player)
                    if(enemy.position.x > (_myShip?.position.x)! && enemy.position.x > -0.35){
                        enemy.position.x -= 0.0005
                    } else if(enemy.position.x < (_myShip?.position.x)! && enemy.position.x < 0.35){
                        enemy.position.x += 0.0005
                    }
                    
                    if(enemy.path.count > 0){
                        enemy.path.removeAll()
                    }
                    enemy.position.y = 0.6
                    setBossShot(enemy)
                }
            }else if (enemy.endTime < _time && enemy.endTime != -100){
                enemy.needsDeleted = true
            }
        }
    }
    
    //creates a random shot time for an enemy depending on level
    //If no path remains, removes sprite
    //If endTime expires, removes sprite
    //If object destroyed, removes object
    private func setEnemyShot(enemy: GameObject){
        //randomize when enemy ships can shoot
        if(enemy._canShoot < _time){
            if(_level == 1){
                enemy._canShoot = _time + Double(arc4random_uniform(4)) + 0.75
            }else if(_level == 2){
                enemy._canShoot = _time + Double(arc4random_uniform(3)) + 0.5
            }else if (_level == 3){
                enemy._canShoot = _time + Double(arc4random_uniform(2)) + 0.25
            }
            enemyFire(enemy, locX: enemy.position.x, locY: enemy.position.y)
        }
    }
    
    //creates a random shot time for an Boss depending on level
    //If no path remains, removes sprite
    //If endTime expires, removes sprite
    //If object destroyed, removes object
    private func setBossShot(enemy: GameObject){
        //randomize when enemy ships can shoot
        if(enemy._canShoot < _time){
            if(_level == 1){
                enemy._canShoot = _time + Double(arc4random_uniform(2))
            }else if(_level == 2){
                enemy._canShoot = _time + Double(arc4random_uniform(2))

            }else if (_level == 3){
                enemy._canShoot = _time + Double(arc4random_uniform(2))
            }
            //Determine which location to shoot bullet
            if(rand() % 3 == 0){
                enemyFire(enemy, locX: enemy.position.x + (enemy.width / 2) - 0.015 , locY: enemy.position.y + 0.025)
            } else if (rand() % 3 == 1 ) {
                enemyFire(enemy, locX: enemy.position.x - (enemy.width / 2) + 0.015, locY: enemy.position.y + 0.025)

            } else {
                enemyFire(enemy, locX: enemy.position.x, locY: enemy.position.y)
            }
        }
    }
    
    
    //updates all current player bullet locations
    //checks for bullet collisions with enemy ships
    //If no path remains, removes sprite
    //If endTime expires, removes sprite
    //If object destroyed, removes object
    private func updateMyBulletLocations(){
        //move bullets and check for collisions
        for bullet in _gameMyBullets {
            for enemy in _gameEnemy {
                if(objectsCollide(bullet, enemy: enemy)){
                    if(enemy.endTime == -100 && enemy.startTime < _time){

                        //check hit
                        bullet.needsDeleted = true
                        bullet.endTime = 0
                        createCollision(bullet.position.x , y: bullet.position.y, size: 0.2)
                        increaseScore()
                        
                        //check boss life
                        if(bossLife > 0){
                            decreaseBossLife()
                        } else {
                            enemy.needsDeleted = true
                            enemy.endTime = 0
                            createCollision(enemy.position.x , y: enemy.position.y, size: enemy.width)
                            bossDefeated = true
                        }
                        break;
                    } else {
                        enemy.needsDeleted = true
                        enemy.endTime = 0
                        bullet.needsDeleted = true
                        bullet.endTime = 0
                        createCollision(enemy.position.x , y: enemy.position.y, size: 0.2)
                        increaseScore()
                        break;
                    }
                }
            }
            if(_time >= bullet.startTime && _time < bullet.endTime) {
                if(bullet.path.count > 0) {
                    let newLocationX = bullet.path.first?.x
                    let newLocationY = bullet.path.first?.y
                    bullet.position.x = newLocationX!
                    bullet.position.y = newLocationY!
                    bullet.path.removeFirst()
                }
            } else if (bullet.endTime < _time){
                bullet.needsDeleted = true
            }
        }
    }
    
    //updates all the current enemy bullet locations
    //checks for bullet collisions with player ship
    //If no path remains, removes sprite
    //If endTime expires, removes sprite
    //If object destroyed, removes object
    private func updateEnemyBulletLocations(){
        //move bullets and check for collisions
        for bullet in _gameEnemyBullets {
            if(objectsCollide(_myShip!, enemy: bullet)){
                bullet.needsDeleted = true
                bullet.endTime = 0
                createCollision(bullet.position.x , y: bullet.position.y, size: 0.2)
                decreaseLife()
                continue
            }
            
            if(_time >= bullet.startTime && _time < bullet.endTime) {
                if(bullet.path.count > 0) {
                    let newLocationX = bullet.path.first?.x
                    let newLocationY = bullet.path.first?.y
                    bullet.position.x = newLocationX!
                    bullet.position.y = newLocationY!
                    bullet.path.removeFirst()
                }
            } else if (bullet.endTime < _time){
                bullet.needsDeleted = true
            }
        }
    }
    
    //Determines if two objects have collided
    //two game objects
    private func objectsCollide(bullet: GameObject, enemy: GameObject) -> Bool{
        let radii = (bullet.getRadius() + enemy.getRadius()) * 0.75
        let xDiff = (enemy.position.x - bullet.position.x)
        let yDiff = (enemy.position.y - bullet.position.y)
        let distance = sqrt(Double(xDiff * xDiff) + Double(yDiff * yDiff))
        return distance < (radii * 0.9)
    }
    
    //Determines if two objects have collided
    //game object and player sprite
    private func objectsCollide(myShip: Sprite, enemy: GameObject) -> Bool{
        let radii = (myShip.getRadius() + enemy.getRadius()) * 0.75
        let xDiff = (enemy.position.x - myShip.position.x)
        let yDiff = (enemy.position.y - myShip.position.y)
        let distance = sqrt(Double(xDiff * xDiff) + Double(yDiff * yDiff))
        return distance < (radii * 0.9)
    }
    
    //Creates a Collision Object
    private func createCollision(x: Float , y: Float, size: Float){
        let boom = GameObject()
        boom.width = size
        boom.height = size
        boom.position.x = x
        boom.position.y = y
        boom.startTime = _time
        boom.endTime = _time + 0.5
        _gameCollisions.append(boom)
    }
    
    //Adds a player bullet to the world
    func playerFire(){
        if(_canShoot < _time){
            _canShoot = _time + 0.5
            let shot = GameObject()
            shot.width = 0.075
            shot.height = 0.075
            shot.position.x = _myShip!.position.x
            shot.position.y = -1.5
            shot.startTime = _time
            shot.endTime = _time + 2
            var distance = _myShip!.position.y + (_myShip!.height / 2) + (Float(_animation) * 0.1)
            while distance <= 1.1 {
                let p = Vector((_myShip?.position.x)!, distance)
                shot.path.append(p)
                distance += 0.02
            }
            _gameMyBullets.append(shot)
        }
    }
    
    //Fires a bullet from a specified enemy ship
    private func enemyFire(ship: GameObject, locX: Float, locY: Float){
        let shot = GameObject()
        shot.width = 0.075
        shot.height = 0.075
        shot.position.x = locX
        shot.position.y = locY - (ship.height / 2) // -1.5
        shot.startTime = _time
        shot.endTime = _time + 2
        var distance = locY - (ship.height / 2) + (Float(_animation) * 0.1)
        while distance >= -1.25 {
            let p = Vector(locX, distance)
            shot.path.append(p)
            if(_level == 3){
                distance -= 0.03
            } else {
                
                distance -= (0.02)
            }
        }
        _gameEnemyBullets.append(shot)
    }
    
    //Spawns an enemy with the provided information
    private func spawnEnemy(start: Double, end: Double, x: Float, y: Float, speed: Float, direction: Int){
        //Enemy Sprite
        let _spriteEnemy = GameObject()
        _spriteEnemy.position.y = y
        _spriteEnemy.position.x = x
        _spriteEnemy.width = 0.15
        _spriteEnemy.height = 0.15
        _spriteEnemy._movementSpeed = speed
        _spriteEnemy.startTime = start
        _spriteEnemy.endTime = end
        _spriteEnemy.generateRandomPath(direction)
        _gameEnemy.append(_spriteEnemy)
    }
    
    //Spawns a boss with the provided information
    private func spawnBoss(start: Double, level: Int){
        let _spriteEnemy = GameObject()
        _spriteEnemy.position.y = 1.3
        _spriteEnemy.position.x = 0
        _spriteEnemy.width = 0.40
        _spriteEnemy.height = 0.40
        _spriteEnemy.startTime = start
        _spriteEnemy.endTime = -100
        _spriteEnemy.generateRandomPath(0)
        _gameEnemy.append(_spriteEnemy)
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////

    //MARK: - LEVEL SCRIPTS

    private func setUpLevelOne() {
        _time = 0.0
        _canShoot = _time
        _gameEnemy.removeAll()
        _gameMyBullets.removeAll()
        _gameEnemyBullets.removeAll()
        _gameCollisions.removeAll()

        let left: Float = -0.6
        let right: Float = 0.6
        let top: Float = 1.1
        let speed: Float = 0.008
        
        //flying V
        spawnEnemy(2, end: 20 , x: 0.0, y: top, speed: speed, direction: 0)
        spawnEnemy(3, end: 20 , x: -0.1, y: top, speed: speed, direction: 0)
        spawnEnemy(3, end: 20 , x: 0.1, y: top, speed: speed, direction: 0)
        spawnEnemy(4, end: 20 , x: -0.3, y: top, speed: speed, direction: 0)
        spawnEnemy(4, end: 20 , x: 0.3, y: top, speed: speed, direction: 0)
        spawnEnemy(5, end: 20 , x: -0.5, y: top, speed: speed, direction: 0)
        spawnEnemy(5, end: 20 , x: 0.5, y: top, speed: speed, direction: 0)
        
        //fork right/left
        spawnEnemy(8.5, end: 20 , x: right, y: 0.55, speed: speed, direction: 1)
        spawnEnemy(10, end: 22 , x: right, y: 0.55, speed: speed, direction: 1)
        spawnEnemy(11.5, end: 23 , x: right, y: 0.55, speed: speed, direction: 1)
        spawnEnemy(10, end: 22 , x: left, y: 0.65, speed: speed, direction: 2)
        spawnEnemy(11.5, end: 23 , x: left, y: 0.65, speed: speed, direction: 2)
        spawnEnemy(8.5, end: 20 , x: left, y: 0.65, speed: speed, direction: 2)
        spawnEnemy(8.5, end: 20 , x: right, y: 0.75, speed: speed, direction: 1)
        spawnEnemy(10, end: 22 , x: right, y: 0.75, speed: speed, direction: 1)
        spawnEnemy(11.5, end: 23 , x: right, y: 0.75, speed: speed, direction: 1)
        
        //Bounce In -> Out
        spawnEnemy(13 , end: 25 , x: right, y: 0.55, speed: speed, direction: 4)
        spawnEnemy(13 , end: 25 , x: left, y: 0.65, speed: speed, direction: 3)
        spawnEnemy(13 , end: 25 , x: right, y: 0.75, speed: speed, direction: 4)
        
        //flying V
        spawnEnemy(17, end: 37 , x: 0.0, y: top, speed: speed, direction: 0)
        spawnEnemy(18, end: 38 , x: -0.1, y: top, speed: speed, direction: 0)
        spawnEnemy(18, end: 38 , x: 0.1, y: top, speed: speed, direction: 0)
        spawnEnemy(19, end: 38 , x: -0.3, y: top, speed: speed, direction: 0)
        spawnEnemy(19, end: 38 , x: 0.3, y: top, speed: speed, direction: 0)
        spawnEnemy(20, end: 40 , x: -0.5, y: top, speed: speed, direction: 0)
        spawnEnemy(20, end: 40 , x: 0.5, y: top, speed: speed, direction: 0)
        
        //DIVE RIGHT
        spawnEnemy(21, end: 45 , x: -0.5, y: top, speed: speed * 1.25, direction: 5)
        spawnEnemy(22, end: 45 , x: -0.5, y: top, speed: speed * 1.25, direction: 5)
        spawnEnemy(23, end: 45 , x: -0.5, y: top, speed: speed * 1.25, direction: 5)
        spawnEnemy(24, end: 45 , x: -0.5, y: top, speed: speed * 1.25, direction: 5)
        spawnEnemy(25, end: 45 , x: -0.5, y: top, speed: speed * 1.25, direction: 5)
        spawnEnemy(26, end: 45 , x: -0.5, y: top, speed: speed * 1.25, direction: 5)
        spawnEnemy(27, end: 45 , x: -0.5, y: top, speed: speed * 1.25, direction: 5)
        
        //fork left/RIGHT
        spawnEnemy(30, end: 50 , x: left, y: 0.55, speed: speed, direction: 2)
        spawnEnemy(32, end: 50 , x: left, y: 0.55, speed: speed, direction: 2)
        spawnEnemy(34, end: 50 , x: left, y: 0.55, speed: speed, direction: 2)
        spawnEnemy(34, end: 50 , x: right, y: 0.65, speed: speed, direction: 1)
        spawnEnemy(32, end: 50 , x: right, y: 0.65, speed: speed, direction: 1)
        spawnEnemy(30, end: 50 , x: right, y: 0.65, speed: speed, direction: 1)
        spawnEnemy(30, end: 50 , x: left, y: 0.75, speed: speed, direction: 2)
        spawnEnemy(32, end: 50 , x: left, y: 0.75, speed: speed, direction: 2)
        spawnEnemy(34, end: 50 , x: left, y: 0.75, speed: speed, direction: 2)
        
        //Bounce In -> Out
        spawnEnemy(36 , end: 55 , x: left, y: 0.55, speed: speed, direction: 3)
        spawnEnemy(36 , end: 55 , x: right, y: 0.65, speed: speed, direction: 4)
        spawnEnemy(36 , end: 55 , x: left, y: 0.75, speed: speed, direction: 3)
        
        //Slice X
        spawnEnemy(42, end: 62 , x: right * 1.6 , y: top, speed: speed, direction: 8)
        spawnEnemy(44, end: 62 , x: right * 1.6 , y: top, speed: speed, direction: 8)
        spawnEnemy(46, end: 62 , x: right * 1.6 , y: top, speed: speed, direction: 8)
        spawnEnemy(47, end: 67 , x: right * 1.6 , y: top, speed: speed, direction: 8)
        spawnEnemy(48, end: 68 , x: right * 1.6 , y: top, speed: speed, direction: 8)
        spawnEnemy(50, end: 69 , x: right * 1.6 , y: top, speed: speed, direction: 8)
        spawnEnemy(52, end: 70 , x: right * 1.6 , y: top, speed: speed, direction: 8)
        spawnEnemy(42.6, end: 62 , x: left * 1.6, y: top, speed: speed, direction: 7)
        spawnEnemy(44.6, end: 64 , x: left * 1.6, y: top, speed: speed, direction: 7)
        spawnEnemy(46.6, end: 66 , x: left * 1.6, y: top, speed: speed, direction: 7)
        spawnEnemy(47.6, end: 67 , x: left * 1.6, y: top, speed: speed, direction: 7)
        spawnEnemy(48.6, end: 68 , x: left * 1.6, y: top, speed: speed, direction: 7)
        spawnEnemy(50.6, end: 70 , x: left * 1.6, y: top, speed: speed, direction: 7)
        spawnEnemy(52.6, end: 70 , x: left * 1.6, y: top, speed: speed, direction: 7)
    }
    
    private func setUpLevelTwo(){
        _time = 0.0
        _canShoot = _time
        _gameEnemy.removeAll()
        _gameMyBullets.removeAll()
        _gameEnemyBullets.removeAll()
        _gameCollisions.removeAll()

        let left: Float = -0.6
        let right: Float = 0.6
        let top: Float = 1.1
        let speed: Float = 0.01
        
        //Dive middle and turn out
        spawnEnemy(12.5, end: 33 , x: right, y: 0.54, speed: speed * 0.9, direction: 4)
        spawnEnemy(8.5, end: 28 , x: right, y: 0.54, speed: speed * 0.9, direction: 4)
        spawnEnemy(4.5, end: 25 , x: right, y: 0.54, speed: speed * 0.9, direction: 4)
        spawnEnemy(2.5, end: 24 , x: right, y: 0.62, speed: speed * 0.9, direction: 4)
        spawnEnemy(6.5, end: 28 , x: right, y: 0.62, speed: speed * 0.9, direction: 4)
        spawnEnemy(10.5, end: 30 , x: right, y: 0.62, speed: speed * 0.9, direction: 4)
        spawnEnemy(2, end: 22 , x: 0.1, y: top, speed: speed, direction: 9)
        spawnEnemy(4, end: 24 , x: 0.1, y: top, speed: speed, direction: 9)
        spawnEnemy(6, end: 25 , x: 0.1, y: top, speed: speed, direction: 9)
        spawnEnemy(8, end: 28 , x: 0.1, y: top, speed: speed, direction: 9)
        spawnEnemy(10, end: 30 , x: 0.1, y: top, speed: speed, direction: 9)
        spawnEnemy(12, end: 32 , x: 0.1, y: top, speed: speed, direction: 9)
        spawnEnemy(2.5, end: 23 , x: left, y: 0.54, speed: speed * 0.9, direction: 3)
        spawnEnemy(6.5, end: 25 , x: left, y: 0.54, speed: speed * 0.9, direction: 3)
        spawnEnemy(10.5, end: 30 , x: left, y: 0.54, speed: speed * 0.9, direction: 3)
        spawnEnemy(8.5, end: 28 , x: left, y: 0.62, speed: speed * 0.9, direction: 3)
        spawnEnemy(4.5, end: 23 , x: left, y: 0.62, speed: speed * 0.9, direction: 3)
        spawnEnemy(12.5, end: 32 , x: left, y: 0.62, speed: speed * 0.9, direction: 3)

        spawnEnemy(2, end: 22 , x: -0.1, y: top, speed: speed, direction: 10)
        spawnEnemy(4, end: 23 , x: -0.1, y: top, speed: speed, direction: 10)
        spawnEnemy(6, end: 25 , x: -0.1, y: top, speed: speed, direction: 10)
        spawnEnemy(8, end: 28 , x: -0.1, y: top, speed: speed, direction: 10)
        spawnEnemy(10, end: 30 , x: -0.1, y: top, speed: speed, direction: 10)
        spawnEnemy(12, end: 32 , x: -0.1, y: top, speed: speed, direction: 10)
        
        //Flying V
        spawnEnemy(14, end: 34 , x: 0.0, y: top, speed: speed, direction: 0)
        spawnEnemy(15, end: 34 , x: 0.0, y: top, speed: speed, direction: 0)
        spawnEnemy(15.5, end: 35 , x: -0.1, y: top, speed: speed, direction: 0)
        spawnEnemy(15.5, end: 35 , x: 0.1, y: top, speed: speed, direction: 0)
        spawnEnemy(16, end: 36 , x: -0.3, y: top, speed: speed, direction: 0)
        spawnEnemy(16, end: 36 , x: 0.3, y: top, speed: speed, direction: 0)
        spawnEnemy(16.5, end: 36 , x: -0.5, y: top, speed: speed, direction: 0)
        spawnEnemy(16.5, end: 36 , x: 0.5, y: top, speed: speed, direction: 0)
        
        //Dive V right -> up
        spawnEnemy(18, end: 40 , x: -0.5, y: top, speed: speed, direction: 5)
        spawnEnemy(19, end: 40 , x: -0.5, y: top, speed: speed, direction: 5)
        spawnEnemy(20, end: 40 , x: -0.5, y: top, speed: speed, direction: 5)
        spawnEnemy(21, end: 40 , x: -0.5, y: top, speed: speed, direction: 5)
        spawnEnemy(22, end: 41 , x: -0.5, y: top, speed: speed, direction: 5)
        spawnEnemy(23, end: 42 , x: -0.5, y: top, speed: speed, direction: 5)
        spawnEnemy(24, end: 45 , x: -0.5, y: top, speed: speed, direction: 5)
        
        //left
        spawnEnemy(20, end: 40 , x: right, y: 0.05, speed: speed, direction: 1)
        spawnEnemy(22, end: 42 , x: right, y: 0.05, speed: speed, direction: 1)
        spawnEnemy(24, end: 44 , x: right, y: 0.05, speed: speed, direction: 1)
        spawnEnemy(28, end: 48 , x: right, y: 0.05, speed: speed, direction: 1)
        spawnEnemy(26, end: 46 , x: right, y: 0.05, speed: speed, direction: 1)
        spawnEnemy(25, end: 45 , x: right, y: 0.15, speed: speed, direction: 1)
        spawnEnemy(27, end: 47 , x: right, y: 0.15, speed: speed, direction: 1)
        spawnEnemy(23, end: 43 , x: right, y: 0.15, speed: speed, direction: 1)
        spawnEnemy(21, end: 41 , x: right, y: 0.15, speed: speed, direction: 1)
        
        //Rain Down All
        spawnEnemy(31, end: 46 , x: -0.1, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(31, end: 46 , x: 0.1, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(31, end: 46 , x: -0.3, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(31, end: 46 , x: 0.3, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(31, end: 46 , x: -0.5, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(31, end: 46 , x: 0.5, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(31.2, end: 46 , x: 0.0, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(31.2, end: 46 , x: 0.2, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(31.2, end: 46 , x: 0.4, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(31.2, end: 46 , x: -0.2, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(31.2, end: 46 , x: -0.4, y: top, speed: speed * 1.5, direction: 0)
        
        //fork left/RIGHT
        spawnEnemy(37, end: 50 , x: right, y: 0.45, speed: speed, direction: 1)
        spawnEnemy(33, end: 50 , x: right, y: 0.45, speed: speed, direction: 1)
        spawnEnemy(35, end: 50 , x: right, y: 0.45, speed: speed, direction: 1)
        spawnEnemy(37, end: 50 , x: left, y: 0.55, speed: speed, direction: 2)
        spawnEnemy(35, end: 50 , x: left, y: 0.55, speed: speed, direction: 2)
        spawnEnemy(33, end: 50 , x: left, y: 0.55, speed: speed, direction: 2)
        spawnEnemy(33, end: 50 , x: right, y: 0.65, speed: speed, direction: 1)
        spawnEnemy(35, end: 50 , x: right, y: 0.65, speed: speed, direction: 1)
        spawnEnemy(37, end: 50 , x: right, y: 0.65, speed: speed, direction: 1)
        spawnEnemy(37, end: 50 , x: left, y: 0.75, speed: speed, direction: 2)
        spawnEnemy(35, end: 50 , x: left, y: 0.75, speed: speed, direction: 2)
        spawnEnemy(33, end: 50 , x: left, y: 0.75, speed: speed, direction: 2)
        
        //Flying V
        spawnEnemy(39, end: 55, x: 0, y: top, speed: speed * 2, direction: 0)
        spawnEnemy(39.2, end: 55 , x: 0.0, y: top, speed: speed * 2, direction: 0)
        spawnEnemy(39.4, end: 55 , x: -0.1, y: top, speed: speed * 2, direction: 0)
        spawnEnemy(39.4, end: 55 , x: 0.1, y: top, speed: speed * 2, direction: 0)
        spawnEnemy(39.6, end: 55 , x: -0.3, y: top, speed: speed * 2, direction: 0)
        spawnEnemy(39.6, end: 55 , x: 0.3, y: top, speed: speed * 2, direction: 0)
        spawnEnemy(39.8, end: 55 , x: -0.5, y: top, speed: speed * 2, direction: 0)
        spawnEnemy(39.8, end: 55 , x: 0.5, y: top, speed: speed * 2, direction: 0)
        
        //Slice X
        spawnEnemy(41, end: 62 , x: right * 1.6 , y: top, speed: speed, direction: 8)
        spawnEnemy(43, end: 62 , x: right * 1.6 , y: top, speed: speed, direction: 8)
        spawnEnemy(45, end: 62 , x: right * 1.6 , y: top, speed: speed, direction: 8)
        spawnEnemy(46, end: 67 , x: right * 1.6 , y: top, speed: speed, direction: 8)
        spawnEnemy(47, end: 68 , x: right * 1.6 , y: top, speed: speed, direction: 8)
        spawnEnemy(49, end: 69 , x: right * 1.6 , y: top, speed: speed, direction: 8)
        spawnEnemy(51, end: 70 , x: right * 1.6 , y: top, speed: speed, direction: 8)
        spawnEnemy(41.6, end: 62 , x: left * 1.6, y: top, speed: speed, direction: 7)
        spawnEnemy(43.6, end: 64 , x: left * 1.6, y: top, speed: speed, direction: 7)
        spawnEnemy(45.6, end: 66 , x: left * 1.6, y: top, speed: speed, direction: 7)
        spawnEnemy(46.6, end: 67 , x: left * 1.6, y: top, speed: speed, direction: 7)
        spawnEnemy(47.6, end: 68 , x: left * 1.6, y: top, speed: speed, direction: 7)
        spawnEnemy(49.6, end: 70 , x: left * 1.6, y: top, speed: speed, direction: 7)
        spawnEnemy(51.6, end: 70 , x: left * 1.6, y: top, speed: speed, direction: 7)
    }
    
    private func setUpLevelThree() {
        _time = 0.0
        _canShoot = _time
        _gameEnemy.removeAll()
        _gameMyBullets.removeAll()
        _gameEnemyBullets.removeAll()
        _gameCollisions.removeAll()
        
        let left: Float = -0.6
        let right: Float = 0.6
        let top: Float = 1.1
        let speed: Float = 0.015
        
        //Bounce in Right
        spawnEnemy(2 , end: 20 , x: right, y: 0.05, speed: speed, direction: 4)
        spawnEnemy(2.5 , end: 20 , x: right, y: 0.15, speed: speed, direction: 4)
        spawnEnemy(3 , end: 20 , x: right, y: 0.25, speed: speed, direction: 4)
        spawnEnemy(3.5 , end: 20 , x: right, y: 0.35, speed: speed, direction: 4)
        spawnEnemy(4 , end: 20 , x: right, y: 0.45, speed: speed, direction: 4)
        spawnEnemy(4.5 , end: 20 , x: right, y: 0.55, speed: speed, direction: 4)
        spawnEnemy(5 , end: 20 , x: right, y: 0.65, speed: speed, direction: 4)
        spawnEnemy(5.5 , end: 20 , x: right, y: 0.75, speed: speed, direction: 4)
        spawnEnemy(6 , end: 20 , x: right, y: 0.85, speed: speed, direction: 4)
        spawnEnemy(6.5 , end: 20 , x: right, y: 0.95, speed: speed, direction: 9)
        spawnEnemy(7.5 , end: 20 , x: right, y: 0.95, speed: speed, direction: 9)
        spawnEnemy(8.5 , end: 20 , x: right, y: 0.95, speed: speed, direction: 9)

        //Mirror Bounce in Left
        spawnEnemy(2 , end: 20 , x: left, y: 0.05, speed: speed, direction: 3)
        spawnEnemy(2.5 , end: 20 , x: left, y: 0.15, speed: speed, direction: 3)
        spawnEnemy(3 , end: 20 , x: left, y: 0.25, speed: speed, direction: 3)
        spawnEnemy(3.5 , end: 20 , x: left, y: 0.35, speed: speed, direction: 3)
        spawnEnemy(4 , end: 20 , x: left, y: 0.45, speed: speed, direction: 3)
        spawnEnemy(4.5 , end: 20 , x: left, y: 0.55, speed: speed, direction: 3)
        spawnEnemy(5 , end: 20 , x: left, y: 0.65, speed: speed, direction: 3)
        spawnEnemy(5.5 , end: 20 , x: left, y: 0.75, speed: speed, direction: 3)
        spawnEnemy(6 , end: 20 , x: left, y: 0.85, speed: speed, direction: 3)
        spawnEnemy(6.5 , end: 20 , x: left, y: 0.95, speed: speed, direction: 10)
        spawnEnemy(7.5 , end: 20 , x: left, y: 0.95, speed: speed, direction: 10)
        spawnEnemy(8.5 , end: 20 , x: left, y: 0.95, speed: speed, direction: 10)

        //Snake
        spawnEnemy(10, end: 37 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(11 , end: 40 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(12 , end: 40 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(13 , end: 40 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(14 , end: 40 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(15 , end: 40 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(16 , end: 40 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(17 , end: 40 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(18 , end: 40 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(19 , end: 40 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(20 , end: 50 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(21 , end: 50 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(22 , end: 50 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(23 , end: 50 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(24 , end: 50 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(25 , end: 50 , x: left, y: 0.75, speed: speed, direction: 11)
        spawnEnemy(26 , end: 50 , x: left, y: 0.75, speed: speed, direction: 11)

        //Rain Down All
        spawnEnemy(37, end: 46 , x: -0.1, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(37, end: 46 , x: 0.1, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(37, end: 46 , x: -0.3, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(37, end: 46 , x: 0.3, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(37, end: 46 , x: -0.5, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(37, end: 46 , x: 0.5, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(37.2, end: 46 , x: 0.0, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(37.2, end: 46 , x: 0.2, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(37.2, end: 46 , x: 0.4, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(37.2, end: 46 , x: -0.2, y: top, speed: speed * 1.5, direction: 0)
        spawnEnemy(37.2, end: 46 , x: -0.4, y: top, speed: speed * 1.5, direction: 0)
        
        //Rain Down All FASTER
        spawnEnemy(39, end: 46 , x: -0.1, y: top, speed: speed * 2.5, direction: 0)
        spawnEnemy(39, end: 46 , x: 0.1, y: top, speed: speed * 2.5, direction: 0)
        spawnEnemy(39, end: 46 , x: -0.3, y: top, speed: speed * 2.5, direction: 0)
        spawnEnemy(39, end: 46 , x: 0.3, y: top, speed: speed * 2.5, direction: 0)
        spawnEnemy(39, end: 46 , x: -0.5, y: top, speed: speed * 2.5, direction: 0)
        spawnEnemy(39, end: 46 , x: 0.5, y: top, speed: speed * 2.5, direction: 0)
        spawnEnemy(39.2, end: 46 , x: 0.0, y: top, speed: speed * 2.5, direction: 0)
        spawnEnemy(39.2, end: 46 , x: 0.2, y: top, speed: speed * 2.5, direction: 0)
        spawnEnemy(39.2, end: 46 , x: 0.4, y: top, speed: speed * 2.5, direction: 0)
        spawnEnemy(39.2, end: 46 , x: -0.2, y: top, speed: speed * 2.5, direction: 0)
        spawnEnemy(39.2, end: 46 , x: -0.4, y: top, speed: speed * 2.5, direction: 0)
        
        //Snake FAST
        spawnEnemy(40, end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(41 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(42 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(43 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(44 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(45 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(46 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(47 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(48 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(49 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(50 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(51 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(52 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(53 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(54 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(55 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
        spawnEnemy(56 , end: 70 , x: right, y: 0.75, speed: speed * 2, direction: 12)
    }

    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    
    //MARK: - MAIN GAME LOOP
    
    
    //DRIVER. WHERE ALL THE MAGIC HAPPENS
    func executeGameLoop(timePassed: Double) {
        if(!_paused){
            _time += timePassed
            _animation = timePassed
            loadNextLevel = false
            
            //tell view how much to move the level
            _moveLevel = timePassed * 0.05
            
            //level messages
            if(_time > 2){
                showLevelMessage = false
            } else {
                showLevelMessage = true
            }
            
            //BOSS 1
            if(_time > 55 && _level == 1 && !_setBoss1){
                bossLife = 300
                spawnBoss(55, level: 1)
                _setBoss1 = true
                showBossSheild = true
            }
            
            //BOSS 2
            if(_time > 55 && _level == 2 && !_setBoss2){
                bossLife = 300
                spawnBoss(55, level: 2)
                _setBoss2 = true
                showBossSheild = true
            }
            //BOSS 3
            if(_time > 60 && _level == 3 && !_setBoss3){
                bossLife = 300
                spawnBoss(63, level: 3)
                _setBoss3 = true
                showBossSheild = true
            }
            
            //delay after you beat the boss
            if(bossDefeated && _level < 3){
                endLevelWaitTime += timePassed
            }
            
            //go to level 2
            if(_level == 1 && bossDefeated && endLevelWaitTime > 2){
                _level += 1
                endLevelWaitTime = 0
                bossDefeated = false
                levelTwoNeedsSetup = true
                loadNextLevel = true
                showLevelMessage = false
                showBossSheild = false
            }
            
            //go to level 3
            if(_level == 2 && bossDefeated && endLevelWaitTime > 2){
                _level += 1
                endLevelWaitTime = 0
                bossDefeated = false
                levelThreeNeedsSetup = true
                loadNextLevel = true
                showLevelMessage = false
                showBossSheild = false
            }
            
            //GAME OVER
            if(_level == 3 && bossDefeated && endLevelWaitTime > 2 || _gameOver){
                endLevelWaitTime = 0
                showLevelMessage = false
                print("GAME OVER")
                _gameOver = true
            }
            
            //Spawn sprites (~75 sec per level)
            if(levelOneNeedsSetup){
                setUpLevelOne()
                levelOneNeedsSetup = false
            } else if(levelTwoNeedsSetup){
                setUpLevelTwo()
                levelTwoNeedsSetup = false
            } else if(levelThreeNeedsSetup){
                setUpLevelThree()
                levelThreeNeedsSetup = false
            }
            
            //Move ALL the sprites
            updateGameEnemyLocations()
            updateMyBulletLocations()
            updateEnemyBulletLocations()
        } else {
            writeToFile()
            print("Game loop paused")
        }
    }

    func reset() {
         _paused = false
         _gameOver = false
         _gameEnemy = []
         _gameMyBullets = []
         _gameEnemyBullets = []
         _gameCollisions = []
        _ranking = -1
        
          _score = 0
          _setBoss1 = false
          _setBoss2 = false
         _setBoss3 = false
        
         _animation = 0.0
         _moveLevel = 0.0
         _time = 0.0
         _canShoot = 0.0
         _enemyCanShoot = 2.0
         _level = 1
         levelOneNeedsSetup = true
         levelTwoNeedsSetup = false
         levelThreeNeedsSetup = false
         showBossSheild = false
         bossDefeated = false
         loadNextLevel = false
         bossLife = 300
         myLife = 100
         showLevelMessage = true
         endLevelWaitTime = 0.0
    }
    
    
    //creates a shared instance and loads the game info from file.
    class var sharedInstance: Game {
        struct Static {
            static var instance: Game?
        }
        if(Static.instance == nil){
            Static.instance = Game()
        
            let dir: NSString? = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString?
            
            let filePath: String? = (dir as NSString?)!.stringByAppendingPathComponent("Nebula.txt")
            
            let savedArray: NSArray? = NSArray(contentsOfFile: filePath!)
            
            if(savedArray != nil){
                let array = savedArray as! [NSDictionary]
                for game in array {
                    
                    Static.instance?._paused = game.valueForKey("_paused")!.boolValue
                    Static.instance?._gameOver = game.valueForKey("_gameOver")!.boolValue
                    Static.instance?._score = game.valueForKey("_score")!.integerValue
                    Static.instance?._setBoss1 = game.valueForKey("_setBoss1")!.boolValue
                    Static.instance?._setBoss2 = game.valueForKey("_setBoss2")!.boolValue
                    Static.instance?._setBoss3 = game.valueForKey("_setBoss3")!.boolValue
                    Static.instance?._animation = game.valueForKey("_animation")!.doubleValue
                    Static.instance?._moveLevel = game.valueForKey("_moveLevel")!.doubleValue
                    Static.instance?._time = game.valueForKey("_time")!.doubleValue
                    Static.instance?._canShoot = game.valueForKey("_canShoot")!.doubleValue
                    Static.instance?._enemyCanShoot = game.valueForKey("_enemyCanShoot")!.doubleValue
                    Static.instance?._level = game.valueForKey("_level")!.integerValue
                    Static.instance?.levelOneNeedsSetup = game.valueForKey("levelOneNeedsSetup")!.boolValue
                    Static.instance?.levelTwoNeedsSetup = game.valueForKey("levelTwoNeedsSetup")!.boolValue
                    Static.instance?.levelThreeNeedsSetup = game.valueForKey("levelThreeNeedsSetup")!.boolValue
                    Static.instance?.showBossSheild = game.valueForKey("showBossSheild")!.boolValue
                    Static.instance?.bossDefeated = game.valueForKey("bossDefeated")!.boolValue
                    Static.instance?.loadNextLevel = game.valueForKey("loadNextLevel")!.boolValue
                    Static.instance?.bossLife = game.valueForKey("bossLife")!.integerValue
                    Static.instance?.myLife = game.valueForKey("myLife")!.integerValue
                    Static.instance?.showLevelMessage = game.valueForKey("showLevelMessage")!.boolValue
                    Static.instance?.endLevelWaitTime = game.valueForKey("endLevelWaitTime")!.doubleValue
                    Static.instance?._ranking = game.valueForKey("_ranking")!.integerValue
                    Static.instance?._highScores = game.valueForKey("highScore") as! [Int]
                    Static.instance?._highScoresNames = game.valueForKey("_highScoresNames") as! [String]
                    
                    var bullets: [GameObject] = []
                    var enemy: [GameObject] = []
                    var enemyBull: [GameObject] = []
                    var collide: [GameObject] = []

                    let myBull = game.valueForKey("_gameMyBullets") as! NSMutableArray
                    for item in myBull{
                        let obj = GameObject()
                        obj.position.x = item.valueForKey("myBullPosX")!.floatValue
                        obj.position.y = item.valueForKey("myBullPosX")!.floatValue
                        obj.width = item.valueForKey("myBullWidth")!.floatValue
                        obj.height = item.valueForKey("myBullHeight")!.floatValue
                        obj._movementSpeed = item.valueForKey("myBullSpeed")!.floatValue
                        obj.startTime = item.valueForKey("myBullStart")!.doubleValue
                        obj.endTime = item.valueForKey("myBullEnd")!.doubleValue
                        var path: [Vector] = []
                        let xpos = item.valueForKey("myBullPathX") as! [Float]
                        let ypos = item.valueForKey("myBullPathY") as! [Float]
                        for var index = 0 ; index < xpos.count ; index += 1 {
                            let vec = Vector(xpos[index], ypos[index])
                            path.append(vec)
                        }
                        obj.path = path
                        obj.needsDeleted = item.valueForKey("myBullneedsDeleted")!.boolValue
                        obj._canShoot = item.valueForKey("myBullCanShoot")!.doubleValue
                        
                        bullets.append(obj)
                    }
                    
                    
                    let Enn = game.valueForKey("_gameEnemy") as! NSMutableArray
                    for item in Enn{
                        let obj = GameObject()
                        obj.position.x = item.valueForKey("myBullPosX")!.floatValue
                        obj.position.y = item.valueForKey("myBullPosX")!.floatValue
                        obj.width = item.valueForKey("myBullWidth")!.floatValue
                        obj.height = item.valueForKey("myBullHeight")!.floatValue
                        obj._movementSpeed = item.valueForKey("myBullSpeed")!.floatValue
                        obj.startTime = item.valueForKey("myBullStart")!.doubleValue
                        obj.endTime = item.valueForKey("myBullEnd")!.doubleValue
                        var path: [Vector] = []
                        let xpos = item.valueForKey("myBullPathX") as! [Float]
                        let ypos = item.valueForKey("myBullPathY") as! [Float]
                        for var index = 0 ; index < xpos.count ; index += 1 {
                            let vec = Vector(xpos[index], ypos[index])
                            path.append(vec)
                        }
                        obj.path = path
                        obj.needsDeleted = item.valueForKey("myBullneedsDeleted")!.boolValue
                        obj._canShoot = item.valueForKey("myBullCanShoot")!.doubleValue
                        
                        enemy.append(obj)
                    }
                    
                    
                    let EnBull = game.valueForKey("_gameEnemyBullets") as! NSMutableArray
                    for item in EnBull{
                        let obj = GameObject()
                        obj.position.x = item.valueForKey("myBullPosX")!.floatValue
                        obj.position.y = item.valueForKey("myBullPosX")!.floatValue
                        obj.width = item.valueForKey("myBullWidth")!.floatValue
                        obj.height = item.valueForKey("myBullHeight")!.floatValue
                        obj._movementSpeed = item.valueForKey("myBullSpeed")!.floatValue
                        obj.startTime = item.valueForKey("myBullStart")!.doubleValue
                        obj.endTime = item.valueForKey("myBullEnd")!.doubleValue
                        var path: [Vector] = []
                        let xpos = item.valueForKey("myBullPathX") as! [Float]
                        let ypos = item.valueForKey("myBullPathY") as! [Float]
                        for var index = 0 ; index < xpos.count ; index += 1 {
                            let vec = Vector(xpos[index], ypos[index])
                            path.append(vec)
                        }
                        obj.path = path
                        obj.needsDeleted = item.valueForKey("myBullneedsDeleted")!.boolValue
                        obj._canShoot = item.valueForKey("myBullCanShoot")!.doubleValue
                        
                        enemyBull.append(obj)
                    }
                    
                    let Coll = game.valueForKey("_gameCollisions") as! NSMutableArray
                    for item in Coll{
                        let obj = GameObject()
                        obj.position.x = item.valueForKey("myBullPosX")!.floatValue
                        obj.position.y = item.valueForKey("myBullPosX")!.floatValue
                        obj.width = item.valueForKey("myBullWidth")!.floatValue
                        obj.height = item.valueForKey("myBullHeight")!.floatValue
                        obj._movementSpeed = item.valueForKey("myBullSpeed")!.floatValue
                        obj.startTime = item.valueForKey("myBullStart")!.doubleValue
                        obj.endTime = item.valueForKey("myBullEnd")!.doubleValue
                        var path: [Vector] = []
                        let xpos = item.valueForKey("myBullPathX") as! [Float]
                        let ypos = item.valueForKey("myBullPathY") as! [Float]
                        for var index = 0 ; index < xpos.count ; index += 1 {
                            let vec = Vector(xpos[index], ypos[index])
                            path.append(vec)
                        }
                        obj.path = path
                        obj.needsDeleted = item.valueForKey("myBullneedsDeleted")!.boolValue
                        obj._canShoot = item.valueForKey("myBullCanShoot")!.doubleValue
                        
                        collide.append(obj)
                    }
                    
                    Static.instance?._gameMyBullets = bullets
                    Static.instance?._gameEnemy = enemy
                    Static.instance?._gameEnemyBullets = enemyBull
                    Static.instance?._gameCollisions = collide

                    
                }
            }
        
        }
        
        return Static.instance!
    }
    
    
    func writeToFile(){
        let documentsDirectory: NSString? = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString?
        
        let filePath: String? = (documentsDirectory as NSString?)!.stringByAppendingPathComponent("Nebula.txt")
        
        writeToFile(filePath!)
    }
    
    func writeToFile(path: String) {
        
        let gamesList: NSMutableArray = []
        
        let X_paused: Bool = _paused
        let X_gameOver: Bool = _gameOver
        let X_score: Int = _score
        let X_setBoss1: Bool = _setBoss1
        let X_setBoss2: Bool = _setBoss2
        let X_setBoss3: Bool = _setBoss3
        let X_animation: Double = _animation
        let X_moveLevel: Double = _moveLevel
        let X_time: Double = _time
        let X_canShoot: Double = _canShoot
        let X_enemyCanShoot: Double = _enemyCanShoot
        let X_level: Int = _level
        let XlevelOneNeedsSetup: Bool = levelOneNeedsSetup
        let XlevelTwoNeedsSetup: Bool = levelTwoNeedsSetup
        let XlevelThreeNeedsSetup: Bool = levelThreeNeedsSetup
        let XshowBossSheild : Bool = showBossSheild
        let XbossDefeated: Bool = bossDefeated
        let XloadNextLevel: Bool = loadNextLevel
        let XbossLife: Int = bossLife
        let XmyLife: Int = myLife
        let XshowLevelMessage: Bool = showLevelMessage
        let XendLevelWaitTime: Double = endLevelWaitTime
        let X_ranking: Int = _ranking
        let XhighScore: NSArray = NSArray(array: _highScores)
        let X_highScoresNames: NSArray = NSArray(array: _highScoresNames)
        
        let X_gameMyBullets: NSMutableArray = []
        for myBull in _gameMyBullets {
            let myBullPosX: Float = myBull.position.x
            let myBullPosY: Float = myBull.position.y
            let myBullWidth: Float = myBull.width
            let myBullHeight: Float = myBull.height
            let myBullSpeed: Float = myBull._movementSpeed
            let myBullStart: Double = myBull.startTime
            let myBullEnd: Double = myBull.endTime
            var myBullPathX: [Float] = []
            var myBullPathY: [Float] = []
            for p in myBull.path {
                myBullPathX.append(p.x)
                myBullPathY.append(p.y)
            }
            let myBullneedsDeleted: Bool = myBull.needsDeleted
            let myBullCanShoot: Double = myBull._canShoot
            
            let object: NSMutableDictionary = ["myBullPosX": myBullPosX, "myBullPosY": myBullPosY , "myBullWidth": myBullWidth, "myBullHeight":myBullHeight , "myBullSpeed":myBullSpeed ,"myBullStart":myBullStart , "myBullEnd": myBullEnd ,"myBullPathX": myBullPathX , "myBullPathY": myBullPathY ,"myBullneedsDeleted": myBullneedsDeleted , "myBullCanShoot": myBullCanShoot]
            
            X_gameMyBullets.addObject(object)
        }
        
        
        let X_gameEnemy: NSMutableArray = []
        for myBull in _gameEnemy {
            let myBullPosX: Float = myBull.position.x
            let myBullPosY: Float = myBull.position.y
            let myBullWidth: Float = myBull.width
            let myBullHeight: Float = myBull.height
            let myBullSpeed: Float = myBull._movementSpeed
            let myBullStart: Double = myBull.startTime
            let myBullEnd: Double = myBull.endTime
            var myBullPathX: [Float] = []
            var myBullPathY: [Float] = []
            for p in myBull.path{
                myBullPathX.append(p.x)
                myBullPathY.append(p.y)
            }
            let myBullneedsDeleted: Bool = myBull.needsDeleted
            let myBullCanShoot: Double = myBull._canShoot
            
            let object: NSMutableDictionary = ["myBullPosX": myBullPosX, "myBullPosY": myBullPosY , "myBullWidth": myBullWidth, "myBullHeight":myBullHeight , "myBullSpeed":myBullSpeed ,"myBullStart":myBullStart , "myBullEnd": myBullEnd ,"myBullPathX": myBullPathX , "myBullPathY": myBullPathY ,"myBullneedsDeleted": myBullneedsDeleted , "myBullCanShoot": myBullCanShoot]
            
            X_gameEnemy.addObject(object)
        }
        
        let X_gameEnemyBullets: NSMutableArray = []
        for myBull in _gameEnemyBullets {
            let myBullPosX: Float = myBull.position.x
            let myBullPosY: Float = myBull.position.y
            let myBullWidth: Float = myBull.width
            let myBullHeight: Float = myBull.height
            let myBullSpeed: Float = myBull._movementSpeed
            let myBullStart: Double = myBull.startTime
            let myBullEnd: Double = myBull.endTime
            var myBullPathX: [Float] = []
            var myBullPathY: [Float] = []
            for p in myBull.path{
                myBullPathX.append(p.x)
                myBullPathY.append(p.y)
            }
            let myBullneedsDeleted: Bool = myBull.needsDeleted
            let myBullCanShoot: Double = myBull._canShoot
            
            let object: NSMutableDictionary = ["myBullPosX": myBullPosX, "myBullPosY": myBullPosY , "myBullWidth": myBullWidth, "myBullHeight":myBullHeight , "myBullSpeed":myBullSpeed ,"myBullStart":myBullStart , "myBullEnd": myBullEnd ,"myBullPathX": myBullPathX , "myBullPathY": myBullPathY ,"myBullneedsDeleted": myBullneedsDeleted , "myBullCanShoot": myBullCanShoot]
            
            X_gameEnemyBullets.addObject(object)
        }
        
        let X_gameCollisions: NSMutableArray = []
        for myBull in _gameCollisions {
            let myBullPosX: Float = myBull.position.x
            let myBullPosY: Float = myBull.position.y
            let myBullWidth: Float = myBull.width
            let myBullHeight: Float = myBull.height
            let myBullSpeed: Float = myBull._movementSpeed
            let myBullStart: Double = myBull.startTime
            let myBullEnd: Double = myBull.endTime
            var myBullPathX: [Float] = []
            var myBullPathY: [Float] = []
            for p in myBull.path{
                myBullPathX.append(p.x)
                myBullPathY.append(p.y)
            }
            let myBullneedsDeleted: Bool = myBull.needsDeleted
            let myBullCanShoot: Double = myBull._canShoot
            
            let object: NSMutableDictionary = ["myBullPosX": myBullPosX, "myBullPosY": myBullPosY , "myBullWidth": myBullWidth, "myBullHeight":myBullHeight , "myBullSpeed":myBullSpeed ,"myBullStart":myBullStart , "myBullEnd": myBullEnd ,"myBullPathX": myBullPathX , "myBullPathY": myBullPathY ,"myBullneedsDeleted": myBullneedsDeleted , "myBullCanShoot": myBullCanShoot]
            
            X_gameCollisions.addObject(object)
        }
        
        let gameAsDictionary: NSMutableDictionary = ["_paused": X_paused, "_gameOver": X_gameOver,"_score": X_score, "_setBoss1":X_setBoss1,"_setBoss2": X_setBoss2, "_setBoss3": X_setBoss3, "_animation": X_animation, "_moveLevel":X_moveLevel , "_time":X_time , "_canShoot": X_canShoot, "_enemyCanShoot": X_enemyCanShoot, "_level":X_level , "levelOneNeedsSetup":XlevelOneNeedsSetup , "levelTwoNeedsSetup": XlevelTwoNeedsSetup, "levelThreeNeedsSetup": XlevelThreeNeedsSetup, "showBossSheild":XshowBossSheild , "bossDefeated": XbossDefeated, "loadNextLevel":XloadNextLevel , "bossLife":XbossLife , "myLife": XmyLife, "showLevelMessage": XshowLevelMessage, "endLevelWaitTime": XendLevelWaitTime, "_ranking": X_ranking, "highScore": XhighScore, "_highScoresNames": X_highScoresNames, "_gameMyBullets": X_gameMyBullets, "_gameEnemy": X_gameEnemy, "_gameEnemyBullets": X_gameEnemyBullets, "_gameCollisions":X_gameCollisions]
   
        gamesList.addObject(gameAsDictionary)
        
        gamesList.writeToFile(path, atomically: true)
    }
}
