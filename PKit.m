/*

 PKit.m
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

#import "PKit.h"



@interface PKit () {
    NSString *purchaseWithID;
}

@end

@implementation PKit

@synthesize productIdentifiers;
@synthesize canMakePurchases;
@synthesize showCancelError;
@synthesize showInvalidPaymentError;

- (id _Nonnull)initWithIDs:(NSArray * _Nonnull)IDArray {
    self = [super init];
    if (self) {
        productIdentifiers = IDArray;
        showCancelError = YES;
        showInvalidPaymentError = YES;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (id _Nonnull)initWithID:(NSString * _Nonnull)IDString {
    self = [super init];
    if (self) {
        productIdentifiers = [NSArray arrayWithObject:IDString];
        showCancelError = YES;
        showInvalidPaymentError = YES;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)makePurchaseWithID:(NSString * _Nonnull)purchaseID {
    if (canMakePurchases) {
        purchaseWithID = purchaseID;
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
        request.delegate = self;
        [request start];
    } else {
        NSLog(@"Error 1001: See Error Documentaion W/ Error Code");
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSInteger count = response.products.count;
    if (count > 0) {
        for (SKProduct *product in response.products) {
            if ([product.productIdentifier isEqualToString:purchaseWithID]) {
                [self purchase:product];
            }
        }
    } else {
        NSLog(@"Error 1002: See Error Documentation W/ Error Code");
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
            case SKPaymentTransactionStatePurchased:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                if (transaction.error.code == SKErrorPaymentCancelled) {
                    if (showCancelError) {
                        NSLog(@"Error 1003: See Error Documentation W/ Error Code");
                    }
                } else if (transaction.error.code == SKErrorPaymentInvalid) {
                    if (showInvalidPaymentError) {
                        NSLog(@"Error 1004: See Error Documentation W/ Error Code");
                    }
                } else if (transaction.error.code == SKErrorPaymentNotAllowed) {
                    NSLog(@"Error 1001: See Error Documentation W/ Error Code");
                } else if (transaction.error.code == SKErrorClientInvalid) {
                    NSLog(@"Error 1001: See Error Documentation W/ Error Code");
                } else {
                    NSLog(@"Error 1005: See Error Documentation W/ Error Code");
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

@end
