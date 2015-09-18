/*
 
 PKit.h
 PurchaseKit
 
*/

/*
 
 The MIT License (MIT)
 
 Copyright (c) 2015 Little Man Apps
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
*/

#import <StoreKit/StoreKit.h>
#import <Foundation/Foundation.h>

@interface PKit : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

/*!
 * @discussion A list of product identifiers provided during init. 
 * This property is readonly.
 * @return Array of product identiers set during init.
 */
@property (readonly)  NSArray * _Nonnull productIdentifiers;
/*!
 * @discussion A list of products avalible for purchase
 * @return Array of SKProducts
 */
@property (readonly) NSArray * _Nonnull productList;
/*!
 * @discussion Checks to see if the user is able to make a purchase
 * @return TRUE if user can make a purchase, otherwise FALSE.
 */
@property (readonly) BOOL canMakePurchases;
/*!
 * @discussion Enable this if you would like to know when the user
 * cancels a purchase.
 * @see See ReadMe.md to see how to set this property.
 */
@property BOOL showCancelError;
/*!
 * @discussion Enable this if you would like to know when a purchase
 * fails due to invaild payment.
 * @see See ReadMe.md to see how to set this property.
 */
@property BOOL showInvalidPaymentError;
/*!
 * @discussion Enable this if you do NOT want to receive errors.
 * @see See ReadMe.md to see how to set this property.
 */
@property BOOL noErrorMode;

/// @brief Traditional init unavilable, use initWithIDs or initWithID
- (PKit * _Nonnull)init __unavailable;
/*!
 * @discussion Creates a instance of Purchase Kit (PKit) and initiates 
 * it with the product identifiers for your app located found in 
 * iTunesConnect under your app name. This is a nonnull class.
 * @param IDArray The array of product identifers for your project.
 * @warning This is a NONNULL method, setting it with an empty array 
 * or tricking it with a "false" array will cause it to error and WILL 
 * crash your app.
 * @return Initiates an instance of PKit to be used.
 */
- (PKit * _Nonnull)initWithIDs:(NSArray * _Nonnull)IDArray NS_DESIGNATED_INITIALIZER;
/*!
 * @discussion Creates a instance of Purchase Kit (PKit) and initiates
 * it with the product identifiers for your app located found in
 * iTunesConnect under your app name. This is a nonnull class.
 * @param IDString - A product identifer expressed as a string.
 * @warning This is a NONNULL method, setting it with an empty array
 * or tricking it with a "false" array will cause it to error and WILL
 * crash your app.
 * @return Initiates an instance of PKit to be used.
 */
- (PKit * _Nonnull)initWithID:(NSString * _Nonnull)IDString NS_DESIGNATED_INITIALIZER;
/*!
 * @discussion Creates an empty instance of Purchase Kit (PKit) and
 * initiates it for use in accessing variables only.
 * @warning Using this init for any reason other then variables will
 * cause crashes, errors, and your app to not work correctly.
 * @return Initiates an instance of PKit to be used.
 */
+ (nonnull instancetype)sharedInstance;
/*!
 * @discussion The purchase method, call this to make the initial purchase
 * @param purchaseID This is the product identifer for the object being purchased. This paramater is nonnull.
 * @warning This method will error and crash if you give it a null string.
 */
- (void)makePurchaseWithID:(NSString * _Nonnull)purchaseID;
/*!
 * @discussion Restores all previous purchased items.
 */
- (void)restorePurchases;

@end
