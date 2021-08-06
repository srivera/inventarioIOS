//
//  StockViewController.h
//  comoHogar
//
//  Created by CESAR ALVAREZ C. on 12/20/19.
//  Copyright © 2019 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlideNavigationController.h"
#import "UIViewController+Network.h"
#import "Util/Constants.h"

@interface StockViewController : UIViewController <SlideNavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *procesandoActivityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *codigoTextField;
@property (weak, nonatomic) IBOutlet UITableView *stockTableView;
@property (weak, nonatomic) IBOutlet UILabel *descripcionProductoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *referenciaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fondoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fondo2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *garantiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *precioNormalLabel;

@property (weak, nonatomic) IBOutlet UILabel *seccionLabel;
@property (weak, nonatomic) IBOutlet UILabel *descontinuadoLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriaLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipoCodigoLabel;

@end



