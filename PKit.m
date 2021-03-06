/*

 PKit.m
 PurchaseKit 2.0
 
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

#import "PKit.h"

typedef NS_ENUM(int, UserCancelError) {
    kShowCancelError = 0,
    kDoNotShowCancelError = 1
};

typedef NS_ENUM(int, UserPaymentError) {
    kShowPaymentError = 0,
    kDoNotShowPaymentError = 1
};

@interface PKit () {
    NSString *purchaseWithID;
    NSInteger cancelError;
    NSInteger paymentError;
    NSMutableSet *purchasedProductsIDs;
}

@end

@implementation PKit

@synthesize productIdentifiers;
@synthesize productList;
@synthesize canMakePurchases;
@synthesize showCancelError;
@synthesize showInvalidPaymentError;
@synthesize noErrorMode;

+ (instancetype)sharedInstance {
    static PKit *sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [(PKit *)[self alloc] initWithID:@"VARINIT"];
    }
    return sharedInstance;
}


- (id)initWithIDs:(NSArray *)IDArray {
    self = [super init];
    if (self) {
        productIdentifiers = IDArray;
        if (showCancelError) {
            cancelError = kShowCancelError;
        } else {
            cancelError = kDoNotShowCancelError;
        }
        if (showInvalidPaymentError) {
            paymentError = kShowPaymentError;
        } else {
            paymentError = kDoNotShowPaymentError;
        }
        showInvalidPaymentError = YES;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
        request.delegate = self;
        [request start];
    }
    return self;
}

- (id)initWithID:(NSString *)IDString {
    self = [super init];
    if (self) {
        if ([IDString isEqualToString: @"VARINIT"]) {
            
        } else {
            productIdentifiers = [NSArray arrayWithObject:IDString];
            if (showCancelError) {
                cancelError = kShowCancelError;
            } else {
                cancelError = kDoNotShowCancelError;
            }
            if (showInvalidPaymentError) {
                paymentError = kShowPaymentError;
            } else {
                paymentError = kDoNotShowPaymentError;
            }
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        }
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
        request.delegate = self;
        [request start];
    }
    return self;
}

- (void)makePurchaseWithID:(NSString *)purchaseID {
    if (canMakePurchases) {
        purchaseWithID = purchaseID;
    } else {
        if (!noErrorMode) {
            NSLog(@"Error 1001: See Error Documentaion W/ Error Code");
        }
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSInteger count = response.products.count;
    if (count > 0) {
        productList = response.products;
        if (purchaseWithID != nil) {
            for (SKProduct *product in response.products) {
                if ([product.productIdentifier isEqualToString:purchaseWithID]) {
                    [self purchase:product];
                }
            }
        }
    } else {
        if (!noErrorMode) {
            NSLog(@"Error 1002: See Error Documentation W/ Error Code");
        }
    }
}

- (void)purchase:(SKProduct *)product {
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)restorePurchases {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (BOOL)canMakePurchases {
    return [SKPaymentQueue canMakePayments];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                break;
#if TARGET_OS_IPHONE
            case SKPaymentTransactionStateDeferred:
                if (!noErrorMode) {
                    NSLog(@"Error 1006: See Error Documentation W/ Error Code");
                }
                break;
#endif
            case SKPaymentTransactionStatePurchased:
                [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self restore];
                break;
            case SKPaymentTransactionStateFailed:
                if (transaction.error.code == SKErrorPaymentCancelled) {
                    if (cancelError == kShowCancelError && !noErrorMode) {
                        NSLog(@"Error 1003: See Error Documentation W/ Error Code");
                    }
                } else if (transaction.error.code == SKErrorPaymentInvalid) {
                    if (paymentError == kShowPaymentError && !noErrorMode) {
                        NSLog(@"Error 1004: See Error Documentation W/ Error Code");
                    }
                } else if (transaction.error.code == SKErrorPaymentNotAllowed) {
                    if (!noErrorMode) {
                        NSLog(@"Error 1001: See Error Documentation W/ Error Code");
                    }
                } else if (transaction.error.code == SKErrorClientInvalid) {
                    if (!noErrorMode) {
                        NSLog(@"Error 1001: See Error Documentation W/ Error Code");
                    }
                } else {
                    if (!noErrorMode) {
                        NSLog(@"Error 1005: See Error Documentation W/ Error Code");
                    }
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    [purchasedProductsIDs addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
}

- (BOOL)productPurchasedWithProduct:(SKProduct *)product {
    NSString *productID = product.productIdentifier;
    return [purchasedProductsIDs containsObject:productID];
}

- (BOOL)productPurchasedWithID:(NSString *)productID {
    return [purchasedProductsIDs containsObject:productID];
}

#warning Type what needs to be restored below!

- (void)restore {
    // Example
    NSUserDefaults * local = [NSUserDefaults standardUserDefaults];
    [local setBool:YES forKey:@"com.FunkyTime.removeads"];
    // Support Funky Time and download at
    // https://itunes.apple.com/us/app/funky-time/id915200129?mt=8
}

@end
