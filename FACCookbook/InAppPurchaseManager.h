//
//  InAppPurchaseManager.h
//  angrySanta
//
//  Created by Aaron Eisses on 11-09-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProduct:(SKProduct*)product;
@end
