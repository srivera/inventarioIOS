//
//  LoginViewController.h
//  SlideMenu
//
//  Created by CESAR ALVAREZ C. on 12/6/19.
//  Copyright © 2019 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "UIViewController+Network.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usuarioTextField;
@property (weak, nonatomic) IBOutlet UITextField *claveTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *procesandoIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *registrarButton;
@property (weak, nonatomic) IBOutlet UITextView *urlTextView;


@end

