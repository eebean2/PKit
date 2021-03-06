# PKit - Payment Kit
Payment Processing Simplified for iOS and OS X

* Version: 2.0

# Notes for this Version

* Fixed a bug that caused restore to not work (see step 7)
* Added an exception in Error Doc for the simulator
* Added product lookup for perviously purchased product (will have to iniate restore at least once for proper logging)

#How to use

1) Copy "PKit.m" and "PKit.h" to your project files. (Sorry, this is the only way for now)

2) In your "Linked Frameworks", include "StoreKit.framework".

3) Get your Product Identifers from iTunesConnect. If you do not know what they are, or how to locate them, go to this artical from Apple: https://developer.apple.com/library/ios/qa/qa1329/_index.html

4) With your ID's (if only one, go to 4a) go to the file you are planning on making the purchases in and set `NSArray *productArray = [@"array", @"array", @"array", nil];` where array is the product ID's.

4a) If you only have one ID, you need to set it to a `NSString` instead of `NSArray` because you will init PKit with a string. In the file you plan to make the purchases from, set `NSString *productID = @"someID";` where someID is your single ID. Procede to 5a instead of 5.

5) In the same file, and call `PKit *pkit = [[Pkit alloc] initWithIDs:productArray];`. Where productArray is the array from step 4.

5a) In the same file, and call `PKit *pkit = [[Pkit alloc] initWithID:productID];`. Where productArray is the array from step 4a.

6) In a method (could be a IBAction, or a seperate void, up to you), call `[pkit makePurchaseWithID:@"someID"];` where someID is an individual ID for a product being purchased. This method will initate a purchase for the selected product either return sucess or a detialed error of what went wrong.

7) In the bottom of PKit.m, input any items that need to be restored in `- (void)restore { }` and delete the warning message. IF you do not do this step, you will not restore previous purchases.

# Errors and Options

Most errors are layed out in Error Description.md. Simply open the document in Xcode to view. There are no known bugs at the current time.

* NoErrorMode: Should you desire to run 100% silent, you can choose so!

In your app delegate, under add the followingot the top:
```
    + (void)initialize {
        [PKit sharedInstance].noErrorMode = Yes;
    }
```

* If you would like to see when the user cancels a purchase, in appdelegate, as with NoErrorMode, add the following (the initialize is not required twice):
```
    + (void)initialize {
        [PKit sharedInstance].showCancelError = Yes;
    }
```

* If you would like to see when the user fails to make a purhase due to invalid payment, set to follwoing:
```
    + (void)initialize {
        [PKit sharedInstance].showInvalidPaymentError = YES;
    }
```

* Although PKit already checks to see if the user can make purchases, you can manually check by typing `[pkit canMakePurchases];' where pkit is whatever you named the class in your app.

* You cannot use traditional init, you MUST use initWithID or initWithIDs