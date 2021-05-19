//
//  MyPageViewController.swift
//  DynamicPageViewController
//
//  Created by William.Weng on 2021/5/19.
//

import UIKit

// MARK: - UIPageViewController
final class MyPageViewController: UIPageViewController {

    weak var myDelegate: MyPageViewDelegate?
    
    private var myPageViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension MyPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return pageViewController._nextPage(viewControllers: myPageViewControllers, next: viewController, addIndex: 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return pageViewController._nextPage(viewControllers: myPageViewControllers, next: viewController, addIndex: -1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentPage = pageViewController._currentPage(with: myPageViewControllers) else { return }
        self.myDelegate?.currentPage(currentPage)
    }
}

// MARK: - 小工具 (class function)
extension MyPageViewController {
    
    /// 添加測試用ViewController
    /// - Parameters:
    ///   - backgroundColor: 背景色
    ///   - text: 文字
    func appendPageViewController(backgroundColor: UIColor) {
        
        let text = "第\(myPageViewControllers.count + 1)頁"
        
        self.myPageViewControllers.append(demoViewControllerMaker(backgroundColor: backgroundColor, text: text))
        self.myDelegate?.numberOfPages(myPageViewControllers.count)
        self._reloadData(dataSource: self)
    }
    
    /// 切換頁面
    /// - Parameters:
    ///   - page: 第幾頁
    ///   - direction: 切換頁目的方向
    ///   - animated: 動畫顯示
    ///   - completion: 是否完成
    func changePage(index: Int, direction: UIPageViewController.NavigationDirection = .forward, animated: Bool = false, completion: @escaping (Bool) -> Void) {
        
        self._changePage(viewControllers: myPageViewControllers, index: index) { isCompletion in
            completion(isCompletion)
        }
    }
}

// MARK: - 小工具 (private class function)
extension MyPageViewController {
    
    /// 初始化設定
    private func initSetting() {
        
        self._delegateAndDataSource(with: self)
        
        self.appendPageViewController(backgroundColor: .green)
        self.myDelegate?.numberOfPages(myPageViewControllers.count)
        
        self.changePage(index: 0) { isCompletion in
            wwPrint(isCompletion)
        }
    }
    
    /// 產生測試頁
    /// - Parameters:
    ///   - backgroundColor: 背景色
    ///   - text: 文字
    /// - Returns: DemoViewController
    private func demoViewControllerMaker(backgroundColor: UIColor, text: String) -> DemoViewController {
        
        let viewController = UIStoryboard._instantiateViewController() as DemoViewController

        viewController.view.backgroundColor = backgroundColor
        viewController.myLabel.text = text
        
        return viewController
    }
}
