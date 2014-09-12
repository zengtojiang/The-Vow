//
//  ZLStoreKitManager.h
//  THE VOW
//
//  Created by libs on 14-4-14.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol ZLStoreKitManagerDelegate;

@interface ZLStoreKitManager : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProductsRequest *mProductsRequest;
}

@property(nonatomic,assign)id<ZLStoreKitManagerDelegate> delegate;
-(void)initProductRequest:(NSSet *)productIdentifiers;

-(void)purchaseProduct:(SKProduct *)product count:(int)count;

-(void)cancelAllAction;
@end


@protocol ZLStoreKitManagerDelegate <NSObject>

-(void)storeKitManager_onReceiveProducts:(NSArray *)products;

@optional
-(void)storeKitManager_onRequestProductError;

-(void)storeKitManager_onPurchaseSuccess:(NSString *)productIdentifier withCount:(int)count;
@end