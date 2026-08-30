//===----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------===//
//
//  CoreAnimationLayer.swift
//  core-animation-kit
//
//  Created by Fang Ling on 2026/5/3.
//
//  This source file is part of the CoreAnimationKit open source project
//
//  Copyright (c) 2026 Fang Ling <fangling@fangl.ing>
//  Licensed under Apache License v2.0
//
//  See LICENSE for license information
//
//  SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------===//

import CKit
import CoreGraphicsKit
import FoundationKit
import JavaScriptCoreKit

/// An object that manages DOM-based content and allows you to perform animations on that content.
///
/// Layers are often used to provide the backing store for views but can also be used without a view to display content. A layer's main job is to manage the visual content that you provide but the
/// layer itself has visual attributes that can be set, such as a background color, border, and shadow. In addition to managing visual content, the layer also maintains information about the geometry
/// of its content (such as its position, size, and transform) that is used to present that content onscreen. Modifying the properties of the layer is how you initiate animations on the layer's
/// content or geometry. A layer object encapsulates the duration and pacing of a layer and its animations by adopting the ``CoreAnimationMediaTiming`` protocol, which defines the layer's timing
/// information.
///
/// If the layer object was created by a view, the view typically assigns itself as the layer's delegate automatically, and you should not change that relationship. For layers you create yourself, you
/// can assign a delegate object and use that object to provide the contents of the layer dynamically and perform other tasks. A layer may also have a layout manager object (assigned to the
/// ``layoutManager`` property) to manage the layout of subviews separately.
///
/// ## Topics
///
/// ### Creating a layer
///
/// - ``init()``
///
/// ### Accessing the delegate
///
/// - ``delegate``
///
/// ### Providing the layer's content
///
/// - ``display()``
///
/// ### Modifying the layer's appearance
///
/// - ``isHidden``
/// - ``masksToBounds``
/// - ``cornerRadius``
/// - ``backgroundColor``
///
/// ### Modifying the layer geometry
///
/// - ``frame``
/// - ``bounds``
/// - ``position``
/// - ``anchorPoint``
///
/// ### Managing the layer hierarchy
///
/// - ``sublayers``
/// - ``superlayer``
/// - ``addSublayer(_:)``
/// - ``removeFromSuperlayer()``
/// - ``insertSublayer(_:at:)``
///
/// ### Updating layer display
///
/// - ``setNeedsDisplay()``
/// - ``displayIfNeeded()``
/// - ``needsDisplay``
///
/// ### Managing layer resizing and layout
///
/// - ``setNeedsLayout()``
/// - ``layoutIfNeeded()``
/// - ``layoutSublayers()``
/// - ``needsLayout``
open class CoreAnimationLayer {
  private class var _nodeKind: _JavaScriptCoreNode.Kind {
    return .division
  }

  private var _node: _JavaScriptCoreNode

  /// The layer's delegate object.
  ///
  /// You can use a delegate object to provide the layer's contents, handle the layout of any sublayers, and provide custom actions in response to layer-related changes. The object you assign to this
  /// property should implement one or more of the methods of the ``CoreAnimationLayerDelegate`` informal protocol. For more information about that protocol, see ``CoreAnimationLayerDelegate``.
  ///
  /// If the layer is associated with a ``UIView`` object, this property _must_ be set to the view that owns the layer.
  public weak var delegate: (any CoreAnimationLayerDelegate)?

  /// A Boolean indicating whether the layer is displayed (animatable).
  ///
  /// The default value of this property is `false`.
  public var isHidden: CBoolean {
    didSet {
      if self.isHidden != oldValue {
        self.needsDisplay = true
      }
    }
  }

  /// A Boolean indicating whether sublayers are clipped to the layer's bounds (animatable).
  ///
  /// When the value of this property is `true`, CoreAnimationKit creates an implicit clipping mask that matches the bounds of the layer and includes any corner radius effects. If a value for the
  /// ``mask`` property is also specified, the two masks are multiplied to get the final mask value.
  ///
  /// The default value of this property is `false`.
  public var masksToBounds: CBoolean {
    didSet {
      if self.masksToBounds != oldValue {
        self.needsDisplay = true
      }
    }
  }

  // FIXME: When masksToBounds is off, this does not match the CSS.
  /// The radius to use when drawing rounded corners for the layer's background (animatable).
  ///
  /// Setting the radius to a value greater than `0.0` causes the layer to begin drawing rounded corners on its background. By default, the corner radius does not apply to the image in the layer's
  /// ``contents`` property; it applies only to the background color and border of the layer. However, setting the ``masksToBounds`` property to `true` causes the content to be clipped to the rounded
  /// corners.
  ///
  /// The default value of this property is `0.0`.
  public var cornerRadius: CFloatingPoint64 {
    didSet {
      if self.cornerRadius != oldValue {
        self.needsDisplay = true
      }
    }
  }

  /// The background color of the receiver (animatable).
  ///
  /// The default value of this property is `nil`.
  public var backgroundColor: Any?  // TODO: Use CoreGraphicsColor, didSet.

  /// The layer's frame rectangle.
  ///
  /// The frame rectangle is position and size of the layer specified in the superlayer's coordinate space. For layers, the frame rectangle is a computed property that is derived from the values in
  /// the ``bounds``, ``anchorPoint`` and ``position`` properties. When you assign a new value to this property, the layer changes its ``position`` and ``bounds`` properties to match the rectangle you
  /// specified. The values of each coordinate in the rectangle are measured in pixels.
  ///
  /// Do not set the frame if the ``transform`` property applies a rotation transform that is not a multiple of 90 degrees.
  ///
  /// > Note: The ``frame`` property is not directly animatable. Instead you should animate the appropriate combination of the ``bounds``, ``anchorPoint`` and ``position`` properties to achieve the
  ///   desired result.
  public var frame: CoreGraphicsRectangle {
    get {
      return CoreGraphicsRectangle(
        x: self.position.x - self.bounds.size.width * self.anchorPoint.x,
        y: self.position.y - self.bounds.size.height * self.anchorPoint.y,
        width: self.bounds.size.width,
        height: self.bounds.size.height
      )
    }

    set {
      self.position = CoreGraphicsPoint(x: newValue.origin.x + newValue.size.width * self.anchorPoint.x, y: newValue.origin.y + newValue.size.height * self.anchorPoint.y)
      self.bounds = CoreGraphicsRectangle(x: 0, y: 0, width: newValue.size.width, height: newValue.size.height)
    }
  }

  /// The layer's bounds rectangle (animatable).
  ///
  /// The bounds rectangle is the origin and size of the layer in its own coordinate space. When you create a new standalone layer, the default value for this property is an empty rectangle, which you
  /// must change before using the layer. The values of each coordinate in the rectangle are measured in pixels.
  public var bounds: CoreGraphicsRectangle {
    didSet {
      if self.bounds != oldValue {
        self.setNeedsLayout()
        self.setNeedsDisplay()
      }
    }
  }

  /// The layer's position in its superlayer's coordinate space (animatable).
  ///
  /// The value of this property is specified in pixels and is always specified relative to the value in the ``anchorPoint`` property. For new standalone layers, the default position is set to
  /// `(0.0, 0.0)`. Changing the ``frame`` property also updates the value in this property.
  public var position: CoreGraphicsPoint {
    didSet {
      if self.position != oldValue {
        self.setNeedsDisplay()
      }
    }
  }

  /// Defines the anchor point of the layer's bounds rectangle (animatable).
  ///
  /// You specify the value for this property using the unit coordinate space. The default value of this property is `(0.5, 0.5)`, which represents the center of the layer's bounds rectangle. All
  /// geometric manipulations to the view occur about the specified point. For example, applying a rotation transform to a layer with the default anchor point causes the layer to rotate around its
  /// center. Changing the anchor point to a different location would cause the layer to rotate around that new point.
  public var anchorPoint: CoreGraphicsPoint  // TODO: didSet?

  /// An array containing the layer's sublayers.
  ///
  /// The sublayers are listed in back to front order. The default value of this property is `nil`.
  ///
  /// ### Special Considerations
  ///
  /// When setting the ``sublayers`` property to an array populated with layer objects, each layer in the array must not already have a superlayer—that is, its ``superlayer`` property must currently
  /// be `nil`.
  public var sublayers: FoundationArray<CoreAnimationLayer>?

  /// The superlayer of the layer.
  ///
  /// The superlayer manages the layout of its sublayers.
  public private(set) var superlayer: CoreAnimationLayer?  // TODO: store property, weak?

  /// A Boolean indicating whether the layer has been marked as needing an update.
  public private(set) var needsDisplay: CBoolean

  /// A Boolean indicating whether the layer has been marked as needing a layout update.
  public private(set) var needsLayout: CBoolean

  /// Creates an initialized ``CoreAnimationLayer`` object.
  ///
  /// This is the designated initializer for layer objects.
  public required init() {
    self._node = _JavaScriptCoreNode(kind: Self._nodeKind)

    self.isHidden = false
    self.masksToBounds = false
    self.cornerRadius = 0.0
    self.backgroundColor = nil

    self.bounds = CoreGraphicsRectangle(x: 0, y: 0, width: 0, height: 0)
    self.position = CoreGraphicsPoint(x: 0, y: 0)
    self.anchorPoint = CoreGraphicsPoint(x: 0.5, y: 0.5)

    self.sublayers = nil

    self.needsDisplay = true
    self.needsLayout = true
  }

  /// Reloads the content of this layer.
  ///
  /// Do not call this method directly. The layer calls this method at appropriate times to update the layer's content. If the layer has a delegate object, this method attempts to call the delegate's
  /// ``display(_:)`` method, which the delegate can use to update the layer's contents. If the delegate does not implement the ``display(_:)`` method, this method creates a backing store and calls
  /// the layer's ``draw(in:)`` method to fill that backing store with content. The new backing store replaces the previous contents of the layer.
  ///
  /// Subclasses can override this method and use it to set the layer's contents property directly. You might do this if your custom layer subclass handles layer updates differently.
  public func display() {
    // FIXME: No way to the `draw(in:)` branch.
    self.delegate?.display(self)
  }

  /// Appends the layer to the layer's list of sublayers.
  ///
  /// If the array in the sublayers property is `nil`, calling this method creates an array for that property and adds the specified layer to it.
  ///
  /// - Parameter layer: The layer to be added.
  public func addSublayer(_ layer: CoreAnimationLayer) {
    if self.sublayers == nil {
      self.sublayers = []
    }

    if layer.superlayer !== self {
      layer.removeFromSuperlayer()
    }

    self.sublayers?.append(layer)

    // [self.contents addSubnode:layer.contents];

    layer.superlayer = self

    self.needsLayout = true
  }

  /// Detaches the layer from its parent layer.
  ///
  /// You can use this method to remove a layer (and all of its sublayers) from a layer hierarchy. This method updates both the superlayer's list of sublayers and sets this layer's ``superlayer``
  /// property to `nil`.
  public func removeFromSuperlayer() {
    if self.superlayer == nil {
      return
    }

    self.superlayer?.sublayers?.removeAll(where: { $0 === self })

    // [self.contents removeFromSupernode];

    self.superlayer?.needsLayout = true
    self.superlayer?.needsDisplay = true
    self.superlayer = nil
  }

  /// Inserts the specified layer into the receiver's list of sublayers at the specified index.
  ///
  /// - Parameters:
  ///   - layer: The sublayer to be inserted into the current layer.
  ///   - index: The index at which to insert aLayer. This value must be a valid 0-based index into the ``sublayers`` array.
  public func insertSublayer(_ layer: CoreAnimationLayer, at index: CInteger) {
    if self.sublayers == nil {
      self.sublayers = []
    }

    if layer.superlayer !== self {
      layer.removeFromSuperlayer()
    }

    self.sublayers?.insert(layer, at: index)

    // [self.contents insertSubnode:layer.contents atIndex:index];

    layer.superlayer = self

    self.needsLayout = true
  }

  /// Marks the layer's contents as needing to be updated.
  ///
  /// Calling this method causes the layer to recache its content. This results in the layer potentially calling either the ``display(_:)`` or ``draw(_:in:)`` method of its delegate. The existing
  /// content in the layer's contents property is removed to make way for the new content.
  public func setNeedsDisplay() {
    self.needsDisplay = true
  }

  /// Initiates the update process for a layer if it is currently marked as needing an update.
  ///
  /// You can call this method as needed to force an update to your layer's contents outside of the normal update cycle. Doing so is generally not needed, though. The preferred way to update a layer
  /// is to call ``setNeedsDisplay()`` and let the system update the layer during the next cycle.
  public func displayIfNeeded() {
    if self.needsDisplay {
      self.needsDisplay = false
      self.display()
    }

    for sublayer in self.sublayers ?? [] {
      sublayer.displayIfNeeded()
    }
  }

  /// Invalidates the layer's layout and marks it as needing an update.
  ///
  /// You can call this method to indicate that the layout of a layer's sublayers has changed and must be updated. The system typically calls this method automatically when the layer's bounds change
  /// or when sublayers are added or removed. If your layer's ``layoutManager`` property contains an object that implements the ``invalidateLayout(of:)`` method, the system calls that method too.
  ///
  /// During the next update cycle, the system calls the ``layoutSublayers()`` method of any layers requiring layout updates.
  public func setNeedsLayout() {
    self.needsLayout = true
  }

  /// Tells the layer to update its layout.
  ///
  /// Subclasses can override this method and use it to implement their own layout algorithm. Your implementation must set the frame of each sublayer managed by the receiver.
  ///
  /// The default implementation of this method calls the ``layoutSublayers(of:)`` method of the layer's delegate object. If there is no delegate object, or the delegate does not implement that
  /// method, this method calls the ``layoutSublayers(of:)`` method of the object in the ``layoutManager`` property.
  public func layoutSublayers() {
    if let delegate = self.delegate {
      delegate.layoutSublayers(of: self)
    } else {
      // TODO: Add layoutManager.
    }
  }

  /// Recalculate the receiver's layout, if required.
  ///
  /// When this message is received, the layer's super layers are traversed until a ancestor layer is found that does not require layout. Then layout is performed on the entire layer-tree beneath that
  /// ancestor.
  public func layoutIfNeeded() {
    var superlayer = self
    while true {
      guard let ancestorLayer = superlayer.superlayer else {
        break
      }

      if !ancestorLayer.needsLayout {
        superlayer = ancestorLayer

        break
      }
    }

    superlayer._layout()
  }
}

extension CoreAnimationLayer {
  private func _layout() {
    if self.needsLayout {
      self.layoutSublayers()
      self.needsLayout = false
    }

    for sublayer in self.sublayers ?? [] {
      sublayer._layout()
    }
  }
}
