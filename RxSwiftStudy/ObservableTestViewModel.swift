//
//  ObservableTestViewModel.swift
//  RxSwiftStudy
//
//  Created by cjyang on 2019/11/14.
//  Copyright © 2019 cjyang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ObservableTestViewModel {
    var disposeBag = DisposeBag()
    
    //MARK: - Creating Observables
    
    func createTest() {
        let createObservable = Observable<Int>.create({ event in
            event.on(.next(1))
            event.on(.next(2))
            event.on(.next(3))
            event.on(.completed)
            
            return Disposables.create {
                print("disposed")
            }
        })
        
        createObservable.subscribe { (event) in
            print(event)
            }.disposed(by: disposeBag)
        
        /*
         next(1)
         next(2)
         next(3)
         completed
         disposed
         */
    }
    
    func ofTest() {
        let ofObservable = Observable<Int>.of(1,2,3)
        
        ofObservable.subscribe { (event) in
            print(event)
            }.disposed(by: disposeBag)
        
        /*
         next(1)
         next(2)
         next(3)
         completed
         */
    }
    
    func fromTest() {
        let fromObservable = Observable<Int>.from([1,2,3,])
        
        fromObservable.subscribe { (event) in
            print(event)
            }.disposed(by: disposeBag)
        
        /*
         next(1)
         next(2)
         next(3)
         completed
         */
    }
    
    func deferTest() {
        //subscribe까지 기다렸다가 수행
        
        let deferObservable = Observable<Int>.deferred { () -> Observable<Int> in
            return Observable<Int>.just(1)
        }
        
        deferObservable.subscribe({ event in
            print(event)
        }).disposed(by: disposeBag)
        
        /*
         next(1)
         completed
         */
    }
    
    
    func emptyTest() {
        let emptyObservable = Observable<Int>.empty() //subscribe하면 .completed만 방출
        
        emptyObservable.subscribe { (event) in
            print(event)
            }.disposed(by: disposeBag)
        
        /*
         completed
         */
    }
    
    func repeatTest() {
        let repeatObservable = Observable<String>.repeatElement("a")
        
        repeatObservable.subscribe({ print($0) }).disposed(by: disposeBag)
        
        /*
         a
         a
         ...
         */
    }
    
    func intervalTest() {
        let intervalObservable = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: ConcurrentMainScheduler.instance)
        
        intervalObservable.subscribe { (event) in
            print(event)
            }.disposed(by: disposeBag)
        
        /*
         0부터 시작해서 interval 간격으로 1씩 증가해서 값을 보내줌
         next(0)
         next(1)
         ...
         */
    }
    
    func rageTest() {
        let rangeObservable = Observable<Int>.range(start: 0, count: 3)
        
        rangeObservable.subscribe { (event) in
            print(event)
            }.disposed(by: disposeBag)
        
        /*
         next(0)
         next(1)
         next(2)
         completed
         */
    }
    
    
    func startWithTest() {
        let startWithObservable = Observable<Int>.of(1,2,3).startWith(0)
        
        startWithObservable.subscribe({print($0)}).disposed(by: disposeBag)
        
        /*
         next(0)
         next(1)
         next(2)
         next(3)
         completed
         */
    }
    
    func timeTest() {
        let timerObservable = Observable<Int>.timer(RxTimeInterval.seconds(3), scheduler: ConcurrentMainScheduler.instance)
        
        timerObservable.subscribe({event in print(event)}).disposed(by: disposeBag)
        
        /*
         Int만가능. 특정시간후에 1번만 onNext 후 completed
         
         next(0)
         completed
         */
    }
    
    //MARK: - Transforming Observables
    
    func bufferTest() {
        let bufferObservable = Observable<String>.of("1","1","2")
            .buffer(timeSpan: RxTimeInterval.seconds(1), count: 2, scheduler: ConcurrentMainScheduler.instance)
        
        bufferObservable.subscribe{print($0)}.disposed(by: disposeBag)
        
        /*
         next(["1", "1"])
         next(["2"])
         completed
         
         */
    }
    
    func windowTest() {
        let windowObservable = Observable<String>.of("1","1","2")
            .window(timeSpan: RxTimeInterval.seconds(1), count: 2, scheduler: ConcurrentMainScheduler.instance)
        
        windowObservable.subscribe(onNext: { observable in
            observable.subscribe({ (event) in
                print(event)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        /*
         next(1)
         next(1)
         completed
         next(2)
         completed
         */
    }
    
    func mapTest() {
        let mapObservable = Observable<Int>.of(1,2,3).map { "\($0)"}
        
        mapObservable.subscribe({print($0)}).disposed(by: disposeBag)
        
        /*
         //타입을 바꾸거나 값을 변경할 떄 사용
         
         next(1)
         next(2)
         next(3)
         completed
         */
    }
    
    func flatMapTest() {
        let flatMapObservable = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { (count) -> Observable<String> in
                return Observable<String>.of("\(count)", "\(count)")
        }
        
        flatMapObservable.subscribe({print($0)}).disposed(by: disposeBag)
        
        /*
         새로운 oberverable을 만들 때 사용
         
         next(0)
         next(0)
         next(1)
         next(1)
         ...
         */
    }
    
    
    func scanTest() {
        let scanObservable = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .scan(into: 0) { (accumulator, num) in
                accumulator += num
        }
        
        scanObservable.subscribe({print($0)}).disposed(by: disposeBag)
        
        /*
         next(0) +1
         next(1) +2
         next(3) +3
         next(6) +4
         next(10) +5
         next(15)
         */
    }
    
    
    //MARK: - Filtering Observables -> 여기서부터하면됨
    
    func filterTest() {
        let observable = Observable<Int>.of(1,2,3,4,5,6,1).filter{
            $0 > 3
        }
        
        observable.subscribe({print($0)}).disposed(by: disposeBag)
        
        /*
         next(4)
         next(5)
         next(6)
         completed
         */
    }
    
    func lastTest() {
        let observable = Observable<Int>.of(1,2,3,4,5,6,1).takeLast(2)
        
        observable.subscribe({print($0)}).disposed(by: disposeBag)
        
        /*
         next(6)
         next(1)
         completed
         */
    }
    
    //skipUntil, while등 활용가능이 있음
    func skipTest() {
        let skipObservable = Observable<Int>.of(1,2,3,4,5,6,1).skip(2)
        
        skipObservable.subscribe({print($0)}).disposed(by: disposeBag)
        
        /*
         next(3)
         next(4)
         next(5)
         next(6)
         next(1)
         completed
         */
    }
    
    
    //MARK: - Combining Observables
    
    func mergeTest() {
        let observable1 = Observable<String>.of("1","2","3")
        let observable2 = Observable<String>.of("4","5","6")
        
        Observable.of(observable1, observable2).merge().subscribe({print($0)}).disposed(by: disposeBag)
        
        /*
         next(1)
         next(2)
         next(4)
         next(3)
         next(5)
         next(6)
         */
    }
    
    func combineLatestTest() {
        let observable1 = PublishSubject<Int>()
        let observable2 = PublishSubject<Int>()
        
        Observable.combineLatest(observable1, observable2).subscribe({print($0)}).disposed(by: disposeBag)
        
        observable1.onNext(1)
        observable2.onNext(2)
        observable1.onNext(3)
        observable2.onNext(4)
        
        /*
         next((1, 2))
         next((3, 2))
         next((3, 4))
         */
    }
    
    func zipTest() {
        let observable1 = PublishSubject<Int>()
        let observable2 = PublishSubject<Int>()
        
        Observable.zip(observable1, observable2).subscribe({print($0)}).disposed(by: disposeBag)
        
        observable1.onNext(1)
        observable2.onNext(2)
        observable1.onNext(3)
        observable2.onNext(4)
        
        /*
         next((1, 2))
         next((3, 4))
         */
    }
    
    //MARK: - Error Handling Operators
    
    //에러가발생했을 때 onError로 종료되지않고, 이벤트를 발생하고 onComplete로 될 수 있도록 한다.
    func catchTest() {
        let observable = PublishSubject<Int>()
        
        let catchObservable = observable.catchError { (aError) -> Observable<Int> in
            return Observable<Int>.just(100)
        }
        
        catchObservable.subscribe({print($0)}).disposed(by: disposeBag)
        
        observable.onNext(1)
        observable.onError(NSError(domain: "123", code: 1, userInfo: nil))
        
        /*
         next(1)
         next(100)
         completed
         */
    }

    //에러발생 시 다시 시도. 시도 카운트 파라미터 줄 수 있음
    func retryTest() {
        let observable = Observable<Int>.create({ event in
            event.on(.next(1))
            event.on(.next(2))
            event.on(.error(NSError(domain: "1", code: 1, userInfo: nil)))
            event.on(.completed)
            
            return Disposables.create {
                print("disposed")
            }
        })
        
        observable.retry(2).subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        /*
         1
         2
         disposed
         1
         2
         disposed
         */
    }
    
    //MARK: - Observable Utility Operators
    func delayTest() {
        let observable = Observable<Int>.just(3).delay(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
        
        observable.subscribe({print($0)}).disposed(by: disposeBag)
    }
    
    func doTest() {
        let observable = Observable<Int>.just(1).do(onNext: { (item) in
            print(item)
        }, afterNext: nil, onError: nil, afterError: nil, onCompleted: nil, afterCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
        
        observable.subscribe({print($0)}).disposed(by: disposeBag)
        
        /*
         1
         next(1)
         completed
         */
    }
    
    
    //MARK: - Convert Observable
    
    func toTest() {
        let observable = Observable<Int>.of(1,2,3).toArray().subscribe({print($0)})
        
        /*
         success([1, 2, 3])
         */
    }
    
    //MARK: - Math
    func concatTest() {
        let observable1 = PublishSubject<Int>()
        let observable2 = PublishSubject<Int>()
        
        observable1.concat(observable2).subscribe({print($0)}).disposed(by: disposeBag)
        
        observable1.onNext(1)
        observable2.onNext(2)
        observable1.onNext(1)
        observable2.onNext(2)
        observable1.onCompleted()
        observable2.onNext(2)
        observable2.onCompleted()
        
        /*
         next(1)
         next(1)
         next(2)
         completed
         */
    }
    
    func reduceTest() {
        Observable<Int>.of(1,2,3,4).reduce(0, accumulator: +).subscribe({print($0)}).disposed(by: disposeBag)
        
        /*
         next(10)
         completed
         */
    }
    
    //MARK: - 추가 공부
    
    func driverTest() {
        Driver<Int>.of(1,2,3).drive(onNext: { (item) in
            print(item)
        }, onCompleted: {
            print("completed")
        }) {
            print("disposed")
        }.disposed(by: disposeBag)
        
        /*
         1
         2
         3
         completed
         disposed
         */
    }
    
    func relayTest() {
        let relay = PublishRelay<Int>()
        
        relay.subscribe({print($0)}).disposed(by: disposeBag)
        relay.accept(10)
        relay.accept(20)
        
        /*
         next(10)
         next(20)
         */
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}
