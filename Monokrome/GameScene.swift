//
//  GameScene.swift
//  Monokrome
//
//  Created by Daniel Song on 2016-07-27.
//  Copyright (c) 2016 Bin Song. All rights reserved.
//

import SpriteKit
import GameKit

class GameScene: SKScene {
    
    var parentViewController: GameViewController!
    var interstitialDelegate: InterstitialDelegate!
    
    var leftBackgroundNode: SKSpriteNode!
    var rightBackgroundNode: SKSpriteNode!
    var leftTargetNode: SKSpriteNode!
    var rightTargetNode: SKSpriteNode!
    var monokromeParentNode: SKNode!
    var scoreLabelNode: SKLabelNode!
    var startMenuBackgroundNode: SKSpriteNode!
    var startMenuHighscoreLabelNode: SKLabelNode!
    var startMenuStartButtonNode: SKSpriteNode!
    var startMenuLeaderboardsButtonNode: SKSpriteNode!
    var startMenuHelpButtonNode: SKSpriteNode!
    var helpMenuBackgroundNode: SKSpriteNode!
    
    var lastUpdateTime: CFTimeInterval!
    var lastSpawnTime: CFTimeInterval = 0.0
    var timeBetweenSpawns: CFTimeInterval = 3.0 / 4.0
    var currentDownSpeed: CFTimeInterval = 1.0 / 3.0
    
    var running: Bool = false
    
    var score: Int = 0 {
        didSet {
            scoreLabelNode.run(SKAction.scale(to: 5.0 / 4.0, duration: timeBetweenSpawns / 4), completion: {
                self.scoreLabelNode.text = "\(self.score)"
                self.scoreLabelNode.run(SKAction.scale(to: 1.0, duration: self.timeBetweenSpawns / 4))
            })
        }
    }
    
    let helpText = ["In monoKrome, your goal is to", "capture as many monoKromes as", "possible. monoKromes will fall", "from the top of the screen. Tap", "the rings at the bottom of the", "screen in order to capture them.", "Be careful though; tap when there", "aren't any monoKromes in the rings", "and a point will be deducted."]
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        leftBackgroundNode = SKSpriteNode(color: UIColor(hue: 0.0, saturation: 0.0, brightness: 0.3, alpha: 1.0), size: CGSize(width: size.width / 2, height: size.height))
        leftBackgroundNode.position = CGPoint(x: -size.width / 4, y: -size.height / 2)
        addChild(leftBackgroundNode)
        
        rightBackgroundNode = SKSpriteNode(color: UIColor(hue: 0.0, saturation: 0.0, brightness: 0.9, alpha: 1.0), size: CGSize(width: size.width / 2, height: size.height))
        rightBackgroundNode.position = CGPoint(x: size.width / 4, y: -size.height / 2)
        addChild(rightBackgroundNode)
        
        leftTargetNode = SKSpriteNode(texture: SKTexture(imageNamed: "Target"), color: UIColor(white: 1.0, alpha: 1.0), size: CGSize(width: size.width * 3 / 8, height: size.width * 3 / 8))
        leftTargetNode.name = "leftTarget"
        leftTargetNode.position = CGPoint(x: -size.width / 4, y: size.width / 4 - size.height)
        leftTargetNode.zPosition = 16
        addChild(leftTargetNode)
        
        rightTargetNode = SKSpriteNode(texture: SKTexture(imageNamed: "Target"), color: UIColor(white: 1.0, alpha: 1.0), size: CGSize(width: size.width * 3 / 8, height: size.width * 3 / 8))
        rightTargetNode.name = "rightTarget"
        rightTargetNode.position = CGPoint(x: size.width / 4, y: size.width / 4 - size.height)
        rightTargetNode.zPosition = 16
        addChild(rightTargetNode)
        
        monokromeParentNode = SKNode()
        monokromeParentNode.position = CGPoint(x: 0.0, y: -size.height / 2)
        addChild(monokromeParentNode)
        
        scoreLabelNode = SKLabelNode(fontNamed: "Josefin Sans Light")
        scoreLabelNode.fontSize = size.width / 4
        scoreLabelNode.fontColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.6, alpha: 1.0)
        scoreLabelNode.text = "\(score)"
        scoreLabelNode.position = CGPoint(x: 0.0, y: -size.height * 3 / 16)
        addChild(scoreLabelNode)
        
        startMenuBackgroundNode = SKSpriteNode(color: UIColor(white: 0.9, alpha: 1.0), size: CGSize(width: size.width, height: size.height))
        startMenuBackgroundNode.position = CGPoint(x: 0.0, y: size.height / 2)
        startMenuBackgroundNode.zPosition = 32
        addChild(startMenuBackgroundNode)
        
        let startMenuTitleLabelNode = SKLabelNode(fontNamed: "Josefin Sans Light")
        startMenuTitleLabelNode.fontSize = size.width / 6
        startMenuTitleLabelNode.fontColor = UIColor(white: 0.3, alpha: 1.0)
        startMenuTitleLabelNode.text = "monoKrome"
        startMenuTitleLabelNode.position = CGPoint(x: 0.0, y: size.height * 5 / 16)
        startMenuTitleLabelNode.zPosition = 48
        startMenuBackgroundNode.addChild(startMenuTitleLabelNode)
        
        startMenuStartButtonNode = SKSpriteNode(texture: SKTexture(imageNamed: "StartButton"), color: UIColor(white: 1.0, alpha: 1.0), size: CGSize(width: size.width, height: size.width / 4))
        startMenuStartButtonNode.name = "start"
        startMenuStartButtonNode.position = CGPoint(x: 0.0, y: size.width * 18 / 32 - size.height / 2)
        startMenuStartButtonNode.zPosition = 48
        startMenuBackgroundNode.addChild(startMenuStartButtonNode)
        
        startMenuHelpButtonNode = SKSpriteNode(texture: SKTexture(imageNamed: "HelpButton"), color: UIColor(white: 1.0, alpha: 1.0), size: CGSize(width: size.width, height: size.width / 4))
        startMenuHelpButtonNode.name = "help"
        startMenuHelpButtonNode.position = CGPoint(x: 0.0, y: size.width * 11 / 32 - size.height / 2)
        startMenuHelpButtonNode.zPosition = 48
        startMenuBackgroundNode.addChild(startMenuHelpButtonNode)
        
        startMenuLeaderboardsButtonNode = SKSpriteNode(texture: SKTexture(imageNamed: "LeaderboardsButton"), color: UIColor(white: 1.0, alpha: 1.0), size: CGSize(width: size.width, height: size.width / 4))
        startMenuLeaderboardsButtonNode.name = "leaderboards"
        startMenuLeaderboardsButtonNode.position = CGPoint(x: 0.0, y: size.width * 4 / 32 - size.height / 2)
        startMenuLeaderboardsButtonNode.zPosition = 48
        startMenuBackgroundNode.addChild(startMenuLeaderboardsButtonNode)
        
        startMenuHighscoreLabelNode = SKLabelNode(fontNamed: "Josefin Sans Light")
        startMenuHighscoreLabelNode.fontSize = size.height / 16
        startMenuHighscoreLabelNode.fontColor = UIColor(white: 0.3, alpha: 1.0)
        startMenuHighscoreLabelNode.text = "Highscore: \(UserDefaults.standard.integer(forKey: "highscore"))"
        startMenuHighscoreLabelNode.position = CGPoint(x: 0.0, y: startMenuTitleLabelNode.position.y - (startMenuTitleLabelNode.position.y - startMenuStartButtonNode.position.y) * 5 / 8)
        startMenuHighscoreLabelNode.zPosition = 48
        startMenuBackgroundNode.addChild(startMenuHighscoreLabelNode)
        
        let expandAction = SKAction.scale(to: 17.0 / 16.0, duration: 0.5)
        expandAction.timingMode = .easeInEaseOut
        let contractAction = SKAction.scale(to: 1.0, duration: 0.5)
        contractAction.timingMode = .easeInEaseOut
        startMenuHighscoreLabelNode.run(SKAction.repeatForever(SKAction.sequence([expandAction, contractAction])))
        
        helpMenuBackgroundNode = SKSpriteNode(color: UIColor(white: 0.3, alpha: 1.0), size: CGSize(width: size.width, height: size.height))
        helpMenuBackgroundNode.name = "helpBackgroundNode"
        helpMenuBackgroundNode.alpha = 0.0
        helpMenuBackgroundNode.position = CGPoint(x: 0.0, y: size.height / 2)
        helpMenuBackgroundNode.zPosition = 128
        addChild(helpMenuBackgroundNode)
        
        for i in 0 ..< helpText.count {
            let helpTextLabelNode = SKLabelNode(fontNamed: "Josefin Sans Light")
            helpTextLabelNode.fontSize = size.width / 16
            helpTextLabelNode.fontColor = UIColor(white: 0.9, alpha: 1.0)
            helpTextLabelNode.text = helpText[i]
            helpTextLabelNode.position = CGPoint(x: 0.0, y: size.width / 24 * CGFloat(helpText.count) - size.width / 12 * CGFloat(i))
            helpTextLabelNode.zPosition = 160
            helpMenuBackgroundNode.addChild(helpTextLabelNode)
        }
        
        let tapInformationLabelNode = SKLabelNode(fontNamed: "Josefin Sans Light")
        tapInformationLabelNode.fontSize = size.width / 16
        tapInformationLabelNode.fontColor = UIColor(white: 0.9, alpha: 1.0)
        tapInformationLabelNode.text = "TAP TO CONTINUE"
        tapInformationLabelNode.position = CGPoint(x: 0.0, y: -size.height / 2 + size.height / 16)
        tapInformationLabelNode.zPosition = 160
        helpMenuBackgroundNode.addChild(tapInformationLabelNode)
        
        GKLocalPlayer.localPlayer().authenticateHandler = { (viewController: UIViewController?, error: Error?) -> Void in
            if viewController != nil {
                self.parentViewController.present(viewController!, animated: true, completion: nil)
            }
            
            if GKLocalPlayer.localPlayer().isAuthenticated {
                let leaderboard = GKLeaderboard()
                leaderboard.identifier = "TopScoreLeaderboard"
                leaderboard.loadScores(completionHandler: { (scores: [GKScore]?, error: Error?) -> Void in
                    if error == nil {
                        UserDefaults.standard.set(Int(leaderboard.localPlayerScore!.value) > UserDefaults.standard.integer(forKey: "highscore") ? Int(leaderboard.localPlayerScore!.value) : UserDefaults.standard.integer(forKey: "highscore"), forKey: "highscore")
                        self.startMenuHighscoreLabelNode.text = "Highscore: \(UserDefaults.standard.integer(forKey: "highscore"))"
                    }
                })
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if running {
            var leftTapped = false
            var rightTapped = false
            var leftMonokromeFlag = false
            var rightMonokromeFlag = false
            for touch in touches {
                for node in nodes(at: touch.location(in: self)) {
                    if node.name == "leftTarget" || node.name == "rightTarget" {
                        node.run(SKAction.sequence([SKAction.scale(to: 0.5, duration: timeBetweenSpawns / 4), SKAction.scale(to: 1.0, duration: timeBetweenSpawns / 4)]))
                    }
                    if node.name == "leftTarget" {
                        leftTapped = true
                    }
                    if node.name == "rightTarget" {
                        rightTapped = true
                    }
                    for monokrome in monokromeParentNode.children {
                        if (node.name == "leftTarget" && monokrome.name == "leftMonokrome" && monokrome.position.y + monokromeParentNode.position.y >= size.width / 16 && monokrome.position.y + monokromeParentNode.position.y < size.width * 7 / 16) || (node.name == "rightTarget" && monokrome.name == "rightMonokrome" && monokrome.position.y + monokromeParentNode.position.y >= size.width / 16 && monokrome.position.y + monokromeParentNode.position.y < size.width * 7 / 16) {
                            let animationMonokrome = SKSpriteNode(texture: (monokrome as! SKSpriteNode).texture, color: UIColor(white: 1.0, alpha: 1.0), size: (monokrome as! SKSpriteNode).size)
                            animationMonokrome.position = CGPoint(x: monokrome.position.x, y: monokrome.position.y + monokromeParentNode.position.y)
                            addChild(animationMonokrome)
                            monokrome.removeFromParent()
                            let fadeAction = SKAction.fadeAlpha(to: 0.0, duration: timeBetweenSpawns / 2)
                            fadeAction.timingMode = .easeIn
                            let scaleAction = SKAction.scale(to: 4.0, duration: timeBetweenSpawns / 2)
                            scaleAction.timingMode = .easeOut
                            animationMonokrome.run(fadeAction)
                            animationMonokrome.run(scaleAction, completion: {
                                animationMonokrome.removeFromParent()
                            })
                            score += 1
                            if monokrome.name == "leftMonokrome" {
                                leftMonokromeFlag = true
                            }
                            if monokrome.name == "rightMonokrome" {
                                rightMonokromeFlag = true
                            }
                        }
                    }
                }
            }
            if leftTapped && !leftMonokromeFlag {
                score = score <= 0 ? 0 : score - 1
            }
            if rightTapped && !rightMonokromeFlag {
                score = score <= 0 ? 0 : score - 1
            }
        }
        
        let touchedNode = nodes(at: touches.first!.location(in: self)).first!
        if touchedNode.name == "start" {
            startMenuStartButtonNode.run(SKAction.sequence([SKAction.scale(to: 0.875, duration: 0.125), SKAction.scale(to: 1.0, duration: 0.125)]), completion: {
                self.startGame()
            })
        }
        if touchedNode.name == "leaderboards" {
            startMenuLeaderboardsButtonNode.run(SKAction.sequence([SKAction.scale(to: 0.875, duration: 0.125), SKAction.scale(to: 1.0, duration: 0.125)]), completion: {
                let gameCenterController = GKGameCenterViewController()
                gameCenterController.gameCenterDelegate = self.parentViewController
                gameCenterController.viewState = .leaderboards
                gameCenterController.leaderboardIdentifier = "TopScoreLeaderboard"
                self.parentViewController.present(gameCenterController, animated: true, completion: nil)
            })
        }
        if touchedNode.name == "help" {
            startMenuHelpButtonNode.run(SKAction.sequence([SKAction.scale(to: 0.875, duration: 0.125), SKAction.scale(to: 1.0, duration: 0.125)]), completion: {
                self.helpMenuBackgroundNode.run(SKAction.fadeAlpha(to: 15.0 / 16.0, duration: 0.5))
            })
        }
        for node in nodes(at: touches.first!.location(in: self)) {
            if node.name == "helpBackgroundNode" {
                self.helpMenuBackgroundNode.run(SKAction.fadeAlpha(to: 0.0, duration: 0.5))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if running {
            if lastUpdateTime == nil {
                lastUpdateTime = currentTime
            } else {
                if currentTime - lastSpawnTime > timeBetweenSpawns {
                    spawnMonokromes()
                    lastSpawnTime = currentTime
                }
            }
            
            monokromeParentNode.position = CGPoint(x: 0.0, y: monokromeParentNode.position.y - CGFloat(currentDownSpeed * (currentTime - lastUpdateTime)) * size.height)
            
            timeBetweenSpawns = (timeBetweenSpawns - 0.25) * pow(15.0 / 16.0, currentTime - lastUpdateTime) + 0.25
            currentDownSpeed = 0.25 / timeBetweenSpawns
            
            for monokrome in monokromeParentNode.children {
                if monokrome.position.y + monokromeParentNode.position.y < size.width / 16 {
                    endGame()
                }
            }
        }
        lastUpdateTime = currentTime
    }
    
    func startGame() {
        score = 0
        
        timeBetweenSpawns = 3.0 / 4.0
        
        let moveAction = SKAction.moveBy(x: 0.0, y: size.height, duration: 1.0)
        moveAction.timingMode = .easeInEaseOut
        leftBackgroundNode.run(moveAction)
        rightBackgroundNode.run(moveAction)
        leftTargetNode.run(moveAction)
        rightTargetNode.run(moveAction)
        monokromeParentNode.run(moveAction)
        scoreLabelNode.run(moveAction)
        startMenuBackgroundNode.run(moveAction, completion: {
            self.startMenuBackgroundNode.alpha = 0.0
            
            self.running = true
            
            self.interstitialDelegate.prepareInterstitial()
        })
    }
    
    func endGame() {
        if running == true {
            running = false
            
            for monokrome in monokromeParentNode.children {
                let animationMonokrome = SKSpriteNode(texture: (monokrome as! SKSpriteNode).texture, color: UIColor(white: 1.0, alpha: 1.0), size: (monokrome as! SKSpriteNode).size)
                animationMonokrome.position = CGPoint(x: monokrome.position.x, y: monokrome.position.y + monokromeParentNode.position.y)
                addChild(animationMonokrome)
                monokrome.removeFromParent()
                let fadeAction = SKAction.fadeAlpha(to: 0.0, duration: 0.25)
                fadeAction.timingMode = .easeIn
                let scaleAction = SKAction.scale(to: 4.0, duration: 0.25)
                scaleAction.timingMode = .easeOut
                animationMonokrome.run(fadeAction)
                animationMonokrome.run(scaleAction, completion: {
                    animationMonokrome.removeFromParent()
                })
            }
            
            UserDefaults.standard.set(score > UserDefaults.standard.integer(forKey: "highscore") ? score : UserDefaults.standard.integer(forKey: "highscore"), forKey: "highscore")
            startMenuHighscoreLabelNode.text = "Highscore: \(UserDefaults.standard.integer(forKey: "highscore"))"
            
            if GKLocalPlayer.localPlayer().isAuthenticated {
                let score = GKScore(leaderboardIdentifier: "TopScoreLeaderboard")
                score.value = Int64(self.score)
                GKScore.report([score], withCompletionHandler: nil)
                
                let leaderboard = GKLeaderboard()
                leaderboard.identifier = "TopScoreLeaderboard"
                leaderboard.loadScores(completionHandler: { (scores: [GKScore]?, error: Error?) -> Void in
                    if error == nil {
                        UserDefaults.standard.set(Int(leaderboard.localPlayerScore!.value) > UserDefaults.standard.integer(forKey: "highscore") ? Int(leaderboard.localPlayerScore!.value) : UserDefaults.standard.integer(forKey: "highscore"), forKey: "highscore")
                        self.startMenuHighscoreLabelNode.text = "Highscore: \(UserDefaults.standard.integer(forKey: "highscore"))"
                    }
                })
            }
            
            self.startMenuBackgroundNode.alpha = 1.0
            
            let delayAction = SKAction.wait(forDuration: 0.5)
            var moveAction = SKAction.moveBy(x: 0.0, y: -size.height, duration: 1.0)
            moveAction.timingMode = .easeInEaseOut
            moveAction = SKAction.sequence([delayAction, moveAction])
            leftBackgroundNode.run(moveAction)
            rightBackgroundNode.run(moveAction)
            leftTargetNode.run(moveAction)
            rightTargetNode.run(moveAction)
            monokromeParentNode.run(moveAction)
            scoreLabelNode.run(moveAction)
            startMenuBackgroundNode.run(moveAction, completion: {
                
                self.interstitialDelegate.presentInterstitial()
            })
        }
    }
    
    func spawnMonokromes() {
        let randomNumber = arc4random_uniform(4)
        if randomNumber & 0x2 != 0 {
            let monokromeNode = SKSpriteNode(texture: SKTexture(imageNamed: "LeftMonokrome"), color: UIColor(white: 1.0, alpha: 1.0), size: CGSize(width: size.width * 3 / 16, height: size.width * 3 / 16))
            monokromeNode.name = "leftMonokrome"
            monokromeNode.position = CGPoint(x: -size.width / 4, y: size.height - monokromeParentNode.position.y)
            monokromeNode.alpha = 0.0
            monokromeParentNode.addChild(monokromeNode)
            
            monokromeNode.run(SKAction.fadeAlpha(to: 1.0, duration: timeBetweenSpawns / 4))
            monokromeNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.25, duration: 0.5), SKAction.scale(to: 0.8, duration: 0.5)])))
        }
        if randomNumber & 0x1 != 0 {
            let monokromeNode = SKSpriteNode(texture: SKTexture(imageNamed: "RightMonokrome"), color: UIColor(white: 1.0, alpha: 1.0), size: CGSize(width: size.width * 3 / 16, height: size.width * 3 / 16))
            monokromeNode.name = "rightMonokrome"
            monokromeNode.position = CGPoint(x: size.width / 4, y: size.height - monokromeParentNode.position.y)
            monokromeNode.alpha = 0.0
            monokromeParentNode.addChild(monokromeNode)
            
            monokromeNode.run(SKAction.fadeAlpha(to: 1.0, duration: timeBetweenSpawns / 4))
            monokromeNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.25, duration: 0.5), SKAction.scale(to: 0.8, duration: 0.5)])))
        }
    }
    
}
