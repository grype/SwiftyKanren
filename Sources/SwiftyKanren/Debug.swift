import Foundation

public typealias GoalDecorator = (@escaping Goal) -> Goal

public func trace(_ name: String) -> GoalDecorator {
    return { (goal: @escaping Goal) in
        return { incomingState in
            let outgoingStates = goal(incomingState)
            print("\(name)(\(incomingState)) -> \(outgoingStates.takeAll())")
            return outgoingStates
        }
    }
}

precedencegroup DecorationPrecedence {
    associativity: right
    lowerThan: AssignmentPrecedence
}

// Infix syntax for debug decorators, allowing usage such as:
//
// trace("unify x with 3") % x =~= 3

infix operator !: DecorationPrecedence
public func ! (decorator: GoalDecorator, goal: @escaping Goal) -> Goal {
    return decorator(goal)
}
