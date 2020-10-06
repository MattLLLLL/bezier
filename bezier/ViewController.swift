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
    
    let bezierLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
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
        
        let boardHeightGap = (board.frame.height - board.frame.height / 1.5) / 2
        let boardLocation = view.convert(sender.cubic?.center ?? .zero, to: board)

        if let l = sender.line?.layer.sublayers {
            for layers in l {
                if let layer = layers as? CAShapeLayer{
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: 0, y: 0))
                    
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
                    path.move(to: CGPoint(x: 0, y: 0))
                    
                    if sender.cubic == cubicPink {
                        let bluePoint = view.convert(cubicBlue.center, to: board)
                        path.addCurve(to: CGPoint(x: board.frame.width, y:board.frame.width),
                                      controlPoint1: CGPoint(x: boardLocation.x, y: boardLocation.y - boardHeightGap),
                                      controlPoint2: CGPoint(x: bluePoint.x, y: bluePoint.y - boardHeightGap))
                    }else{
                        let pinkPoint = view.convert(cubicPink.center, to: board)
                        path.addCurve(to: CGPoint(x: board.frame.width, y:board.frame.width),
                                      controlPoint1: CGPoint(x: pinkPoint.x, y: pinkPoint.y - boardHeightGap),
                                      controlPoint2: CGPoint(x: boardLocation.x, y: boardLocation.y - boardHeightGap))
                    }

                    layer.path = path.cgPath
                }
            }
        }
        cubicBlue.layer.zPosition = 0
        cubicPink.layer.zPosition = 0
        sender.cubic?.layer.zPosition = 100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(board)
        view.addSubview(cubicPink)
        view.addSubview(cubicBlue)
        view.addSubview(bezierLabel)
        NSLayoutConstraint.activate([
            board.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            board.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            board.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            board.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            bezierLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            bezierLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            bezierLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            bezierLabel.bottomAnchor.constraint(equalTo: board.topAnchor, constant: 0)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        //initShapeLayer()
        initBezierLine()
    }

    func initShapeLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = board.frame
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 8
        shapeLayer.strokeColor = UIColor.systemGray4.cgColor
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: board.frame.width, y:board.frame.width))
        shapeLayer.path = path.cgPath
        shapeLayer.position = CGPoint(x: board.frame.width / 2, y: board.frame.height / 2)
        board.layer.addSublayer(shapeLayer)
    }
    
    func initBezierLine() {
        board.addSubview(linePink)
        board.addSubview(lineBlue)
        
        let boardHeightGap = (board.frame.height - board.frame.height / 1.5) / 2
        
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
        shapeLayer_cubic.frame = board.frame
        shapeLayer_cubic.fillColor = nil
        shapeLayer_cubic.lineWidth = 8
        shapeLayer_cubic.strokeColor = UIColor.black.cgColor
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        
        path.addCurve(to: CGPoint(x: board.frame.width, y:board.frame.width),
                      controlPoint1: CGPoint(x: pinkPoint.x, y: pinkPoint.y - boardHeightGap),
                      controlPoint2: CGPoint(x: bluePoint.x, y: bluePoint.y - boardHeightGap))
        
        shapeLayer_cubic.path = path.cgPath
        shapeLayer_cubic.position = CGPoint(x: board.frame.width / 2, y: board.frame.height / 1.5)
        board.layer.addSublayer(shapeLayer_cubic)
    }
    
}

