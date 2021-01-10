//
//  ViewController.swift
//  DemoCustomPageViewController
//
//  Created by Bùi Xuân Huy on 07/01/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    private var pageViewController: CustomPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    private func configView() {
        contentView.applyShadow()
        pageViewController = CustomPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.customDelegate = self
        pageViewController.controllers = [ColorViewController(), ColorViewController(), ColorViewController()]
        addChild(pageViewController)
        contentView.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(15)
            $0.trailing.bottom.equalToSuperview().inset(15)
        }
    }
}

extension ViewController: CustomPageViewControllerDelegate {
    func pageViewController(pageViewController: CustomPageViewController, didUpdatePageIndex index: Int) {
        pageLabel.text = "Trang \(index + 1)"
    }
}
