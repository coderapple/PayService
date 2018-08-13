//
//  ViewController.m
//  PayDemo
//
//  Created by 李志华 on 2018/8/9.
//  Copyright © 2018年 Chris Lee. All rights reserved.
//

#import "ViewController.h"
#import "PayService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPayViews];
}

- (void)setUpPayViews {
    NSArray *titles = @[@"支付宝",@"微信",@"银联"];
    CGFloat w = UIScreen.mainScreen.bounds.size.width;
    for (int i = 0; i < 4; i++) {
        if (i < 3) {
            UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            payBtn.frame = CGRectMake((w-200)/2.0, 100+(i+1)*60, 200, 50);
            payBtn.layer.cornerRadius = 5;
            payBtn.tag = i;
            payBtn.backgroundColor = [UIColor blackColor];
            [payBtn setTitle:titles[i] forState:UIControlStateNormal];
            [payBtn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:payBtn];
        } else {
            if ([PayService isSupportApplePay]) {
                if ([PayService isApplePaySupportBankCards:@[PKPaymentNetworkVisa,PKPaymentNetworkMasterCard]]) {
                    PKPaymentButton *payBtn = [PKPaymentButton buttonWithType:PKPaymentButtonTypePlain style:PKPaymentButtonStyleBlack];
                    payBtn.frame = CGRectMake((w-200)/2.0, 100+(i+1)*60, 200, 50);
                    payBtn.tag = i;
                    [payBtn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:payBtn];
                } else {
                    PKPaymentButton *payBtn = [PKPaymentButton buttonWithType:PKPaymentButtonTypePlain style:PKPaymentButtonStyleBlack];
                    payBtn.frame = CGRectMake((w-200)/2.0, 100+(i+1)*60, 200, 50);
                    [payBtn addTarget:self action:@selector(setUp:) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:payBtn];
                }
            }
        }
    }
}

- (void)pay:(UIButton *)sender {
    NSInteger tag = sender.tag;
    PayOrderInfo *orderInfo = [[PayOrderInfo alloc] init];
    //支付宝
    if (tag == 0) {
        orderInfo.pay = PayAli;
        //orderString由服务器返回
        orderInfo.orderString = @"app_id=2015052600090779&biz_content=%7B%22timeout_express%22%3A%2230m%22%2C%22seller_id%22%3A%22%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22total_amount%22%3A%220.02%22%2C%22subject%22%3A%221%22%2C%22body%22%3A%22%E6%88%91%E6%98%AF%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%22%2C%22out_trade_no%22%3A%22314VYGIAGG7ZOYY%22%7D&charset=utf-8&method=alipay.trade.app.pay&sign_type=RSA2&timestamp=2016-08-15%2012%3A12%3A15&version=1.0&sign=MsbylYkCzlfYLy9PeRwUUIg9nZPeN9SfXPNavUCroGKR5Kqvx0nEnd3eRmKxJuthNUx4ERCXe552EV9PfwexqW%2B1wbKOdYtDIb4%2B7PL3Pc94RZL0zKaWcaY3tSL89%2FuAVUsQuFqEJdhIukuKygrXucvejOUgTCfoUdwTi7z%2BZzQ%3D";
        orderInfo.scheme = @"alipay";
        [[PayService defaultService] payOrderInfo:orderInfo result:^(BOOL success, NSString *data) {
            if (success) {
                //在此向自己的服务器请求验证支付是否成功
            }
        }];
        [[PayService defaultService] setHandleBackToAppByUnusualWay:^{
            //通过左上角或者其他非正常途径返回APP
            //在此向自己的服务器请求验证支付是否成功
            NSLog(@"支付验证");
        }];
    }
    //微信
    if (tag == 1) {
        orderInfo.pay = PayWX;
        orderInfo.openID = @"wxd930ea5d5a258f4f";
        orderInfo.partnerId = @"10000100";
        orderInfo.prepayId= @"1101000000140415649af9fc314aa427";
        orderInfo.package = @"Sign=WXPay";
        orderInfo.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
        orderInfo.timeStamp= @1397527777;
        orderInfo.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
        [[PayService defaultService] payOrderInfo:orderInfo result:^(BOOL success, NSString *data) {
            if (success) {
                //在此向自己的服务器请求验证支付是否成功
            }
        }];
        [[PayService defaultService] setHandleBackToAppByUnusualWay:^{
            //通过左上角或者其他非正常途径返回APP
            //在此向自己的服务器请求验证支付是否成功
            NSLog(@"支付验证");
        }];
    }
    //银联
    if (tag == 2) {
        orderInfo.pay = PayUnion;
        orderInfo.scheme = @"unionpay";
        orderInfo.orderString = @"app_id=2015052600090779&biz_content=%7B%22timeout_express%22%3A%2230m%22%2C%22seller_id%22%3A%22%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22total_amount%22%3A%220.02%22%2C%22subject%22%3A%221%22%2C%22body%22%3A%22%E6%88%91%E6%98%AF%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%22%2C%22out_trade_no%22%3A%22314VYGIAGG7ZOYY%22%7D&charset=utf-8&method=alipay.trade.app.pay&sign_type=RSA2&timestamp=2016-08-15%2012%3A12%3A15&version=1.0&sign=MsbylYkCzlfYLy9PeRwUUIg9nZPeN9SfXPNavUCroGKR5Kqvx0nEnd3eRmKxJuthNUx4ERCXe552EV9PfwexqW%2B1wbKOdYtDIb4%2B7PL3Pc94RZL0zKaWcaY3tSL89%2FuAVUsQuFqEJdhIukuKygrXucvejOUgTCfoUdwTi7z%2BZzQ%3D";
        orderInfo.mode= @"01";
        orderInfo.viewController = self;
        [[PayService defaultService] payOrderInfo:orderInfo result:^(BOOL success, NSString *data) {
            if (success) {
                //在此向自己的服务器请求验证支付是否成功
            }
        }];
        [[PayService defaultService] setHandleBackToAppByUnusualWay:^{
            //通过左上角或者其他非正常途径返回APP
            //在此向自己的服务器请求验证支付是否成功
            NSLog(@"支付验证");
        }];
    }
    //Apple Pay
    if (tag == 3) {
        orderInfo.pay = PayApple;
        orderInfo.merchantIdentifier = @"";
        orderInfo.supportBankCards = @[PKPaymentNetworkVisa,PKPaymentNetworkMasterCard];
        orderInfo.shipMethods = @[];
        orderInfo.paySummaryItems = @[];
        orderInfo.applicationData = @"id=apple-pay";
        orderInfo.viewController = self;
        [[PayService defaultService] payOrderInfo:orderInfo result:nil];
        [[PayService defaultService] setHandleApplePayAuthorizePayment:^BOOL(PKPayment *payment) {
            PKPaymentToken *token = payment.token;
            PKPaymentMethod *method = token.paymentMethod;
            NSLog(@"PKPaymentMethod==%@",method);
            //在此根据token向自己的服务器请求验证支付是否成功
            return YES;
        }];
    }
    
    
    
}
- (void)setUp:(UIButton *)sender {
    [PayService setUpApplePayBankCard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
