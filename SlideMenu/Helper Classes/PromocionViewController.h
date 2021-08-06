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

@interface PromocionViewController:UIViewController <SlideNavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *productoTextField;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *procesandoActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *referenciaLabel;

@property (weak, nonatomic) IBOutlet UITableView *promocionTableView;

@property (weak, nonatomic) IBOutlet UILabel *descripcionProductoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIImageView *fondoImageView;

@property (weak, nonatomic) IBOutlet UIImageView *fondo2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *garantiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *seccionLabel;
@property (weak, nonatomic) IBOutlet UILabel *descontinuadoLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriaLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipoCodigoLabel;

@end
