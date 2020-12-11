//
//  ItemCellTests.swift
//  ListableUI-Unit-Tests
//
//  Created by Kyle Van Essen on 11/22/19.
//

import XCTest

@testable import ListableUI


class ItemElementCellTests : XCTestCase
{
    func test_init()
    {
        let cell = ItemCell<TestItemContent>(frame: CGRect(origin: .zero, size: CGSize(width: 100.0, height: 100.0)))
        
        XCTAssertEqual(cell.backgroundColor, .clear)
        XCTAssertEqual(cell.layer.masksToBounds, false)
        
        XCTAssertEqual(cell.contentView.backgroundColor, .clear)
        XCTAssertEqual(cell.contentView.layer.masksToBounds, false)
        
        XCTAssertEqual(cell.contentContainer.superview, cell.contentView)

        // Ensure the content subviews can specify accessibility element params.
        XCTAssertFalse(cell.contentContainer.isAccessibilityElement)
    }
    
    func test_sizeThatFits()
    {
        // The default implementation of size that fits on UIView returns the existing size of the view.
        // Make sure that value is returned from the cell.
        
        let cell1 = ItemCell<TestItemContent>(frame: CGRect(origin: .zero, size: CGSize(width: 100.0, height: 100.0)))
        XCTAssertEqual(cell1.sizeThatFits(.zero), CGSize(width: 100.0, height: 100.0))
        
        let cell2 = ItemCell<TestItemContent>(frame: CGRect(origin: .zero, size: CGSize(width: 150.0, height: 150.0)))
        XCTAssertEqual(cell2.sizeThatFits(.zero), CGSize(width: 150.0, height: 150.0))
    }
    
    func test_systemLayoutSizeFitting() {
        XCTFail()
    }
    
    func test_systemLayoutSizeFitting_withHorizontalFittingPriority_verticalFittingPriority() {
        XCTFail()
    }
}

fileprivate struct TestItemContent : ItemContent, Equatable
{
    // MARK: ItemElement
    
    var identifier: Identifier<TestItemContent> {
        return .init("Test")
    }
    
    func apply(to views: ItemContentViews<Self>, for reason: ApplyReason, with info: ApplyItemContentInfo) {}

    typealias ContentView = UIView
    
    static func createReusableContentView(frame: CGRect) -> UIView {
        return UIView(frame: frame)
    }
}


class ItemElementCell_LiveCells_Tests : XCTestCase
{
    func test_add() {
        
    }
    
    func test_perform() {
        
    }
}
