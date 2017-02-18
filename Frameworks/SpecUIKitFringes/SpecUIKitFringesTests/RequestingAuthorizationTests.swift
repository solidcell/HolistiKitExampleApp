import XCTest
import CoreLocation
@testable import SpecUIKitFringes

class RequestingAuthorizationTests: SpecLocationManagerTestCase {
    
    func test_WhenStatusNotDetermined_ThenAllowed() {
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
        subject.setAuthorizationStatusInSettingsApp(.denied)
        delegate.receivedAuthorizationChange = nil
        
        subject.requestWhenInUseAuthorization()

        XCTAssertNil(dialogManager.visibleDialog)
        XCTAssertEqual(subject.authorizationStatus(), .denied)
        XCTAssertNil(delegate.receivedAuthorizationChange)
    }
    
    func test_WhenStatusAuthorizedWhenInUse() {
        subject.setAuthorizationStatusInSettingsApp(.authorizedWhenInUse)
        delegate.receivedAuthorizationChange = nil

        subject.requestWhenInUseAuthorization()

        XCTAssertNil(dialogManager.visibleDialog)
        XCTAssertEqual(subject.authorizationStatus(), .authorizedWhenInUse)
        XCTAssertNil(delegate.receivedAuthorizationChange)
    }

    func test_WhenStatusNotDetermined_AndLocationServicesOff() {
        XCTAssertEqual(subject.authorizationStatus(), .notDetermined)
        subject.setLocationServicesEnabledInSettingsApp(false)
        delegate.receivedAuthorizationChange = nil

        subject.requestWhenInUseAuthorization()

        XCTAssertEqual(dialogManager.visibleDialog, .locationManager(.requestJumpToLocationServicesSettings))
        
        subject.tapSettingsOrCancelInDialog()
        
        XCTAssertNil(dialogManager.visibleDialog)
    }

    func test_WhenStatusAuthorizedWhenInUse_AndLocationServicesOff_ThenOn() {
        subject.setAuthorizationStatusInSettingsApp(.authorizedWhenInUse)
        subject.setLocationServicesEnabledInSettingsApp(false)
        delegate.receivedAuthorizationChange = nil

        subject.requestWhenInUseAuthorization()

        XCTAssertEqual(dialogManager.visibleDialog, .locationManager(.requestJumpToLocationServicesSettings))
        
        subject.tapSettingsOrCancelInDialog()
        
        XCTAssertNil(dialogManager.visibleDialog)
        
        subject.setLocationServicesEnabledInSettingsApp(true)
        
        XCTAssertEqual(delegate.receivedAuthorizationChange, .authorizedWhenInUse)
    }

    func test_WhenStatusAuthorizedDenied_AndLocationServicesOff() {
        subject.setAuthorizationStatusInSettingsApp(.denied)
        subject.setLocationServicesEnabledInSettingsApp(false)
        delegate.receivedAuthorizationChange = nil

        subject.requestWhenInUseAuthorization()

        XCTAssertNil(dialogManager.visibleDialog)
        XCTAssertEqual(subject.authorizationStatus(), .denied)
        XCTAssertNil(delegate.receivedAuthorizationChange)
    }

    func test_tappingAllowInDialogWhenNotPrompted() {
        XCTAssertNil(dialogManager.visibleDialog)
        
        errorHandler.fatalErrorsOff() {
            self.dialogManager.tap(.allow)
        }
        XCTAssertEqual(errorHandler.errors, [.noDialog])
    }

    func test_tappingAllowInDialogWhenWrongDialog() {
        subject.setLocationServicesEnabledInSettingsApp(false)
        subject.requestWhenInUseAuthorization()
        XCTAssertEqual(dialogManager.visibleDialog, .locationManager(.requestJumpToLocationServicesSettings))
        
        errorHandler.fatalErrorsOff() {
            self.dialogManager.tap(.allow)
        }
        XCTAssertEqual(errorHandler.errors, [.notAValidDialogResponse])
    }

    func test_tappingDoNotAllowInDialogWhenNotPrompted() {
        XCTAssertNil(dialogManager.visibleDialog)
        
        errorHandler.fatalErrorsOff() {
            self.dialogManager.tap(.dontAllow)
        }
        XCTAssertEqual(errorHandler.errors, [.noDialog])
    }

    func test_tappingDoNotAllowInDialogWhenWrongDialog() {
        subject.setLocationServicesEnabledInSettingsApp(false)
        subject.requestWhenInUseAuthorization()
        XCTAssertEqual(dialogManager.visibleDialog, .locationManager(.requestJumpToLocationServicesSettings))
        
        errorHandler.fatalErrorsOff() {
            self.dialogManager.tap(.dontAllow)
        }
        XCTAssertEqual(errorHandler.errors, [.notAValidDialogResponse])
    }
    
}
