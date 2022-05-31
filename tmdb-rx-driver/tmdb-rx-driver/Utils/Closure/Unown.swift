// http://sveinhal.github.io/2016/03/16/retain-cycles-function-references/

//swiftlint:disable identifier_name
import Foundation

func unowned<Type: AnyObject, R>(_ type: Type,
                                 in block: @escaping (Type) -> R) -> () -> R {
    return { [unowned type] in block(type) }
}

func unowned<Type: AnyObject, R>(_ type: Type,
                                 in block: @escaping (Type) throws -> R) -> () throws -> R {
    return { [unowned type] in try block(type) }
}

///

func unowned<Type: AnyObject>(_ type: Type,
                              in block: @escaping (Type) -> (() -> Void),
                              file: StaticString = #file,
                              line: Int = #line)
    -> () -> Void {
        return { [weak type] in
            guard let strong = type else {
                fatalError("\(file), \(line), \(String.init(describing: Type.self))")
            }
            let instanceFunction = block(strong)
            return instanceFunction()
        }
}

func unowned<Type: AnyObject, Arg, ReturnType>(_ type: Type,
                                               in block: @escaping (Type) -> ((Arg) -> ReturnType))
    -> (Arg) -> ReturnType {
        return { [weak type] arg in
            guard let type = type else {
                fatalError("\(String(describing: Type.self))")
            }
            let instanceFunction = block(type)
            return instanceFunction(arg)
        }
}

func unowned<Type: AnyObject, Arg1, Arg2, ReturnType>(_ type: Type,
                                                      in block: @escaping (Type) -> ((Arg1, Arg2) -> ReturnType))
    -> (Arg1, Arg2) -> ReturnType {
        return { [unowned type] arg1, arg2 in
            let instanceFunction = block(type)
            return instanceFunction(arg1, arg2)
        }
}

func unowned<Type: AnyObject, Arg1, Arg2, Arg3, ReturnType>(_ type: Type,
                                                            in block: @escaping (Type) -> ((Arg1, Arg2, Arg3) -> ReturnType))
    -> (Arg1, Arg2, Arg3) -> ReturnType {
        return { [unowned type] arg1, arg2, arg3 in
            let instanceFunction = block(type)
            return instanceFunction(arg1, arg2, arg3)
        }
}

func unowned<Type: AnyObject, Arg1, Arg2, Arg3, ReturnType>(_ type: Type,
                                                            in block: @escaping (Type) -> ((Arg1, Arg2, Arg3) throws -> ReturnType))
    -> (Arg1, Arg2, Arg3) throws -> ReturnType {
        return { [unowned type] arg1, arg2, arg3 in
            let instanceFunction = block(type)
            return try instanceFunction(arg1, arg2, arg3)
        }
}

func unowned<Type: AnyObject, Arg1, Arg2, Arg3, Arg4, ReturnType>(_ type: Type,
                                                                  in block: @escaping (Type) -> ((Arg1, Arg2, Arg3, Arg4) -> ReturnType))
    -> (Arg1, Arg2, Arg3, Arg4) -> ReturnType {
        return { [unowned type] arg1, arg2, arg3, arg4 in
            let instanceFunction = block(type)
            return instanceFunction(arg1, arg2, arg3, arg4)
        }
}

func unowned<Type: AnyObject, Arg1, Arg2, Arg3, Arg4, Arg5, ReturnType>(_ type: Type,
                                                                        in block: @escaping (Type) -> ((Arg1, Arg2, Arg3, Arg4, Arg5) -> ReturnType))
    -> (Arg1, Arg2, Arg3, Arg4, Arg5) -> ReturnType {
        return { [unowned type] arg1, arg2, arg3, arg4, arg5 in
            let instanceFunction = block(type)
            return instanceFunction(arg1, arg2, arg3, arg4, arg5)
        }
}

func unowned<Type: AnyObject, A, B, C, D, E, F, ReturnType>(_ type: Type,
                                                            in block: @escaping (Type) -> ((A, B, C, D, E, F) -> ReturnType))
    -> (A, B, C, D, E, F) -> ReturnType {
        return { [unowned type] a, b, c, d, e, f in
            let instanceFunction = block(type)
            return instanceFunction(a, b, c, d, e, f)
        }
}

// MARK: Weak

// Void as return

// Type

func weak<Type: AnyObject>(_ type: Type?,
                           in block: @escaping (Type) -> Void) -> () -> Void {
    return {
        guard let strong = type else {
            return
        }
        block(strong)
    }
}

func weak<Type: AnyObject, Arg>(_ type: Type?,
                                in block: @escaping (Type, Arg) -> Void) -> (Arg) -> Void {
    return { arg in
        guard let strong = type else {
            return
        }
        block(strong, arg)
    }
}

func weak<Type: AnyObject, Arg1, Arg2>(_ type: Type?,
                                       in block: @escaping (Type, Arg1, Arg2) -> Void) -> (Arg1, Arg2) -> Void {
    return { arg1, arg2 in
        guard let strong = type else {
            return
        }
        block(strong, arg1, arg2)
    }
}

func weak<Type: AnyObject, Arg1, Arg2, Arg3>(_ type: Type?,
                                             in block: @escaping (Type, Arg1, Arg2, Arg3) -> Void) -> (Arg1, Arg2, Arg3) -> Void {
    return { arg1, arg2, arg3 in
        guard let strong = type else {
            return
        }
        block(strong, arg1, arg2, arg3)
    }
}

func weak<Type: AnyObject, Arg1, Arg2, Arg3, Arg4>(_ type: Type?,
                                                   in block: @escaping (Type, Arg1, Arg2, Arg3, Arg4) -> Void) -> (Arg1, Arg2, Arg3, Arg4) -> Void {
    return { arg1, arg2, arg3, arg4 in
        guard let strong = type else {
            return
        }
        block(strong, arg1, arg2, arg3, arg4)
    }
}

// Method

func weak<Type: AnyObject>(_ type: Type?,
                           in block: @escaping (Type) -> (() -> Void))
    -> () -> Void {
        return { [weak type] in
            guard let type = type else {
               log(.fatal("\(String(describing: Type.self))"))
                return
            }
            let instanceFunction = block(type)
            return instanceFunction()
        }
}

func weak<Type: AnyObject, Arg>(_ type: Type?,
                                in block: @escaping (Type) -> ((Arg) -> Void))
    -> (Arg) -> Void {
        return { [weak type] arg in
            guard let type = type else {
               log(.fatal("\(String(describing: Type.self))"))
                return
            }
            let instanceFunction = block(type)
            return instanceFunction(arg)
        }
}

func weak<Type: AnyObject, Arg1, Arg2>(_ type: Type?,
                                       in block: @escaping (Type) -> ((Arg1, Arg2) -> Void))
    -> (Arg1, Arg2) -> Void {
        return { [weak type] arg1, arg2 in
            guard let type = type else {
               log(.fatal("\(String(describing: Type.self))"))
                return
            }
            let instanceFunction = block(type)
            return instanceFunction(arg1, arg2)
        }
}

func weak<Type: AnyObject, Arg1, Arg2, Arg3>(_ type: Type?,
                                             in block: @escaping (Type) -> ((Arg1, Arg2, Arg3) -> Void))
    -> (Arg1, Arg2, Arg3) -> Void {
        return { [weak type] arg1, arg2, arg3 in
            guard let type = type else {
               log(.fatal("\(String(describing: Type.self))"))
                return
            }
            let instanceFunction = block(type)
            return instanceFunction(arg1, arg2, arg3)
        }
}

//

func weak<Type: AnyObject, Arg, ReturnType>(_ type: Type?,
                                            in block: @escaping (Type) -> ((Arg) -> ReturnType?))
    -> (Arg) -> ReturnType? {
        return { [weak type] arg in
            guard let type = type else {
               log(.fatal("\(String(describing: Type.self))"))
                return nil
            }
            let instanceFunction = block(type)
            return instanceFunction(arg)
        }
}

func weak<Type: AnyObject, Arg1, Arg2, ReturnType>(_ type: Type?,
                                                   in block: @escaping (Type) -> ((Arg1, Arg2) -> ReturnType?))
    -> (Arg1, Arg2) -> ReturnType? {
        return { [weak type] arg1, arg2 in
            guard let type = type else {
               log(.fatal("\(String(describing: Type.self))"))
                return nil
            }
            let instanceFunction = block(type)
            return instanceFunction(arg1, arg2)
        }
}

func weak<Type: AnyObject, Arg1, Arg2, Arg3, ReturnType>(_ type: Type?,
                                                         in block: @escaping (Type) -> ((Arg1, Arg2, Arg3) -> ReturnType?))
    -> (Arg1, Arg2, Arg3) -> ReturnType? {
        return { [weak type] arg1, arg2, arg3 in
            guard let type = type else {
               log(.fatal("\(String(describing: Type.self))"))
                return nil
            }
            let instanceFunction = block(type)
            return instanceFunction(arg1, arg2, arg3)
        }
}

func weak<Type: AnyObject, Arg1, Arg2, Arg3, Arg4, ReturnType>(_ type: Type?,
                                                               in block: @escaping (Type) -> ((Arg1, Arg2, Arg3, Arg4) -> ReturnType?))
    -> (Arg1, Arg2, Arg3, Arg4) -> ReturnType? {
        return { [weak type] arg1, arg2, arg3, arg4 in
            guard let type = type else {
               log(.fatal("\(String(describing: Type.self))"))
                return nil
            }
            let instanceFunction = block(type)
            return instanceFunction(arg1, arg2, arg3, arg4)
        }
}

func weak<Type: AnyObject, Arg1, Arg2, Arg3, Arg4, Arg5, ReturnType>(_ type: Type?,
                                                                     in block: @escaping (Type) -> ((Arg1, Arg2, Arg3, Arg4, Arg5) -> ReturnType?))
    -> (Arg1, Arg2, Arg3, Arg4, Arg5) -> ReturnType? {
        return { [weak type] arg1, arg2, arg3, arg4, arg5 in
            guard let type = type else {
                log(.fatal("\(String(describing: Type.self))"))
                return nil
            }
            let instanceFunction = block(type)
            return instanceFunction(arg1, arg2, arg3, arg4, arg5)
        }
}
