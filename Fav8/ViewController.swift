//
//  ViewController.swift
//  Fav8
//
//  Created by Administrator on 2018-05-09.
//  Copyright © 2018 Administrator. All rights reserved.
//

import AVFoundation
import AVKit
import Lottie
import MediaPlayer
import os.log
import QuartzCore
import UIKit

var currentButtonNumber = 0
var buttonX = Int()
var buttonY = Int()
var player = AVQueuePlayer()
var playerItem: AVPlayerItem!
var buttonState = "Stop"
var buttonsY = 50

class ViewController: UIViewController, AVPlayerItemMetadataOutputPushDelegate {
    var curSta: Int?
    
    var lottieBut: LOTAnimationView?
    var lottieNext: LOTAnimationView?
    var lottiePrev: LOTAnimationView?
    var play = Bool()
    //    let lottieButFrame = CGRect(x:0, y: 50, width: 100, height: 100)
    
    var mainScreenStations = [Station]()
    
    private func loadSampleStations() {
        guard let station1 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color1")) else {
            fatalError("Unable to instantiate station1")
        }
        
        guard let station2 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color2")) else {
            fatalError("Unable to instantiate station2")
        }
        
        guard let station3 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color3")) else {
            fatalError("Unable to instantiate station2")
        }
        
        guard let station4 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color4")) else {
            fatalError("Unable to instantiate station1")
        }
        
        guard let station5 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color5")) else {
            fatalError("Unable to instantiate station2")
        }
        
        guard let station6 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color6")) else {
            fatalError("Unable to instantiate station2")
        }
        
        guard let station7 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color7")) else {
            fatalError("Unable to instantiate station1")
        }
        
        guard let station8 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color8")) else {
            fatalError("Unable to instantiate station2")
        }
        
        mainScreenStations += [station1, station2, station3, station4, station5, station6, station7, station8]
    }
    
    var currentButtonNumberOOO = Int()
    static let notificationName = Notification.Name("myNotificationName")
    let commandCenter = MPRemoteCommandCenter.shared()
    weak var square: UIView!
    weak var square1: UIView!
    weak var square2: UIView!
    weak var square3: UIView!
    
    let shapeLayerView1 = UIView()
    let shapeLayerView2 = UIView()
    let lottiView = UIView()
    let shapeLayer = CAShapeLayer()
    let shapeLayer1 = CAShapeLayer()
    let shapeLayer2 = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let pulsatingLayer = CAShapeLayer()
    var buttonTag = 1
    var lottieButbuttonTag = 1
    
    var buttonStroke = 4
    var buttonRadius = 36
    var currentlyPlaying = "Song Info"
    var currentImage = UIImage()
    var myString = String()
    var currentStation = String()
    var data: String?
    
    var stationArray = [
        ["xPos": -110, "yPos": buttonsY],
        ["xPos": 110, "yPos": buttonsY],
        ["xPos": 0, "yPos": buttonsY+90],
        ["xPos": -110, "yPos": buttonsY+180],
        ["xPos": 110, "yPos": buttonsY+180],
        ["xPos": 0, "yPos": buttonsY+270],
        ["xPos": -110, "yPos": buttonsY+360],
        ["xPos": 110, "yPos": buttonsY+360]
    ]
    
    let buttonArray = [
        ["xPos": 0, "yPos": 120, "buttonName": "Stoped"],
        ["xPos": -110, "yPos": 120, "buttonName": "Previous"],
        ["xPos": 110, "yPos": 120, "buttonName": "Next"]
    ]
    
    @IBOutlet var chooseButton: UIButton!
    @IBOutlet var buttonView: UIView!
    @IBOutlet var bottomFrame: UIView!
    @IBOutlet var gradient: UIView!
    @IBOutlet var gradientImage: UIImageView!
    @IBOutlet var songTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBlack: UIView!
    @IBOutlet var viewMenu: UIView!
    @IBOutlet var constraintMenuLeft: NSLayoutConstraint!
    @IBOutlet var constraintMenuWidth: NSLayoutConstraint!
    
    @IBAction func goToSettings(_ sender: YTRoundedButton) {}
    
    @IBAction func gestureTap(_ sender: UITapGestureRecognizer) {
        hideMenu()
    }
    
    @IBAction func buttonHamburger(_ sender: Any) {
//        UIApplication.shared.connectedScenes.first.windowLevel = UIWindow.Level.statusBar
//        self.openMenu()
        let windowScene = UIApplication.shared.connectedScenes.first
        if let windowScene = windowScene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.windowLevel = UIWindow.Level.statusBar
            openMenu()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if let data = UserDefaults.standard.object(forKey: "Imagine") as! NSData? {
            gradientImage.image = UIImage(data: data as Data)
        } else {
            print("Error loading background")
        }
        
        if buttonState == "Play" {
            animatePulsatingLayer(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
        } else if buttonState == "Stop" {
            animateControlsPulsatingLayer(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
        } else {
            print("Nothing is playing so the pulsating layer doesn't appear")
        }
    }
    
    func loadCommandCenterControls() {
        currentButtonNumberOOO = currentButtonNumber
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.isEnabled = true
        
        commandCenter.playCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            player.play()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            player.pause()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            currentButtonNumber = self.currentButtonNumberOOO+1
            DispatchQueue.main.async {
                self.nextStation()
            }
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            currentButtonNumber = self.currentButtonNumberOOO-1
            DispatchQueue.main.async {
                self.prevStation()
            }
            return .success
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        addLottieBut()
        
        loadCommandCenterControls()
        pulsatingLayerNotificationObserver()
        phoneInterruption()
        
        //        // Use the edit button item provided by the table view controller.
        //        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved stations, otherwise load sample data.
        if let savedStations = loadStations() {
            mainScreenStations += savedStations
        } else {
            // Load the sample data.
            loadSampleStations()
        }
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        let midX = view.bounds.midX
        let maxY = view.bounds.maxY
        let size: CGFloat = 0
        
        shapeLayerView1.layer.insertSublayer(shapeLayer, at: 0)
        shapeLayerView2.layer.insertSublayer(shapeLayer, at: 0)
        buttonView.insertSubview(shapeLayerView1, at: 3)
        bottomFrame.insertSubview(shapeLayerView2, at: 4)
        constraintMenuLeft.constant = -constraintMenuWidth.constant
        viewBlack.alpha = 0
        viewBlack.isHidden = true
        songTitle.layer.cornerRadius = songTitle.frame.size.height / 2.0
        bottomFrame.layer.cornerRadius = songTitle.frame.size.height / 2.0
        songTitle.layer.masksToBounds = true
        songTitle.text = "Choose a station"
        
        for (index, element) in stationArray.enumerated() {
            let xPos = element["xPos"]!
            let yPos = element["yPos"]!
            let img = mainScreenStations[index].photo
            
            let trackLayer = CAShapeLayer()
            let circularPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: CGFloat(buttonRadius), startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
            
            trackLayer.path = circularPath.cgPath
            trackLayer.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            trackLayer.frame = CGRect(x: midX+CGFloat(xPos), y: CGFloat(yPos), width: size, height: size)
            trackLayer.lineWidth = 4
            trackLayer.fillColor = UIColor.clear.cgColor
            trackLayer.lineCap = CAShapeLayerLineCap.round
            
            buttonView.layer.insertSublayer(trackLayer, at: 0)
            
            let button = UIButton(type: .custom)
            
            button.frame = CGRect(x: Double(midX)+Double(xPos)-(Double(buttonRadius)-Double(buttonStroke)), y: Double(yPos)-(Double(buttonRadius)-Double(buttonStroke)), width: 2 * (Double(buttonRadius)-Double(buttonStroke)), height: 2 * (Double(buttonRadius)-Double(buttonStroke)))
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
            
            button.setImage(img, for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            buttonView.insertSubview(button, at: 1)
            button.tag = buttonTag
            buttonTag = buttonTag+1
        }
        
        lottieBut = LOTAnimationView(name: "playstop")
        lottieBut?.isUserInteractionEnabled = true
        lottieBut?.frame = CGRect(x: -15, y: -15, width: 30, height: 30)
        
        let square1 = UIView()
        view.addSubview(square1)
        self.square1 = square1
        self.square1.frame = CGRect(x: midX+CGFloat(0), y: maxY-CGFloat(120), width: 300, height: 300)
        
        lottieNext = LOTAnimationView(name: "next")
        lottieNext?.isUserInteractionEnabled = true
        lottieNext?.frame = CGRect(x: -15, y: -15, width: 30, height: 30)
        
        let square2 = UIView()
        view.addSubview(square2)
        self.square2 = square2
        self.square2.frame = CGRect(x: midX+CGFloat(110), y: maxY-CGFloat(120), width: 300, height: 300)
        
        lottiePrev = LOTAnimationView(name: "prev")
        lottiePrev?.isUserInteractionEnabled = true
        lottiePrev?.frame = CGRect(x: -15, y: -15, width: 30, height: 30)
        
        let square3 = UIView()
        view.addSubview(square3)
        self.square3 = square3
        self.square3.frame = CGRect(x: midX+CGFloat(-110), y: maxY-CGFloat(120), width: 300, height: 300)
        
        square1.addSubview(lottieBut!)
        square1.isUserInteractionEnabled = false
        
        square2.addSubview(lottieNext!)
        square2.isUserInteractionEnabled = false
        
        square3.addSubview(lottiePrev!)
        square3.isUserInteractionEnabled = false
        
        for (_, element) in buttonArray.enumerated() {
            let xPos = element["xPos"] as! Int
            let yPos = element["yPos"] as! Int
            //            let img = element["buttonName"] as! String
            
            let trackLayer = CAShapeLayer()
            let circularPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: CGFloat(buttonRadius), startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
            let squareFrame = CGRect(x: midX+CGFloat(xPos), y: maxY-CGFloat(yPos), width: size, height: size)
            
            let square = UIView()
            view.addSubview(square)
            self.square = square
            self.square.frame = squareFrame
            
            trackLayer.path = circularPath.cgPath
            trackLayer.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            trackLayer.frame = squareFrame
            trackLayer.lineWidth = 4
            trackLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            trackLayer.lineCap = CAShapeLayerLineCap.round
            view.layer.insertSublayer(trackLayer, at: 3)
            
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: Double(midX)+Double(xPos)-(Double(buttonRadius)-Double(buttonStroke)), y: Double(maxY)-Double(yPos)-(Double(buttonRadius)-Double(buttonStroke)), width: 2 * (Double(buttonRadius)-Double(buttonStroke)), height: 2 * (Double(buttonRadius)-Double(buttonStroke)))
            
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
            button.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.04705882353, blue: 0.2117647059, alpha: 1)
            //            button.setImage(UIImage(named:img), for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            view.insertSubview(button, at: 7)
            
            button.tag = buttonTag
            buttonTag = buttonTag+1
        }
    }
    
    //
    //    func addLottieBut () {
    //
    //        lottieBut = LOTAnimationView(name: "data")
    //        lottieBut?.isUserInteractionEnabled = true
    //        lottieBut?.frame = lottieButFrame
    //        lottieBut?.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    //        lottieBut?.contentMode = .scaleAspectFill
    //        buttonTapRecognizer()
    //        self.view.addSubview(lottieBut!)
    //    }
    
    //    func buttonTapRecognizer() {
    //        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.gestRec(recognizer:)))
    //        tapRecognizer.numberOfTapsRequired = 1
    //        lottieBut?.addGestureRecognizer(tapRecognizer)
    //    }
    
    //    @objc func gestRec (recognizer:UITapGestureRecognizer) {
    //        if play == true {
    //            lottieBut?.animationSpeed = -1.0
    //            lottieBut?.play()
    //
    //            play = false
    //        } else {
    //            play = true
    //            lottieBut?.animationSpeed = 1.0
    //            lottieBut?.play()
    //        }
    //    }
    
    func phoneInterruption() {
        let theSession = AVAudioSession.sharedInstance()
        
        do {
            try theSession.setCategory(AVAudioSession.Category.playback)
            print("AVAudioSession Category Playback OK")
            do {
                try theSession.setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.handleInterruption), name: AVAudioSession.interruptionNotification, object: theSession)
    }
    
    @objc func handleInterruption(notification: NSNotification) {
        if notification.name != AVAudioSession.interruptionNotification
            || notification.userInfo == nil
        {
            return
        }
        
        let info = notification.userInfo!
        var intValue: UInt = 0
        (info[AVAudioSessionInterruptionTypeKey] as! NSValue).getValue(&intValue)
        if let interruptionType = AVAudioSession.InterruptionType(rawValue: intValue) {
            switch interruptionType {
            case .began:
                if buttonState == "Play" {
                    player.pause()
                    print("Audio paused with button state =\(buttonState)")
                } else {
                    print("Player is not initialized")
                }
            default:
                if buttonState != "Stop" {
                    player.play()
                    print("Audio resumed with button state =\(buttonState)")
                }
            }
        }
    }
    
    func pulsatingLayerNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func handleEnterForeground() {
        if buttonState == "Play" {
            animatePulsatingLayer(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
            
        } else if buttonState == "Stop" {
            animateControlsPulsatingLayer(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
        } else {
            print("Nothing is playing so the pulsating layer doesn't appear")
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        switch sender.tag {
        case 1...8:
            let arrayData = stationArray[sender.tag-1]
            buttonX = arrayData["xPos"]!
            buttonY = arrayData["yPos"]!
            currentStation = mainScreenStations[sender.tag-1].name
            
            currentButtonNumber = sender.tag
            currentButtonNumberOOO = currentButtonNumber
            buttonState = "Play"
            songTitle.text = currentStation
            currentlyPlaying = currentStation
            currentImage = mainScreenStations[sender.tag-1].photo!
            setupAVAudioSession()
            
            animatePulsatingLayer(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
            chooseStation(station: sender.tag)
            curSta = sender.tag
            pathAnim(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
            play = true
            print(play)
            
        case 9:
            let arrayData = buttonArray[0]
            buttonX = arrayData["xPos"]! as! Int
            
            //            animateControlsPulsatingLayer(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
            
            //            controlsPathAnim(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
            
            //
            //            if  buttonState == "Play" {
            //
            //            } else {
            //
            //            }
            
            if play == true {
                player.pause()
                buttonState = "Stop"
                currentStation = arrayData["buttonName"]! as! String
                lottieBut?.animationSpeed = 1.0
                lottieBut?.play()
                play = false
            } else if play == false {
                player.play()
                buttonState = "Play"
                if let curStat = curSta {
                    player.pause()
                    currentStation = mainScreenStations[curStat-1].name
                    chooseStation(station: curStat)
                    lottieBut?.animationSpeed = -1.0
                    lottieBut?.play()
                    play = true
                }
            }
            
            songTitle.text = currentStation
            currentlyPlaying = currentStation
            currentImage = UIImage(named: "Stop")!
            setupAVAudioSession()
            
        case 10:
            if let curStat = curSta {
                curSta = curStat-1
                
                lottiePrev?.play()
                currentButtonNumber = currentButtonNumber-1
                currentButtonNumberOOO = currentButtonNumber
                prevStation()
            }
            
        case 11:
            if let curStat = curSta {
                curSta = curStat+1
                lottieNext?.play()
                currentButtonNumber = currentButtonNumber+1
                currentButtonNumberOOO = currentButtonNumber
                nextStation()
            }
            
        default:
            print("No more buttons")
        }
    }
    
    func nextStation() {
        if case 1...8 = currentButtonNumber {
            self.currentButtonNumberOOO = currentButtonNumber
            
            buttonState = "Play"
            
            let arrayData = stationArray[currentButtonNumber-1]
            buttonX = arrayData["xPos"]!
            buttonY = arrayData["yPos"]!
            currentStation = mainScreenStations[currentButtonNumber-1].name
            
            songTitle.text = currentStation
            currentlyPlaying = currentStation
            currentImage = mainScreenStations[currentButtonNumber-1].photo!
            goToStation()
            animatePulsatingLayer(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
            pathAnim(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
            setupAVAudioSession()
        } else {
            currentButtonNumber = 1
            currentButtonNumberOOO = currentButtonNumber
            
            if buttonState == "Stop" {
                buttonState = "Play"
            } else {
                player.removeAllItems()
            }
            
            let arrayData = stationArray[currentButtonNumber-1]
            buttonX = arrayData["xPos"]!
            buttonY = arrayData["yPos"]!
            currentStation = mainScreenStations[currentButtonNumber-1].name
            
            songTitle.text = currentStation
            currentlyPlaying = currentStation
            currentImage = mainScreenStations[currentButtonNumber-1].photo!
            goToStation()
            animatePulsatingLayer(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
            pathAnim(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
            setupAVAudioSession()
        }
    }
    
    func prevStation() {
        if case 1...8 = currentButtonNumber {
            self.currentButtonNumberOOO = currentButtonNumber
            buttonState = "Play"
            let arrayData = stationArray[currentButtonNumber-1]
            buttonX = arrayData["xPos"]!
            buttonY = arrayData["yPos"]!
            currentStation = mainScreenStations[currentButtonNumber-1].name
            
            songTitle.text = currentStation
            currentlyPlaying = currentStation
            currentImage = mainScreenStations[currentButtonNumber-1].photo!
            goToStation()
            animatePulsatingLayer(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
            pathAnim(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
            setupAVAudioSession()
        } else {
            currentButtonNumber = 8
            currentButtonNumberOOO = currentButtonNumber
            
            if buttonState == "Stop" {
                buttonState = "Play"
            } else {
                player.removeAllItems()
            }
            
            let arrayData = stationArray[currentButtonNumber-1]
            buttonX = arrayData["xPos"]!
            buttonY = arrayData["yPos"]!
            currentStation = mainScreenStations[currentButtonNumber-1].name
            
            songTitle.text = currentStation
            currentlyPlaying = currentStation
            currentImage = mainScreenStations[currentButtonNumber-1].photo!
            goToStation()
            animatePulsatingLayer(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
            pathAnim(xPoint: buttonX, yPoint: buttonY, radiusSize: CGFloat(buttonRadius))
            setupAVAudioSession()
        }
    }
    
    func goToStation() {
        let item1 = AVPlayerItem(url: URL(string: mainScreenStations[0].url)!)
        let item2 = AVPlayerItem(url: URL(string: mainScreenStations[1].url)!)
        let item3 = AVPlayerItem(url: URL(string: mainScreenStations[2].url)!)
        let item4 = AVPlayerItem(url: URL(string: mainScreenStations[3].url)!)
        let item5 = AVPlayerItem(url: URL(string: mainScreenStations[4].url)!)
        let item6 = AVPlayerItem(url: URL(string: mainScreenStations[5].url)!)
        let item7 = AVPlayerItem(url: URL(string: mainScreenStations[6].url)!)
        let item8 = AVPlayerItem(url: URL(string: mainScreenStations[7].url)!)
        let metadataOutput = AVPlayerItemMetadataOutput(identifiers: nil)
        metadataOutput.setDelegate(self, queue: DispatchQueue.main)
        
        if currentButtonNumber == 1 {
            play = true
            lottieBut?.animationProgress = 0
            item1.add(metadataOutput)
            player = AVQueuePlayer(playerItem: item1)
            player.play()
        } else if currentButtonNumber == 2 {
            play = true
            lottieBut?.animationProgress = 0
            item2.add(metadataOutput)
            player = AVQueuePlayer(playerItem: item2)
            player.play()
        } else if currentButtonNumber == 3 {
            play = true
            lottieBut?.animationProgress = 0
            item3.add(metadataOutput)
            player = AVQueuePlayer(playerItem: item3)
            player.play()
        } else if currentButtonNumber == 4 {
            play = true
            lottieBut?.animationProgress = 0
            item4.add(metadataOutput)
            player = AVQueuePlayer(playerItem: item4)
            player.play()
        } else if currentButtonNumber == 5 {
            play = true
            lottieBut?.animationProgress = 0
            item5.add(metadataOutput)
            player = AVQueuePlayer(playerItem: item5)
            player.play()
        } else if currentButtonNumber == 6 {
            play = true
            lottieBut?.animationProgress = 0
            item6.add(metadataOutput)
            player = AVQueuePlayer(playerItem: item6)
            player.play()
        } else if currentButtonNumber == 7 {
            play = true
            lottieBut?.animationProgress = 0
            item7.add(metadataOutput)
            player = AVQueuePlayer(playerItem: item7)
            player.play()
        } else if currentButtonNumber == 8 {
            play = true
            lottieBut?.animationProgress = 0
            item8.add(metadataOutput)
            player = AVQueuePlayer(playerItem: item8)
            player.play()
        }
    }
    
    func chooseStation(station: Int) {
        let item1 = AVPlayerItem(url: URL(string: mainScreenStations[0].url)!)
        let itemUrl1 = mainScreenStations[0].url
        let item2 = AVPlayerItem(url: URL(string: mainScreenStations[1].url)!)
        let itemUrl2 = mainScreenStations[1].url
        let item3 = AVPlayerItem(url: URL(string: mainScreenStations[2].url)!)
        let itemUrl3 = mainScreenStations[2].url
        let item4 = AVPlayerItem(url: URL(string: mainScreenStations[3].url)!)
        let itemUrl4 = mainScreenStations[3].url
        let item5 = AVPlayerItem(url: URL(string: mainScreenStations[4].url)!)
        let itemUrl5 = mainScreenStations[4].url
        let item6 = AVPlayerItem(url: URL(string: mainScreenStations[5].url)!)
        let itemUrl6 = mainScreenStations[5].url
        let item7 = AVPlayerItem(url: URL(string: mainScreenStations[6].url)!)
        let itemUrl7 = mainScreenStations[6].url
        let item8 = AVPlayerItem(url: URL(string: mainScreenStations[7].url)!)
        let itemUrl8 = mainScreenStations[7].url
        let metadataOutput = AVPlayerItemMetadataOutput(identifiers: nil)
        metadataOutput.setDelegate(self, queue: DispatchQueue.main)
        
        if station == 1 {
            if itemUrl1 == "url" {
                performSegue(withIdentifier: "FavoritesSegue", sender: nil)
            } else {
                item1.add(metadataOutput)
                player = AVQueuePlayer(playerItem: item1)
                player.play()
                lottieBut?.animationProgress = 0
            }
        } else if station == 2 {
            if itemUrl2 == "url" {
                performSegue(withIdentifier: "FavoritesSegue", sender: nil)
            } else {
                item2.add(metadataOutput)
                player = AVQueuePlayer(playerItem: item2)
                player.play()
                lottieBut?.animationProgress = 0
            }
        } else if station == 3 {
            if itemUrl3 == "url" {
                performSegue(withIdentifier: "FavoritesSegue", sender: nil)
            } else {
                item3.add(metadataOutput)
                player = AVQueuePlayer(playerItem: item3)
                player.play()
                lottieBut?.animationProgress = 0
            }
        } else if station == 4 {
            if itemUrl4 == "url" {
                performSegue(withIdentifier: "FavoritesSegue", sender: nil)
            } else {
                item4.add(metadataOutput)
                player = AVQueuePlayer(playerItem: item4)
                player.play()
                lottieBut?.animationProgress = 0
            }
        } else if station == 5 {
            if itemUrl5 == "url" {
                performSegue(withIdentifier: "FavoritesSegue", sender: nil)
            } else {
                item5.add(metadataOutput)
                player = AVQueuePlayer(playerItem: item5)
                player.play()
                lottieBut?.animationProgress = 0
            }
        } else if station == 6 {
            if itemUrl6 == "url" {
                performSegue(withIdentifier: "FavoritesSegue", sender: nil)
            } else {
                item6.add(metadataOutput)
                player = AVQueuePlayer(items: [item6])
                player.play()
                lottieBut?.animationProgress = 0
            }
        } else if station == 7 {
            if itemUrl7 == "url" {
                performSegue(withIdentifier: "FavoritesSegue", sender: nil)
            } else {
                item7.add(metadataOutput)
                player = AVQueuePlayer(items: [item7])
                player.play()
                lottieBut?.animationProgress = 0
            }
        } else if station == 8 {
            if itemUrl8 == "url" {
                performSegue(withIdentifier: "FavoritesSegue", sender: nil)
            } else {
                item8.add(metadataOutput)
                player = AVQueuePlayer(items: [item8])
                player.play()
                lottieBut?.animationProgress = 0
            }
        }
    }
    
    private func setupAVAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            debugPrint("AVAudioSession is Active and Category Playback is set")
            UIApplication.shared.beginReceivingRemoteControlEvents()
            setupCommandCenter()
        } catch {
            debugPrint("Error: \(error)")
        }
    }
    
    private func setupCommandCenter() {
        let image = currentImage
        
        let albumArt = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { _ -> UIImage in
            image
        })
        
        let myString = currentlyPlaying
        
        if myString.range(of: " - ") != nil {
            let myStringArr = myString.components(separatedBy: " - ")
            let artist: String = myStringArr[0]
            let song: String = myStringArr[1]
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyTitle: song,
                MPMediaItemPropertyArtist: artist,
                MPMediaItemPropertyArtwork: albumArt
            ]
        } else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyTitle: currentlyPlaying,
                MPMediaItemPropertyArtist: currentlyPlaying,
                MPMediaItemPropertyArtwork: albumArt
            ]
        }
    }
    
    func pathAnim(xPoint: Int, yPoint: Int, radiusSize: CGFloat) {
        let midX = view.bounds.midX
        let minY = view.bounds.minY
        let size: CGFloat = 0
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: xPoint, y: yPoint), radius: radiusSize, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer1.path = circularPath.cgPath
        shapeLayer1.strokeColor = #colorLiteral(red: 0.1921568627, green: 0.9294117647, blue: 0.9176470588, alpha: 1)
        shapeLayer1.lineWidth = CGFloat(buttonStroke)
        shapeLayer1.fillColor = UIColor.clear.cgColor
        shapeLayer1.lineCap = CAShapeLayerLineCap.round
        shapeLayer1.strokeEnd = 0
        
        shapeLayer1.frame = CGRect(x: midX, y: minY, width: size, height: size)
        
        shapeLayerView2.layer.sublayers?.removeAll()
        shapeLayerView1.layer.insertSublayer(shapeLayer1, at: 0)
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer1.add(basicAnimation, forKey: "urSoBasic")
    }
    
    func controlsPathAnim(xPoint: Int, yPoint: Int, radiusSize: CGFloat) {
        let midX = view.bounds.midX
        let size: CGFloat = 0
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: xPoint, y: yPoint), radius: radiusSize, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer2.path = circularPath.cgPath
        shapeLayer2.strokeColor = #colorLiteral(red: 0.1921568627, green: 0.9294117647, blue: 0.9176470588, alpha: 1)
        shapeLayer2.lineWidth = CGFloat(buttonStroke)
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.lineCap = CAShapeLayerLineCap.round
        shapeLayer2.strokeEnd = 0
        
        shapeLayer2.frame = CGRect(x: midX+CGFloat(xPoint), y: -(120+2 * CGFloat(buttonStroke)), width: size, height: size)
        
        shapeLayerView1.layer.sublayers?.removeAll()
        shapeLayerView2.layer.insertSublayer(shapeLayer2, at: 0)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer2.add(basicAnimation, forKey: "urSoBasic")
    }
    
    private func animatePulsatingLayer(xPoint: Int, yPoint: Int, radiusSize: CGFloat) {
        let midX = view.bounds.midX
        let size: CGFloat = 0
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: CGFloat(buttonRadius),
                                        startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = CGFloat(buttonStroke)
        pulsatingLayer.fillColor = #colorLiteral(red: 0.1921568627, green: 0.9294117647, blue: 0.9176470588, alpha: 1)
        pulsatingLayer.lineCap = CAShapeLayerLineCap.round
        pulsatingLayer.frame = CGRect(x: midX+CGFloat(xPoint), y: CGFloat(yPoint+20), width: size, height: size)
        pulsatingLayer.opacity = 0.4
        
        scrollView.layer.insertSublayer(pulsatingLayer, at: 0)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0.8
        opacity.toValue = 0
        opacity.duration = 1.4
        opacity.autoreverses = false
        opacity.repeatCount = Float.infinity
        animation.toValue = 1.4
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    private func animateControlsPulsatingLayer(xPoint: Int, yPoint: Int, radiusSize: CGFloat) {
        let midX = view.bounds.midX
        let maxY = view.bounds.maxY
        let size: CGFloat = 0
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: CGFloat(buttonRadius),
                                        startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = CGFloat(buttonStroke)
        pulsatingLayer.fillColor = #colorLiteral(red: 0.1921568627, green: 0.9294117647, blue: 0.9176470588, alpha: 1)
        pulsatingLayer.lineCap = CAShapeLayerLineCap.round
        
        pulsatingLayer.frame = CGRect(x: midX+CGFloat(xPoint), y: maxY-CGFloat(yPoint), width: size, height: size)
        pulsatingLayer.opacity = 0.4
        
        view.layer.insertSublayer(pulsatingLayer, at: 2)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.4
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup], from track: AVPlayerItemTrack?) {
        if let item = groups.first?.items.first // make this an AVMetadata item
        {
            item.value(forKeyPath: "value")
            let currentlyPlaying = (item.value(forKeyPath: "value")! as? String)
            songTitle.text = currentlyPlaying
            setupAVAudioSession()
        } else {
            print("MetaData Error") // No Metadata or Could not read
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openMenu() {
        // when menu is opened, it's left constraint should be 0
        constraintMenuLeft.constant = 0
        // view for dimming effect should also be shown
        viewBlack.isHidden = false
        
        // animate opening of the menu - including opacity value
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.viewBlack.alpha = 0.5
        }, completion: { _ in
            
            // disable the screen edge pan gesture when menu is fully opened
            //           self.gestureScreenEdgePan.isEnabled = false
        })
    }
    
    func hideMenu() {
        // when menu is closed, it's left constraint should be of value that allows it to be completely hidden to the left of the screen - which is negative value of it's width
        constraintMenuLeft.constant = -constraintMenuWidth.constant
        
        // animate closing of the menu - including opacity value
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.viewBlack.alpha = 0
        }, completion: { _ in
            
            // reenable the screen edge pan gesture so we can detect it next time
            //        self.gestureScreenEdgePan.isEnabled = true
            
            // hide the view for dimming effect so it wont interrupt touches for views underneath it
            self.viewBlack.isHidden = true
//            UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
            
            let windowScene = UIApplication.shared.connectedScenes.first
            if let windowScene = windowScene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.windowLevel = UIWindow.Level.normal
            }
            
        })
    }
    
    @IBAction func chooseButtonTapped(_ sender: UIButton) {
        let selectionVC = storyboard?.instantiateViewController(withIdentifier: "BackgroundImageViewController") as! BackgroundImageViewController
        
        selectionVC.selectionDelegate = self
        
        present(selectionVC, animated: true, completion: nil)
    }
    
    private func loadStations() -> [Station]? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: Station.ArchiveURL.path))
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Station]
        } catch {
            print(error)
            return nil
        }
    }
}

extension ViewController: BackgroundImageDelegate {
    func didTapChoise(imgData: NSData) {
        hideMenu()
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}
