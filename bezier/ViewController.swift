//
//  ViewController.swift
//  bezier
//
//  Created by Matt on 2020/10/5.
//

import UIKit

class ViewController: UIViewController {
    
    let linePink = UIView()
    let lineBlue = UIView()
    
    let Go : UIButton = {
        let but = UIButton(type: .system)
        but.setTitleColor(.white, for: .normal)
        but.backgroundColor = .systemBlue
        but.setTitle("Preview", for: .normal)
        but.translatesAutoresizingMaskIntoConstraints = false
        but.layer.cornerRadius = 4
        but.addTarget(self, action: #selector(GoAction), for: .touchUpInside)
        return but
    }()
    
    @objc func GoAction() {
        let emoji = ["😀","😃","😁","😆","😇","😂","☺️","🤣","🤩","😎","🤪","😛","🧐","🥺","🥳","🥴","😴","🙄","😮","🥶"]
        let alert = SimpleAlert()
        .addTitle(emoji.randomElement()!, .boldSystemFont(ofSize: 100))
        .setProgressBar(TimeInterval(slider.value))
        .addButton("Done")
        
        alert.endAnimatedCallBack = {
            print("animationDidStop")
        }
        
        let boardHeightGap = (board.frame.height - board.frame.width) / 2
        let pinkPoint = view.convert(cubicPink.center, to: board)
        let bluePoint = view.convert(cubicBlue.center, to: board)
        alert.show(duration: TimeInterval(slider.value),
                   controlPoint1: CGPoint(x: abs(pinkPoint.x / board.frame.width), y: (pinkPoint.y - boardHeightGap) / board.frame.width),
                   controlPoint2: CGPoint(x: abs(bluePoint.x / board.frame.width), y: (bluePoint.y - boardHeightGap) / board.frame.width))
    }
    
    let sliderLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Duration: 2.0"
        label.textColor = .black
        return label
    }()
    
    let slider : UISlider = {
       let s = UISlider()
        s.minimumValue = 0.1
        s.maximumValue = 10.0
        s.value = 2.0
        s.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    @objc func sliderValueChange(sender:UISlider) {
        sliderLabel.text = "Duration: \(String(format: "%.1f", sender.value))"
    }
    
    let bezierLabel : UITextView = {
       let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.isEditable = false
        text.isUserInteractionEnabled = false
        return text
    }()
    
    let timeLabel : UILabel = {
       let label = UILabel()
        label.text = "TIME"
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let progressionLabel : UILabel = {
       let label = UILabel()
        label.text = "PROGRESSION"
        label.font = .systemFont(ofSize: 14)
        label.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let boardBackground : UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let board : UIView = {
       let v = UIView()
        v.backgroundColor = .systemGray6
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        v.transform = CGAffineTransform(scaleX: 1, y: -1)
        return v
    }()
    
    lazy var cubicPink : UIButton = {
        let but = UIButton(type: .system)
        but.frame = CGRect(x: 150, y: 300, width: 30, height: 30)
        but.backgroundColor = .systemPink
        but.layer.cornerRadius = 30 / 2
        let touch = CustomGestureRecognizer(target: self, action: #selector(touchCubic))
        touch.maximumNumberOfTouches = 1
        touch.minimumNumberOfTouches = 1
        touch.cubic = but
        touch.line = linePink
        but.addGestureRecognizer(touch)
        but.layer.zPosition = 99
        return but
    }()
    
    lazy var cubicBlue : UIButton = {
        let but = UIButton(type: .system)
        but.frame = CGRect(x: 220, y: 550, width: 30, height: 30)
        but.backgroundColor = .systemBlue
        but.layer.cornerRadius = 30 / 2
        let touch = CustomGestureRecognizer(target: self, action: #selector(touchCubic))
        touch.maximumNumberOfTouches = 1
        touch.minimumNumberOfTouches = 1
        touch.cubic = but
        touch.line = lineBlue
        but.addGestureRecognizer(touch)
        but.layer.zPosition = 99
        return but
    }()
    
    @objc func touchCubic(sender:CustomGestureRecognizer) {
        let point = sender.location(in: view)
        
        if point.x >= (board.frame.width) + ((view.frame.width - board.frame.width)/2) {
            sender.cubic?.center = CGPoint(x: (board.frame.width) + ((view.frame.width - board.frame.width)/2), y: point.y)
        }else if point.x <= ((view.frame.width - board.frame.width)/2){
            sender.cubic?.center = CGPoint(x: ((view.frame.width - board.frame.width)/2), y: point.y)
        }else{
            sender.cubic?.center = point
        }
        
        if point.y <= board.frame.origin.y {
            if point.x >= (board.frame.width) + ((view.frame.width - board.frame.width)/2) {
                sender.cubic?.center = CGPoint(x: (board.frame.width) + ((view.frame.width - board.frame.width)/2), y: board.frame.origin.y)
            }else if point.x <= ((view.frame.width - board.frame.width)/2){
                sender.cubic?.center = CGPoint(x: ((view.frame.width - board.frame.width)/2), y: board.frame.origin.y)
            }else{
                sender.cubic?.center = CGPoint(x: point.x, y: board.frame.origin.y)
            }
        }else if point.y >= board.frame.height + board.frame.origin.y{
            if point.x >= (board.frame.width) + ((view.frame.width - board.frame.width)/2) {
                sender.cubic?.center = CGPoint(x: (board.frame.width) + ((view.frame.width - board.frame.width)/2), y: board.frame.height + board.frame.origin.y)
            }else if point.x <= ((view.frame.width - board.frame.width)/2){
                sender.cubic?.center = CGPoint(x: ((view.frame.width - board.frame.width)/2), y: board.frame.height + board.frame.origin.y)
            }else{
                sender.cubic?.center = CGPoint(x: point.x, y: board.frame.height + board.frame.origin.y)
            }
        }
        
        
        let boardHeightGap = (board.frame.height - board.frame.width) / 2
        let boardLocation = view.convert(sender.cubic?.center ?? .zero, to: board)

        if let l = sender.line?.layer.sublayers {
            for layers in l {
                if let layer = layers as? CAShapeLayer{
                    let path = UIBezierPath()
                    path.move(to: .zero)
                    
                    if sender.line == linePink {
                        path.addLine(to: CGPoint(x: boardLocation.x, y: boardLocation.y - boardHeightGap))
                    }else{
                        path.addLine(to: CGPoint(x: board.frame.width - boardLocation.x, y: board.frame.width - (boardLocation.y - boardHeightGap)))
                    }
                    
                    layer.path = path.cgPath
                }
            }
        }
        
        if let b = board.layer.sublayers {
            for layers in b {
                if let layer = layers as? CAShapeLayer{
                    let path = UIBezierPath()
                    path.move(to: .zero)
                    
                    if sender.cubic == cubicPink {
                        let bluePoint = view.convert(cubicBlue.center, to: board)
                        path.addCurve(to: CGPoint(x: board.frame.width, y:board.frame.width),
                                      controlPoint1: CGPoint(x: boardLocation.x, y: boardLocation.y - boardHeightGap),
                                      controlPoint2: CGPoint(x: bluePoint.x, y: bluePoint.y - boardHeightGap))
                        let point1 = String(format: "%.2f", abs(boardLocation.x / board.frame.width)) + " , " +
                                     String(format: "%.2f", (boardLocation.y - boardHeightGap) / board.frame.width)
                        let point2 = String(format: "%.2f", bluePoint.x / board.frame.width) + " , " +
                                     String(format: "%.2f", (bluePoint.y - boardHeightGap) / board.frame.width)
                        attributedString(text: "Cubic-Bezier\nPoint1: \(point1)\nPoint2: \(point2)", string1: "\(point1)", string2: "\(point2)")
                    }else{
                        let pinkPoint = view.convert(cubicPink.center, to: board)
                        path.addCurve(to: CGPoint(x: board.frame.width, y:board.frame.width),
                                      controlPoint1: CGPoint(x: pinkPoint.x, y: pinkPoint.y - boardHeightGap),
                                      controlPoint2: CGPoint(x: boardLocation.x, y: boardLocation.y - boardHeightGap))
                        let point1 = String(format: "%.2f", pinkPoint.x / board.frame.width) + " , " +
                                     String(format: "%.2f", (pinkPoint.y - boardHeightGap) / board.frame.width)
                        let point2 = String(format: "%.2f", abs(boardLocation.x / board.frame.width)) + " , " +
                                     String(format: "%.2f", (boardLocation.y - boardHeightGap) / board.frame.width)
                        attributedString(text: "Cubic-Bezier\nPoint1: \(point1)\nPoint2: \(point2)", string1: "\(point1)", string2: "\(point2)")
                    }
                    
                    layer.path = path.cgPath
                }
            }
        }
        cubicBlue.layer.zPosition = 99
        cubicPink.layer.zPosition = 99
        sender.cubic?.layer.zPosition = 100
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(board)
        view.addSubview(cubicPink)
        view.addSubview(cubicBlue)
        view.addSubview(bezierLabel)
        view.addSubview(Go)
        board.addSubview(boardBackground)
        view.addSubview(timeLabel)
        view.addSubview(progressionLabel)
        view.addSubview(sliderLabel)
        view.addSubview(slider)
        NSLayoutConstraint.activate([
            board.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            board.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            board.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            board.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            bezierLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            bezierLabel.leftAnchor.constraint(equalTo: board.leftAnchor, constant: 0),
            bezierLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            bezierLabel.bottomAnchor.constraint(equalTo: board.topAnchor, constant: 0),
            Go.centerYAnchor.constraint(equalTo: bezierLabel.centerYAnchor, constant: 0),
            Go.rightAnchor.constraint(equalTo: board.rightAnchor, constant: 0),
            Go.heightAnchor.constraint(equalToConstant: 40),
            Go.widthAnchor.constraint(equalToConstant: 70),
            boardBackground.centerYAnchor.constraint(equalTo: board.centerYAnchor, constant: 0),
            boardBackground.centerXAnchor.constraint(equalTo: board.centerXAnchor, constant: 0),
            boardBackground.heightAnchor.constraint(equalTo: board.widthAnchor, multiplier: 1),
            boardBackground.widthAnchor.constraint(equalTo: board.widthAnchor, multiplier: 1),
            timeLabel.topAnchor.constraint(equalTo: boardBackground.bottomAnchor, constant: 2),
            timeLabel.leftAnchor.constraint(equalTo: boardBackground.leftAnchor, constant: 5),
            progressionLabel.rightAnchor.constraint(equalTo: boardBackground.leftAnchor, constant: 40),
            progressionLabel.bottomAnchor.constraint(equalTo: boardBackground.bottomAnchor, constant: -50),
            sliderLabel.topAnchor.constraint(equalTo: board.bottomAnchor, constant: 3),
            sliderLabel.leftAnchor.constraint(equalTo: board.leftAnchor, constant: 0),
            slider.topAnchor.constraint(equalTo: sliderLabel.bottomAnchor, constant: 0),
            slider.leftAnchor.constraint(equalTo: board.leftAnchor, constant: 0),
            slider.rightAnchor.constraint(equalTo: board.rightAnchor, constant: 0),
            slider.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        drawBoardBackground()
        initBezierLine()
    }
    
    func drawBoardBackground() {
        let shapeLayer_line = CAShapeLayer()
        shapeLayer_line.lineWidth = 8
        shapeLayer_line.zPosition = 5
        shapeLayer_line.strokeColor = UIColor.systemGray4.withAlphaComponent(0.5).cgColor
        let path_line = UIBezierPath()
        path_line.move(to: CGPoint(x: 0, y: 0))
        path_line.addLine(to: CGPoint(x: board.frame.width, y:board.frame.width))
        shapeLayer_line.path = path_line.cgPath
        boardBackground.layer.addSublayer(shapeLayer_line)
        
        let shapeLayer_frame = CAShapeLayer()
        shapeLayer_frame.lineWidth = 1
        shapeLayer_frame.zPosition = 5
        shapeLayer_frame.fillColor = nil
        shapeLayer_frame.strokeColor = UIColor.black.cgColor
        let path_frame = UIBezierPath()
        path_frame.move(to: CGPoint(x: 0, y: board.frame.width))
        path_frame.addLine(to: CGPoint(x: 0, y:0))
        path_frame.addLine(to: CGPoint(x: board.frame.width, y:0))
        shapeLayer_frame.path = path_frame.cgPath
        boardBackground.layer.addSublayer(shapeLayer_frame)
        
        for i in 0...14 {
            let cellHeight = board.frame.width / 15
            let gap = cellHeight * CGFloat(i)
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = cellHeight
            shapeLayer.strokeColor = i % 2 == 0 ? UIColor.white.cgColor : UIColor.systemGray6.cgColor
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: (board.frame.width - gap) - (cellHeight / 2)))
            path.addLine(to: CGPoint(x: board.frame.width, y: (board.frame.width - gap) - (cellHeight / 2)))
            shapeLayer.path = path.cgPath
            boardBackground.layer.addSublayer(shapeLayer)
        }
    }
    
    func initBezierLine() {
        board.addSubview(linePink)
        board.addSubview(lineBlue)
        
        linePink.layer.zPosition = 99
        lineBlue.layer.zPosition = 99
        
        let boardHeightGap = (board.frame.height - board.frame.width) / 2
        
        let pinkPoint = view.convert(cubicPink.center, to: board)
        linePink.center = CGPoint(x: 0, y: boardHeightGap)
        let shapeLayer_pink = CAShapeLayer()
        shapeLayer_pink.lineWidth = 2
        shapeLayer_pink.strokeColor = UIColor.red.cgColor
        let path_pink = UIBezierPath()
        path_pink.move(to: .zero)
        path_pink.addLine(to: CGPoint(x: pinkPoint.x, y: pinkPoint.y - boardHeightGap))
        shapeLayer_pink.path = path_pink.cgPath
        linePink.layer.addSublayer(shapeLayer_pink)
        
        
        let bluePoint = view.convert(cubicBlue.center, to: board)
        lineBlue.transform = CGAffineTransform(scaleX: -1, y: -1)
        lineBlue.center = CGPoint(x: board.frame.width, y: board.frame.width + boardHeightGap)
        let shapeLayer_blue = CAShapeLayer()
        shapeLayer_blue.lineWidth = 2
        shapeLayer_blue.strokeColor = UIColor.systemBlue.cgColor
        let path_blue = UIBezierPath()
        path_blue.move(to: .zero)
        path_blue.addLine(to: CGPoint(x: board.frame.width - bluePoint.x, y: board.frame.width - (bluePoint.y - boardHeightGap)))
        shapeLayer_blue.path = path_blue.cgPath
        lineBlue.layer.addSublayer(shapeLayer_blue)
        
        let shapeLayer_cubic = CAShapeLayer()
        shapeLayer_cubic.zPosition = 98
        shapeLayer_cubic.frame = board.frame
        shapeLayer_cubic.fillColor = nil
        shapeLayer_cubic.lineWidth = 8
        shapeLayer_cubic.strokeColor = UIColor.black.cgColor
        let path = UIBezierPath()
        path.move(to: .zero)
        
        path.addCurve(to: CGPoint(x: board.frame.width, y:board.frame.width),
                      controlPoint1: CGPoint(x: pinkPoint.x, y: pinkPoint.y - boardHeightGap),
                      controlPoint2: CGPoint(x: bluePoint.x, y: bluePoint.y - boardHeightGap))
        
        shapeLayer_cubic.path = path.cgPath
        shapeLayer_cubic.position = CGPoint(x: board.frame.width / 2, y: (board.frame.height / 2) + boardHeightGap)
        board.layer.addSublayer(shapeLayer_cubic)
        
        let point1 = String(format: "%.2f", pinkPoint.x / board.frame.width) + " , " +
                     String(format: "%.2f", (pinkPoint.y - boardHeightGap) / board.frame.width)
        let point2 = String(format: "%.2f", bluePoint.x / board.frame.width) + " , " +
                     String(format: "%.2f", (bluePoint.y - boardHeightGap) / board.frame.width)
        attributedString(text: "Cubic-Bezier\nPoint1: \(point1)\nPoint2: \(point2)", string1: "\(point1)", string2: "\(point2)")
    }
    
    func attributedString(text:String,string1:String,string2:String)  {
        let t = text as NSString
        let message = NSMutableAttributedString(string: text, attributes: [
                                                    NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
        let sr1 = t.range(of: string1)
        message.addAttributes([
            .foregroundColor: UIColor.red,
        ], range: sr1)
        let sr2 = t.range(of: string2)
        message.addAttributes([
            .foregroundColor: UIColor.systemBlue,
        ], range: sr2)
        bezierLabel.attributedText = message
    }
    
}

