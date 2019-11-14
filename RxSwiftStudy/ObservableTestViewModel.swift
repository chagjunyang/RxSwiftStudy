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
    
    //MARK: - Combining Observables
    
    //MARK: - Observable Utility Operators
    
    
    
    
    
    deinit {
        disposeBag = DisposeBag()
    }
}
