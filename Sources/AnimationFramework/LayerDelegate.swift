//
//  LayerDelegate.swift
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

/// Methods your app can implement to respond to layer-related events.
///
/// You can implement the methods of this protocol to provide the layer's
/// content, handle the layout of sublayers, and provide custom animation
/// actions to perform. The object that implements this protocol must be
/// assigned to the delegate property of the layer object.
@available(macOS 13.3.0, *)
public protocol LayerDelegate: AnyObject {
  /// Tells the delegate to implement the display process.
  ///
  /// The ``display(_:)`` delegate method is called when the layer is marked for
  /// its content to be reloaded, typically initiated by setting
  /// ``needsDisplay`` to `true`. The typical technique for updating is to set
  /// the layer's contents property.
  func display(_ layer: Layer)

  /// Tells the delegate a layer's bounds have changed.
  ///
  /// The ``layoutSublayers(of:)`` method is called when a layer's bounds have
  /// changed and its sublayers may need rearranging, for example by changing
  /// its frame's size. You can implement this method if you need precise
  /// control over the layout of your layer's sublayers.
  ///
  /// - Parameter layer: The layer that requires layout of its sublayers.
  func layoutSublayers(of layer: Layer)
}

@available(macOS 13.3.0, *)
public extension LayerDelegate {
  func display(_ layer: Layer) { }

  func layoutSublayers(of layer: Layer) { }
}
