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
  /// Tells the delegate to implement the display process using the layer's
  /// context.
  ///
  /// The ``draw(_:)`` method is called when the layer is marked for its content
  /// to be reloaded, typically with setting ``needsDisplay`` to `true`.
  ///
  /// - Parameter layer: The layer whose contents need to be drawn.
  func draw(_ layer: Layer)
}

@available(macOS 13.3.0, *)
public extension LayerDelegate {
  func draw(_ layer: Layer) { }
}
