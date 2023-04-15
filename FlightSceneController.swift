//
//  FlightSceneController.swift
//  Constellation Explorer
//
//  Created by David Mazzeo on 15/4/2023.
//

import SpriteKit
import CoreMotion

class FlightScene: SKScene, SKPhysicsContactDelegate {
    
    let rocketImages = [SKTexture(imageNamed: "Rocket 1"),
                        SKTexture(imageNamed: "Rocket 2"),
                        SKTexture(imageNamed: "Rocket 3"),
                        SKTexture(imageNamed: "Rocket 4"),
                        SKTexture(imageNamed: "Rocket 3A"),
                        SKTexture(imageNamed: "Rocket 5"),
                        SKTexture(imageNamed: "Rocket 6")]
    
    let cometImages = [SKTexture(imageNamed: "Comet 1"),
                       SKTexture(imageNamed: "Comet 2"),
                       SKTexture(imageNamed: "Comet 3"),
                       SKTexture(imageNamed: "Comet 4"),
                       SKTexture(imageNamed: "Comet 5"),
                       SKTexture(imageNamed: "Comet 6"),
                       SKTexture(imageNamed: "Comet 7"),
                       SKTexture(imageNamed: "Comet 8")]
    
    let blackHoleImages = [SKTexture(imageNamed: "Black Hole 1"),
                           SKTexture(imageNamed: "Black Hole 2"),
                           SKTexture(imageNamed: "Black Hole 3"),
                           SKTexture(imageNamed: "Black Hole 4"),
                           SKTexture(imageNamed: "Black Hole 5"),
                           SKTexture(imageNamed: "Black Hole 6"),
                           SKTexture(imageNamed: "Black Hole 7")]
    
    let greenChargeUpImages = [SKTexture(imageNamed: "Green Beam 1"),
                               SKTexture(imageNamed: "Green Beam 2"),
                               SKTexture(imageNamed: "Green Beam 3"),
                               SKTexture(imageNamed: "Green Beam 4"),
                               SKTexture(imageNamed: "Green Beam 5"),
                               SKTexture(imageNamed: "Green Beam 6")]
    
    let scientistImages = [SKTexture(imageNamed: "Scientist 1"),
                           SKTexture(imageNamed: "Scientist 2")]
    
    let asteroidDestroyedImages = [SKTexture(imageNamed: "Asteroid Hit 1"),
                                   SKTexture(imageNamed: "Asteroid Hit 2"),
                                   SKTexture(imageNamed: "Asteroid Hit 3"),
                                   SKTexture(imageNamed: "Asteroid Hit 4"),
                                   SKTexture(imageNamed: "Asteroid Hit 5"),
                                   SKTexture(imageNamed: "Asteroid Hit 6"),
                                   SKTexture(imageNamed: "Asteroid Hit 7"),
                                   SKTexture(imageNamed: "Asteroid Hit 8"),
                                   SKTexture(imageNamed: "Asteroid Hit 9"),
                                   SKTexture(imageNamed: "Asteroid Hit 10"),
                                   SKTexture(imageNamed: "Asteroid Hit 11")]
    
    let cometDestroyedImages = [SKTexture(imageNamed: "Comet Hit 1"),
                                SKTexture(imageNamed: "Comet Hit 2"),
                                SKTexture(imageNamed: "Comet Hit 3"),
                                SKTexture(imageNamed: "Comet Hit 4"),
                                SKTexture(imageNamed: "Comet Hit 5"),
                                SKTexture(imageNamed: "Comet Hit 6"),
                                SKTexture(imageNamed: "Comet Hit 7"),
                                SKTexture(imageNamed: "Comet Hit 8"),
                                SKTexture(imageNamed: "Comet Hit 9"),
                                SKTexture(imageNamed: "Comet Hit 10")]
    
    let explosionImages = [SKTexture(imageNamed: "Explosion 1"),
                           SKTexture(imageNamed: "Explosion 2"),
                           SKTexture(imageNamed: "Explosion 3"),
                           SKTexture(imageNamed: "Explosion 4"),
                           SKTexture(imageNamed: "Explosion 5"),
                           SKTexture(imageNamed: "Explosion 6"),
                           SKTexture(imageNamed: "Explosion 7"),
                           SKTexture(imageNamed: "Explosion 8"),
                           SKTexture(imageNamed: "Explosion 9"),
                           SKTexture(imageNamed: "Explosion 10"),
                           SKTexture(imageNamed: "Explosion 11"),
                           SKTexture(imageNamed: "Explosion 12"),
                           SKTexture(imageNamed: "Explosion 13"),
                           SKTexture(imageNamed: "Explosion 14"),
                           SKTexture(imageNamed: "Explosion 15")]
    
    let cometExplosionImages = [SKTexture(imageNamed: "Comet Explosion 1"),
                                SKTexture(imageNamed: "Comet Explosion 2"),
                                SKTexture(imageNamed: "Comet Explosion 3"),
                                SKTexture(imageNamed: "Comet Explosion 4"),
                                SKTexture(imageNamed: "Comet Explosion 5"),
                                SKTexture(imageNamed: "Comet Explosion 6"),
                                SKTexture(imageNamed: "Comet Explosion 7"),
                                SKTexture(imageNamed: "Comet Explosion 8"),
                                SKTexture(imageNamed: "Comet Explosion 9"),
                                SKTexture(imageNamed: "Comet Explosion 10"),
                                SKTexture(imageNamed: "Comet Explosion 11"),
                                SKTexture(imageNamed: "Comet Explosion 12"),
                                SKTexture(imageNamed: "Comet Explosion 13"),
                                SKTexture(imageNamed: "Comet Explosion 14"),
                                SKTexture(imageNamed: "Comet Explosion 15")]
    
    let rocketDestroyedImages = [SKTexture(imageNamed: "Rocket Hit 1"),
                                 SKTexture(imageNamed: "Rocket Hit 2"),
                                 SKTexture(imageNamed: "Rocket Hit 3"),
                                 SKTexture(imageNamed: "Rocket Hit 4"),
                                 SKTexture(imageNamed: "Rocket Hit 5"),
                                 SKTexture(imageNamed: "Rocket Hit 6"),
                                 SKTexture(imageNamed: "Rocket Hit 7"),
                                 SKTexture(imageNamed: "Rocket Hit 8"),
                                 SKTexture(imageNamed: "Rocket Hit 9"),
                                 SKTexture(imageNamed: "Rocket Hit 10"),
                                 SKTexture(imageNamed: "Rocket Hit 11"),
                                 SKTexture(imageNamed: "Rocket Hit 12")]
    
    var isTVOn = false
    var isSetup = false
    var isBeamActive = false
    var isAlreadyBlackHole = false
    var healthEvents = true
    var isRoundFinished = false
    var objectPickerMax = 0
    var forceModifier = Double(0)
    var motionEngine = CMMotionManager()
    
    let TVScreen = SKSpriteNode(imageNamed: "CRT Shape")
    let protagonist = SKSpriteNode(imageNamed: "Rocket 1.png")
    let croppedFrame = SKCropNode()
    let beam = SKShapeNode()
    let level = UserDefaults.standard.integer(forKey: "nextLevel")
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    
    let topPadding = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.safeAreaInsets.top ?? 0
    let bottomPadding = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.safeAreaInsets.bottom ?? 0
    
    override func didMove(to view: SKView) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(fireLaser(_:)), name: Notification.Name("fire"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endLaser(_:)), name: Notification.Name("released"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishLevel(_:)), name: Notification.Name("finishLevel"), object: nil)
        
        self.backgroundColor = .clear
        self.view?.allowsTransparency = true
        self.view?.backgroundColor = .clear
        
        self.scaleMode = .aspectFit
        physicsWorld.contactDelegate = self
        
        for image in rocketImages {
            image.filteringMode = .nearest
        }
        
        for image in greenChargeUpImages {
            image.filteringMode = .nearest
        }
        
        for image in scientistImages {
            image.filteringMode = .nearest
        }
        
        for image in asteroidDestroyedImages {
            image.filteringMode = .nearest
        }
        
        for image in cometDestroyedImages {
            image.filteringMode = .nearest
        }
        
        for image in cometImages {
            image.filteringMode = .nearest
        }
        
        for image in explosionImages {
            image.filteringMode = .nearest
        }
        
        for image in cometExplosionImages {
            image.filteringMode = .nearest
        }
        
        for image in cometImages {
            image.filteringMode = .nearest
        }
        
        for image in blackHoleImages {
            image.filteringMode = .nearest
        }
        
        for image in rocketDestroyedImages {
            image.filteringMode = .nearest
        }
        
        switch UserDefaults.standard.integer(forKey: "nextLevel") {
        case 1: objectPickerMax = 6 // Level 1; asteroids only.
        case 2: objectPickerMax = 11 // Level 2; asteroids and comets.
        default: objectPickerMax = 12 // Level 3; asteroids, comets, and black holes.
        }
        
        motionEngine.accelerometerUpdateInterval = 1/60
        motionEngine.gyroUpdateInterval = 1/60
        
        motionEngine.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { [self] (data, error) -> Void in
            let xAxis = motionEngine.accelerometerData?.acceleration.x ?? 0.0
            print(xAxis)
            if isSetup {
                protagonist.physicsBody!.applyForce(CGVector(dx: (40 * xAxis) + forceModifier, dy: 0))
            }
        })
        
        run(SKAction.run { [self] in
            
            protagonist.size = CGSize(width: 72, height: 120)
            protagonist.position = CGPoint(x: 50, y: 163 + bottomPadding)
            protagonist.zRotation = 0
            protagonist.name = "Rocket"
            
            protagonist.physicsBody = SKPhysicsBody(rectangleOf: protagonist.size)
            protagonist.physicsBody?.isDynamic = true
            protagonist.physicsBody?.mass = 0.02
            protagonist.physicsBody?.affectedByGravity = false
            protagonist.physicsBody?.allowsRotation = false
            protagonist.physicsBody?.contactTestBitMask = 1
            protagonist.constraints = [SKConstraint.zRotation(SKRange(constantValue: 0)),
                                       SKConstraint.positionY(SKRange(constantValue: 163 + bottomPadding)),
                                       SKConstraint.positionX(SKRange(lowerLimit: 1, upperLimit: deviceWidth - 1))]
            
            self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

            let rocketAnimation = SKAction.repeatForever(SKAction.animate(with: rocketImages, timePerFrame: 0.1))
            protagonist.run(rocketAnimation)
            
            self.addChild(protagonist)
            isSetup = true
            
            if level == 1 {
                isTVOn = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    displayTV(dialogue: "Ah, we've arrived. Let's begin.", speaker: "Scientist")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                        hideTV()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                            displayTV(dialogue: "Steer your rocket with motion controls, and fire at asteroids by holding 'Hydrochloric Acid' at the bottom of your device.", speaker: "System")
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                                hideTV()
                                NotificationCenter.default.post(Notification(name: Notification.Name("startLevel")))
                                run(SKAction.repeatForever(SKAction.sequence([
                                    SKAction.run { [self] in
                                        if !isRoundFinished {
                                            pickObject()
                                        }
                                    },
                                    SKAction.wait(forDuration: 0.6, withRange: 0.4)])))
                                
                                                                                                    
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                                    displayTV(dialogue: "You can gain a life with every 10 objects you destroy, however you'll lose one if your ship gets hit.", speaker: "System")
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                                        hideTV(complete: { [self] in
                                            isTVOn = false
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if level == 2 {
                isTVOn = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    displayTV(dialogue: "Destination set to the second star. Let's do this!", speaker: "Scientist")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                        hideTV()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                            displayTV(dialogue: "Comets are present in this area. Fire at them by holding 'Thermal Energy' at the bottom of your device.", speaker: "System")
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                                hideTV(complete: { [self] in
                                    isTVOn = false
                                })
                                
                                NotificationCenter.default.post(Notification(name: Notification.Name("startLevel")))
                                run(SKAction.repeatForever(SKAction.sequence([
                                    SKAction.run { [self] in
                                        if !isRoundFinished {
                                            pickObject()
                                        }
                                    },
                                    SKAction.wait(forDuration: 0.6, withRange: 0.4)])))
                            }
                        }
                    }
                }
            }
            
            if level == 3 {
                isTVOn = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    displayTV(dialogue: "This is the final stretch! You can do this!", speaker: "Scientist")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                        hideTV()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                            displayTV(dialogue: "Black holes are present in this area. Prevent them from sucking you in by steering away from them!", speaker: "System")
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                                hideTV(complete: { [self] in
                                    isTVOn = false
                                })
                                
                                NotificationCenter.default.post(Notification(name: Notification.Name("startLevel")))
                                run(SKAction.repeatForever(SKAction.sequence([
                                    SKAction.run { [self] in
                                        if !isRoundFinished {
                                            pickObject()
                                        }
                                    },
                                    SKAction.wait(forDuration: 0.6, withRange: 0.4)])))
                            }
                        }
                    }
                }
            }
            
        })
        
    }
    
    func displayTV(dialogue: String, speaker: String) {
        var deviceOffset = CGFloat(0)
        var speakerFontSize = CGFloat(30)
        var dialogueFontSize = CGFloat(18)
        var offsetToCenter = CGFloat(60)
        var labelOffset = CGFloat(-10)
        var scientistSize = CGSize(width: 120, height: 162)
        var systemSize = CGSize(width: 107.5, height: 102.5)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            deviceOffset = 50
            speakerFontSize = 16
            dialogueFontSize = 12
            offsetToCenter = 40
            labelOffset = -5
            scientistSize = CGSize(width: 100, height: 135)
            systemSize = CGSize(width: 86, height: 82)
        }
        
        TVScreen.size = CGSize(width: 20, height: 20)
        TVScreen.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight - 166) - topPadding + (deviceOffset / 2))
        
        let croppedTV = SKSpriteNode(imageNamed: "CRT Shape")
        croppedTV.size = TVScreen.size
        
        croppedFrame.maskNode = croppedTV
        croppedFrame.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight - 166) - topPadding + (deviceOffset / 2))
        
        var portrait = SKSpriteNode(imageNamed: "Scientist 1")
        
        if speaker == "System" {
            let texture = SKTexture(imageNamed: "System")
            texture.filteringMode = .nearest
            portrait = SKSpriteNode(texture: texture)
            portrait.position = CGPoint(x: (120 - deviceOffset / 2) - (deviceWidth / 2), y: 0)
            portrait.size = systemSize
        } else {
            let portraitAnimation = SKAction.repeatForever(SKAction.animate(with: scientistImages, timePerFrame: 0.3))
            portrait.run(portraitAnimation)
            portrait.position = CGPoint(x: 100 - (deviceWidth / 2), y: -10)
            portrait.size = scientistSize
        }
        
        
        var speakerFont = UIFont.systemFont(ofSize: speakerFontSize, weight: .bold)
        
        if #available(iOS 16.0, *) {
            speakerFont = UIFont.systemFont(ofSize: speakerFontSize, weight: .bold, width: UIFont.Width(rawValue: 1))
        }
        
        let speakerLabel = SKLabelNode(attributedText: NSAttributedString(string: speaker, attributes: [.font: speakerFont, .foregroundColor: UIColor.green]))
        speakerLabel.horizontalAlignmentMode = .left
        
        let dialogueFont = UIFont.systemFont(ofSize: dialogueFontSize, weight: .regular)
        
        let dialogueLabel = SKLabelNode(attributedText: NSAttributedString(string: dialogue, attributes: [.font: dialogueFont, .foregroundColor: UIColor.green]))
        dialogueLabel.horizontalAlignmentMode = .left
        dialogueLabel.verticalAlignmentMode = .top
        dialogueLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        dialogueLabel.numberOfLines = 0
        dialogueLabel.preferredMaxLayoutWidth = deviceWidth - 240
        
        speakerLabel.position = CGPoint(x: 190 - (deviceWidth / 2) - (deviceOffset / 2), y: (speakerLabel.frame.height + 10 + dialogueLabel.frame.height - offsetToCenter) / 2)
        dialogueLabel.constraints = [SKConstraint.distance(SKRange(constantValue: 0), to: CGPoint(x: 0, y: labelOffset), in: speakerLabel)]
        
        croppedFrame.addChild(portrait)
        croppedFrame.addChild(speakerLabel)
        croppedFrame.addChild(dialogueLabel)
        
        self.addChild(TVScreen)
        self.addChild(croppedFrame)
        
        let firstGrow = SKAction.resize(toWidth: deviceWidth - 40, height: 20, duration: 0.1)
        let secondGrow = SKAction.resize(toWidth: deviceWidth - 40, height: 200 - deviceOffset, duration: 0.2)
        
        TVScreen.run(SKAction.sequence([firstGrow, secondGrow]))
        croppedFrame.maskNode!.run(SKAction.sequence([firstGrow, secondGrow]))
    }
    
    func hideTV(complete: (() -> Void)? = nil) {
        if isTVOn {
            let firstShrink = SKAction.resize(toWidth: deviceWidth - 40, height: 20, duration: 0.2)
            let secondShrink = SKAction.resize(toWidth: 20, height: 20, duration: 0.1)
            
            TVScreen.run(SKAction.sequence([firstShrink, secondShrink, SKAction.removeFromParent()]))
            croppedFrame.maskNode!.run(SKAction.sequence([firstShrink, secondShrink, SKAction.run { [self] in
                croppedFrame.removeAllChildren()
                croppedFrame.removeFromParent()
                
                if complete != nil {
                    complete!()
                }
            }]))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var isCompatible = false
        var isEnemy = false
        var isBeam = false
        
        if contact.bodyB.node?.name == "Asteroid" || contact.bodyB.node?.name == "Comet" || contact.bodyB.node?.name == "Black Hole" {
            isEnemy = true
        }
        
        if contact.bodyA.node?.name == "Beam" || contact.bodyA.node?.name == "BeamTwo" {
            isBeam = true
        }
        
        if contact.bodyA.node?.name == "Beam" && contact.bodyB.node?.name == "Asteroid" {
            isCompatible = true
        }
        
        if contact.bodyA.node?.name == "BeamTwo" && contact.bodyB.node?.name == "Comet" {
            isCompatible = true
        }
        
        if isBeam && isEnemy && isCompatible {
            
            objectsHit += 1
            NotificationCenter.default.post(Notification(name: Notification.Name("asteroidHit")))
            
            if objectsHit.isMultiple(of: 10) {
                livesRemaining += 1
                NotificationCenter.default.post(Notification(name: Notification.Name("lifeModified")))
            }
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                let generator = UIImpactFeedbackGenerator(style: .rigid)
                generator.impactOccurred()
            }
            
            if contact.bodyB.node?.name == "Asteroid" {
                
                contact.bodyB.node?.run(SKAction.sequence([SKAction.run {
                    contact.bodyB.node?.physicsBody = nil
                }, SKAction.animate(with: asteroidDestroyedImages, timePerFrame: 1/33),
                    SKAction.removeFromParent()]))
                
            } else {
                
                contact.bodyB.node?.run(SKAction.sequence([SKAction.run {
                    contact.bodyB.node?.physicsBody = nil
                }, SKAction.animate(with: cometDestroyedImages, timePerFrame: 1/33),
                    SKAction.removeFromParent()]))
                
            }
            
        }
        
        if contact.bodyA.node?.name == "Rocket" && isEnemy && healthEvents {
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                let tapticFeedback = UINotificationFeedbackGenerator()
                tapticFeedback.notificationOccurred(.error)
            }
            
            var explosion = SKSpriteNode()
            
            switch contact.bodyB.node?.name {
            case "Comet":
                
                explosion = SKSpriteNode(imageNamed: "Comet Explosion 1")
                explosion.size = CGSize(width: 60, height: 60)
                explosion.position = contact.contactPoint
                
                explosion.run(SKAction.sequence([
                    SKAction.animate(with: cometExplosionImages, timePerFrame: 1/30),
                    SKAction.removeFromParent()]))
                
                contact.bodyB.node?.run(SKAction.sequence([SKAction.run {
                    contact.bodyB.node?.physicsBody = nil
                }, SKAction.animate(with: cometDestroyedImages, timePerFrame: 1/30),
                    SKAction.removeFromParent()]))
                
                self.addChild(explosion)
                
            case "Asteroid":
                
                explosion = SKSpriteNode(imageNamed: "Explosion 1")
                explosion.size = CGSize(width: 60, height: 60)
                explosion.position = contact.contactPoint
                
                explosion.run(SKAction.sequence([
                    SKAction.animate(with: explosionImages, timePerFrame: 1/30),
                    SKAction.removeFromParent()]))
                
                contact.bodyB.node?.run(SKAction.sequence([SKAction.run {
                    contact.bodyB.node?.physicsBody = nil
                }, SKAction.animate(with: asteroidDestroyedImages, timePerFrame: 1/33),
                    SKAction.removeFromParent()]))
                
                self.addChild(explosion)
                
            case "Black Hole":
                
                forceModifier = 0
                
                if forceModifier == -20 {
                    protagonist.run(SKAction.move(to: CGPoint(x: 150, y: 163 + bottomPadding), duration: 0))
                } else {
                    protagonist.run(SKAction.move(to: CGPoint(x: deviceWidth - protagonist.size.width - 150, y: 163 + bottomPadding), duration: 0))
                }
            
            default: break
            }
            
            livesRemaining -= 1
            NotificationCenter.default.post(Notification(name: Notification.Name("lifeModified")))
            
            healthEvents = false
            if livesRemaining > 0 {
                
                if !isTVOn {
                    isTVOn = true
                    displayTV(dialogue: pickHitDialogue(), speaker: "Scientist")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                        hideTV(complete: { [self] in
                            isTVOn = false
                        })
                    }
                }
                
                var timerCount = 0
                
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [self] timer in
                    if timerCount == 10 {
                        timer.invalidate()
                        protagonist.isHidden = false
                        healthEvents = true
                    } else {
                        if protagonist.isHidden {
                            protagonist.isHidden = false
                        } else {
                            protagonist.isHidden = true
                        }
                        
                        timerCount += 1
                    }
                })
            } else {
                
                protagonist.run(SKAction.sequence([
                    SKAction.animate(with: rocketDestroyedImages, timePerFrame: 1/36),
                    SKAction.removeFromParent()]))
                
                if isTVOn {
                    hideTV(complete: { [self] in
                        isTVOn = false
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                        displayTV(dialogue: pickEliminatedDialogue(), speaker: "Scientist")
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                        hideTV()
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        NotificationCenter.default.post(Notification(name: Notification.Name("restartLevel")))
                    }
                    }
                    }
                } else {
                    displayTV(dialogue: pickEliminatedDialogue(), speaker: "Scientist")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                        hideTV()
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        NotificationCenter.default.post(Notification(name: Notification.Name("restartLevel")))
                    }
                    }
                }
                
            }
        }
    }
    
    func pickHitDialogue() -> String {
        let randomNumber = Int.random(in: 0 ..< 5)
        var livesText = "lives"
        
        if livesRemaining == 1 {
            livesText = "life"
        }
        
        switch randomNumber {
        case 0: return "Be careful! \(livesRemaining) \(livesText) remaining!"
        case 1: return "Don't be reckless! \(livesRemaining) \(livesText) left!"
        case 2: return "Hey, are you ok?! You have \(livesRemaining) \(livesText) left!"
        case 3: return "Uh-oh, is everything alright? \(livesRemaining) \(livesText) remaining."
        case 4: return "\(livesRemaining) \(livesText) remaining, break some stuff to get them back!"
        default: return ""
        }
        
    }
    
    func pickEliminatedDialogue() -> String {
        let randomNumber = Int.random(in: 0 ..< 5)
        
        switch randomNumber {
        case 0: return "We failed after all..."
        case 1: return "Hey! Are you there?!"
        case 2: return "No!..."
        case 3: return "It can't be..."
        case 4: return "Hello?! Do you read me?!"
        default: return ""
        }
    }
    
    @objc func finishLevel(_ notification: Notification) {
        isRoundFinished = true
        motionEngine.stopAccelerometerUpdates()
        motionEngine.stopGyroUpdates()
        
        for child in self.children {
            
            if child.name == "Asteroid" {
                
                child.run(SKAction.sequence([SKAction.run {
                    child.physicsBody = nil
                }, SKAction.animate(with: asteroidDestroyedImages, timePerFrame: 1/33),
                    SKAction.removeFromParent()]))
                
            }
            
            if child.name == "Comet" {
                
                child.run(SKAction.sequence([SKAction.run {
                    child.physicsBody = nil
                }, SKAction.animate(with: cometDestroyedImages, timePerFrame: 1/33),
                    SKAction.removeFromParent()]))
                
            }
            
            if child.name == "Black Hole" {
                
                child.run(SKAction.sequence([SKAction.run {
                    child.physicsBody = nil
                }, SKAction.fadeAlpha(to: 0, duration: 0.33),
                    SKAction.removeFromParent()]))
                
            }
        }
        
        var dialogue = ""
        
        switch level {
        case 1: dialogue = "Nice work! Now to grab a sample of that star..."
        case 2: dialogue = "Great work! Let's grab that sample."
        case 3: dialogue = "All done! You know what to do from here."
        default: break
        }
        
        if isTVOn {
            hideTV(complete: { [self] in
                isTVOn = false
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                displayTV(dialogue: dialogue, speaker: "Scientist")
            }
        } else {
            displayTV(dialogue: dialogue, speaker: "Scientist")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            hideTV(complete: { [self] in
                isTVOn = false
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: Notification.Name("switchViews"), object: nil)
            }
        }
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 4294967296)
    }
    
    func randomBesides(min: CGFloat, max: CGFloat, besidesMin: CGFloat, besidesMax: CGFloat) -> CGFloat {
        var value = random() * (max - min) + min
        
        while value > besidesMin && value < besidesMax {
            value = random() * (max - min) + min
        }
        
        return value
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func pickObject() {
        var randomNumber = 0
        
        if isAlreadyBlackHole {
            randomNumber = Int.random(in: 0 ..< (objectPickerMax - 1))
        } else {
            randomNumber = Int.random(in: 0 ..< objectPickerMax)
        }
        
        if 0...5 ~= randomNumber {
            addAsteroid()
            print("asteroid \(randomNumber)")
        } else if 5...10 ~= randomNumber {
            addComet()
            print("comet \(randomNumber)")
        } else {
            addBlackHole()
            print("black hole \(randomNumber)")
        }
    }
    
    func addAsteroid() {
        let texture = SKTexture(imageNamed: "Asteroid 1")
        texture.filteringMode = .nearest
        
        let asteroid = SKSpriteNode(texture: texture)
        
        asteroid.size = CGSize(width: 120, height: 104)
        asteroid.position = CGPoint(x: random(min: 0 + (asteroid.size.width / 2), max: deviceWidth - (asteroid.size.width / 2)), y: deviceHeight + 100)
        
        asteroid.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 96, height: 80))
        asteroid.physicsBody?.isDynamic = true
        asteroid.physicsBody?.affectedByGravity = false
        asteroid.physicsBody?.collisionBitMask = 0
        asteroid.physicsBody?.contactTestBitMask = 1
        asteroid.name = "Asteroid"
        
        self.addChild(asteroid)
        
        let actionMove = SKAction.move(to: CGPoint(x: random(min: 0 + (asteroid.size.width / 2), max: deviceWidth - (asteroid.size.width / 2)), y: 0), duration: TimeInterval(random(min: 2, max: 3)))
        asteroid.run(SKAction.sequence([actionMove, SKAction.removeFromParent()]))
        
    }
    
    func addComet() {
        let texture = SKTexture(imageNamed: "Comet 1")
        texture.filteringMode = .nearest
        
        let comet = SKSpriteNode(texture: texture)
        
        comet.size = CGSize(width: 68, height: 128)
        comet.position = CGPoint(x: random(min: 0 + (comet.size.width / 2), max: deviceWidth - (comet.size.width / 2)), y: deviceHeight + 100)
        
        comet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 68, height: 128))
        comet.physicsBody?.isDynamic = true
        comet.physicsBody?.affectedByGravity = false
        comet.physicsBody?.collisionBitMask = 0
        comet.physicsBody?.contactTestBitMask = 1
        comet.name = "Comet"
        
        self.addChild(comet)
        
        let actionMove = SKAction.move(to: CGPoint(x: comet.position.x, y: 0), duration: TimeInterval(random(min: 2, max: 3)))
        comet.run(SKAction.repeatForever(SKAction.animate(with: cometImages, timePerFrame: 0.1)))
        comet.run(SKAction.sequence([actionMove, SKAction.removeFromParent()]))
        
    }
    
    func addBlackHole() {
        isAlreadyBlackHole = true
        let texture = SKTexture(imageNamed: "Black Hole 1")
        texture.filteringMode = .nearest
        
        let blackHole = SKSpriteNode(texture: texture)
        let xPosition = randomBesides(min: 0 + (blackHole.size.width / 2), max: deviceWidth - (blackHole.size.width / 2), besidesMin: 100, besidesMax: deviceWidth - 100)
        
        if xPosition <= 100 {
            forceModifier = -10
        } else {
            forceModifier = 10
        }
        
        blackHole.size = CGSize(width: 116, height: 76)
        blackHole.position = CGPoint(x: xPosition, y: deviceHeight + 100)
        
        blackHole.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 52, height: 52))
        blackHole.physicsBody?.isDynamic = true
        blackHole.physicsBody?.affectedByGravity = false
        blackHole.physicsBody?.collisionBitMask = 0
        blackHole.physicsBody?.contactTestBitMask = 1
        blackHole.name = "Black Hole"
        
        self.addChild(blackHole)
        
        let actionMove = SKAction.move(to: CGPoint(x: blackHole.position.x, y: 0), duration: TimeInterval(random(min: 3, max: 4)))
        
        blackHole.run(SKAction.repeatForever(SKAction.animate(with: blackHoleImages, timePerFrame: 0.1)))
        
        blackHole.run(SKAction.sequence([actionMove, SKAction.removeFromParent(), SKAction.run { [self] in
            forceModifier = 0
            isAlreadyBlackHole = false
        }]))
    }
    
    @objc func fireLaser(_ notification: Notification) {
        let chargeUpView = SKSpriteNode(texture: greenChargeUpImages.first)
        
        chargeUpView.size = CGSize(width: 24, height: 18)
        chargeUpView.position = CGPoint(x: 0, y: 70)
        
        protagonist.addChild(chargeUpView)
        
        let chargeUpAnimation = SKAction.animate(with: greenChargeUpImages, timePerFrame: 1/24)
        
        chargeUpView.run(SKAction.sequence([chargeUpAnimation, SKAction.removeFromParent(), SKAction.run { [self] in
            
            var colour = UIColor()
            var name = "Beam"
            protagonist.addChild(beam)
            
            let element = notification.userInfo?["element"] as? Int
            
            switch element {
            case 1: colour = .green
                    name = "Beam"
            case 2: colour = .orange
                    name = "BeamTwo"
            default: break
            }
            
            let beamHeight = (deviceHeight - 240) - (topPadding + bottomPadding)
            let beamPath = UIBezierPath(rect: CGRect(x: 0, y: 70, width: 2, height: beamHeight)).cgPath
            
            beam.path = beamPath
            beam.lineWidth = 6
            beam.strokeColor = colour
            
            beam.name = name
            beam.physicsBody = SKPhysicsBody(edgeChainFrom: beamPath)
            beam.physicsBody?.isDynamic = true
            beam.physicsBody?.affectedByGravity = false
            beam.physicsBody?.allowsRotation = false
            beam.physicsBody?.collisionBitMask = 0
            beam.physicsBody?.contactTestBitMask = 1
            beam.constraints = [SKConstraint.zRotation(SKRange(constantValue: 0)),
                                SKConstraint.positionY(SKRange(constantValue: 0)),
                                SKConstraint.positionX(SKRange(constantValue: 0))]
            
            isBeamActive = true
            
            let particles = [SKShapeNode(), SKShapeNode(), SKShapeNode(), SKShapeNode(), SKShapeNode(), SKShapeNode()]
            
            for particle in particles {
                particle.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2, height: 2)).cgPath
                particle.strokeColor = colour
                particle.lineWidth = 1
                
                beam.addChild(particle)
            }
            
            
            run(SKAction.repeatForever(SKAction.sequence([
                SKAction.run { [self] in
                    for particle in particles {
                        particle.position = CGPoint(x: randomBesides(min: -20, max: 22, besidesMin: -10, besidesMax: 12), y: random(min: 70, max: beamHeight))
                    }
                },
                SKAction.wait(forDuration: 0.4)])))
            
        }]))
        
    }
    
    @objc func endLaser(_ notification: Notification) {
        beam.removeAllChildren()
        protagonist.removeAllChildren()
        isBeamActive = false
    }
    
}