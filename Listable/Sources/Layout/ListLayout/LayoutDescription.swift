//
//  LayoutDescription.swift
//  Listable
//
//  Created by Kyle Van Essen on 6/15/20.
//

import Foundation


///
/// A `LayoutDescription`, well, describes the type of and properties of a layout to apply to a list view.
///
/// You use a `LayoutDescription` by passing a closure to its initializer, which you use to
/// customize the `layoutAppearance` of the provided list type.
///
/// For example, to use a standard list layout, and customize the layout, your code would look something like this:
///
/// ```
/// listView.layout = .list {
///     $0.stickySectionHeaders = true
///
///     $0.layout.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
///     $0.layout.itemSpacing = 10.0
/// }
/// ```
///
/// Or a layout for your own custom layout type would look somewhat like this:
///
/// ```
/// MyCustomLayout.describe {
///     $0.myLayoutOption = true
///     $0.anotherLayoutOption = .polkadots
/// }
/// ```
///
/// Note
/// ----
/// Under the hood, Listable is smart, and will only re-create the underlying
/// layout object when needed (when the layout type or layout appearance changes).
///
public struct LayoutDescription
{
    let configuration : AnyLayoutDescriptionConfiguration
    
    /// Creates a new layout description for the provided layout type, with the provided optional layout configuration.
    public init<LayoutType:ListLayout>(
        layoutType : LayoutType.Type,
        appearance configure : @escaping (inout LayoutType.LayoutAppearance) -> () = { _ in }
    ) {
        self.configuration = Configuration(layoutType: layoutType, configure: configure)
    }
}


public extension ListLayout
{
    /// Creates a new layout description for a list layout, with the provided optional layout configuration.
    static func describe(
        appearance : @escaping (inout Self.LayoutAppearance) -> () = { _ in }
    ) -> LayoutDescription
    {
        return LayoutDescription(
            layoutType: Self.self,
            appearance: appearance
        )
    }
}


extension LayoutDescription
{
    struct Configuration<LayoutType:ListLayout> : AnyLayoutDescriptionConfiguration
    {
        let layoutType : LayoutType.Type
        
        let configure : (inout LayoutType.LayoutAppearance) -> ()
        
        // MARK: AnyLayoutDescriptionConfiguration
        
        public func createEmptyLayout() -> AnyListLayout
        {
            let layoutAppearance = LayoutType.LayoutAppearance.default
            
            return LayoutType(
                layoutAppearance: layoutAppearance,
                appearance: .init(),
                behavior: .init(),
                content: .init()
            )
        }
        
        public func createPopulatedLayout(
            appearance : Appearance,
            behavior: Behavior,
            delegate : CollectionViewLayoutDelegate
        ) -> AnyListLayout
        {
            var layoutAppearance = LayoutType.LayoutAppearance.default
            self.configure(&layoutAppearance)
            
            return LayoutType(
                layoutAppearance: layoutAppearance,
                appearance: appearance,
                behavior: behavior,
                content: delegate.listLayoutContent(defaults: LayoutType.defaults)
            )
        }
        
        public func shouldRebuild(layout anyLayout : AnyListLayout) -> Bool
        {
            let layout = anyLayout as! LayoutType
            let old = layout.layoutAppearance
            
            var new = old
            
            self.configure(&new)
            
            return old != new
        }
        
        public func isSameLayoutType(as anyOther : AnyLayoutDescriptionConfiguration) -> Bool
        {
            guard let other = anyOther as? Self else {
                return false
            }
            
            return self.layoutType == other.layoutType
        }
    }
}


public protocol AnyLayoutDescriptionConfiguration
{
    func createEmptyLayout() -> AnyListLayout
    
    func createPopulatedLayout(
        appearance : Appearance,
        behavior: Behavior,
        delegate : CollectionViewLayoutDelegate
    ) -> AnyListLayout
    
    func shouldRebuild(layout anyLayout : AnyListLayout) -> Bool

    func isSameLayoutType(as other : AnyLayoutDescriptionConfiguration) -> Bool
}
