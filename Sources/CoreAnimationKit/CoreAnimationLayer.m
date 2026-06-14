/*
 *  CoreAnimationLayer.m
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

#import "CoreAnimationLayer.h"

#import <JavaScriptCoreKit/JavaScriptCoreKit.h>

C_ASSUME_NONNULL_BEGIN

@interface CoreAnimationLayer()

@property (nullable, nonatomic, readwrite) CoreAnimationLayer* superlayer;

@property (nonatomic, readwrite) FoundationMutableArray* sublayers;

@end

@implementation CoreAnimationLayer

- (instancetype)init {
  if (!(self = [super init])) {
    return nil;
  }

  self.contents = -1;

  self.masksToBounds = no;
  self.cornerRadius = 0.0;
  self.needsLayout = yes;
  self.needsDisplay = yes;
  self.isHidden = no;

  self.bounds = (CoreFoundationRectangle){ 0 };
  self.position = (CoreFoundationPoint){ 0 };
  self.anchorPoint = (CoreFoundationPoint){ .x = 0.5, .y = 0.5 };
  self.sublayers = [FoundationMutableArray makeArray];

  return self;
}

- (CoreFoundationRectangle)frame {
  return (CoreFoundationRectangle){
    .origin = {
      .x = self.position.x - self.bounds.size.width * self.anchorPoint.x,
      .y = self.position.y - self.bounds.size.height * self.anchorPoint.y
    },
    .size = {
      .width = self.bounds.size.width,
      .height = self.bounds.size.height
    }
  };
}

- (void)setFrame:(CoreFoundationRectangle)frame {
  self.bounds = (CoreFoundationRectangle){
    .origin = { 0 },
    .size = frame.size
  };
  self.position = (CoreFoundationPoint){
    .x = frame.origin.x + frame.size.width * self.anchorPoint.x,
    .y = frame.origin.y + frame.size.height * self.anchorPoint.y
  };
}

- (void)setCornerRadius:(CFloatingPoint)cornerRadius {
  if (self.cornerRadius != cornerRadius) {
    self.needsDisplay = yes;
  }
  self->_cornerRadius = cornerRadius;
}

- (void)setMasksToBounds:(CBoolean)masksToBounds {
  if (self.masksToBounds != masksToBounds) {
    self.needsDisplay = yes;
  }
  self->_masksToBounds = masksToBounds;
}

- (void)setBounds:(CoreFoundationRectangle)bounds {
  if (!CoreFoundationRectangleEqual(self.bounds, bounds)) {
    self.needsLayout = yes;
    self.needsDisplay = yes;
  }

  self->_bounds = bounds;
}

- (void)setPosition:(CoreFoundationPoint)position {
  if (!CoreFoundationPointEqual(self.position, position)) {
    self.needsDisplay = yes;
  }
  self->_position = position;
}

- (void)setIsHidden:(CBoolean)isHidden {
  if (self.isHidden != isHidden) {
    self.needsDisplay = yes;
  }
  self->_isHidden = isHidden;
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
- (void)display {
  [self.delegate displayLayer:self];
}

- (void)displayIfNeeded {
  if (self.needsDisplay) {
    self.needsDisplay = no;
    [self display];
  }

  for (let i = 0; i < self.sublayers.count; i += 1) {
    let sublayer = (CoreAnimationLayer*)[self.sublayers objectAtIndex:i];
    [sublayer displayIfNeeded];
  }
}

- (void)layoutSublayers {
  /* TODO: Add layoutManager? */
  [self.delegate layoutSublayersOfLayer:self];
}

- (void)layout { /* private */
  if (self.needsLayout) {
    [self layoutSublayers];
    self.needsLayout = no;
  }

  for (let i = 0; i < self.sublayers.count; i += 1) {
    let sublayer = (CoreAnimationLayer*)[self.sublayers objectAtIndex:i];
    [sublayer layout];
  }
}

- (void)layoutIfNeeded {
  let superlayer = self;
  while (yes) {
    let ancestorLayer = superlayer.superlayer;

    if (!ancestorLayer) {
      break;
    }

    if (!ancestorLayer.needsLayout) {
      superlayer = ancestorLayer;
      break;
    }
  }

  [superlayer layout];
}

- (void)removeFromSuperlayer {
  if (self.superlayer == nil) {
    return;
  }

  [self.superlayer.sublayers
   removeAllObjectsWhere:^CBoolean(ObjectiveCAnyObject object) {
    return [object isEqual:self];
  }];

  [JavaScriptCoreContext removeFromSupernode:self.superlayer.contents
                                     forNode:self.contents];

  self.superlayer.needsLayout = yes;
  self.superlayer.needsDisplay = yes;
  self.superlayer = nil;
}

- (void)addSublayer:(CoreAnimationLayer*)layer {
  if (self.sublayers == nil) {
    self.sublayers = [FoundationMutableArray makeArray];
  }

  if (layer.superlayer != self) {
    [layer removeFromSuperlayer];
  }

  [self.sublayers appendObject:layer];

  [JavaScriptCoreContext addSubnode:layer.contents forNode:self.contents];

  layer.superlayer = self;

  self.needsLayout = yes;
}

@end

C_ASSUME_NONNULL_END
