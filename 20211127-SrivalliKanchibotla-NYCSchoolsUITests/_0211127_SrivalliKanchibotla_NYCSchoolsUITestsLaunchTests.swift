//
//  _0211127_SrivalliKanchibotla_NYCSchoolsUITestsLaunchTests.swift
//  20211127-SrivalliKanchibotla-NYCSchoolsUITests
//
//  Created by Srivalli Kanchibotla on 11/27/21.
//

import XCTest

class _0211127_SrivalliKanchibotla_NYCSchoolsUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
