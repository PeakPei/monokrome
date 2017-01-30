//
//  GameViewController.swift
//  Monokrome
//
//  Created by Daniel Song on 2016-07-27.
//  Copyright (c) 2016 Bin Song. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import GoogleMobileAds

class GameViewController: UIViewController {
    
    let interstitialAdUnitID = "ca-app-pub-8564143878629299/2765979360"
    
    var interstitial: GADInterstitial!
    
    var interstitialNumberOfTimesPresented: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene(fileNamed: "GameScene") {
            let skView = self.view as! SKView
            
            skView.ignoresSiblingOrder = true
            
            scene.scaleMode = .resizeFill
            scene.interstitialDelegate = self
            scene.parentViewController = self
            
            skView.presentScene(scene)
        }
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}

extension GameViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
}

extension GameViewController: InterstitialDelegate {
    
    func prepareInterstitial() {
        if interstitial == nil || interstitial.hasBeenUsed {
            interstitial = GADInterstitial(adUnitID: interstitialAdUnitID)
            let request = GADRequest()
            request.keywords = ["gaming", "arcade", "strategy", "games", "fun", "endless", "2D"]
            request.testDevices = [kGADSimulatorID]
            interstitial.load(request)
        }
    }
    
    func presentInterstitial() {
        if interstitial.isReady {
            if interstitialNumberOfTimesPresented % 4 == 0 {
                interstitial.present(fromRootViewController: self)
            }
            interstitialNumberOfTimesPresented += 1
        }
    }
    
}

protocol InterstitialDelegate {
    
    func prepareInterstitial()
    
    func presentInterstitial()
    
}
