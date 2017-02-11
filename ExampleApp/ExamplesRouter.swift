import UIKitFringes

class ExamplesRouter {

    private let examplesPresenterFactory: ExamplesPresenterFactory
    private let datePresenterFactory: DatePresenterFactory
    private let timerPresenterFactory: TimerPresenterFactory
    private let urlSessionPresenterFactory: URLSessionPresenterFactory
    private let examplesNavigationPresenterFactory: ExamplesNavigationPresenterFactory
    private let uiViewControllerPresenterFactory: UIViewControllerPresenterFactory

    init(examplesNavigationPresenterFactory: ExamplesNavigationPresenterFactory,
         examplesPresenterFactory: ExamplesPresenterFactory,
         timerPresenterFactory: TimerPresenterFactory,
         urlSessionPresenterFactory: URLSessionPresenterFactory,
         datePresenterFactory: DatePresenterFactory,
         uiViewControllerPresenterFactory: UIViewControllerPresenterFactory) {
        self.examplesNavigationPresenterFactory = examplesNavigationPresenterFactory
        self.examplesPresenterFactory = examplesPresenterFactory
        self.timerPresenterFactory = timerPresenterFactory
        self.urlSessionPresenterFactory = urlSessionPresenterFactory
        self.datePresenterFactory = datePresenterFactory
        self.uiViewControllerPresenterFactory = uiViewControllerPresenterFactory
    }
    
    func present(onWindow window: Windowing) {
        let examplesNavigationPresenter = examplesNavigationPresenterFactory.create(withRouter: self)
        examplesNavigationPresenter.present(onWindow: window)
    }

    enum PresenterIdentifier {
        case examples
        case date
        case timer
        case urlSession
        case uiViewController
    }

    private func presenter(for presenterIdentifier: PresenterIdentifier) -> PushedPresenter {
        switch presenterIdentifier {
        case .examples:
            return examplesPresenterFactory.create(withRouter: self)
        case .date:
            return datePresenterFactory.create(withRouter: self)
        case .timer:
            return timerPresenterFactory.create(withRouter: self)
        case .urlSession:
            return urlSessionPresenterFactory.create(withRouter: self)
        case .uiViewController:
            return uiViewControllerPresenterFactory.create(withRouter: self)
        }
    }

    func push(_ presenterIdentifier: PresenterIdentifier, on pushingPresenter: PushingPresenter) {
        let pushedPresenter = presenter(for: presenterIdentifier)
        pushedPresenter.push(on: pushingPresenter)
    }
    
    func presentUIViewController(on presenter: PresentingPresenter) {
        let uiViewControllerPresenter = uiViewControllerPresenterFactory.create(withRouter: self)
        uiViewControllerPresenter.present(on: presenter)
    }
}