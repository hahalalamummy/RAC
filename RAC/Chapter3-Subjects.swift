//
//  Chapter3-Subjects.swift
//  RAC
//
//  Created by admin on 11/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class Chapter3_Subjects: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    public func example(of description: String, action: () -> Void) {
        print("\n\n--- Example of:", description, "---")
        action()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //PublishSubjectTest()
        //BehaviorSubjectTest()
        VariableTest()
    }
    
    func PublishSubjectTest() {
        // PublishSubject only emits to current subscribers. So if you weren’t subscribed when something was added to it previously, you don’t get it when you do subscribe
        example(of: "PublishSubject") {
            let subject = PublishSubject<String>()
            subject.onNext("Is anyone listening?") // NOT listening
            
            let subscriptionOne = subject
                .subscribe(onNext: { string in
                    print(string)
                })
            subject.on(.next("1"))
            subject.onNext("2")
            
            
            let subscriptionTwo = subject
                .subscribe { event in
                    print("subscriptionTwo: ", event.element ?? event)
            }
            subject.onNext("3")
            subject.onNext("4")
            
            subscriptionOne.dispose()
            subject.onNext("5")
            
            subject.onCompleted()
            subject.onNext("6")
            
            subscriptionTwo.dispose()
            
            subject
                .subscribe {
                    print("last: ", $0.element ?? $0) // ko nhận sự kiện onNext("?")
                }
                .addDisposableTo(disposeBag)
            
            // Every subject type, once terminated, will re-emit its stop event to future subscribers
            subject.onNext("?")
        }
    }
    
    func BehaviorSubjectTest() {
        enum MyError: Error {
            case anError
        }
        
        func printCustom<T: CustomStringConvertible>(label: String, event: Event<T>) {
            print(label, event.element ?? event.error ?? event)
        }
        
        example(of: "BehaviorSubject") {
            
            let subject = BehaviorSubject(value: "Initial value")
            subject.onNext("2")
            subject
                .subscribe {
                    printCustom(label: "1: ", event: $0)
                }
                .addDisposableTo(disposeBag)
            
            subject.onNext("3")
            
            subject.onError(MyError.anError)
            subject
                .subscribe {
                    printCustom(label: "2: ", event: $0)
                }
                .addDisposableTo(disposeBag)
        }
    }
    
    func VariableTest() {
        func printCustom<T: CustomStringConvertible>(label: String, event: Event<T>) {
            print(label, event.element ?? event.error ?? event)
        }
        
        // Variable does not have .onError() or .onCompleted()
        example(of: "Variable") {
            
            let variable = Variable("Initial value")
            variable.value = "New initial value"
            
            variable.asObservable()
                .subscribe {
                    printCustom(label: "1: ", event: $0)
                }
                .addDisposableTo(disposeBag)
            
            variable.value = "1"
            variable.asObservable()
                .subscribe {
                    printCustom(label: "2: ", event: $0)
                }
                .addDisposableTo(disposeBag)
            
            variable.value = "2"
        }
    }
}
