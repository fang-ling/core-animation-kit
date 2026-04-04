// swift-tools-version: 6.2

//
//  Package.swift
//  animation-framework
//
//  Created by Fang Ling on 2026/3/28.
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

import PackageDescription

let dependencies = [
  ("https://github.com/fang-ling/foundation-framework", "snapshot"),
  ("https://github.com/fang-ling/javascript-bridge-framework", "snapshot")
]

let package = Package(
  name: "animation-framework",
  products: [
    .library(name: "AnimationFramework", targets: ["AnimationFramework"])
  ],
  dependencies: dependencies.map({ .package(url: $0.0, branch: $0.1) }),
  targets: [
    .target(
      name: "AnimationFramework",
      dependencies: [
        .product(name: "FoundationFramework", package: "foundation-framework"),
        .product(
          name: "JavaScriptBridgeFramework",
          package: "javascript-bridge-framework"
        )
      ],
    )
  ]
)
