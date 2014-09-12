//
//  ZLStoreKitManager.m
//  THE VOW
//
//  Created by libs on 14-4-14.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLStoreKitManager.h"
#import "ZLHistoryManager.h"

@implementation ZLStoreKitManager

-(id)init
{
    self=[super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//        if(![ZLHistoryManager isFirstLaunch]){
//            [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
//        }
    }
    return self;
}

-(void)initProductRequest:(NSSet *)productIdentifiers
{
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    if (mProductsRequest) {
        mProductsRequest.delegate=nil;
        [mProductsRequest cancel];
        mProductsRequest=nil;
    }
    mProductsRequest=[[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    mProductsRequest.delegate=self;
    [mProductsRequest start];
}

-(void)purchaseProduct:(SKProduct *)product count:(int)count
{
    if (product&&count>0) {
        if ([SKPaymentQueue canMakePayments]) {
            ZLTRACE(@"can payment");
            SKMutablePayment *payment=[SKMutablePayment paymentWithProduct:product];
            payment.quantity=count;
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }else{
            ZLTRACE(@"cannot payment");
        }
    }
    
}

-(void)cancelAllAction
{
    if (mProductsRequest) {
        mProductsRequest.delegate=nil;
        [mProductsRequest cancel];
        mProductsRequest=nil;
    }
}

#pragma mark - SKProductsRequestDelegate <SKRequestDelegate>

// Sent immediately before -requestDidFinish:
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    ZLTRACE(@"invalidIdentifiers:%@",[response invalidProductIdentifiers]);
    [self.delegate storeKitManager_onReceiveProducts:[response products]];
}

- (void)requestDidFinish:(SKRequest *)request
{
    ZLTRACE(@"");
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    ZLTRACE(@"error domain:%@ errorCode:%d",[error domain],[error code]);
    if ([self.delegate respondsToSelector:@selector(storeKitManager_onRequestProductError)]) {
        [self.delegate storeKitManager_onRequestProductError];
    }
}

#pragma mark - @protocol SKPaymentTransactionObserver <NSObject>
// Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
//SKPaymentTransactionStatePurchasing,    // Transaction is being added to the server queue.
//SKPaymentTransactionStatePurchased,     // Transaction is in queue, user has been charged.  Client should complete the transaction.
//SKPaymentTransactionStateFailed,        // Transaction was cancelled or failed before being added to the server queue.
//SKPaymentTransactionStateRestored
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    if (transactions&&[transactions count]) {
        for (int i=0; i<[transactions count]; i++) {
            SKPaymentTransaction *transactionItem=[transactions objectAtIndex:i];
            ZLTRACE(@"transactionState:%d",[transactionItem transactionState]);
            if ([transactionItem transactionState]==SKPaymentTransactionStatePurchased) {
                [self.delegate storeKitManager_onPurchaseSuccess:transactionItem.payment.productIdentifier withCount:(int)transactionItem.payment.quantity];
                [[SKPaymentQueue defaultQueue] finishTransaction:transactionItem];
            }
        }
    }
}


@end
