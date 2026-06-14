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

#import "CoreAnimationLayerDelegate.h"

#import <CKit/CKit.h>
#import <CoreFoundationKit/CoreFoundationKit.h>
#import <FoundationKit/FoundationKit.h>
#import <ObjectiveCKit/ObjectiveCKit.h>

C_ASSUME_NONNULL_BEGIN

/**
 * An object that manages DOM-based content and allows you to perform animations
 * on that content.
 *
 * Layers are often used to provide the backing store for views but can also be
 * used without a view to display content. A layer's main job is to manage the
 * visual content that you provide but the layer itself has visual attributes
 * that can be set, such as a background color, border, and shadow. In addition
 * to managing visual content, the layer also maintains information about the
 * geometry of its content (such as its position, size, and transform) that is
 * used to present that content onscreen. Modifying the properties of the layer
 * is how you initiate animations on the layer's content or geometry. A layer
 * object encapsulates the duration and pacing of a layer and its animations by
 * adopting the ``CAMediaTiming`` protocol, which defines the layer's timing
 * information.
 *
 * If the layer object was created by a view, the view typically assigns itself
 * as the layer's delegate automatically, and you should not change that
 * relationship. For layers you create yourself, you can assign a delegate
 * object and use that object to provide the contents of the layer dynamically
 * and perform other tasks. A layer may also have a layout manager object
 * (assigned to the layoutManager property) to manage the layout of subviews
 * separately.
 *
 * ## Topics
 *
 * ### Modifying the layer's appearance
 *
 * - ``masksToBounds``
 * - ``cornerRadius``
 *
 * ### Managing the layer hierarchy
 *
 * - ``superlayer``
 * - ``removeFromSuperlayer``
 */
@interface CoreAnimationLayer: ObjectiveCObject

@property (nonatomic) CUnsignedInteger32 contents;

@property (nonatomic, weak)
  ObjectiveCAnyObject<CoreAnimationLayerDelegate> delegate;

/**
 * A Boolean indicating whether sublayers are clipped to the layer's bounds.
 * Animatable.
 *
 * When the value of this property is `yes`, CoreAnimation creates an implicit
 * clipping mask that matches the bounds of the layer and includes any corner
 * radius effects. If a value for the ``mask`` property is also specified, the
 * two masks are multiplied to get the final mask value.
 *
 * The default value of this property is `no`.
 */
@property (nonatomic) CBoolean masksToBounds;

/**
 * The radius to use when drawing rounded corners for the layer's background.
 * Animatable.
 *
 * Setting the radius to a value greater than `0.0` causes the layer to begin
 * drawing rounded corners on its background. By default, the corner radius does
 * not apply to the content in the layer's ``contents`` property; it applies
 * only to the background color and border of the layer. However, setting the
 * ``masksToBounds`` property to `yes` causes the content to be clipped to the
 * rounded corners.
 *
 * The default value of this property is `0.0`.
 */
@property (nonatomic) CFloatingPoint cornerRadius;
/* FIXME: When masksToBounds is off, this does not match the CSS. */

@property (nonatomic) CBoolean needsDisplay;

@property (nonatomic) CBoolean needsLayout;

/**
 * The superlayer of the layer.
 *
 * The superlayer manages the layout of its sublayers.
 */
@property (nullable, nonatomic, readonly) CoreAnimationLayer* superlayer;

@property (nonatomic, readonly) FoundationMutableArray* sublayers;

@property (nonatomic) CoreFoundationRectangle frame;

@property (nonatomic) CoreFoundationRectangle bounds;

@property (nonatomic) CoreFoundationPoint position;

@property (nonatomic) CoreFoundationPoint anchorPoint;

@property (nonatomic) CBoolean isHidden;

/**
 * Returns an initialized ``CoreAnimationLayer`` object.
 *
 * This is the designated initializer for layer objects
 */
- (instancetype)init;

- (void)displayIfNeeded;

- (void)layoutIfNeeded;

/**
 * Appends the layer to the layer's list of sublayers.
 *
 * If the array in the sublayers property is `nil`, calling this method creates
 * an array for that property and adds the specified layer to it.
 *
 * - Parameter layer: The layer to be added.
 */
- (void)addSublayer:(CoreAnimationLayer*)layer;

/**
 * Detaches the layer from its parent layer.
 *
 * You can use this method to remove a layer (and all of its sublayers) from a
 * layer hierarchy. This method updates both the superlayer's list of sublayers
 * and sets this layer's superlayer property to `nil`.
 */
- (void)removeFromSuperlayer;

@end

C_ASSUME_NONNULL_END
