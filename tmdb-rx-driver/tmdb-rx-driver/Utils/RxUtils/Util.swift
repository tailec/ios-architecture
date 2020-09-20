//
//  Util.swift
//  RxUtils
//
//  Created by Dmytro Shulzhenko on 4/29/19.
//  Copyright © 2019 Dmytro Shulzhenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Observable {
    func toVoid() -> Observable<Void> {
        return map { _ in }
    }
}

extension PrimitiveSequence where Trait == CompletableTrait, Element == Swift.Never {
    func onErrorJustComplete() -> Completable {
        return Completable.create { complete in
            return self.subscribe(
                onCompleted: { complete(.completed) },
                onError: { _ in complete(.completed) }
            )
        }
    }
    
    func passErrorsAssert(_ file: StaticString = #file,
                          _ function: StaticString = #function,
                          _ line: UInt = #line,
                          onError: @escaping (Error) -> Void) -> Completable {
        return Completable.create { complete in
            return self.subscribe(
                onCompleted: { complete(.completed) },
                onError: { error in
                    onError(error)
                    log(.fatal(error, file, function, line))
            }
            )
        }
    }
    
    func passErrors() -> Completable {
        return Completable.create { complete in
            return self.subscribe(
                onCompleted: { complete(.completed) },
                onError: { error in
                    log(.error(error))
            }
            )
        }
    }
    
    static func amb(_ sources: Completable...) -> Completable {
        return Completable.create { complete in
            Disposables.create(
                sources.map { source in
                    source.subscribe(
                        onCompleted: { complete(.completed) },
                        onError: { complete(.error($0)) }
                    )
                }
            )
        }
    }
}

extension ObservableType {
    func passErrors() -> Observable<Element> {
        return Observable.create { observer in
            self
                .subscribe(
                    onNext: observer.onNext,
                    onError: { error in
                        log(.error(error))
                },
                    onCompleted: observer.onCompleted
            )
        }
    }
}

extension PrimitiveSequence {
    func onError(switchTo other: PrimitiveSequence<Trait, Element>) -> PrimitiveSequence<Trait, Element> {
        return catchError { _ in other }
    }
    
    static func | (lhs: PrimitiveSequence<Trait, Element>,
                   rhs: PrimitiveSequence<Trait, Element>) -> PrimitiveSequence<Trait, Element> {
        return lhs.catchError { _ in rhs }
    }
}

extension Observable {
    func onError(switchTo other: Observable<Element>) -> Observable<Element> {
        return catchError { _ in other }
    }
    
    static func | (lhs: Observable<Element>, rhs: Observable<Element>) -> Observable<Element> {
        return lhs.onError(switchTo: rhs)
    }
}
///

// MARK: Observer
// Like Any Observer but accepts only next events.

struct Observer<Element> {
    private let observer: AnyObserver<Element>
    
    init(_ observer: AnyObserver<Element>) {
        self.observer = observer
    }
    
    func next(_ element: Element) {
        observer.onNext(element)
    }
    
    func complete() {
        observer.onCompleted()
    }
}

extension Observer where Element == Void {
    func next() {
        next(())
    }
}

extension ObservableType {
    func bind(to observer: Observer<Element>) -> Disposable {
        return subscribe(onNext: observer.next,
                         onError: { log(.fatal($0)) })
    }
    
    func bind(next observer: Observer<Element>,
              error: @escaping (Error) -> Void = { log(.fatal($0)) }) -> Disposable {
        return subscribe(onNext: observer.next,
                         onError: error)
    }
}

extension Observable {
    func `do`<T>(onNil action: @escaping () -> Void) -> Observable where Element == T? {
        return `do`(onNext: { element in
            guard element == nil else {
                return
            }
            action()
        })
    }
}

extension ObservableType {
    func withLatestFromBuffer<Source: ObservableConvertibleType, ResultType>
        (_ second: Source,
         resultSelector: @escaping (Element, Source.Element) -> ResultType)
        -> Observable<ResultType> {
            return Observable.create { observer in
                var buffer: [Element] = []
                var latest: Source.Element?
                let lock = NSRecursiveLock()
                
                let secondDisposable = second.asObservable().subscribe { event in
                    lock.lock(); defer { lock.unlock() }
                    guard case let .next(element) = event else { return }
                    latest = element
                    guard !buffer.isEmpty else { return }
                    buffer.map { resultSelector($0, element) }.forEach(observer.onNext)
                    buffer = []
                }
                let disposable = self.subscribe { event in
                    lock.lock(); defer { lock.unlock() }
                    switch event {
                    case .next(let element):
                        buffer.append(element)
                        guard let latest = latest else { return }
                        buffer.map { resultSelector($0, latest) }.forEach(observer.onNext)
                        buffer = []
                    case .completed:
                        observer.onCompleted()
                    case .error(let error):
                        observer.onError(error)
                    }
                }
                return Disposables.create([disposable, secondDisposable])
            }
    }
}

extension Disposables {
    static func create(_ disposable: Disposable) -> Cancelable {
        return create([disposable])
    }
}

extension Single where Trait == SingleTrait {
    static func createThrows(subscribe: @escaping (@escaping SingleObserver) throws -> Disposable) -> Single<Element> {
        return .create { complete in
            do {
                return Disposables.create(
                    try subscribe(complete)
                )
            } catch let error {
                complete(.error(error))
                return Disposables.create()
            }
        }
    }
}

extension Completable {
    static func createThrows(subscribe: @escaping (@escaping CompletableObserver) throws -> Disposable) -> Completable {
        return .create { complete in
            do {
                return Disposables.create(
                    try subscribe(complete)
                )
            } catch let error {
                complete(.error(error))
                return Disposables.create()
            }
        }
    }
    
    static func workItem(_ block: @escaping () throws -> Void) -> Completable {
        return .create { complete in
            do {
                try block()
                complete(.completed)
                return Disposables.create()
            } catch let error {
                complete(.error(error))
                return Disposables.create()
            }
        }
    }
}

enum ElementChange<Element> {
    case initial(Element)
    case change(oldValue: Element, newValue: Element)
    
    var change: (oldValue: Element, newValue: Element)? {
        guard case let .change(oldValue, newValue) = self else {
            return nil
        }
        return (oldValue, newValue)
    }
}

extension ObservableType {
    // with latest
    
    func combineWithLatestFrom<Source>(_ second: Source) -> Observable<(Element, Source.Element)>
        where Source: ObservableConvertibleType {
            return self.withLatestFrom(second) { ($0, $1) }
    }
    
    func combineWithLatestFrom<First, Second, Source>(_ second: Source)
        -> Observable<(First, Second, Source.Element)>
        where Element == (First, Second), Source: ObservableConvertibleType {
            return self.withLatestFrom(second) { ($0.0, $0.1, $1) }
    }
    
    func combineWithLatestFrom<First, Second, Third, Source>(_ second: Source)
        -> Observable<(First, Second, Third, Source.Element)>
        where Element == (First, Second, Third), Source: ObservableConvertibleType {
            return self.withLatestFrom(second) { ($0.0, $0.1, $0.2, $1) }
    }
    
    func combineWithLatestFrom<First, Second, Third, Fourth, Source>(_ second: Source)
        -> Observable<(First, Second, Third, Fourth, Source.Element)>
        where Element == (First, Second, Third, Fourth), Source: ObservableConvertibleType {
            return self.withLatestFrom(second) { ($0.0, $0.1, $0.2, $0.3, $1) }
    }
    
    // Flat map
    
    func combineFlatMapLatest<Source>(_ second: Source, scheduler: SchedulerType)
        -> Observable<(Element, Source.Element)>
        where Source: ObservableConvertibleType {
            return self.flatMapLatest { element in second.asObservable().take(1).map { (element, $0) } }
                .observeOn(scheduler)
    }
    
    func combineFlatMapLatest<Source>(_ second: Source) -> Observable<(Element, Source.Element)>
        where Source: ObservableConvertibleType {
            return combineFlatMapLatest(second, resultSelector: { ($0, $1) })
    }
    
    func combineFlatMapLatest<Source, T>(_ second: Source,
                                         resultSelector: @escaping (Element, Source.Element) -> T)
        -> Observable<T>
        where Source: ObservableConvertibleType {
            return flatMapLatest { element in
                second.asObservable().take(1).map { resultSelector(element, $0) }
            }
    }

    func combineFlatMapLatest<First, Second, Source>(_ second: Source)
        -> Observable<(First, Second, Source.Element)>
        where Source: ObservableConvertibleType, Element == (First, Second) {
            return self.flatMapLatest { element in second.asObservable().take(1).map { (element.0, element.1, $0) } }
    }
    
    func combineFlatMapLatest<First, Second, Third, Source>(_ second: Source)
        -> Observable<(First, Second, Third, Source.Element)>
        where Source: ObservableConvertibleType, Element == (First, Second, Third) {
            return self.flatMapLatest { element in
                second.asObservable().take(1).map {
                    (element.0, element.1, element.2, $0)
                }
            }
    }
    
    func combineFlatMapLatest<First, Second, Third, Fourth, Source>(_ second: Source)
        -> Observable<(First, Second, Third, Fourth, Source.Element)>
        where Source: ObservableConvertibleType, Element == (First, Second, Third, Fourth) {
            return self.flatMapLatest { element in
                second.asObservable().take(1).map {
                    (element.0, element.1, element.2, element.3, $0)
                }
            }
    }
    
    func combineFlatMapLatest<Source>(_ second: Source,
                                      scheduler: SchedulerType) -> Observable<Source.Element>
        where Source: ObservableConvertibleType, Element == Void {
            return self.flatMapLatest { _ in second.asObservable().take(1) }.observeOn(scheduler)
    }
    
    // .. TBD
}

final class BagContainer<T> {
    final class DisposeTracker: Disposable {
        func dispose() {
            print("DISPOSED: \(String(describing: T.self))")
        }
    }
    
    private(set) var bag = createBag()
    
    func resetBag() {
        bag = BagContainer.createBag()
    }
    
    private static func createBag() -> DisposeBag {
        let bag = DisposeBag()
        #if DEBUG
        bag.insert(DisposeTracker())
        #endif
        return bag
    }
}
