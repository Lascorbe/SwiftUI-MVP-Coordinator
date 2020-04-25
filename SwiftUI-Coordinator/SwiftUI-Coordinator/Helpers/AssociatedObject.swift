import Foundation

// This protocol will help us in creating the Coordinator Mixin
//
// If you want to know more, there're a great explanation by my friend Luis Recuenco here: https://jobandtalent.engineering/the-power-of-mixins-in-swift-f9013254c503
// which is where I got this handy protocol. So all credits to them!

protocol AssociatedObjects: class {
    func associatedObject<T>(for key: UnsafeRawPointer) -> T?
    func setAssociatedObject<T>(
        _ object: T,
        for key: UnsafeRawPointer,
        policy: AssociationPolicy
    )
}
extension AssociatedObjects {
    func associatedObject<T>(for key: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(self, key) as? T
    }
    
    func setAssociatedObject<T>(
        _ object: T,
        for key: UnsafeRawPointer,
        policy: AssociationPolicy = .strong
    ) {
        return objc_setAssociatedObject(
            self,
            key,
            object,
            policy.objcPolicy
        )
    }
}
enum AssociationPolicy {
    case strong
    case copy
    case weak
    
    var objcPolicy: objc_AssociationPolicy {
        switch self {
            case .strong:
                return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            case .copy:
                return .OBJC_ASSOCIATION_COPY_NONATOMIC
            case .weak:
                return .OBJC_ASSOCIATION_ASSIGN
        }
    }
}
