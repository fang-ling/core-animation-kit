#!/bin/bash

##===----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------===##
##
##  PreviewDocumentation.sh
##  core-animation-kit
##
##  Created by Fang Ling on 2026/8/30.
##
##  This file is part of the CoreAnimationKit open source project
##
##  Copyright (c) 2025-2026 Fang Ling <fangling@fangl.ing>
##  Licensed under Apache License v2.0
##
##  See LICENSE for license information
##
##  SPDX-License-Identifier: Apache-2.0
##
##===----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------===##

SYMBOLS_FOLDER="/dev/shm/symbol-graphs"
OUTPUT_FOLDER="/dev/shm/docc"

swift build --target CoreAnimationKit -Xswiftc -emit-symbol-graph -Xswiftc -emit-symbol-graph-dir -Xswiftc $SYMBOLS_FOLDER

docc convert Sources/CoreAnimationKit/Documentation.docc -o $OUTPUT_FOLDER --additional-symbol-graph-dir $SYMBOLS_FOLDER

echo "========================================"
echo "Starting Local Preview Server"
echo "    Address: http://"$(ip route get 1.1.1.1 | grep -oP '(?<=src\s)\d+(\.\d+){3}')"/documentation/coreanimationkit"
echo "========================================"

python3 -m http.server 80 --directory $OUTPUT_FOLDER
