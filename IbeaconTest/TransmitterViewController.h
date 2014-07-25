//
//  TransmitterViewController.h
//  IbeaconTest
//
//  Created by Rafael Bertholdo on 7/24/14.
//  Copyright (c) 2014 Bertholdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface TransmitterViewController : UIViewController <CBPeripheralManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblUUID;
@property (weak, nonatomic) IBOutlet UILabel *lblMajor;
@property (weak, nonatomic) IBOutlet UILabel *lblMinor;
@property (weak, nonatomic) IBOutlet UILabel *lblIdentity;

@end
