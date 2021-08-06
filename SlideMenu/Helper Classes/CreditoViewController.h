//
//  FriendsViewController.h
//  SlideMenu
//
//  Created by Aryan Ghassemi on 12/31/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "UIViewController+Network.h"
#import "Util/Constants.h"

@interface CreditoViewController:UIViewController <SlideNavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cedulaRucTextField;
@property (weak, nonatomic) IBOutlet UILabel *nombreLabel;
@property (weak, nonatomic) IBOutlet UILabel *estadoCuentaLabel;
@property (weak, nonatomic) IBOutlet UILabel *cupoLabel;
@property (weak, nonatomic) IBOutlet UILabel *fechaCorteLabel;
@property (weak, nonatomic) IBOutlet UILabel *valorLabel;
@property (weak, nonatomic) IBOutlet UILabel *fechaMaximaLabel;
@property (weak, nonatomic) IBOutlet UILabel *diasLabel;
@property (weak, nonatomic) IBOutlet UILabel *estadoCuentaValorLabel;
@property (weak, nonatomic) IBOutlet UILabel *cupoDisponibleValorLabel;
@property (weak, nonatomic) IBOutlet UILabel *fechaCorteValorLabel;
@property (weak, nonatomic) IBOutlet UILabel *pagarValorLabel;
@property (weak, nonatomic) IBOutlet UILabel *fechaMaximoValorLabel;
@property (weak, nonatomic) IBOutlet UILabel *diasMoraValorLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *procesandoActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *fondoImageView;

@end
