import Foundation
import UIKit
import AVFoundation
import SwiftUI


public class LevelOne: UIViewController {

    //MARK: Component Items
    var componentItems = ["BlackWire","RedWire","BlackWireVertical","RedWireVertical"]
    var activeTouchPoints = [CGPoint]()
    var newComponentItems = [UIImageView]()
    var tmpComponentItems: UIView?
    
    //MARK: Embeded Component Item
    var lamp = UIImageView()
    var Source = UIImageView()
    var ampereMeter = UIImageView()
    var level1Objective = UILabel()
    
    
    //MARK: Background and Others
    var gameBackground = UIImageView()
    var collectionView: UICollectionView!
    var playButton: UIButton!
    var refreshButton: UIButton!
    var animator: UIDynamicAnimator?
    
    // MARK: Sound Variables
    var soundURL: URL?
    var playAudio = AVAudioPlayer()
    
    //MARK: Success Screen Properties
    
    var popUpLayOut: UIView = {
        let m_view = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
        m_view.image = UIImage(named: "popUp.png")
        return m_view
    }()
    
    var buttonRestart: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
        button.setImage(UIImage(named: "RestartButton"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    
    var buttonNext: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
        button.setImage(UIImage(named: "NextLevelButton"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    var lastRotation: CGFloat = 0
    public override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 581, height: 640))
        self.view = view
        
        //MARK: To Set Up Background
        gameBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: 581, height: 640))
        gameBackground.image = UIImage(named: "Mainbackground.png")
        gameBackground.contentMode = .scaleAspectFit
        view.addSubview(gameBackground)
        
        // MARK: To Set Up Lamp
        lamp = UIImageView(frame: CGRect(x: 240, y: 195, width: 50, height: 50))
        lamp.image = UIImage(named: "LampOff.png")
        lamp.contentMode = .scaleAspectFit
        view.addSubview(lamp)
        
        // MARK: To Set Up Source
        Source = UIImageView(frame: CGRect(x: 220, y: 390, width: 50, height: 50))
        Source.image = UIImage(named: "SourceSelected.png")
        Source.contentMode = .scaleAspectFit
        view.addSubview(Source)
        
        //MARK: Amperemeter
        ampereMeter = UIImageView(frame: CGRect(x: 20, y: 20, width: 200, height: 100))
        ampereMeter.image = UIImage(named: "AmpereMeter.png")
        ampereMeter.contentMode = .scaleAspectFit
        view.addSubview(ampereMeter)
        
        //MARK: Play and Refresh Button
        playButton = UIButton(frame: CGRect(x: 100, y: 500, width: 80, height: 80))
        playButton.setImage(UIImage(named: "PlayButton.png"), for: .normal)
        playButton.contentMode = .scaleAspectFit
        view.addSubview(playButton)
        
        //Refresh Button
        refreshButton = UIButton(frame: CGRect(x: 200, y: 500, width: 80, height: 80))
        refreshButton.setImage(UIImage(named: "RefreshButton.png"), for: .normal)
        refreshButton.contentMode = .scaleAspectFit
        view.addSubview(refreshButton)
        
        
        //MARK: Objective
        
        let x_pos_label_level1Objective = 50
        let y_pos_label_level1Objective = 40
        level1Objective = UILabel(frame: CGRect(x: x_pos_label_level1Objective, y: y_pos_label_level1Objective, width: 300, height: 60))
        level1Objective.text = "TURN ON THE LAMP!"
        level1Objective.font = level1Objective.font.withSize(14)
        level1Objective.textColor = #colorLiteral(red: 1, green: 0.3281747699, blue: 0.4034234285, alpha: 1)
        view.addSubview(level1Objective)
        
        
        
        // MARK: Collection View Invoke
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 50, height: 50)
        collectionView = UICollectionView(frame: CGRect(x: view.frame.width - 150 , y: 100, width: 100, height: 350), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ComponentsCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        view.addSubview(collectionView)
        
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
        
        //MARK: Animate Some Objects
        animator = UIDynamicAnimator(referenceView: self.view)
        view.addSubview(playButton)
        
        // Animate play Button
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.calculationModeCubic, .autoreverse, .repeat, .allowUserInteraction], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                self.playButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            })
        })
        
        // Animate refresh Button
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.calculationModeCubic, .autoreverse, .repeat, .allowUserInteraction], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                self.refreshButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            })
        })
        // Animate ampereMeter
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubic, .autoreverse, .repeat, .allowUserInteraction], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                self.ampereMeter.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            })
        })
        
        
        
        //MARK: Set Up the Play and Refresh Button
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped(_:)), for: .touchUpInside)
        
    }
    
    //MARK: Sound Utilities
    public func playSound(file: String, fileExtension: String, isLoop: Bool = false){
        soundURL = URL(fileURLWithPath: Bundle.main.path(forResource: file, ofType: fileExtension)!)
        do {
            guard let url = soundURL else {return}
            playAudio = try AVAudioPlayer(contentsOf: url)
            playAudio.play()
        } catch {
        }
    }
    public func tapSound(){
        self.playSound(file: "applause", fileExtension: "mp3")
    }
    
    public func applauseSound() {
        self.playSound(file: "applause3", fileExtension: "mp3")
    }

    public func failSound() {
        self.playSound(file: "electriccurrent", fileExtension: "mp3")
    }
    
    
    //MARK: Success Screen
    public func successPopUpScreen(){
        popUpLayOut.center = view.center
        popUpLayOut.layer.cornerRadius = 20
        buttonRestart.center.x = view.center.x
        
        buttonNext.center.x = view.frame.width - popUpLayOut.frame.origin.x - 50
        buttonRestart.center.x = view.frame.width - popUpLayOut.frame.origin.x - 350
        
        buttonNext.frame.origin.y = view.frame.height - popUpLayOut.frame.origin.y - buttonRestart.frame.height - 10
        buttonRestart.frame.origin.y = view.frame.height - popUpLayOut.frame.origin.y - buttonRestart.frame.height - 10
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubic, .autoreverse, .repeat, .allowUserInteraction], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                self.popUpLayOut.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            })
            
        })
            
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubic, .autoreverse, .repeat, .allowUserInteraction], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                    self.buttonRestart.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                })
                
            })
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubic, .autoreverse, .repeat, .allowUserInteraction], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                    self.buttonNext.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                })
                
            })
        
            // MARK: Buttons is tapped
            buttonRestart.addTarget(self, action: #selector(restart), for: .touchUpInside)
            buttonNext.addTarget(self, action: #selector(nextLevel), for: .touchUpInside)
            
            
            view.addSubview(popUpLayOut)
            view.addSubview(buttonRestart)
            view.addSubview(buttonNext)
            
        }
        
        // What restart button and next level button do
        @objc public func restart(){
            let vc = LevelOne()
            newComponentItems = []
            tapSound()
            vc.componentItems = self.componentItems
            navigationController?.pushViewController(vc, animated: false)
        }
    
        // What restart button and next level button do
        @objc public func nextLevel(){
            let vc = InstructionTwo()
            tapSound()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        // MARK: Select Component Item
        public func showComponentSelected(itemAt: Int, position: CGPoint){
            let img = UIImage(named: componentItems[itemAt])
            let componentItems = UIImageView(image: img)
            componentItems.contentMode = .left
            componentItems.center = position
            componentItems.isUserInteractionEnabled = true
            
            //Do Some Gesture
            let moveGS = UIPanGestureRecognizer(target: self, action: #selector(self.gestureMoveObject(_:)))
            moveGS.delegate = self
            moveGS.delegate = self
            
            let rotateGS = UIRotationGestureRecognizer(target: self, action: #selector(self.gestureRotateObject) )
            
            
            componentItems.addGestureRecognizer(moveGS)
            componentItems.addGestureRecognizer(rotateGS)
            view.addSubview(componentItems)
            
            
            //MARK: How To Animate
            var itemToAnimate = newComponentItems
            itemToAnimate.append(componentItems)
            let viewIndexOnArray = newComponentItems.count
            componentItems.tag = viewIndexOnArray
            newComponentItems = itemToAnimate
            
            view.bringSubviewToFront(collectionView)
            view.bringSubviewToFront(lamp)
            view.bringSubviewToFront(Source)
            
            
            
            
        }
        
        //MARK: Gestures Definition
        @objc func onPan(_ sender: UIPanGestureRecognizer){
            let position = sender.location(in: view)
            let indexItem = sender.view?.tag
            if sender.state == .began {
                let img = UIImage(named: componentItems[indexItem!])
                tmpComponentItems = UIImageView(image: img)
                tmpComponentItems?.contentMode = .left
                tmpComponentItems?.center = position
                view.addSubview(tmpComponentItems!)
            } else if sender.state == .ended {
                showComponentSelected(itemAt: indexItem!, position: position)
                tmpComponentItems?.removeFromSuperview()
            } else {
                tmpComponentItems?.center = position
            }
        }
        
        // MARK: Play and Refresh Button Actions
        @objc func playButtonTapped(_ sender: UIButton){
            tapSound()
            if newComponentItems.count <= 12 && newComponentItems.count >= 10 {
                lamp.image = UIImage(named: "LampOn.png")
                applauseSound()
                self.successPopUpScreen()
            }
            else{
                failSound()
                return
            }
            
        }
        
        @objc func refreshButtonTapped(_ sender: UIButton){
            let vc = LevelOne()
            newComponentItems = []
            tapSound()
            vc.componentItems = self.componentItems
            navigationController?.pushViewController(vc, animated: false)
        }
        
        
        
        //MARK: Gestures Action
        @objc func gestureMoveObject(_ sender: UIPanGestureRecognizer){
            
            let point = sender.location(in: view)
            let panGesture = sender.view
            panGesture?.center = point
            print(point)
        }
        
        @objc func gestureRotateObject(_ sender: UIRotationGestureRecognizer){
            
            let point = sender.location(in: view)
            let rotateGesture = sender.view
            rotateGesture?.center = point
            print(point)
        }
        
        @objc func rotatedComponents(_ sender: UIRotationGestureRecognizer) {
            var originalRotation = CGFloat()
            if sender.state == .began {
                sender.rotation = lastRotation
                originalRotation = sender.rotation
            } else if sender.state == .changed  {
                let newRotation = sender.rotation + originalRotation
                sender.view?.transform = CGAffineTransform(rotationAngle: newRotation)
            } else if sender.state == .ended {
                lastRotation = sender.rotation
            }
        }
        
    }
    
    
