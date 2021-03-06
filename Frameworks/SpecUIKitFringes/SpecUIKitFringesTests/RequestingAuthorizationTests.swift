import XCTest
import CoreLocation
@testable import SpecUIKitFringes

class RequestingAuthorizationTests: SpecLocationManagerTestCase {
    
    func test_WhenStatusNotDetermined_ThenAllowed() {
        subject.delegate = delegate
        XCTAssertEqual(subject.authorizationStatus(), .notDetermined)
        delegate.receivedAuthorizationChange = nil

        subject.requestWhenInUseAuthorization()

        XCTAssertEqual(dialogManager.visibleDialog, .locationManager(.requestAccessWhileInUse))
        
        dialogManager.tap(.allow)

        XCTAssertNil(dialogManager.visibleDialog)
        XCTAssertEqual(subject.authorizationStatus(), .authorizedWhenInUse)
        XCTAssertEqual(delegate.receivedAuthorizationChange, .authorizedWhenInUse)
    }
    
    func test_WhenStatusNotDetermined_ThenNotAllowed() {
        subject.delegate = delegate
        XCTAssertEqual(subject.authorizationStatus(), .notDetermined)
        delegate.receivedAuthorizationChange = nil

        subject.requestWhenInUseAuthorization()

        XCTAssertEqual(dialogManager.visibleDialog, .locationManager(.requestAccessWhileInUse))
        
        dialogManager.tap(.dontAllow)
        
        XCTAssertNil(dialogManager.visibleDialog)
        XCTAssertEqual(subject.authorizationStatus(), .denied)
        XCTAssertEqual(delegate.receivedAuthorizationChange, .denied)
    }
    
    func test_WhenStatusDenied() {
        subject.delegate = delegate
        settingsApp.set(authorizationStatus: .denied)
        delegate.receivedAuthorizationChange = nil
        
        subject.requestWhenInUseAuthorization()

        XCTAssertNil(dialogManager.visibleDialog)
        XCTAssertEqual(subject.authorizationStatus(), .denied)
        XCTAssertNil(delegate.receivedAuthorizationChange)
    }
    
    func test_WhenStatusAuthorizedWhenInUse() {
        subject.delegate = delegate
        settingsApp.set(authorizationStatus: .authorizedWhenInUse)
        delegate.receivedAuthorizationChange = nil

        subject.requestWhenInUseAuthorization()

        XCTAssertNil(dialogManager.visibleDialog)
        XCTAssertEqual(subject.authorizationStatus(), .authorizedWhenInUse)
        XCTAssertNil(delegate.receivedAuthorizationChange)
    }

    func test_WhenStatusNotDetermined_AndLocationServicesOff() {
        subject.delegate = delegate
        XCTAssertEqual(subject.authorizationStatus(), .notDetermined)
        settingsApp.set(locationServicesEnabled: false)
        delegate.receivedAuthorizationChange = nil

        subject.requestWhenInUseAuthorization()

        XCTAssertEqual(dialogManager.visibleDialog, .locationManager(.requestJumpToLocationServicesSettings))
        
        dialogManager.tap(.cancel)
        
        XCTAssertNil(dialogManager.visibleDialog)
    }

    func test_WhenStatusAuthorizedWhenInUse_AndLocationServicesOff_ThenOn() {
        subject.delegate = delegate
        settingsApp.set(authorizationStatus: .authorizedWhenInUse)
        settingsApp.set(locationServicesEnabled: false)
        delegate.receivedAuthorizationChange = nil

        subject.requestWhenInUseAuthorization()

        XCTAssertEqual(dialogManager.visibleDialog, .locationManager(.requestJumpToLocationServicesSettings))
        
        dialogManager.tap(.settings)
        
        XCTAssertNil(dialogManager.visibleDialog)
        
        settingsApp.set(locationServicesEnabled: true)
        
        XCTAssertEqual(delegate.receivedAuthorizationChange, .authorizedWhenInUse)
    }

    func test_WhenStatusAuthorizedDenied_AndLocationServicesOff() {
        subject.delegate = delegate
        settingsApp.set(authorizationStatus: .denied)
        settingsApp.set(locationServicesEnabled: false)
        delegate.receivedAuthorizationChange = nil

        subject.requestWhenInUseAuthorization()

        XCTAssertNil(dialogManager.visibleDialog)
        XCTAssertEqual(subject.authorizationStatus(), .denied)
        XCTAssertNil(delegate.receivedAuthorizationChange)
    }

    func test_tappingAllowInDialogWhenNotPrompted() {
        XCTAssertNil(dialogManager.visibleDialog)
        
        errorHandler.fatalErrorsOff {
            dialogManager.tap(.allow)
        }
        XCTAssertEqual(errorHandler.recordedError, .noDialog)
    }

    func test_tappingAllowInDialogWhenWrongDialog() {
        settingsApp.set(locationServicesEnabled: false)
        subject.requestWhenInUseAuthorization()
        XCTAssertEqual(dialogManager.visibleDialog, .locationManager(.requestJumpToLocationServicesSettings))
        
        errorHandler.fatalErrorsOff {
            dialogManager.tap(.allow)
        }
        XCTAssertEqual(errorHandler.recordedError, .notAValidDialogResponse)
    }

    func test_tappingDoNotAllowInDialogWhenNotPrompted() {
        XCTAssertNil(dialogManager.visibleDialog)
        
        errorHandler.fatalErrorsOff {
            dialogManager.tap(.dontAllow)
        }
        XCTAssertEqual(errorHandler.recordedError, .noDialog)
    }

    func test_tappingDoNotAllowInDialogWhenWrongDialog() {
        settingsApp.set(locationServicesEnabled: false)
        subject.requestWhenInUseAuthorization()
        XCTAssertEqual(dialogManager.visibleDialog, .locationManager(.requestJumpToLocationServicesSettings))
        
        errorHandler.fatalErrorsOff {
            dialogManager.tap(.dontAllow)
        }
        XCTAssertEqual(errorHandler.recordedError, .notAValidDialogResponse)
    }
    
}
