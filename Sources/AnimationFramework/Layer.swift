//
//  Layer.swift
//  animation-framework
//
//  Created by Fang Ling on 2026/3/29.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import FoundationFramework
import JavaScriptBridgeFramework

/// An object that manages image-based content and allows you to perform
/// animations on that content.
///
/// Layers are often used to provide the backing store for views but can also be
/// used without a view to display content. A layer's main job is to manage the
/// visual content that you provide but the layer itself has visual attributes
/// that can be set, such as a background color, border, and shadow. In addition
/// to managing visual content, the layer also maintains information about the
/// geometry of its content (such as its position, size, and transform) that is
/// used to present that content onscreen. Modifying the properties of the layer
/// is how you initiate animations on the layer's content or geometry. A layer
/// object encapsulates the duration and pacing of a layer and its animations by
/// adopting the ``MediaTiming`` protocol, which defines the layer's timing
/// information.
///
/// If the layer object was created by a view, the view typically assigns itself
/// as the layer's delegate automatically, and you should not change that
/// relationship. For layers you create yourself, you can assign a ``delegate``
/// object and use that object to provide the contents of the layer dynamically
/// and perform other tasks. A layer may also have a layout manager object
/// (assigned to the ``layoutManager`` property) to manage the layout of
/// subviews separately.
@available(macOS 13.3.0, *)
public class Layer {
  /// An object that provides the contents of the layer. Animatable.
  ///
  /// If the layer object is tied to a view object, you should avoid setting the
  /// contents of this property directly. The interplay between views and layers
  /// usually results in the view replacing the contents of this property during
  /// a subsequent update.
  public var contents: UUID

  /// The layer's delegate object.
  ///
  /// You can use a delegate object to provide the layer's contents, handle the
  /// layout of any sublayers, and provide custom actions in response to
  /// layer-related changes. The object you assign to this property should
  /// implement one or more of the methods of the ``LayerDelegate`` informal
  /// protocol.
  ///
  /// If the layer is associated with a ``View`` object, this property must be
  /// set to the view that owns the layer.
  public weak var delegate: (any LayerDelegate)?

  /// A Boolean value indicating whether the layer has been marked as needing an
  /// update.
  public var needsDisplay = true

  /// A Boolean value indicating whether the layer has been marked as needing a
  /// layout update.
  ///
  /// You can call this method to indicate that the layout of a layer's
  /// sublayers has changed and must be updated. The system typically calls this
  /// method automatically when the layer's bounds change or when sublayers are
  /// added or removed.
  ///
  /// During the next update cycle, the system calls the ``layoutSublayers()``
  /// method of any layers requiring layout updates.
  public var needsLayout = true

  /// An array containing the layer's sublayers.
  ///
  /// The sublayers are listed in back to front order. The default value of this
  /// property is `nil`.
  ///
  /// > Important: When setting the sublayers property to an array populated
  ///   with layer objects, each layer in the array must not already have a
  ///   superlayer—that is, its superlayer property must currently be `nil`.
  var sublayers: [Layer]? // TODO: Use FoundationFramework's array

  /// The superlayer of the layer.
  ///
  /// The superlayer manages the layout of its sublayers.
  var superlayer: Layer?

  /// The layer's frame rectangle.
  ///
  /// The frame rectangle is position and size of the layer specified in the
  /// superlayer's coordinate space. For layers, the frame rectangle is a
  /// computed property that is derived from the values in the ``bounds``,
  /// ``anchorPoint`` and ``position`` properties. When you assign a new value
  /// to this property, the layer changes its ``position`` and ``bounds``
  /// properties to match the rectangle you specified. The values of each
  /// coordinate in the rectangle are measured in pixels.
  ///
  /// Do not set the frame if the ``transform`` property applies a rotation
  /// transform that is not a multiple of 90 degrees.
  ///
  /// > Note: The frame property is not directly animatable. Instead you should
  ///   animate the appropriate combination of the ``bounds``, ``anchorPoint``
  ///   and ``position`` properties to achieve the desired result.
  public var frame: Rectangle {
    get {
      Rectangle(
        x: position.x - bounds.size.width * anchorPoint.x,
        y: position.y - bounds.size.height * anchorPoint.y,
        width: bounds.size.width,
        height: bounds.size.height
      )
    }
    set {
      bounds = Rectangle(origin: .zero, size: newValue.size)
      position = Point(
        x: newValue.origin.x + newValue.size.width * anchorPoint.x,
        y: newValue.origin.y + newValue.size.height * anchorPoint.y
      )
    }
  }

  /// The layer's bounds rectangle. Animatable.
  ///
  /// The bounds rectangle is the origin and size of the layer in its own
  /// coordinate space. When you create a new standalone layer, the default
  /// value for this property is an empty rectangle, which you must change
  /// before using the layer. The values of each coordinate in the rectangle are
  /// measured in pixels.
  public var bounds = Rectangle.zero {
    didSet {
      if oldValue != bounds {
        needsLayout = true
        needsDisplay = true
      }
    }
  }

  /// The layer's position in its superlayer's coordinate space. Animatable.
  ///
  /// The value of this property is specified in points and is always specified
  /// relative to the value in the ``anchorPoint`` property. For new standalone
  /// layers, the default position is set to `(0.0, 0.0)`. Changing the
  /// ``frame`` property also updates the value in this property.
  var position = Point.zero {
    didSet {
      if oldValue != position {
        needsDisplay = true
      }
    }
  }

  /// Defines the anchor point of the layer's bounds rectangle. Animatable.
  ///
  /// You specify the value for this property using the unit coordinate space.
  /// The default value of this property is `(0.5, 0.5)`, which represents the
  /// center of the layer's bounds rectangle. All geometric manipulations to the
  /// view occur about the specified point. For example, applying a rotation
  /// transform to a layer with the default anchor point causes the layer to
  /// rotate around its center. Changing the anchor point to a different
  /// location would cause the layer to rotate around that new point.
  var anchorPoint = Point(x: 0.5, y: 0.5)

  /// A Boolean value indicating whether the layer is displayed. Animatable.
  open var isHidden = false {
    didSet {
      if isHidden != oldValue {
        needsDisplay = true
      }
    }
  }

  /// Creates an initialized ``Layer`` object.
  public init() {
    contents = UUID()
  }

  /// Initiates the update process for a layer if it is currently marked as
  /// needing an update.
  ///
  /// You can call this method as needed to force an update to your layer's
  /// contents outside of the normal update cycle. Doing so is generally not
  /// needed, though. The preferred way to update a layer is to set
  /// ``needsDisplay`` to `true` and let the system update the layer during the
  /// next cycle.
  public func displayIfNeeded() {
    if needsDisplay {
      needsDisplay = false
      display()
    }

    sublayers?.forEach { sublayer in
      sublayer.displayIfNeeded()
    }
  }

  /// Reloads the content of this layer.
  ///
  /// Do not call this method directly. The layer calls this method at
  /// appropriate times to update the layer's content. If the layer has a
  /// delegate object, this method attempts to call the delegate's
  /// ``display(_:)`` method, which the delegate can use to update the layer's
  /// contents.
  ///
  /// Subclasses can override this method and use it to set the layer's
  /// ``contents`` property directly. You might do this if your custom layer
  /// subclass handles layer updates differently.
  func display() {
    delegate?.display(self)
  }

  /// Recalculate the receiver's layout, if required.
  ///
  /// When this message is received, the layer's super layers are traversed
  /// until a ancestor layer is found that does not require layout. Then layout
  /// is performed on the entire layer-tree beneath that ancestor.
  public func layoutIfNeeded() {
    var superlayer = self
    while let ancestorLayer = superlayer.superlayer {
      if !ancestorLayer.needsLayout {
        superlayer = ancestorLayer
        break
      }
    }

    superlayer.layout()
  }

  private func layout() {
    if needsLayout {
      layoutSublayers()
      needsLayout = false
    }

    sublayers?.forEach { sublayer in
      sublayer.layout()
    }
  }

  /// Tells the layer to update its layout.
  ///
  /// Subclasses can override this method and use it to implement their own
  /// layout algorithm. Your implementation must set the frame of each sublayer
  ///  managed by the receiver.
  ///
  /// The default implementation of this method calls the
  /// ``layoutSublayers(of:)`` method of the layer's delegate object. If there
  /// is no delegate object, or the delegate does not implement that method,
  /// this method calls the layoutSublayers(of:) method ``layoutManager``
  /// property.
  func layoutSublayers() {
    // TODO: Add layoutManager?
    delegate?.layoutSublayers(of: self)
  }

  /// Appends the layer to the layer's list of sublayers.
  ///
  /// If the array in the sublayers property is `nil`, calling this method
  /// creates an array for that property and adds the specified layer to it.
  ///
  /// - Parameter layer: The layer to be added.
  public func addSublayer(_ layer: Layer) {
    if sublayers == nil {
      sublayers = []
    }

    if layer.superlayer !== self {
      layer.removeFromSuperlayer()
    }

    sublayers?.append(layer)

    JavaScriptBridge.linkElements(elementID: layer.contents, parentID: contents)

    layer.superlayer = self

    needsLayout = true
  }

  /// Detaches the layer from its parent layer.
  ///
  /// You can use this method to remove a layer (and all of its sublayers) from
  /// a layer hierarchy. This method updates both the superlayer's list of
  /// sublayers and sets this layer's superlayer property to `nil`.
  public func removeFromSuperlayer() {
    guard
      let index = superlayer?.sublayers?.firstIndex(where: { $0 === self })
    else {
      return
    }
    superlayer?.sublayers?.remove(at: index)
    superlayer = nil

    superlayer?.needsLayout = true
    superlayer?.needsDisplay = true
  }
}
