import SwiftUI

protocol Coordinator: AssociatedObject {
    associatedtype U: View
    associatedtype P: Coordinator
    func start() -> U
    func stop()
}

extension Coordinator {
    private(set) var identifier: UUID {
        get {
            guard let identifier: UUID = associatedObject(for: &identifierKey) else {
                self.identifier = UUID()
                return self.identifier
            }
            return identifier
        }
        set { setAssociatedObject(newValue, for: &identifierKey) }
    }
    
    private(set) var children: [UUID: Any] {
        get {
            guard let children: [UUID: Any] = associatedObject(for: &childrenKey) else {
                self.children = [UUID: Any]()
                return self.children
            }
            return children
        }
        set { setAssociatedObject(newValue, for: &childrenKey) }
    }
    
    private func store<T: Coordinator>(child coordinator: T) {
        children[coordinator.identifier] = coordinator
    }
    
    private func free<T: Coordinator>(child coordinator: T) {
        children.removeValue(forKey: coordinator.identifier)
    }
    
    private(set) weak var parent: P? {
        get { associatedObject(for: &parentKey) }
        set { setAssociatedObject(newValue, for: &parentKey, policy: .weak) }
    }
    
    func coordinate<T: Coordinator>(to coordinator: T) -> some View {
        store(child: coordinator)
        coordinator.parent = self as? T.P
        return coordinator.start()
    }
    
    func stop() {
        children.removeAll()
        parent?.free(child: self)
    }
}

private var identifierKey: UInt8 = 0
private var childrenKey: UInt8 = 0
private var parentKey: UInt8 = 0

///////////////////////////////////////////////////////////////

// MARK: AppCoordinator

final class AppCoordinator: Coordinator {
    typealias P = AppCoordinator // let's just set parent to itself, since it won't have a parent anyway
    
    private weak var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    @discardableResult
    func start() -> some View {
        let coordinator = RootMasterCoordinator<AppCoordinator>(window: window)
        return coordinate(to: coordinator)
    }
}

// MARK: MasterCoordinator

protocol MasterCoordinator: Coordinator {}

extension MasterCoordinator {
    func presentDetailView(isPresented: Binding<Bool>) -> some View {
        let coordinator = NavigationDetailCoordinator<Self>(isPresented: isPresented)
        return coordinate(to: coordinator)
    }
}

final class RootMasterCoordinator<P: Coordinator>: MasterCoordinator {
    private weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() -> some View {
        let view = MasterFactory.make(with: self)
        let navigation = NavigationView { view }
        let hosting = UIHostingController(rootView: navigation)
        window?.rootViewController = hosting
        window?.makeKeyAndVisible()
        return EmptyView()
    }
}

// MARK: DetailCoordinator

protocol DetailCoordinator: Coordinator {}

final class NavigationDetailCoordinator<P: Coordinator>: DetailCoordinator {
    private var isPresented: Binding<Bool>
    
    init(isPresented: Binding<Bool>) {
        self.isPresented = isPresented
    }
    
    func start() -> some View {
        return NavigationLink(destination: EmptyView(), isActive: isPresented) {
            EmptyView()
        }
    }
}

// MARK: Factory

enum MasterFactory {
    static func make<C: MasterCoordinator>(with coordinator: C) -> some View {
        let presenter = MasterPresenter(coordinator: coordinator)
        let view = MasterView(presenter: presenter)
        return view
    }
}

// MARK: Presenter

class Presenter<C: Coordinator> {
    private(set) weak var coordinator: C?
    
    init(coordinator: C) {
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator?.stop()
    }
}

// MARK: MVP

struct MasterViewModel {
    let date: Date
}

protocol MasterPresenting: ObservableObject {
    associatedtype U: View
    var viewModel: MasterViewModel { get }
    func onButtonPressed(isPresented: Binding<Bool>) -> U
}

final class MasterPresenter<C: MasterCoordinator>: Presenter<C>, MasterPresenting {
    @Published private(set) var viewModel: MasterViewModel
    
    override init(coordinator: C) {
        self.viewModel = MasterViewModel(date: Date())
        super.init(coordinator: coordinator)
    }
    
    func onButtonPressed(isPresented: Binding<Bool>) -> some View {
        return coordinator?.presentDetailView(isPresented: isPresented)
    }
}

struct MasterView<T: MasterPresenting>: View {
    @ObservedObject var presenter: T
    
    var body: some View {
        NavigationButton(contentView: Text("\(presenter.viewModel.date, formatter: dateFormatter)"),
                         navigationView: { isPresented in
                            self.presenter.onButtonPressed(isPresented: isPresented)
        })
    }
}

struct NavigationButton<CV: View, NV: View>: View {
    @State private var isPresented = false
    
    var contentView: CV
    var navigationView: (Binding<Bool>) -> NV
    
    var body: some View {
        Button(action: {
            self.isPresented = true
        }) {
            contentView
                .background(
                    navigationView($isPresented)
            )
        }
    }
}

let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

////////////////////////////////////////////////////////////////

protocol AssociatedObject: class {
    func associatedObject<T>(for key: UnsafeRawPointer) -> T?
    func setAssociatedObject<T>(
        _ object: T,
        for key: UnsafeRawPointer,
        policy: AssociationPolicy
    )
}
extension AssociatedObject {
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
