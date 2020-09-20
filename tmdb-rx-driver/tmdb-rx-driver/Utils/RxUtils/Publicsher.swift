//
//  Publicsher.swift
//  RxUtils
//
//  Created by Dmytro Shulzhenko on 4/29/19.
//  Copyright © 2019 Dmytro Shulzhenko. All rights reserved.
//

import RxSwift

// MARK: Publisher.
// Like publish subject that accepts only next events.

struct Publisher<Element> {
    private let subject = PublishSubject<Element>()
    
    init() { }
}

extension Publisher: ObserverType {
    func on(_ event: RxSwift.Event<Element>) {
        guard case .next = event else { return }
        subject.on(event)
    }
}

extension Publisher: ObservableType {
    func subscribe<Observer>(_ observer: Observer) -> Disposable
        where Observer: ObserverType, Element == Observer.Element {
            return subject.subscribe(observer)
    }
}

// MARK: SharedPublisher.
// Like behavior subject, but replays only when first element was fired, also accepts only next events.

final class SharedPublisher<Element> {
    private let lock = NSRecursiveLock()
    private let subject = PublishSubject<Element>()
    private(set) var latestEvent: RxSwift.Event<Element>?
    
    init() { }
}

extension SharedPublisher {
    convenience init(initial: Element) {
        self.init()
        on(.next(initial))
    }
}

extension SharedPublisher: ObserverType {
    func on(_ event: RxSwift.Event<Element>) {
        lock.lock()
        defer { lock.unlock() }
        switch event {
        case .completed, .next:
            latestEvent = event
            subject.on(event)
        case let .error(error):
            log(.fatal(error))
        }
    }
}

extension SharedPublisher: ObservableType {
    func subscribe<Observer>(_ observer: Observer) -> Disposable
        where Observer: ObserverType, SharedPublisher.Element == Observer.Element {
            if let replayed = latestEvent {
                observer.on(replayed)
            }
            return subject.subscribe(observer)
    }
}
