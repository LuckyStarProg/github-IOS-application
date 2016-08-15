//
//  AllertController.h
//  AMGitHubApplication
//
//  Created by Амин on 15.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertController : UIViewController

+(void)showAlertOnVC:(UIViewController *)viewController withMessage:(NSString *)message;
@end
