//  Copyright (c) 2016 Indragie Karunaratne. All rights reserved.
//  Licensed under the MIT license, see LICENSE file for more info.

#if os(OSX)
import AppKit
public typealias View = NSView
public typealias LayoutPriority = NSLayoutConstraint.Priority

@available(OSX 10.11, *)
public typealias LayoutGuide = NSLayoutGuide
#elseif os(iOS) || os(tvOS)
import UIKit
public typealias View = UIView
public typealias LayoutPriority = UILayoutPriority

@available(iOS 9.0, *)
public typealias LayoutGuide = UILayoutGuide
#endif

public protocol LayoutRegion: AnyObject {}
extension View: LayoutRegion {}

@available(iOS 9.0, OSX 10.11, *)
extension LayoutGuide: LayoutRegion {}

public struct XAxis {}
public struct YAxis {}
public struct Dimension {}

public struct LayoutItem<C> {
    public let item: AnyObject
    public let attribute: NSLayoutConstraint.Attribute
    public let multiplier: CGFloat
    public let constant: CGFloat

    fileprivate func constrain(_ secondItem: LayoutItem, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relation, toItem: secondItem.item, attribute: secondItem.attribute, multiplier: secondItem.multiplier, constant: secondItem.constant)
    }
    
    fileprivate func constrain(_ constant: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant)
    }
    
    fileprivate func itemWithMultiplier(_ multiplier: CGFloat) -> LayoutItem {
        return LayoutItem(item: self.item, attribute: self.attribute, multiplier: multiplier, constant: self.constant)
    }
    
    fileprivate func itemWithConstant(_ constant: CGFloat) -> LayoutItem {
        return LayoutItem(item: self.item, attribute: self.attribute, multiplier: self.multiplier, constant: constant)
    }
}

public func *<C>(lhs: LayoutItem<C>, rhs: CGFloat) -> LayoutItem<C> {
    return lhs.itemWithMultiplier(lhs.multiplier * rhs)
}

public func /<C>(lhs: LayoutItem<C>, rhs: CGFloat) -> LayoutItem<C> {
    return lhs.itemWithMultiplier(lhs.multiplier / rhs)
}

public func +<C>(lhs: LayoutItem<C>, rhs: CGFloat) -> LayoutItem<C> {
    return lhs.itemWithConstant(lhs.constant + rhs)
}

public func -<C>(lhs: LayoutItem<C>, rhs: CGFloat) -> LayoutItem<C> {
    return lhs.itemWithConstant(lhs.constant - rhs)
}

public func ==<C>(lhs: LayoutItem<C>, rhs: LayoutItem<C>) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .equal)
}

public func ==(lhs: LayoutItem<Dimension>, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .equal)
}

public func >=<C>(lhs: LayoutItem<C>, rhs: LayoutItem<C>) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .greaterThanOrEqual)
}

public func >=(lhs: LayoutItem<Dimension>, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .greaterThanOrEqual)
}

public func <=<C>(lhs: LayoutItem<C>, rhs: LayoutItem<C>) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .lessThanOrEqual)
}

public func <=(lhs: LayoutItem<Dimension>, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .lessThanOrEqual)
}

private func layoutItem<C>(_ item: AnyObject, _ attribute: NSLayoutConstraint.Attribute) -> LayoutItem<C> {
    return LayoutItem(item: item, attribute: attribute, multiplier: 1.0, constant: 0.0)
}

@available(iOS 8.0, *)
public extension LayoutRegion {
    var left: LayoutItem<XAxis> { return layoutItem(self, .left) }
    var right: LayoutItem<XAxis> { return layoutItem(self, .right) }
    var top: LayoutItem<YAxis> { return layoutItem(self, .top) }
    var bottom: LayoutItem<YAxis> { return layoutItem(self, .bottom) }
    var leading: LayoutItem<XAxis> { return layoutItem(self, .leading) }
    var trailing: LayoutItem<XAxis> { return layoutItem(self, .trailing) }
    var width: LayoutItem<Dimension> { return layoutItem(self, .width) }
    var height: LayoutItem<Dimension> { return layoutItem(self, .height) }
    var centerX: LayoutItem<XAxis> { return layoutItem(self, .centerX) }
    var centerY: LayoutItem<YAxis> { return layoutItem(self, .centerY) }
//    var leftMargin: LayoutItem<XAxis> { return layoutItem(self, .leftMargin) }
//    var rightMargin: LayoutItem<XAxis> { return layoutItem(self, .rightMargin) }
//    var topMargin: LayoutItem<YAxis> { return layoutItem(self, .topMargin) }
//    var bottomMargin: LayoutItem<YAxis> { return layoutItem(self, .bottomMargin) }
//    var leadingMargin: LayoutItem<XAxis> { return layoutItem(self, .leadingMargin) }
//    var trailingMargin: LayoutItem<XAxis> { return layoutItem(self, .trailingMargin) }
//    var centerXWithinMargins: LayoutItem<XAxis> { return layoutItem(self, .centerXWithinMargins) }
//    var centerYWithinMargins: LayoutItem<YAxis> { return layoutItem(self, .centerYWithinMargins) }
    var baseline: LayoutItem<YAxis> { return layoutItem(self, .lastBaseline) }
    @available(iOS 8.0, OSX 10.11, *)
    var firstBaseline: LayoutItem<YAxis> { return layoutItem(self, .firstBaseline) }
    var lastBaseline: LayoutItem<YAxis> { return layoutItem(self, .lastBaseline) }
}

#if os(iOS) || os(tvOS)
extension UILayoutSupport {
    @available(iOS, introduced: 7.0, deprecated: 11.0, message: "Use view.safeAreaLayoutGuide")
    public var top: LayoutItem<YAxis> { return layoutItem(self, .top) }
    @available(iOS, introduced: 7.0, deprecated: 11.0, message: "Use view.safeAreaLayoutGuide")
    public var bottom: LayoutItem<YAxis> { return layoutItem(self, .bottom) }
}

public extension UIViewController {
    @available(iOS, introduced: 7.0, deprecated: 11.0, message: "Use view.safeAreaLayoutGuide")
    public var topLayoutGuideTop: LayoutItem<YAxis> {
        return layoutItem(topLayoutGuide, .top)
    }
    
    @available(iOS, introduced: 7.0, deprecated: 11.0, message: "Use view.safeAreaLayoutGuide")
    public var topLayoutGuideBottom: LayoutItem<YAxis> {
        return layoutItem(topLayoutGuide, .bottom)
    }
    
    @available(iOS, introduced: 7.0, deprecated: 11.0, message: "Use view.safeAreaLayoutGuide")
    public var bottomLayoutGuideTop: LayoutItem<YAxis> {
        return layoutItem(bottomLayoutGuide, .top)
    }
    @available(iOS, introduced: 7.0, deprecated: 11.0, message: "Use view.safeAreaLayoutGuide")
    public var bottomLayoutGuideBottom: LayoutItem<YAxis> {
        return layoutItem(bottomLayoutGuide, .bottom)
    }
}
#endif

precedencegroup PriorityPrecedence {
    lowerThan: ComparisonPrecedence
    higherThan: AssignmentPrecedence
}

infix operator ~ : PriorityPrecedence

public func ~ (lhs: NSLayoutConstraint, rhs: Float) -> NSLayoutConstraint {
    guard let firstItem = lhs.firstItem else {
        assert(false, "first item can't be nil")
        return NSLayoutConstraint()
    }
    let newConstraint = NSLayoutConstraint(item: firstItem, attribute: lhs.firstAttribute, relatedBy: lhs.relation, toItem: lhs.secondItem, attribute: lhs.secondAttribute, multiplier: lhs.multiplier, constant: lhs.constant)
    newConstraint.priority = LayoutPriority(rawValue: rhs)
    return newConstraint
}
