//
//  List.swift
//  SwiftUILists
//
//  Created by Kyle Van Essen on 10/22/19.
//


import Listable
import SwiftUI


@available(iOS 13.0, *)
public struct ListableList : UIViewControllerRepresentable
{
    public var listDescription : ListDescription

    //
    // MARK: Initialization
    //
        
    public init(build : ListDescription.Build)
    {
        self.listDescription = ListDescription(
            animatesChanges: UIView.inheritedAnimationDuration > 0.0,
            layoutType: .list,
            appearance: .init(),
            behavior: .init(),
            autoScrollAction: .none,
            scrollInsets: .init(),
            accessibilityIdentifier: nil,
            debuggingIdentifier: nil,
            build: build
        )
    }
    
    //
    // MARK: UIViewRepresentable
    //
    
    public typealias UIViewControllerType = ListableViewController
    
    public func makeUIViewController(context: Context) -> ListableViewController
    {
        ListableViewController(self.listDescription)
    }
    
    public func updateUIViewController(_ viewController: ListableViewController, context: Context)
    {
        viewController.listView.setProperties(with: self.listDescription)
    }
}


public final class ListableViewController : UIViewController
{
    var listView : ListView
        
    init(_ description : ListDescription)
    {
        self.listView = ListView(frame: .zero, appearance: description.appearance)
        
        super.init(nibName: nil, bundle: nil)
        
        self.listView.containingViewController = self
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public override func loadView()
    {
        self.view = self.listView
    }
}
