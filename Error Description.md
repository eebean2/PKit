PKit
Version 1.0

1001: Parental Controls

    Problem:
            Parental Controls are turned on

    Solution:
            Add check for parental controls. Such as:
                PKit *kit = [Pkit alloc] init...];
                if (kit.canMakePurchases) {
                    ...your code here...
                    (best practice is to put an NSAlert
                     here to notify the user)
                }

    Note:
        PKit makes a check to see if the user can make purchases with this error being the result when the user can NOT make them.

1002: No Products Returned

    Problem:
            No products returned with your Product ID's.

    Solution:
            Please check you have the correct ID's in iTunesConnect. If you just created them, give them between 1 and 5 hours to sync with Xcode.

    Note:
        It is reported of taking as little as only a few mins, and as much as 10 hours to sync. So if you have tripple checked everything and it still doesn't work, go out side and do what code monkies do in the sun... whis is... ummm... well... you know! :D

            Perv... not that...

1002: Payment Cancelled

    Problem:
            Payment Cancelled

    Solution:
            Ask again nicely?

    Note:
            Really Nicely?

1004: Invalid Payment

    Problem:
            User's payment is invalid or declined.

    Solution:
            Suggest another payment method, the user to double check there payment settings, or other similar matter. iTunes or the Mac App Store should do a similar matter for you.

    Note:

1005: Unknown Payment Error

    Problem:
            Error Unknown

    Solution:
            Please check all code, and try again. If problem persist, please check all user settings and try again. If problem still persist, please check Apple status page at https://developer.apple.com/system-status/ and https://www.apple.com/support/systemstatus/

    Note:
            This is a VERY rare error usually caused by mistyped code, system outage, or bad system settings. Try running your app on another computer?

