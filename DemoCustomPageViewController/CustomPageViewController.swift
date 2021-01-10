//
//  CustomPageViewController.swift
//  DemoCustomPageViewController
//
//  Created by Bùi Xuân Huy on 07/01/2021.
//

import UIKit
import SnapKit

private struct Constant {
    static let numberItemsOnARow: CGFloat = 4
    static let spacing: CGFloat = 15
    static let bottomPaddingCell: CGFloat = 20
}

class ColorViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let randomColors: [UIColor] = [.red, .yellow, .blue, .orange, .purple, .systemPink, .brown]
    
    override func viewDidLoad() {
        configView()
    }
    
    private func configView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
}

extension ColorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = randomColors.randomElement()
        cell.contentView.cornerRadius = 13
        return cell
    }
}



protocol CustomPageViewControllerDelegate: AnyObject {
    func pageViewController(pageViewController: CustomPageViewController, didUpdatePageIndex index: Int)
}

class CustomPageViewController: UIPageViewController {
    weak var customDelegate: CustomPageViewControllerDelegate?
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let initialViewController = controllers.first {
            scrollToViewController(viewController: initialViewController)
        }
    }
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
           let currentIndex = controllers.firstIndex(of: firstViewController) {
            let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = controllers[newIndex]
            scrollToViewController(viewController: nextViewController, direction: direction)
        }
    }
    
    
    private func notifyTutorialDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
           let index = controllers.firstIndex(of: firstViewController) {
            customDelegate?.pageViewController(pageViewController: self, didUpdatePageIndex: index)
        }
    }
    
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewController.NavigationDirection = .forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { _ in
                            self.notifyTutorialDelegateOfNewIndex()
                           })
    }
}

extension CustomPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let controllerIndex = controllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = controllerIndex - 1
        if previousIndex >= 0 {
            return controllers[previousIndex]
        }
        return nil
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controllerIndex = controllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = controllerIndex + 1
        if nextIndex < controllers.count {
            return controllers[nextIndex]
        }
        return nil
    }
}

extension CustomPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_: UIPageViewController,
                            didFinishAnimating _: Bool,
                            previousViewControllers _: [UIViewController],
                            transitionCompleted _: Bool) {
        notifyTutorialDelegateOfNewIndex()
    }
}
