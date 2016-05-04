//
//  MainMenuController.swift
//  Nebula
//
//  Created by Jordan Davis on 4/27/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit
import GLKit

class MainMenuController: UIViewController {
    
    private var _gameView: GameViewController = GameViewController()
    private var _game: Game = Game.sharedInstance
    
    var menuView: MainMenuView {
        return view as! MainMenuView
    }
    
    override func loadView() {
        view = MainMenuView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        //disable resume button
        if(_game._paused){
            menuView.activeResumeButton(true)
        } else {
            menuView.activeResumeButton(false)
        }
        if(_game._gameOver){
            if(_game.addNewScore()){
                navigationController?.pushViewController(LeaderboardController(), animated: false)
            }
            menuView.activeResumeButton(false)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        

        if(_game._paused){
            menuView.activeResumeButton(true)
        } else {
            menuView.activeResumeButton(false)
        }
        
        if(_game._gameOver){
            if(_game.addNewScore()){
                navigationController?.pushViewController(LeaderboardController(), animated: false)
            }
            menuView.activeResumeButton(false)

        }
        
        //setup buttons
        menuView.resumeGame.addTarget(self, action: #selector(MainMenuController.resume), forControlEvents: UIControlEvents.TouchUpInside)
        
        menuView.startGame.addTarget(self, action: #selector(MainMenuController.new), forControlEvents: UIControlEvents.TouchUpInside)
        
        menuView.leaderboard.addTarget(self, action: #selector(MainMenuController.highscores), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func resume() {
        _game._paused = false
        _gameView._lastUpdate = NSDate()
        navigationController?.pushViewController(_gameView, animated: true)
    }
    
    func new() {
        _game.reset()
        navigationController?.pushViewController(_gameView, animated: true)
    }
    
    func highscores(){
        navigationController?.pushViewController(LeaderboardController(), animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
}
