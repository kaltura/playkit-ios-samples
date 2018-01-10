//
//  ChangeMediaSampleUITests.swift
//  ChangeMediaSampleUITests
//
//  Created by Владимир on 1/10/18.
//  Copyright © 2018 Kaltura. All rights reserved.
//

import XCTest

var app : XCUIApplication!

class ChangeMediaSampleUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        //        XCUIApplication().launch()
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPlayerViewAndControls() {
        let playerView = app.otherElements["playerView"]
        XCTAssertTrue(playerView.waitForExistence(timeout: 2))
        
        let controlView = app.otherElements["controlsView"]
        XCTAssertTrue(controlView.waitForExistence(timeout: 2))
        
        let slider = app.sliders["Playhead"]
        XCTAssertTrue(slider.exists)
        
        let startPosition = slider.normalizedSliderPosition
        self.tapPlayButton()
        sleep(2)
        XCTAssertTrue(slider.normalizedSliderPosition > startPosition)
        
        slider.adjust(toNormalizedSliderPosition: 0.8)
        sleep(2)
        slider.adjust(toNormalizedSliderPosition: 0.2)
        sleep(2)
        
        self.tapPauseButton()
        let pausePosition = slider.normalizedSliderPosition
        sleep(2)
        XCTAssertTrue(slider.normalizedSliderPosition == pausePosition)
        
        slider.adjust(toNormalizedSliderPosition: 0.0)
        self.tapChangeMediaButton()
        sleep(2)
        XCTAssertTrue(slider.normalizedSliderPosition > startPosition)
    }
    
    func tapPlayButton() {
        let playButton = app.buttons["Play"]
        if playButton.exists {
            playButton.tap()
        }
    }
    
    func tapPauseButton() {
        let pauseButton = app.buttons["Pause"]
        if pauseButton.exists {
            pauseButton.tap()
        }
    }
    
    func tapChangeMediaButton() {
        let pauseButton = app.buttons["Change Media"]
        if pauseButton.exists {
            pauseButton.tap()
        }
    }
    
    
}


