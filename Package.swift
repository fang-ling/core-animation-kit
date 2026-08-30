// swift-tools-version: 6.3

//===----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------===//
//
//  Package.swift
//  core-animation-kit
//
//  Created by Fang Ling on 2026/3/28.
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

import PackageDescription

let isDevelopment = false

let dependencies = [
  ("c-kit", "CKit", "main"),
  ("core-graphics-kit", "CoreGraphicsKit", "main"),
  ("foundation-kit", "FoundationKit", "main"),
  ("java-script-core-kit", "JavaScriptCoreKit", "main")
]

let package = Package(
  name: "core-animation-kit",
  products: [
    .library(name: "CoreAnimationKit", targets: ["CoreAnimationKit"])
  ],
  dependencies: dependencies.map{ isDevelopment ? .package(path: "../\($0.0)") : .package(url: "https://github.com/fang-ling/\($0.0)", branch: $0.2) },
  targets: [
    .target(
      name: "CoreAnimationKit",
      dependencies: dependencies.map { .product(name: $0.1, package: $0.0) }
    )
  ]
)
