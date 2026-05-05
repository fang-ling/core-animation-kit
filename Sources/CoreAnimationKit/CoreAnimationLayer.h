/*
 *  CoreAnimationLayer.h
 *  core-animation-kit
 *
 *  Created by Fang Ling on 2026/5/3.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#import <CKit/CKit.h>
#import <CoreFoundationKit/CoreFoundationKit.h>
#import <FoundationKit/FoundationKit.h>
#import <ObjectiveCKit/ObjectiveCKit.h>

#import "CoreAnimationLayerDelegate.h"

C_ASSUME_NONNULL_BEGIN

@interface CoreAnimationLayer: ObjectiveCObject

@property (nonatomic) CUnsignedInteger32 contents;

@property (nonatomic, weak)
  ObjectiveCAnyObject<CoreAnimationLayerDelegate> delegate;

@property (nonatomic) CBoolean needsDisplay;

@property (nonatomic) CBoolean needsLayout;

@property (nonatomic) FoundationMutableArray<CoreAnimationLayer*>* sublayers;

@property (nonatomic, readonly) CoreAnimationLayer* superlayer;

@property (nonatomic) CoreFoundationRectangle frame;

@property (nonatomic) CoreFoundationRectangle bounds;

@property (nonatomic) CoreFoundationPoint position;

@property (nonatomic) CoreFoundationPoint anchorPoint;

@property (nonatomic) CBoolean isHidden;

- (instancetype)init;

- (void)displayIfNeeded;

- (void)layoutIfNeeded;

@end

C_ASSUME_NONNULL_END
