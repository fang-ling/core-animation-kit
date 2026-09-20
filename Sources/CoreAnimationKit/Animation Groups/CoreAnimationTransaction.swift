//===----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------===//
//
//  CoreAnimationTransaction.swift
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

/// A mechanism for grouping multiple layer-tree operations into atomic updates to the render tree.
///
/// ``CoreAnimationTransaction`` is the CoreAnimationKit mechanism for batching multiple layer-tree operations into atomic updates to the render tree. Every modification to a layer tree must be part
/// of a transaction. Nested transactions are supported.
///
/// CoreAnimationKit supports two types of transactions: _implicit_ transactions and _explicit_ transactions. Implicit transactions are created automatically when the layer tree is modified by a
/// thread without an active transaction and are committed automatically when the thread's runloop next iterates. Explicit transactions occur when the the application calls the ``begin()`` method of
/// ``CoreAnimationTransaction`` class before modifying the layer tree, and a ``commit()`` method call afterwards.
///
/// ``CoreAnimationTransaction`` allows you to override default animation properties that are set for animatable properties. You can customize duration, timing function, whether changes to properties
/// trigger animations, and provide a handler that informs you when all animations from the transaction group are completed.
///
/// During a transaction you can temporarily acquire a recursive spin lock for managing property atomicity.
@MainActor
public class CoreAnimationTransaction {
  // TODO: This isn't how Apple's UIKit works. In real UIKit, it uses `CAContext` together with `CATransaction`, but it's too complicated to implement right now.
  public class func _flush(with layer: CoreAnimationLayer) {
    layer.layoutIfNeeded()
    layer.displayIfNeeded()
  }
}
