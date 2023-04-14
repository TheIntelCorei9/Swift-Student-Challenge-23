import UIKit

enum Time {
    case Sunrise
    case Daytime
    case Evening
    case Night
}

class ViewController: UIViewController, CAAnimationDelegate {
    
    let gradient = CAGradientLayer()
    var timer = Timer()
    
    @IBOutlet weak var starView: UIView!
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    @IBOutlet weak var cloudView: UIView!
    @IBOutlet weak var cloudOne: UIImageView!
    @IBOutlet weak var cloudTwo: UIImageView!
    
    @IBOutlet weak var tvScreen: UIImageView!
    @IBOutlet weak var dialogueView: UITextView!
    
    @IBOutlet weak var textWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var continueButton: UIButton!
    
    var currentDialogueStage = 0
    
    @IBAction func go(_ sender: Any) {
        
        UserDefaults.standard.set(1, forKey: "nextLevel")
        
        // MARK: DEBUG CODE, REMOVE BEFORE LAUNCH
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FlightScene")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        // MARK: DEBUG CODE, REMOVE BEFORE LAUNCH
        
        UIView.animate(withDuration: 1, animations: { [self] in
            goButton.alpha = 0
            aboutButton.alpha = 0
        }, completion: { [self] (finished: Bool) in
            
            presentTV {
                
                UIView.animate(withDuration: 0.2, animations: { [self] in
                    dialogueView.alpha = 1
                    continueButton.alpha = 1
                }, completion: { [self] (finished: Bool) in
                    continueButton.isEnabled = false
                    dialogueView.characterByCharacter(string: """
                    You are a citizen of the planet Lunaro, home to a colony of humans who settled here recently. Although previously thriving, recent climate pollution — manifesting as a cloud of gases encasing the planet, blocking solar energy — has thrown the lives of millions into jeopardy.
                    """, complete: { [self] in
                        continueButton.isEnabled = true
                    })
                })
                
            }
            
        })
        
    }
    
    func presentTV(complete: @escaping () -> Void) {
        
        var widthScale = CGFloat(0)
        var heightScale = CGFloat(0)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            widthScale = (self.view.frame.width - 40) / 20
            heightScale = (self.view.frame.height - 400) / 20
            
            textWidthConstraint.constant = (widthScale * 20) - 170
            textHeightConstraint.constant = (heightScale * 20) - 300
        } else {
            widthScale = (self.view.frame.width - 40) / 20
            heightScale = (self.view.frame.height - 100) / 20
            
            textWidthConstraint.constant = (widthScale * 20) - 80
            textHeightConstraint.constant = (heightScale * 20) - 200
        }
        
        tvScreen.isHidden = false
        
        UIView.animate(withDuration: 0.1, animations: { [self] in
            
            tvScreen.transform = CGAffineTransform(scaleX: widthScale, y: 1)
            
        }, completion: { [self] (finished: Bool) in

        UIView.animate(withDuration: 0.2, animations: { [self] in
            
            tvScreen.transform = CGAffineTransform(scaleX: widthScale, y: heightScale)
            
        }, completion: {_ in
            
            complete()
            
        }) })
    }
    
    @IBAction func continueDialogue(_ sender: Any) {
        switch currentDialogueStage {
        case 0:
            continueButton.isEnabled = false
            dialogueView.characterByCharacter(string: """
                    When disaster began to loom, however, a researcher discovered an Ancient Greek myth suggesting the existence of spirits living in the constellations. These findings were presented to the space administration, who begrudgingly approved a flight to the constellation of rebirth — the Phoenix — to acquire a "rebirth" of their home. Such a journey would drain the last of Lunaro's energy supply, turning this into an extremely high-stakes mission.
                    """, complete: { [self] in
                continueButton.isEnabled = true
            })
        case 1:
            continueButton.isEnabled = false
            dialogueView.characterByCharacter(string: """
                    You, a professional space traveller, have been entrusted to pilot this flight. To complete your goal, you need to venture to some of these stars and collect samples. These samples, the researcher believes, can summon the Phoenix when fused with one another.

                    Your craft is equipped with a set of mixtures that can each dissolve certain debris, which you must utilise combined with precision steering skills in order to protect you and your ship.
                    """, complete: { [self] in
                        continueButton.isEnabled = true
                    })
        case 2:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FlightScene")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
            view.layer.removeAllAnimations()
            gradient.removeAllAnimations()
            cloudView.layer.removeAllAnimations()
            timer.invalidate()
        default: break
        }
        
        currentDialogueStage += 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: View Initialisation
        if UIDevice.current.userInterfaceIdiom == .phone {
            dialogueView.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
        
        continueButton.isEnabled = false
        continueButton.alpha = 0
        dialogueView.alpha = 0
        
        // Sets up and displays the inital background gradient.
        let window = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first
        let topPadding = (window?.safeAreaInsets.top ?? 0)

        gradient.frame = CGRect(x: 0, y: -topPadding, width: view.bounds.width, height: view.bounds.height + topPadding)
        gradient.colors = coloursFromTime(time: .Daytime)

        view.layer.insertSublayer(gradient, at: 0)
        
        // Sets image views to upscale with nearest neighbour, optimising them for pixel art.
        cloudOne.layer.magnificationFilter = .nearest
        cloudTwo.layer.magnificationFilter = .nearest
        
        // MARK: Cloud Cover
        initTimer()
        
        // MARK: Begins passing time.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            cycleTime(time: .Evening)
        }
        
    }
    
    func initTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 100, repeats: true, block: { [self] timer in
            cloudView.transform = CGAffineTransform(translationX: 0, y: 0)
            UIView.animate(withDuration: 100, delay: 0, options: [.curveLinear], animations: { [self] in
                cloudView.transform = CGAffineTransform(translationX: -2745, y: 0)
            })
        })
        
        timer.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        starView.backgroundColor = UIColor(patternImage: UIImage(named: "Star Pattern.png")!)
        let starGradient = CAGradientLayer()
        
        starGradient.frame = starView.bounds
        starGradient.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        starGradient.startPoint = CGPointMake(0, 0.8)
        starGradient.endPoint = CGPointMake(0, 1)
        
        starView.layer.mask = starGradient
        starView.alpha = 0
    }
    
    func cycleTime(time: Time, express: Bool = false) {
        
        CATransaction.begin()
        
        var duration = CFTimeInterval(10)
        
        if express {
            duration = 2
        }

        let oldColours = gradient.colors
        let newColours = coloursFromTime(time: time)
        
        gradient.colors = newColours
        
        let animation = CABasicAnimation(keyPath: "colors")

        animation.fromValue = oldColours
        animation.toValue = newColours
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.delegate = self
        
        if time == .Night {
            UIView.animate(withDuration: duration) { [self] in
                starView.alpha = 1
            }
        }
        
        if time == .Sunrise {
            UIView.animate(withDuration: duration) { [self] in
                starView.alpha = 0
            }
        }
        
        CATransaction.setCompletionBlock { [self] in
            if time == .Daytime || time == .Night {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
                    if time == .Daytime {
                        cycleTime(time: .Evening)
                    } else {
                        cycleTime(time: .Sunrise)
                    }
                }
                
            } else {
                
                switch time {
                case .Sunrise: cycleTime(time: .Daytime)
                case .Evening: cycleTime(time: .Night)
                default: break
                }
                
            }
        }

        gradient.add(animation, forKey: "animateGradient")
        CATransaction.commit()
    }
    
    func coloursFromTime(time: Time) -> [CGColor] {
        switch time {
        case .Sunrise: return [CGColor(red: 100/255,
                                       green: 210/255,
                                       blue: 255/255, alpha: 1),
                               CGColor(red: 255/255,
                                       green: 159/255,
                                       blue: 10/255, alpha: 1)]
        // Teal to Blue
        case .Daytime: return [CGColor(red: 64/255,
                                       green: 200/255,
                                       blue: 224/255, alpha: 1),
                               CGColor(red: 10/255,
                                       green: 132/255,
                                       blue: 255/255, alpha: 1)]
        // Pink to Orange
        case .Evening: return [CGColor(red: 255/255,
                                       green: 55/255,
                                       blue: 95/255, alpha: 1),
                               CGColor(red: 255/255,
                                       green: 159/255,
                                       blue: 10/255, alpha: 1)]
        // Black to Indigo
        case .Night: return [CGColor(red: 0/255,
                                     green: 0/255,
                                     blue: 0/255, alpha: 1),
                             CGColor(red: 44/255,
                                     green: 43/255,
                                     blue: 107/255, alpha: 1)]
        }
    }
    
}

extension UITextView {
    func characterByCharacter(string: String, complete: @escaping () -> Void) {
        let characters = string.count
        var currentString = ""
        var count = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.00825, repeats: true, block: { [self] timer in
            if count == characters {
                timer.invalidate()
                self.text = currentString
                complete()
            } else {
                let index = string.index(string.startIndex, offsetBy: count)
                currentString.append(string[index])
                self.text = currentString + "█"
                count += 1
            }
        })
        
    }
}
