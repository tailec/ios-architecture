//
//  Set.swift
//  Headway
//
//  Created by Dmytro Shulzhenko on 3/6/19.
//  Copyright © 2019 Dmitriy. All rights reserved.
//

import Foundation

// MARK: Set Closure inputs to Keypath

func set<Element: AnyObject, Inputs>(weak element: Element,
                                     to path: ReferenceWritableKeyPath<Element, Inputs>)
    -> Closure<Inputs, Void> {
        return Closure { [weak element] in element?[keyPath: path] = $0 }
}

func set<Element: AnyObject, Inputs>(unowned element: Element,
                                     to path: ReferenceWritableKeyPath<Element, Inputs>)
    -> Closure<Inputs, Void> {
        return Closure { [unowned element] in element[keyPath: path] = $0 }
}

func set<Element: AnyObject, Inputs>(unowned element: Element,
                                     to path: ReferenceWritableKeyPath<Element, Inputs>)
    -> (Inputs) -> Void {
        return { [unowned element] in element[keyPath: path] = $0 }
}

func set<Element: AnyObject, Inputs>(capture element: Element,
                                     to path: ReferenceWritableKeyPath<Element, Inputs>)
    -> Closure<Inputs, Void> {
        return Closure { element[keyPath: path] = $0 }
}

// MARK: Optional value in setter

func set<Element: AnyObject, Inputs>(weak element: Element,
                                     to path: ReferenceWritableKeyPath<Element, Inputs?>)
    -> Closure<Inputs, Void> {
        return Closure { [weak element] in element?[keyPath: path] = $0 }
}

func set<Element: AnyObject, Inputs>(unowned element: Element,
                                     to path: ReferenceWritableKeyPath<Element, Inputs?>)
    -> Closure<Inputs, Void> {
        return Closure { [unowned element] in element[keyPath: path] = $0 }
}

func set<Element: AnyObject, Inputs>(unowned element: Element,
                                     to path: ReferenceWritableKeyPath<Element, Inputs?>)
    -> (Inputs) -> Void {
        return { [unowned element] in element[keyPath: path] = $0 }
}

func set<Element: AnyObject, Inputs>(capture element: Element,
                                     to path: ReferenceWritableKeyPath<Element, Inputs?>)
    -> Closure<Inputs, Void> {
        return Closure { element[keyPath: path] = $0 }
}

// MARK: Optional element

func set<Element: AnyObject, Inputs>(weak element: Element?,
                                     to path: ReferenceWritableKeyPath<Element, Inputs>)
    -> Closure<Inputs, Void> {
        return Closure { [weak element] in element?[keyPath: path] = $0 }
}

func set<Element: AnyObject, Inputs>(unowned element: Element?,
                                     to path: ReferenceWritableKeyPath<Element, Inputs>)
    -> Closure<Inputs, Void> {
        guard let element = element else { return Closure { _ in } }
        return Closure { [unowned element] in element[keyPath: path] = $0 }
}

func set<Element: AnyObject, Inputs>(capture element: Element?,
                                     to path: ReferenceWritableKeyPath<Element, Inputs>)
    -> Closure<Inputs, Void> {
        guard let element = element else { return Closure { _ in } }
        return Closure { element[keyPath: path] = $0 }
}

// MARK: Optional element and value

func set<Element: AnyObject, Inputs>(weak element: Element?,
                                     to path: ReferenceWritableKeyPath<Element, Inputs?>)
    -> Closure<Inputs, Void> {
        return Closure { [weak element] in element?[keyPath: path] = $0 }
}

func set<Element: AnyObject, Inputs>(unowned element: Element?,
                                     to path: ReferenceWritableKeyPath<Element, Inputs?>)
    -> Closure<Inputs, Void> {
        guard let element = element else { return Closure { _ in } }
        return Closure { [unowned element] in element[keyPath: path] = $0 }
}

func set<Element: AnyObject, Inputs>(capture element: Element?,
                                     to path: ReferenceWritableKeyPath<Element, Inputs?>)
    -> Closure<Inputs, Void> {
        guard let element = element else { return Closure { _ in } }
        return Closure { element[keyPath: path] = $0 }
}

// MARK: Set on queue

func setOnMain<Element: AnyObject, Inputs>
    (unowned element: Element, to path: ReferenceWritableKeyPath<Element, Inputs>)
    -> Closure<Inputs, Void> {
        return setOn(queue: .main,
                     check: !Thread.isMainThread,
                     unowned: element,
                     to: path)
}

func setOn<Element: AnyObject, Inputs>(queue: DispatchQueue,
                                       check: @autoclosure @escaping () -> Bool = true,
                                       unowned element: Element,
                                       to path: ReferenceWritableKeyPath<Element, Inputs>)
    -> Closure<Inputs, Void> {
        return Closure { [unowned element] value in
            if check() {
                queue.async {
                    element[keyPath: path] = value
                }
            } else {
                element[keyPath: path] = value
            }
        }
}

//

func get<Element: AnyObject, Outputs>(
    unowned element: Element,
    from path: KeyPath<Element, Outputs>
) -> () -> Outputs {
    return { [unowned element] in element[keyPath: path] }
}
