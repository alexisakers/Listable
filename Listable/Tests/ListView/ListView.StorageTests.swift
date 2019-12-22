//
//  ListView.StorageTests.swift
//  Listable-Unit-Tests
//
//  Created by Kyle Van Essen on 11/27/19.
//

import XCTest

@testable import Listable


class ListView_StorageTests: XCTestCase
{
    func testStorage(with view : ListView) -> ListView.Storage
    {
        let storage = ListView.Storage()
        storage.presentationState.view = view
        
        storage.allContent = Content { content in
            content += Section(identifier: "section-1") { section in
                section += Item(with: TestElement(name: "row-1"), appearance: TestElement.Appearance())
                section += Item(with: TestElement(name: "row-2"), appearance: TestElement.Appearance())
            }
            
            content += Section(identifier: "section-2") { section in
                section += Item(with: TestElement(name: "row-3"), appearance: TestElement.Appearance())
                section += Item(with: TestElement(name: "row-4"), appearance: TestElement.Appearance())
                section += Item(with: TestElement(name: "row-5"), appearance: TestElement.Appearance())
            }
        }
        
        let diff = ListView.diffWith(old : [], new: storage.allContent.sections)
        
        storage.presentationState.update(with: diff, slice: Content.Slice(containsAllItems: true, content: storage.allContent))
        
        return storage
    }
    
    func test_moveItem()
    {
        let view = ListView()
        let storage = self.testStorage(with: view)
        
        storage.moveItem(from: IndexPath(item: 0, section: 0), to: IndexPath(item: 1, section: 1))
        
        let items : [[Item<TestElement>]] = storage.allContent.sections.map {
            return $0.items as! [Item<TestElement>]
        }
        
        let names : [[String]] = items.map {
            $0.map { $0.element.name }
        }
        
        XCTAssertEqual(names, [
            [
                "row-2",
            ],
            [
                "row-3",
                "row-1",
                "row-4",
                "row-5",
            ],
        ])
    }
    
    func test_remove()
    {
        
    }
}

fileprivate struct TestElement : ItemElement, Equatable
{
    var name : String
    
    var identifier: Identifier<TestElement> {
        return .init(self.name)
    }
    
    func apply(to view: TestElement.Appearance.ContentView, for reason: ApplyReason, with info: ApplyItemElementInfo) {}

    struct Appearance : ItemElementAppearance, Equatable
    {
        typealias ContentView = UIView
        
        static func createReusableItemView(frame: CGRect) -> UIView {
            return UIView(frame: frame)
        }
        
        func apply(to view: UIView, with info: ApplyItemElementInfo) {}
    }
}