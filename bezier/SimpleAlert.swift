//
//  SimpleAlert.swift
//  ViewPropertyAnimator
//
//  Created by Matt on 2020/9/7.
//  Copyright © 2020 Matt. All rights reserved.
//

import UIKit

class SimpleAlert: UIViewController,CAAnimationDelegate {
    
    var isTouchBackgroundDismissed = false
    var isProgress = false
    var duration = 5.0
    var endAnimatedCallBack : (() -> Void)? = nil
    var squareLayout : NSLayoutConstraint?
    
    
    func isTouchBackgroundDismissed(_ Bool:Bool = false) -> SimpleAlert {
        isTouchBackgroundDismissed = Bool
        return self
    }
    
    let backgroundView : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let progressView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var mainStackView : UIStackView = {
       let view = UIStackView(arrangedSubviews: [titleSubText,progressView,Buttons])
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleSubText : UIStackView = {
       let view = UIStackView()
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
       view.axis = .vertical
        view.spacing = 5
        view.alignment = .center
       return view
    }()
    
    lazy var Buttons : UIStackView = {
       let view = UIStackView()
        view.isLayoutMarginsRelativeArrangement = true
       view.axis = .vertical
        view.distribution = .fillEqually
       return view
    }()
    
    func close () {
        dismiss(animated: true, completion: nil)
//        let ani = UIViewPropertyAnimator(duration: 0.4, controlPoint1: CGPoint(x: 0.1, y: 0.57), controlPoint2: CGPoint(x: 0.13, y: 0.98)) {
//            self.squareLayout?.isActive = false
//            self.squareLayout = self.backgroundView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
//            self.squareLayout?.isActive = true
//            self.view.layoutIfNeeded()
//            }
//        ani.addCompletion { (_) in
//            self.dismiss(animated: true) {
//                self.squareLayout?.isActive = false
//                self.squareLayout = self.backgroundView.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
//                self.squareLayout?.isActive = true
//            }
//        }
//        ani.startAnimation()
    }
    
    func show(duration: TimeInterval, controlPoint1:CGPoint, controlPoint2:CGPoint){
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: {
            UIViewPropertyAnimator(duration: duration, controlPoint1:controlPoint1, controlPoint2:controlPoint2) {
                self.squareLayout?.isActive = false
                self.squareLayout = self.backgroundView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
                self.squareLayout?.isActive = true
                self.view.layoutIfNeeded()
            }.startAnimation()
        })
    }
    
    @discardableResult
    func addButton(_ title:String, _ color:UIColor? = nil, userAction:(() -> Void)? = nil) -> SimpleAlert {
        let button : MyButton = {
            let but = MyButton(type: .system)
            but.setTitle(title, for: .normal)
            but.setTitleColor(color ?? .systemBlue, for: .normal)
            but.contentEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
            but.addBorder(.top, color: .lightGray, thickness: 0.5)
            but.whenButtonIsClicked {
                userAction?()
                self.close()
            }
            return but
        }()
        Buttons.addArrangedSubview(button)
        return self
    }
    
    @discardableResult
    func cancelButton(_ title:String? = nil, _ color:UIColor? = nil) -> SimpleAlert {
        let button : UIButton = {
            let but = UIButton(type: .system)
            but.setTitle(title ?? "Cancel", for: .normal)
            but.setTitleColor(color ?? .red, for: .normal)
            but.contentEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
            but.addBorder(.top, color: .lightGray, thickness: 0.5)
            but.addTarget(self, action: #selector(CancelAction), for: .touchUpInside)
            return but
        }()
        Buttons.addArrangedSubview(button)
        return self
    }
    
    @objc func CancelAction() {
        close()
    }
    
    func cleanAllButton() -> SimpleAlert{
        Buttons.removeFromSuperview()
        return self
    }
    
    @discardableResult
    func addTitle(_ text:String, _ font:UIFont? = nil) -> SimpleAlert {
        let titleText : UILabel = {
           let label = UILabel()
            label.text = text
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = font ?? .boldSystemFont(ofSize: 18)
            return label
        }()
        titleSubText.addArrangedSubview(titleText)
        return self
    }
    
    @discardableResult
    func addMessage(_ text:String, _ font:UIFont? = nil) -> SimpleAlert {
        let messageText : UILabel = {
           let label = UILabel()
            label.text = text
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.font = font ?? .systemFont(ofSize: 14)
            return label
        }()
        titleSubText.addArrangedSubview(messageText)
        return self
    }
    
    @discardableResult
    func setProgressBar(_ duration:CFTimeInterval? = nil) -> SimpleAlert {
        self.isProgress = true
        self.duration = duration ?? 5.0
        return self
    }
    
    @discardableResult
    func removeProgressBar() -> SimpleAlert {
        self.isProgress = false
        return self
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.addSubview(backgroundView)
        backgroundView.addSubview(mainStackView)
        squareLayout = backgroundView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        squareLayout?.isActive = true
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            backgroundView.widthAnchor.constraint(equalToConstant: 250),
            mainStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0),
            mainStackView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 0),
            mainStackView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: 0),
            mainStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 0),
            progressView.heightAnchor.constraint(equalToConstant: 3),
            progressView.leftAnchor.constraint(equalTo: titleSubText.leftAnchor, constant: 0),
            progressView.rightAnchor.constraint(equalTo: titleSubText.rightAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard isProgress else {return}
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: backgroundView.frame.width, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: 0.0))
        let checkmarkLayer = CAShapeLayer()
        checkmarkLayer.path = path.cgPath
        checkmarkLayer.lineWidth = 4
        checkmarkLayer.strokeColor = UIColor.red.cgColor
        checkmarkLayer.fillColor = nil
        
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = self.duration
        animation.delegate = self
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        checkmarkLayer.add(animation, forKey: nil)

        progressView.layer.addSublayer(checkmarkLayer)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag { endAnimatedCallBack?() }
        close()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.view == view && isTouchBackgroundDismissed{
                close()
            }
        }
    }
}

extension UIView {
    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let subview = UIView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = color
        self.addSubview(subview)
        switch edge {
        case .top, .bottom:
            subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            subview.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .top {
                subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            } else {
                subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            }
        case .left, .right:
            subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .left {
                subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            } else {
                subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            }
        default:
            break
        }
    }
}

class MyButton: UIButton {
    var action: (() -> Void)?

    func whenButtonIsClicked(action: @escaping () -> Void) {
        self.action = action
        self.addTarget(self, action: #selector(MyButton.clicked), for: .touchUpInside)
    }
    
    @objc func clicked() {
        action?()
    }
}
