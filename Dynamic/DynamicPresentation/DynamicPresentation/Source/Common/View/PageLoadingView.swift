//
//  PageLoadingView.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/27.
//

import UIKit

class PageLoadingView: UIView {
    private var square1 = UIView()
    private var square2 = UIView()
    private var square3 = UIView()
    private var square4 = UIView()
    private var square5 = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupSquare3()
        setupSquare2()
        setupSquare1()
        setupSquare4()
        setupSquare5()
    }
    
    private func setupSquare1() {
        square1.backgroundColor = .systemGreen
        self.addSubview(square1)
        square1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            square1.widthAnchor.constraint(equalToConstant: self.xValueRatio(10)),
            square1.heightAnchor.constraint(equalToConstant: self.yValueRatio(10)),
            square1.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -self.yValueRatio(40)),
            square1.trailingAnchor.constraint(equalTo: square2.leadingAnchor, constant: -self.xValueRatio(10))
        ])
    }
    
    private func setupSquare2() {
        square2.backgroundColor = .systemTeal
        self.addSubview(square2)
        square2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            square2.widthAnchor.constraint(equalToConstant: self.xValueRatio(10)),
            square2.heightAnchor.constraint(equalToConstant: self.yValueRatio(10)),
            square2.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -self.yValueRatio(40)),
            square2.trailingAnchor.constraint(equalTo: square3.leadingAnchor, constant: -self.xValueRatio(10))
        ])
    }
    
    private func setupSquare3() {
        square3.backgroundColor = .systemPurple
        self.addSubview(square3)
        square3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            square3.widthAnchor.constraint(equalToConstant: self.xValueRatio(10)),
            square3.heightAnchor.constraint(equalToConstant: self.yValueRatio(10)),
            square3.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -self.yValueRatio(40)),
            square3.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func setupSquare4() {
        square4.backgroundColor = .systemRed
        self.addSubview(square4)
        square4.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            square4.widthAnchor.constraint(equalToConstant: self.xValueRatio(10)),
            square4.heightAnchor.constraint(equalToConstant: self.yValueRatio(10)),
            square4.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -self.yValueRatio(40)),
            square4.leadingAnchor.constraint(equalTo: square3.trailingAnchor, constant: self.xValueRatio(10))
        ])
    }
    
    private func setupSquare5() {
        square5.backgroundColor = .systemYellow
        self.addSubview(square5)
        square5.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            square5.widthAnchor.constraint(equalToConstant: self.xValueRatio(10)),
            square5.heightAnchor.constraint(equalToConstant: self.yValueRatio(10)),
            square5.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -self.yValueRatio(40)),
            square5.leadingAnchor.constraint(equalTo: square4.trailingAnchor, constant: self.xValueRatio(10))
        ])
    }
}

extension PageLoadingView {
    internal func bounceAnimation() {
        UIView.animateKeyframes(withDuration: 1,
                                delay: 0,
                                options: .repeat,
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 0.2,
                               animations: {
                self.square1.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            })
            UIView.addKeyframe(withRelativeStartTime: 1/6,
                               relativeDuration: 0.2,
                               animations: {
                self.square1.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
            UIView.addKeyframe(withRelativeStartTime: 1/6,
                               relativeDuration: 0.2,
                               animations: {
                self.square2.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            })
            UIView.addKeyframe(withRelativeStartTime: 2/6,
                               relativeDuration: 0.2,
                               animations: {
                self.square2.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
            UIView.addKeyframe(withRelativeStartTime: 2/6,
                               relativeDuration: 0.2,
                               animations: {
                self.square3.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            })
            UIView.addKeyframe(withRelativeStartTime: 3/6,
                               relativeDuration: 0.2,
                               animations: {
                self.square3.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
            UIView.addKeyframe(withRelativeStartTime: 3/6,
                               relativeDuration: 0.2,
                               animations: {
                self.square4.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            })
            UIView.addKeyframe(withRelativeStartTime: 4/6,
                               relativeDuration: 0.2,
                               animations: {
                self.square4.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
            UIView.addKeyframe(withRelativeStartTime: 4/6,
                               relativeDuration: 0.2,
                               animations: {
                self.square5.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            })
            UIView.addKeyframe(withRelativeStartTime: 5/6,
                               relativeDuration: 0.2,
                               animations: {
                self.square5.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
    }
}
