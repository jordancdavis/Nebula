//
//  ViewController.swift
//  Raptor
//
//  Created by Jordan Davis on 4/24/16.
//  Copyright © 2016 cs4962. All rights reserved.
//
import GLKit

class GameViewController: GLKViewController{
    
    private var _myGame: Game = Game.sharedInstance
    var glkView: GLKView?

    //layout sprites
    private var _levelSprite = Sprite()
    private var _levelMessageSprite = Sprite()
    private var _level1Texture: GLKTextureInfo? = nil
    private var _level2Texture: GLKTextureInfo? = nil
    private var _level3Texture: GLKTextureInfo? = nil
    
    private var _gameOverSprite = Sprite()
    private var _gameOverTexture: GLKTextureInfo? = nil

    //dashboard
    private var _joystickController: JoystickView?
    private var _fireButtonController: FireButtonView?
    private var _pauseButtonController: PauseButtonView?
    private var _sheildBarController: SheildBarView?
    private var _bossSheildBarController: EnemySheildBarView?
    
    //game objects bullets / enemy / collisions/ bosses
    private var _bulletTexture: GLKTextureInfo? = nil
    private var _enemyTexture: GLKTextureInfo? = nil
    private var _collisionTexture: GLKTextureInfo? = nil
    private var _boss1Texture: GLKTextureInfo? = nil
    private var _boss2Texture: GLKTextureInfo? = nil
    private var _boss3Texture: GLKTextureInfo? = nil
    
    //scoreSprites
    private var _oneScoreSprite = Sprite()
    private var _tenScoreSprite = Sprite()
    private var _hundredScoreSprite = Sprite()
    private var _thousandScoreSprite = Sprite()
    private var _tenThousandScoreSprite = Sprite()
    private var _hundredThousandScoreSprite = Sprite()
    
    private var _oneScoreTexture: GLKTextureInfo? = nil
    private var _twoScoreTexture: GLKTextureInfo? = nil
    private var _threeScoreTexture: GLKTextureInfo? = nil
    private var _fourScoreTexture: GLKTextureInfo? = nil
    private var _fiveScoreTexture: GLKTextureInfo? = nil
    private var _sixScoreTexture: GLKTextureInfo? = nil
    private var _sevenScoreTexture: GLKTextureInfo? = nil
    private var _eightScoreTexture: GLKTextureInfo? = nil
    private var _nineScoreTexture: GLKTextureInfo? = nil
    private var _zeroScoreTexture: GLKTextureInfo? = nil
    
    //mySprite
    private var _mySprite = Sprite()
    private var _mySpriteTexture: GLKTextureInfo? = nil
    private var _mySpriteUpRightTexture: GLKTextureInfo? = nil
    private var _mySpriteUpLeftTexture: GLKTextureInfo? = nil
    private var _mySpriteUpTexture: GLKTextureInfo? = nil
    private var _mySpriteDownTexture: GLKTextureInfo? = nil
    private var _mySpriteLeftTexture: GLKTextureInfo? = nil
    private var _mySpriteRightTexture: GLKTextureInfo? = nil
    
    var _lastUpdate = NSDate()
    
    //MARK: - LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glkView = view as? GLKView
        glkView!.context = EAGLContext(API: .OpenGLES2)
        EAGLContext.setCurrentContext(glkView!.context)
        glkView!.drawableColorFormat = .RGBA8888
        glClearColor(0.0, 0.0, 0.0, 1.0) //background color
        view.multipleTouchEnabled = true
        navigationController!.interactivePopGestureRecognizer!.enabled = false;
        
        let width = UIScreen.mainScreen().bounds.width / 2.7
        let bottom = UIScreen.mainScreen().bounds.maxY
        _joystickController = JoystickView(frame: CGRectMake(2,  (bottom - width) - 2 , width, width))
        _joystickController?.joystick.addTarget(self, action: #selector(GameViewController.moveShip), forControlEvents: UIControlEvents.AllTouchEvents)
        
        let right = UIScreen.mainScreen().bounds.width
        _fireButtonController = FireButtonView(frame: CGRectMake(right - width, (bottom - width)-2, width, width))
        _fireButtonController?.fireButton.addTarget(self, action: #selector(GameViewController.fireMissile), forControlEvents: UIControlEvents.AllTouchEvents)
        
        _pauseButtonController = PauseButtonView(frame: CGRectMake((right - (right / 2) - (width / 2.5) / 2), (bottom * 0.9 ), (width / 2.5), (width / 4)))
        _pauseButtonController?.pauseButton.addTarget(self, action: #selector(GameViewController.returnToMenu), forControlEvents: UIControlEvents.TouchDown)
        
        _sheildBarController = SheildBarView(frame: CGRectMake(right - (right / 2), 37, 175, 22))
        _bossSheildBarController = EnemySheildBarView(frame: CGRectMake(11, 65, 22, 175))
        
        glkView?.addSubview(_joystickController!)
        glkView?.addSubview(_fireButtonController!)
        glkView?.addSubview(_pauseButtonController!)
        glkView?.addSubview(_sheildBarController!)
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillDisappear(animated: Bool) {
        returnToMenu()
    }
        
    //runs once
    //MARK: - INITIALIZE SPRITES
    func setup() {
        glClearColor(0.0, 0.0, 0.0, 1.0) //background color
        preferredFramesPerSecond = 60
        
        //Bullet / Enemy
        _bulletTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "laser")!.CGImage!, options: nil)
        _collisionTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "boom")!.CGImage!, options: nil)
        _enemyTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "TIE_Fighter")!.CGImage!, options: nil)
        _gameOverTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "gameover")!.CGImage!, options: nil)
        
        //game over
        _gameOverSprite.texture = _gameOverTexture!.name
        _gameOverSprite.width = 0.9
        _gameOverSprite.height = 0.5
        _gameOverSprite.position.x = 0
        _gameOverSprite.position.y = 0.1
        
        //MyPlayer Sprite
        _mySpriteTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "myShip")!.CGImage!, options: nil)
        _mySpriteUpRightTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "myShipUpRight")!.CGImage!, options: nil)
        _mySpriteUpLeftTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "myShipUpLeft")!.CGImage!, options: nil)
        _mySpriteUpTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "myShipUp")!.CGImage!, options: nil)
        _mySpriteLeftTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "myShipLeft")!.CGImage!, options: nil)
        _mySpriteRightTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "myShipRight")!.CGImage!, options: nil)

        //my ship
        _mySprite.texture = _mySpriteTexture!.name
        _mySprite.position.y = -0.5
        _mySprite.width = 0.20
        _mySprite.height = 0.20
        
        //boss Sprites
        _boss1Texture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "boss1")!.CGImage!, options: nil)
        _boss2Texture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "boss2")!.CGImage!, options: nil)
        _boss3Texture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "boss3")!.CGImage!, options: nil)
        
        //Score Sprite
        _oneScoreTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "one")!.CGImage!, options: nil)
        _twoScoreTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "two")!.CGImage!, options: nil)
        _threeScoreTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "three")!.CGImage!, options: nil)
        _fourScoreTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "four")!.CGImage!, options: nil)
        _fiveScoreTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "five")!.CGImage!, options: nil)
        _sixScoreTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "six")!.CGImage!, options: nil)
        _sevenScoreTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "seven")!.CGImage!, options: nil)
        _eightScoreTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "eight")!.CGImage!, options: nil)
        _nineScoreTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "nine")!.CGImage!, options: nil)
        _zeroScoreTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "zero")!.CGImage!, options: nil)
        
        //ScoreBoard
        let baseX: Float = -0.495
        let baseY: Float = 0.85
        let digitHeight: Float = 0.1
        let digitWidth: Float = digitHeight * 0.8
        _oneScoreSprite.height = digitHeight
        _oneScoreSprite.width = digitWidth
        _oneScoreSprite.position.x = baseX
        _oneScoreSprite.position.y = baseY
        _oneScoreSprite.texture = _zeroScoreTexture!.name

        _tenScoreSprite.height = digitHeight
        _tenScoreSprite.width = digitWidth
        _tenScoreSprite.position.x = baseX + digitWidth
        _tenScoreSprite.position.y = baseY
        _tenScoreSprite.texture = _zeroScoreTexture!.name

        _hundredScoreSprite.height = digitHeight
        _hundredScoreSprite.width = digitWidth
        _hundredScoreSprite.position.x = baseX + (digitWidth * 2)
        _hundredScoreSprite.position.y = baseY
        _hundredScoreSprite.texture = _zeroScoreTexture!.name

        _thousandScoreSprite.height = digitHeight
        _thousandScoreSprite.width = digitWidth
        _thousandScoreSprite.position.x = baseX + (digitWidth * 3)
        _thousandScoreSprite.position.y = baseY
        _thousandScoreSprite.texture = _zeroScoreTexture!.name

        _tenThousandScoreSprite.height = digitHeight
        _tenThousandScoreSprite.width = digitWidth
        _tenThousandScoreSprite.position.x = baseX + (digitWidth * 4)
        _tenThousandScoreSprite.position.y = baseY
        _tenThousandScoreSprite.texture = _zeroScoreTexture!.name

        _hundredThousandScoreSprite.height = digitHeight
        _hundredThousandScoreSprite.width = digitWidth
        _hundredThousandScoreSprite.position.x = baseX + (digitWidth * 5)
        _hundredThousandScoreSprite.position.y = baseY
        _hundredThousandScoreSprite.texture = _zeroScoreTexture!.name
        
        //Level 1 Sprite
        _level1Texture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "space2")!.CGImage!, options: nil)
        _level2Texture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "space5")!.CGImage!, options: nil)
        _level3Texture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "space1")!.CGImage!, options: nil)
        
        //background image
        _levelSprite.texture = _level1Texture!.name
        _levelSprite.position.y = 2.0
        _levelSprite.width = 3
        _levelSprite.height = 6
        
        //level message
        _levelMessageSprite.texture = _oneScoreTexture!.name
        _levelMessageSprite.position.y = 0
        _levelMessageSprite.position.x = 0
        _levelMessageSprite.width = 0.3
        _levelMessageSprite.height = 0.3
        
        //send my ship to model
        _myGame._myShip = _mySprite
    }
    
    
    //runs every frame
    //MARK: - UPDATE
    func update() {
        let now  = NSDate()
        let elapsed = now.timeIntervalSinceDate(_lastUpdate)
        _lastUpdate = now
        
        if(!_myGame._paused && !_myGame._gameOver){

            _myGame.executeGameLoop(elapsed)
            
            if(_myGame.loadNextLevel){
                nextLevel()
            }
            
            if(_myGame.showLevelMessage){
                nextLevelMessage()
            }
            
            //Move the level . Stops before end of image
            if(_levelSprite.position.y > -1.9){
                _levelSprite.position.y -= Float(_myGame._moveLevel)
            }
            
            updateScore()
            updateLifeBar()
            
            if(_myGame.showBossSheild){
                view.addSubview(_bossSheildBarController!)
            } else {
                _bossSheildBarController?.removeFromSuperview()
            }
            
            
            updateBossLifeBar()
            
            //Get Touch
            if(_joystickController!.joystick._held){
                moveShip()
            }
            
            if(_fireButtonController!.fireButton._held){
                fireMissile()
            }
        }
    }
    
    //draws each frame
    //MARK: - DRAW
    override func glkView(view: GLKView, drawInRect rect: CGRect) {
        if(!_myGame._paused){
            glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
            //GL aspect ratio
            let height: GLsizei = GLsizei(view.bounds.height * view.contentScaleFactor)
            let offset: GLsizei = GLsizei(((view.bounds.height - view.bounds.width) * -0.5) * view.contentScaleFactor)
            glViewport(offset, 0, height,  height)
            
            //Draw sprites
            _levelSprite.draw()
            
            if(_myGame.showLevelMessage){
                _levelMessageSprite.draw()
            }
            
            //Draw Updated Sprites
            drawEnemyShips()
            drawMyBullets()
            drawEnemyBullets()
            drawCollisions()
            drawScore()
            
            if(!_myGame._gameOver){
                _mySprite.draw()
            } else {
                
                _gameOverSprite.draw()
            }
        }
    }
    
    //MARK: - Draw Helper
    
    //draws all the score sprites
    private func drawScore(){
        _oneScoreSprite.draw()
        _tenScoreSprite.draw()
        _hundredScoreSprite.draw()
        _thousandScoreSprite.draw()
        _tenThousandScoreSprite.draw()
        _hundredThousandScoreSprite.draw()
    }
    
    //Draws all current enemy ships in the game
    private func drawEnemyShips(){
        var indexToRemove = [Int]()
        var index = 0

        for sprites in _myGame._gameEnemy {
            if(_myGame._time >= sprites.startTime && _myGame._time < sprites.endTime) {
                sprites.texture = (_enemyTexture?.name)!
                sprites.draw()
            } else if (sprites.needsDeleted){
                indexToRemove.append(index)
            } else if (_myGame._time >= sprites.startTime && sprites.endTime == -100){
                if(_myGame._level == 1){
                    sprites.texture = (_boss1Texture?.name)!
                    sprites.draw()
                } else if (_myGame._level == 2){
                    sprites.texture = (_boss2Texture?.name)!
                    sprites.draw()
                } else if (_myGame._level == 3){
                    sprites.texture = (_boss2Texture?.name)!
                    sprites.draw()
                }
            }
            index += 1
        }
        while (indexToRemove.count > 0){
            _myGame._gameEnemy.removeAtIndex(indexToRemove.popLast()!)
        }
    }
    
    //Draws all current bullets in the game.
    private func drawMyBullets(){
        var indexToRemove = [Int]()
        var index = 0
        for sprites in _myGame._gameMyBullets {
            if(_myGame._time >= sprites.startTime && _myGame._time < sprites.endTime) {
                sprites.texture = (_bulletTexture?.name)!
                sprites.draw()
            } else if (sprites.needsDeleted){
                indexToRemove.append(index)
            }
            index += 1
        }
        while (indexToRemove.count > 0){
            _myGame._gameMyBullets.removeAtIndex(indexToRemove.popLast()!)
        }
    }
    
    //draws all the current collisions in the game
    private func drawCollisions(){
        var indexToRemove = [Int]()
        var index = 0
        for sprites in _myGame._gameCollisions {
            if(_myGame._time >= sprites.startTime && _myGame._time < sprites.endTime) {
                sprites.texture = (_collisionTexture?.name)!
                sprites.draw()
            } else if (sprites.needsDeleted){
                indexToRemove.append(index)
            }
            index += 1
        }
        while (indexToRemove.count > 0){
            _myGame._gameCollisions.removeAtIndex(indexToRemove.popLast()!)
        }
    }
    
    //draws the list of enemy bullets in the game
    private func drawEnemyBullets(){
        var indexToRemove = [Int]()
        var index = 0
        for ebullet in _myGame._gameEnemyBullets {
            if(_myGame._time >= ebullet.startTime && _myGame._time < ebullet.endTime) {
                ebullet.texture = (_bulletTexture?.name)!
                ebullet.draw()
            } else if (ebullet.needsDeleted){
                indexToRemove.append(index)
            }
            index += 1
        }
        while (indexToRemove.count > 0){
            _myGame._gameEnemyBullets.removeAtIndex(indexToRemove.popLast()!)
        }
    }
    
    //Updates the players score on the screen using sprites
    private func updateScore(){
        let number = _myGame.score
        var numArray = number.array
       
        //makes sure we have all 6 values
        while numArray.count < 6 {
            numArray.insert(0, atIndex: 0)
        }
        
        //keep this order
        _oneScoreSprite.texture = updateScoreTexture(numArray.removeFirst())
        _tenScoreSprite.texture = updateScoreTexture(numArray.removeFirst())
        _hundredScoreSprite.texture = updateScoreTexture(numArray.removeFirst())
        _thousandScoreSprite.texture = updateScoreTexture(numArray.removeFirst())
        _tenThousandScoreSprite.texture = updateScoreTexture(numArray.removeFirst())
        _hundredThousandScoreSprite.texture = updateScoreTexture(numArray.removeFirst())
    }
    
    private func updateLifeBar(){
        //get value
        if(_myGame.myLife < 0){
            _sheildBarController?.sheildBar.value = 0
        } else {
            _sheildBarController?.sheildBar.value = _myGame.myLife
        }
        
        //change color
        if(_myGame.myLife < 75){
            _sheildBarController?.sheildBar.rColor = 1.0
            _sheildBarController?.sheildBar.gColor = 1.0
            _sheildBarController?.sheildBar.bColor = 0.0
        }
        if (_myGame.myLife < 50){
            _sheildBarController?.sheildBar.rColor = 1.0
            _sheildBarController?.sheildBar.gColor = CGFloat(165/255)
            _sheildBarController?.sheildBar.bColor = 0.0
        }
        if (_myGame.myLife < 25){
            _sheildBarController?.sheildBar.rColor = 1.0
            _sheildBarController?.sheildBar.gColor = 0.0
            _sheildBarController?.sheildBar.bColor = 0.0
        }
        if (_myGame.myLife <= 0){
            _sheildBarController?.sheildBar.rColor = 0.0
            _sheildBarController?.sheildBar.gColor = 1.0
            _sheildBarController?.sheildBar.bColor = 0.0
        }
    }
    
    
    private func updateBossLifeBar(){
        
        //get value

        _bossSheildBarController?.sheildBar.value = _myGame.bossLife
        
        
        //change color
        if(_myGame.bossLife < 300){
            _bossSheildBarController?.sheildBar.rColor = 0.0
            _bossSheildBarController?.sheildBar.gColor = 1.0
            _bossSheildBarController?.sheildBar.bColor = 0.0
            _bossSheildBarController?.sheildBar.aColor = 0.5
        }
        if (_myGame.bossLife < 225){
            _bossSheildBarController?.sheildBar.rColor = 1.0
            _bossSheildBarController?.sheildBar.gColor = 1.0
            _bossSheildBarController?.sheildBar.bColor = 0.0
            _bossSheildBarController?.sheildBar.aColor = 0.5
        }
        if (_myGame.bossLife < 150){
            _bossSheildBarController?.sheildBar.rColor = 1.0
            _bossSheildBarController?.sheildBar.gColor = CGFloat(165/255)
            _bossSheildBarController?.sheildBar.bColor = 0.0
            _bossSheildBarController?.sheildBar.aColor = 0.5
        }
        if (_myGame.bossLife < 75){
            _bossSheildBarController?.sheildBar.rColor = 1.0
            _bossSheildBarController?.sheildBar.gColor = 0.0
            _bossSheildBarController?.sheildBar.bColor = 0.0
            _bossSheildBarController?.sheildBar.aColor = 0.5
        }
        if (_myGame.bossLife < 0){
            _bossSheildBarController?.sheildBar.aColor = 0
        }
    }
    

    //Returns a texture that matches the input Int
    private func updateScoreTexture(number: Int) -> GLuint{
        var update: GLuint = 0
        if(number == 0){
            update = (_zeroScoreTexture!.name)
        } else if(number == 1){
            update = (_oneScoreTexture!.name)
        } else if(number == 2){
            update = (_twoScoreTexture!.name)
        } else if(number == 3){
            update = (_threeScoreTexture!.name)
        } else if(number == 4){
            update = (_fourScoreTexture!.name)
        } else if(number == 5){
            update = (_fiveScoreTexture!.name)
        } else if(number == 6){
            update = (_sixScoreTexture!.name)
        } else if(number == 7){
            update = (_sevenScoreTexture!.name)
        } else if(number == 8){
            update = (_eightScoreTexture!.name)
        } else if(number == 9){
            update = (_nineScoreTexture!.name)
        }
        return update
    }
    
    private func nextLevel(){
        let level = _myGame._level
        if(level == 1){
            _levelSprite.texture = _level1Texture!.name
            _levelMessageSprite.texture = _oneScoreTexture!.name
        } else if(level == 2){
            _levelSprite.texture = _level2Texture!.name
            _levelMessageSprite.texture = _twoScoreTexture!.name
        } else if (level == 3){
            _levelSprite.texture = _level3Texture!.name
            _levelMessageSprite.texture = _threeScoreTexture!.name
        }
        _levelSprite.position.y = 2.0
        _levelSprite.width = 3
        _levelSprite.height = 6
    }
    
    private func nextLevelMessage(){
        let level = _myGame._level
        if(level == 2){
            _levelMessageSprite.texture = _twoScoreTexture!.name
        } else if (level == 3){
            _levelMessageSprite.texture = _threeScoreTexture!.name
        }
    }
    
    //MARK: - DASHBOARD TOUCHES
    
    //pauses the game and returns the player to the menu
    func returnToMenu(){
        _myGame._paused = true
        _myGame.writeToFile()
        navigationController?.popViewControllerAnimated(true)
    }
 
    //gets touches from FrieButton and launches missiles
    func fireMissile() {
        //Fire button
        if(!_myGame._paused){
            _myGame.playerFire()
        }
    }
    
    //Get direction from Joystick and moves the Player ship
    func moveShip(){
        if(!_myGame._paused){
            //MOVEMENT
            if(_joystickController?.joystick.touchAngle < -1.95 && _joystickController?.joystick.touchAngle > -2.65){
                //UP & LEFT - Diagonal
                _mySprite.moveUpLeft()
                _mySprite.texture = _mySpriteUpLeftTexture!.name
            }else if(_joystickController?.joystick.touchAngle < -1.25 && _joystickController?.joystick.touchAngle > 0.40){
                //UP & RIGHT - Diagonal
                _mySprite.moveUpRight()
                _mySprite.texture = _mySpriteUpRightTexture!.name
            }else if(_joystickController?.joystick.touchAngle < 2.65 && _joystickController?.joystick.touchAngle > 1.95){
                //DOWN & LEFT - Diagonal
                _mySprite.moveDownLeft()
                _mySprite.texture = _mySpriteTexture!.name
            }else if(_joystickController?.joystick.touchAngle < 1.25 && _joystickController?.joystick.touchAngle > 0.40){
                //DOWN & Right - Diagonal
                _mySprite.moveDownRight()
                _mySprite.texture = _mySpriteTexture!.name
            }else if(_joystickController?.joystick.touchAngle <= 1.95 && _joystickController?.joystick.touchAngle >= 1.25){
                //DOWN
                _mySprite.moveDown()
                _mySprite.texture = _mySpriteTexture!.name
            }else if(_joystickController?.joystick.touchAngle <= -1.25 && _joystickController?.joystick.touchAngle >= -1.95){
                //UP
                _mySprite.moveUp()
                _mySprite.texture = _mySpriteUpTexture!.name
            } else if(_joystickController?.joystick.touchAngle <= -2.60 || _joystickController?.joystick.touchAngle >= 2.60){
                //LEFT
                _mySprite.moveLeft()
                _mySprite.texture = _mySpriteLeftTexture!.name
            }else if(_joystickController?.joystick.touchAngle < 0.40 || _joystickController?.joystick.touchAngle > -0.40){
                //RIGHT
                _mySprite.moveRight()
                _mySprite.texture = _mySpriteRightTexture!.name
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(_myGame._gameOver){
            navigationController?.popViewControllerAnimated(true)
        }
    }
//    
//    override func encodeRestorableStateWithCoder(coder: NSCoder) {
//        super.encodeRestorableStateWithCoder(coder)
//        _myGame.pa
//        _myGame.writeToFile()
//    }
//    
//    override func decodeRestorableStateWithCoder(coder: NSCoder) {
//        super.decodeRestorableStateWithCoder(coder)
//    }
}

//MARK:- HELPER
//helper to set score on screen with sprites
//converts int to int array
extension Int {
    var array: [Int] {
        return description.characters.map{Int(String($0)) ?? 0}
    }
}
