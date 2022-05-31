//
//  Logging.swift
//  Log
//
//  Created by Dmytro Shulzhenko on 4/25/19.
//  Copyright © 2019 Dmytro Shulzhenko. All rights reserved.
//

import Foundation

struct Logging {
    let log: (Params) -> Void
}

extension Logging {
    static let formatFilename: (StaticString) -> String = {
        String($0).components(separatedBy: "/").last ?? ""
    }

    static var console: Logging {
        return Logging { params in
            #if DEBUG
            print(
                Date(),
                params.level.description,
                formatFilename(params.filename),
                params.function,
                params.line,
                "\(params.message())"
            )
            if params.level == Level.fatal {
                assertionFailure("\(params.filename) \(params.function) \(params.line) \(params.message())")
            }
            #endif
        }
    }
}

extension String {
    init(_ staticString: StaticString) {
        self = staticString.withUTF8Buffer {
            String(decoding: $0, as: UTF8.self)
        }
    }
}
