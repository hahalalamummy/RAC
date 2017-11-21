//
//  CircleViewModel.swift
//  RAC
//
//  Created by admin on 11/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import ChameleonFramework
import RxSwift
import RxCocoa

class CircleViewModel {
    var centerVariable = Variable<CGPoint?>(.zero) // biến lưu center của hình tròn
    var backgroundColorObservable: Observable<UIColor>!
    
    init() {
        //mỗi khi centerVariable thay đổi, backgroundColorObservable bắn thông báo
        backgroundColorObservable = centerVariable.asObservable() // Observable phát ra thông báo thay đổi màu nền quả bóng
            .map { center in
                
                let red: CGFloat = ((center!.x + center!.y).truncatingRemainder(dividingBy: 255.0)) / 255.0
                let green: CGFloat = 0.0
                let blue: CGFloat = 0.0
                print("2")
                return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
        }
    }
}
