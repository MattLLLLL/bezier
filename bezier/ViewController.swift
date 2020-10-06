//
//  ViewController.swift
//  bezier
//
//  Created by Matt on 2020/10/5.
//

import UIKit

class ViewController: UIViewController {
    
    let bezierTitle : UILabel = {
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
    
    let lineViewPink : UIView = {
       let v = UIView()
        return v
    }()
    
    lazy var cubicPink : UIButton = {
        let but = UIButton(type: .system)
        but.backgroundColor = .systemPink
        but.layer.cornerRadius = 30 / 2
        let touch = UIPanGestureRecognizer(target: self, action: #selector(touchCubic))
        touch.maximumNumberOfTouches = 1
        touch.minimumNumberOfTouches = 1
        but.addGestureRecognizer(touch)
        but.layer.zPosition = 99
        return but
    }()
    
    let lineViewBlue : UIView = {
       let v = UIView()
        v.transform = CGAffineTransform(scaleX: -1, y: -1)
        return v
    }()
    
    lazy var cubicBlue : UIButton = {
        let but = UIButton(type: .system)
        but.backgroundColor = .systemBlue
        but.layer.cornerRadius = 30 / 2
        let touch = UIPanGestureRecognizer(target: self, action: #selector(touchCubic2))
        touch.maximumNumberOfTouches = 1
        touch.minimumNumberOfTouches = 1
        but.addGestureRecognizer(touch)
        but.layer.zPosition = 99
        return but
    }()
    
    @objc func touchCubic(sender:UIPanGestureRecognizer) {
        let point = sender.location(in: view)
        var changePoint = CGPoint()
        if point.x >= (board.frame.width) + ((view.frame.width - board.frame.width)/2) {
            cubicPink.center = CGPoint(x: (board.frame.width) + ((view.frame.width - board.frame.width)/2), y: point.y)
            changePoint = view.convert(CGPoint(x: (board.frame.width) + ((view.frame.width - board.frame.width)/2), y: point.y), to: board)
        }else if point.x <= ((view.frame.width - board.frame.width)/2){
            cubicPink.center = CGPoint(x: ((view.frame.width - board.frame.width)/2), y: point.y)
            changePoint = view.convert(CGPoint(x: ((view.frame.width - board.frame.width)/2), y: point.y), to: board)
        }else{
            cubicPink.center = point
            changePoint = view.convert(point, to: board)
        }
        
        let viewY = (board.frame.height - board.frame.height / 1.5) / 2

        if (changePoint.y - viewY) >= 0 {
            lineViewPink.frame = CGRect(x: 0, y: viewY, width: changePoint.x, height: changePoint.y - viewY)
        }
        
        if let l = lineViewPink.layer.sublayers {
            for layers in l {
                if let layer = layers as? CAShapeLayer{
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: changePoint.x, y: changePoint.y - viewY))
                    layer.path = path.cgPath
                }
            }
        }
        
        if let b = board.layer.sublayers {
            for layers in b {
                if let layer = layers as? CAShapeLayer{
                    let path = UIBezierPath()
                    let boardWidth = board.frame.width
                    let bluePoint = view.convert(cubicBlue.center, to: board)
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addCurve(to: CGPoint(x: boardWidth, y:boardWidth), controlPoint1: CGPoint(x: (changePoint.x / boardWidth) * boardWidth, y: ((changePoint.y - viewY) / boardWidth) * boardWidth), controlPoint2: CGPoint(x: (bluePoint.x / boardWidth) * boardWidth, y: ((bluePoint.y - viewY) / boardWidth) * boardWidth))
                    layer.path = path.cgPath
                }
            }
        }
        cubicBlue.layer.zPosition = 99
        cubicPink.layer.zPosition = 100
    }
    
    @objc func touchCubic2(sender:UIPanGestureRecognizer) {
        let point = sender.location(in: view)
        var changePoint = CGPoint()
        if point.x >= (board.frame.width) + ((view.frame.width - board.frame.width)/2) {
            cubicBlue.center = CGPoint(x: (board.frame.width) + ((view.frame.width - board.frame.width)/2), y: point.y)
            changePoint = view.convert(CGPoint(x: (board.frame.width) + ((view.frame.width - board.frame.width)/2), y: point.y), to: board)
        }else if point.x <= ((view.frame.width - board.frame.width)/2){
            cubicBlue.center = CGPoint(x: ((view.frame.width - board.frame.width)/2), y: point.y)
            changePoint = view.convert(CGPoint(x: ((view.frame.width - board.frame.width)/2), y: point.y), to: board)
        }else{
            cubicBlue.center = point
            changePoint = view.convert(point, to: board)
        }
        
        let viewY = (board.frame.height - board.frame.height / 1.5) / 2

//        if (changePoint.y - viewY) >= 0 {
//            lineViewBlue.frame = CGRect(x: 0, y: viewY, width: changePoint.x, height: changePoint.y - viewY)
//        }
        
        if let l = lineViewBlue.layer.sublayers {
            for layers in l {
                if let layer = layers as? CAShapeLayer{
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: board.frame.width - changePoint.x, y: board.frame.width - (changePoint.y - viewY)))
                    layer.path = path.cgPath
                }
            }
        }
        
        if let b = board.layer.sublayers {
            for layers in b {
                if let layer = layers as? CAShapeLayer{
                    let path = UIBezierPath()
                    let boardWidth = board.frame.width
                    path.move(to: CGPoint(x: 0, y: 0))
                    let pinkPoint = view.convert(cubicPink.center, to: board)
                    path.addCurve(to: CGPoint(x: boardWidth, y:boardWidth), controlPoint1: CGPoint(x: (pinkPoint.x / boardWidth) * boardWidth, y: ((pinkPoint.y - viewY) / boardWidth) * boardWidth), controlPoint2: CGPoint(x: (changePoint.x / boardWidth) * boardWidth, y: ((changePoint.y - viewY) / boardWidth) * boardWidth ))
                    layer.path = path.cgPath
                }
            }
        }
        cubicPink.layer.zPosition = 99
        cubicBlue.layer.zPosition = 100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(board)
        view.addSubview(cubicPink)
        view.addSubview(cubicBlue)
        view.addSubview(bezierTitle)
        NSLayoutConstraint.activate([
            board.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            board.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            board.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            board.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            bezierTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            bezierTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            bezierTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            bezierTitle.bottomAnchor.constraint(equalTo: board.topAnchor, constant: 0)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        //initShapeLayer()
        setUI()
        setLine()
        configBezierLine()
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

    func configBezierLine() {
        let p = view.convert(cubicPink.center, to: board)
        let b = view.convert(cubicBlue.center, to: board)
        let viewY = (board.frame.height - board.frame.height / 1.5) / 2
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = board.frame
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 8
        shapeLayer.strokeColor = UIColor.black.cgColor
        let boardWidth = board.frame.width
        let boardHeight = board.frame.height
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addCurve(to: CGPoint(x: boardWidth, y:boardWidth), controlPoint1:  CGPoint(x: (p.x / boardWidth) * boardWidth, y: ((p.y - viewY) / boardWidth) * boardWidth), controlPoint2: CGPoint(x: (b.y / boardWidth) * boardWidth, y: ((b.x - viewY) / boardWidth) * boardWidth))
        shapeLayer.path = path.cgPath
        shapeLayer.position = CGPoint(x: boardWidth / 2, y: boardHeight / 1.5)
        board.layer.addSublayer(shapeLayer)
    }
    
    func setUI() {
        cubicPink.frame = CGRect(x: 150, y: 300, width: 30, height: 30)
        cubicBlue.frame = CGRect(x: 220, y: 550, width: 30, height: 30)
    }
    
    func setLine() {
        board.addSubview(lineViewPink)
        let viewY = (board.frame.height - board.frame.height / 1.5) / 2
        let p = view.convert(cubicPink.center, to: board)
        lineViewPink.frame = CGRect(x: 0, y: viewY, width: p.x, height:p.y - viewY)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = lineViewPink.frame
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.red.cgColor
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: p.x, y: p.y - viewY))
        shapeLayer.path = path.cgPath
        shapeLayer.position = CGPoint(x: lineViewPink.frame.width / 2, y: lineViewPink.frame.height / 2)
        lineViewPink.layer.addSublayer(shapeLayer)
        
        board.addSubview(lineViewBlue)
        let viewX = board.frame.width - lineViewBlue.frame.width
        let b = view.convert(cubicBlue.center, to: board)
        lineViewBlue.frame = CGRect(x: viewX, y: board.frame.width + viewY, width: board.frame.width - b.x, height: 0)
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.frame = lineViewBlue.frame
        shapeLayer2.fillColor = nil
        shapeLayer2.lineWidth = 2
        shapeLayer2.strokeColor = UIColor.systemBlue.cgColor
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0, y: 0))
        path2.addLine(to: CGPoint(x:lineViewBlue.frame.width, y: board.frame.width - (b.y - viewY)))
        shapeLayer2.path = path2.cgPath
        shapeLayer2.position = CGPoint(x: lineViewBlue.frame.width / 2, y: lineViewBlue.frame.height / 2)
        lineViewBlue.layer.addSublayer(shapeLayer2)
    }
    
}

