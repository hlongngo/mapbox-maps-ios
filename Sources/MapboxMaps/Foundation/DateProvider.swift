import Foundation
import QuartzCore

internal protocol DateProvider {

    // Provides the current date
    var now: Date { get }
}

public protocol TimeProvider {
    // Provides the current time
    var current: TimeInterval { get }
}

internal struct DefaultDateProvider: DateProvider {
    var now: Date {
        return Date()
    }
}

public struct DefaultTimeProvider: TimeProvider {
    public var current: TimeInterval {
        return CACurrentMediaTime()
    }
    
    public init() {
        
    }
}
