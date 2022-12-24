//
//  CategoryView.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/23.
//

import UIKit

class CategoryView: UIView {
    private var scrollView = UIScrollView()
    private var stackView = UIStackView()
    private var selectedView = UIView()
    private var selectedViewLeadingConstraint: NSLayoutConstraint?
    private var selectedViewWidthConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .cyan
        setupScrollView()
        setupSelectedView()
        setupStackView()
    }
    
    private func setupStackView() {
        for i in createCategoryItems() {
            stackView.addArrangedSubview(i)
        }
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = xValueRatio(20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: .zero, left: xValueRatio(20), bottom: .zero, right: .zero)
        scrollView.addSubview(stackView)
        scrollView.contentSize = CGSize(width: xValueRatio(673), height: yValueRatio(60))
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupScrollView() {
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupSelectedView() {
        selectedView.backgroundColor = .black
        selectedView.viewRadius(cornerRadius: xValueRatio(22.5))
        scrollView.addSubview(selectedView)
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        selectedViewLeadingConstraint = selectedView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: xValueRatio(5))
        selectedViewWidthConstraint = selectedView.widthAnchor.constraint(equalToConstant: xValueRatio(92))
        NSLayoutConstraint.activate([
            selectedView.topAnchor.constraint(equalTo: self.topAnchor),
            selectedView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        selectedViewLeadingConstraint?.isActive = true
        selectedViewWidthConstraint?.isActive = true
    }
    
    private func createCategoryItems() -> [UIButton] {
        var buttons: [UIButton] = []
        let categorys: [String] = ["Coding", "Memes", "Cats" , "Dogs", "Christmas", "Oops", "Reactions", "Emoji"]
        var count = 0
        for category in categorys {
            buttons.append(createCategoryItem(category, count))
            count += 1
        }
        return buttons
    }
    
    private func createCategoryItem(_ title: String,
                                    _ count: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: xValueRatio(18), weight: .heavy)
        button.tintColor = .clear
        button.tag = count
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        self.branchButtonTag(sender.tag)
    }
    
    private func branchButtonTag(_ tag: Int) {
        switch tag {
        case 0:
            self.animateButton(xValueRatio(6), xValueRatio(90))
        case 1:
            self.animateButton(xValueRatio(89), xValueRatio(90))
        case 2:
            self.animateButton(xValueRatio(175.5), xValueRatio(65))
        case 3:
            self.animateButton(xValueRatio(237), xValueRatio(70))
        case 4:
            self.animateButton(xValueRatio(302), xValueRatio(120))
        case 5:
            self.animateButton(xValueRatio(416), xValueRatio(72))
        case 6:
            self.animateButton(xValueRatio(482.5), xValueRatio(112.5))
        case 7:
            self.animateButton(xValueRatio(591), xValueRatio(77.5))
        default: break
        }
    }
    
    private func animateButton(_ leading: CGFloat, _ width: CGFloat) {
        selectedViewLeadingConstraint?.constant = leading
        selectedViewWidthConstraint?.constant = width
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5) {
            self.layoutIfNeeded()
        }
    }
}
