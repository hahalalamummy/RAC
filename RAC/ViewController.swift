//
//  ViewController.swift
//  RAC
//
//  Created by admin on 11/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    var circleView:UIView!
    var circleViewModel = CircleViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100, height: 100)))
        circleView.center = view.center
        circleView.backgroundColor = .red
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        view.addSubview(circleView)
        
        
        // circleViewModel.centerVariable = circleView.center mỗi khi circleView.center thay đổi giá trị
        circleView
            .rx.observe(CGPoint.self ,"center")
            .bind(to: circleViewModel.centerVariable)
            .addDisposableTo(disposeBag)
        
        
        // Subscribe to backgroundObservable to get new colors from the ViewModel.
        circleViewModel.backgroundColorObservable
            .subscribe(onNext: { [weak self] backgroundColor in
                print(3)
                UIView.animate(withDuration: 0.1) {
                    print(4)
                    
                    // thay đổi màu
                    self?.circleView.backgroundColor = backgroundColor
                    let viewBackgroundColor = UIColor(complementaryFlatColorOf: backgroundColor)
                    if viewBackgroundColor != backgroundColor {
                        self?.view.backgroundColor = viewBackgroundColor
                    }
                }
            })
            .addDisposableTo(disposeBag)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)
    }
    
    func circleMoved(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: view)
        UIView.animate(withDuration: 0.1) {
            print("1")
            self.circleView.center = location
            print("5\n")
        }
    }
}

