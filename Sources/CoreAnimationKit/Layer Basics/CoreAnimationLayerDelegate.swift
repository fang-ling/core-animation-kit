//===----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------===//
//
//  CoreAnimationLayerDelegate.swift
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

/// Methods your app can implement to respond to layer-related events.
///
/// You can implement the methods of this protocol to provide the layer's content, handle the layout of sublayers, and provide custom animation actions to perform. The object that implements this
/// protocol must be assigned to the ``delegate`` property of the layer object.
///
/// ## Topics
///
/// ### Providing the Layer's Content
///
/// - ``display(_:)``
///
/// ### Laying Out Sublayers
///
/// - ``layoutSublayers(of:)``
public protocol CoreAnimationLayerDelegate: Swift::AnyObject {
  /// Tells the delegate to implement the display process.
  ///
  /// The ``display(_:)`` delegate method is called when the layer is marked for its content to be reloaded, typically initiated by the ``setNeedsDisplay()`` method. The typical technique for updating
  /// is to set the layer's ``contents`` property.
  ///
  /// - Parameter layer: The layer whose contents need updating.
  func display(_ layer: CoreAnimationLayer)

  /// Tells the delegate a layer's bounds have changed.
  ///
  /// The ``layoutSublayers(of:)`` method is called when a layer's bounds have changed and its sublayers may need rearranging, for example by changing its frame's size. You can implement this method
  /// if you need precise control over the layout of your layer's sublayers.
  ///
  /// - Parameter layer: The layer that requires layout of its sublayers.
  func layoutSublayers(of layer: CoreAnimationLayer)
}
