//
//  Chapter2-Observables.swift
//  RAC
//
//  Created by admin on 11/20/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class Chapter2_Observables: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    public func example(of description: String, action: () -> Void) {
        print("\n\n--- Example of:", description, "---")
        action()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Just_Of_From()
        Subscribe()
        Empty()
        Never()
        Range()
        Dispose()
        DisposeBagTest()
        Create()
        Deferred()
    }
    
    func Just_Of_From() {
        example(of: "just, of, from") {
            // 1
            let one = 1
            let two = 2
            let three = 3
            var array1 = [one,two,three]
            let array2 = [three,two,one]
            // 2
            let observable: Observable<Int> = Observable<Int>.just(one)
            var observable2 = Observable.of(one, two, three)
            let observable3 = Observable.of([one, two, three])
            let observable4 = Observable.from(array1)
        }
    }
    
    func Subscribe() {
        example(of: "subscribe") {
            let one = 1
            let two = 2
            let three = 3
            
            let observable = Observable.of(one, two, three)
            
            //    observable.subscribe { event in
            //        print(event)
            //        if let element = event.element {
            //            print(element)
            //        }
            //    }
            
            observable.subscribe(
                onNext: { element in
                    print(element)
            },
                onError: { error in
                    print(error)
            },
                onCompleted: {
                    print("Completed")
            })
        }
    }
    
    func Empty() {
        example(of: "empty") {
            let observableEmpty = Observable<Void>.empty()
            observableEmpty
                .subscribe(
                    onNext: { element in
                        print(element)
                },
                    onCompleted: {
                        print("Completed")
                } )
        }
    }
    
    func Never() {
        example(of: "never") {
            let observable = Observable<Any>.never()
            let str: String = "aaa"
            let bool: Bool = false
            observable
                .debug(str, trimOutput: bool)
                .subscribe(
                    onNext: { element in
                        print(element)
                },
                    onCompleted: {
                        print("Completed")
                },
                    onDisposed: {
                        print("Disposed")
                }
            )
                .disposed(by: disposeBag)
        }
    }
    
    func Range() {
        example(of: "range") {
            // 1
            let observable = Observable<Int>.range(start: 1, count: 10)
            observable
                .subscribe(onNext: { i in
                    // 2
                    print(i)
                    let n = Double(i)
                    let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
                    //print(fibonacci)
                })
        }
    }
    
    func Dispose() {
        // To explicitly cancel a subscription, call dispose() on it. After you cancel the subscription, or dispose of it, the observable in the current example will stop emitting events
        example(of: "dispose") {
            // 1
            let observable = Observable.of("A", "B", "C")
            // 2
            let subscription = observable.subscribe { event in
                // 3
                print(event)
            }
            subscription.dispose()
        }
    }
    
    func DisposeBagTest() {
        // Managing each subscription individually would be tedious, so RxSwift includes a DisposeBag type. A dispose bag holds disposables — typically added using the .addDisposableTo() method — and will call dispose() on each one when the dispose bag is about to be deallocated
        example(of: "DisposeBag") {
            // 1
            
            // 2
            Observable.of("A", "B", "C")
                .subscribe { // 3
                    print($0) }
                .addDisposableTo(disposeBag)
        }
    }
    
    func Create() {
        example(of: "create") {
            enum MyError: Error {
                case anError
            }
            //let disposeBag = DisposeBag()
            Observable<String>.create { observer in
                
                observer.onNext("1")
                observer.onNext("2")
                
                observer.onError(MyError.anError) // chưa hiểu
                observer.onCompleted() // bỏ đi thì bị leak memory
                
                observer.onNext("?") // NOT ADDED
                
                return Disposables.create()
            }
                .subscribe(
                    onNext: { print($0) },
                    onError: {error in
                        print("123")
                        print(error)
                },
                    onCompleted: { print("Completed") },
                    onDisposed: { print("Disposed") }
                )
                .addDisposableTo(disposeBag)
        }
    }
    
    func Deferred() {
        // Create observable factories that vend a new observable to each subscriber
        example(of: "deferred") {
            //let disposeBag = DisposeBag()
            // 1
            var flip = false
            // 2
            let factory: Observable<Int> = Observable.deferred {
                // 3
                flip = !flip
                // 4
                if flip {
                    return Observable.of(1, 2, 3)
                } else {
                    return Observable.of(4, 5, 6)
                }
            }
            
            // 1
            factory.subscribe(onNext: {
                print($0, terminator: "") // print trên 1 dòng, ko xuống dòng
            })
                .addDisposableTo(disposeBag)
            print() // \n
            
            
            // 2
            factory.subscribe(onNext: {
                print($0, terminator: "")
            })
                .addDisposableTo(disposeBag)
            print()
            
            
            // 3
            factory.subscribe(onNext: {
                print($0, terminator: "")
            })
                .addDisposableTo(disposeBag)
            print()
            
            
            // 4
            factory.subscribe(onNext: {
                print($0, terminator: "")
            })
                .addDisposableTo(disposeBag)
            print()
        }
    }
}

