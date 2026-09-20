#!/bin/bash

##===----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------===##
##
##  Lint.sh
##  core-animation-kit
##
##  Created by Fang Ling on 2026/8/30.
##
##  This file is part of the CoreAnimationKit open source project
##
##  Copyright (c) 2026 Fang Ling <fangling@fangl.ing>
##  Licensed under Apache License v2.0
##
##  See LICENSE for license information
##
##  SPDX-License-Identifier: Apache-2.0
##
##===----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------===##

swift-format lint . --parallel --recursive --strict
