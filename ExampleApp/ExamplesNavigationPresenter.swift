import UIKitFringes

class ExamplesNavigationPresenter: PushingPresenter {

    private let viewControllerFactory: ExamplesNavigationControllingFactoryProtocol
    private let router: ExamplesRouter
    private weak var viewController: ExamplesNavigationControlling?

    init(viewControllerFactory: ExamplesNavigationControllingFactoryProtocol,
         router: ExamplesRouter) {
        self.viewControllerFactory = viewControllerFactory
        self.router = router
    }

    func present(onWindow window: Windowing) {
        let _viewController = viewControllerFactory.create()
        viewController = _viewController
        router.push(.examples, on: self)
        window.set(rootViewController: _viewController)
    }

    func push(viewController viewControllerToPush: ViewControlling) {
        viewController?.push(viewController: viewControllerToPush, animated: false)
    }
}