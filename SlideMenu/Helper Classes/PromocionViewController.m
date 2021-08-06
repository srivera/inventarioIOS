//
//  FriendsViewController.m
//  SlideMenu
//
//  Created by Aryan Ghassemi on 12/31/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "PromocionViewController.h"

@implementation PromocionViewController
NSMutableDictionary *userInfoPromocion;

- (void)viewDidLoad
{
	[super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(promocionEncontrada:)
                                                 name:PROMOCION_ENCONTRADA
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(promocionError:)
                                                 name:PROMOCION_ERROR
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(escaneoExitoso:)
                                                 name:ESCANEO_EXITOSO
                                               object:nil];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    _tipoCodigoLabel.text = @"Código de Barras / Interno";
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    NSString *formato = [preferencias objectForKey:FORMATO_PREFERIDO];
    
    NSString *nombreImagen =  @"logo.gif";
    
    if ([formato isEqualToString:@"NAVIDAD"]) {
        nombreImagen = @"logosn.png";
    }
    if ([formato isEqualToString:@"SUKASA"]) {
        nombreImagen = @"logo.gif";
    }
    if ([formato isEqualToString:@"TODOHOGAR"]) {
        nombreImagen = @"logoth.jpg";
    }
    [_logoImageView setImage:[UIImage imageNamed:nombreImagen]];
    
    nombreImagen =  @"sukasa_menu.png";
    
    if ([formato isEqualToString:@"NAVIDAD"]) {
        nombreImagen = @"navidad_menu.png";
    }
    if ([formato isEqualToString:@"SUKASA"]) {
        nombreImagen = @"sukasa_menu.png";
    }
    if ([formato isEqualToString:@"TODOHOGAR"]) {
        nombreImagen = @"todohogar_menu.png";
    }
    [_fondoImageView setImage:[UIImage imageNamed:nombreImagen]];
    [_fondo2ImageView setImage:[UIImage imageNamed:nombreImagen]];
    
    userInfoPromocion = [NSMutableDictionary dictionary];
}

- (void) viewDidAppear:(BOOL)animated {
     userInfoPromocion = [NSMutableDictionary dictionary];
}
- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (void) escaneoExitoso:(NSNotification *) notification
{
    _productoTextField.text = (NSString *) [notification object];
    NSLog(@"escaneoExitoso %@",_productoTextField.text);
    [self productoAction:nil];
}

- (void) promocionError:(NSNotification *) notification
{
    NSLog(@"promocionError");
    _referenciaLabel.text = @"" ;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"COMOHOGAR"
                                                                   message:[notification object]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
        [_procesandoActivityIndicator stopAnimating];
        userInfoPromocion = nil;
        _descripcionProductoLabel.text = @"";
        _garantiaLabel.text = @"";
        [_promocionTableView reloadData];
    });
}

- (void) promocionEncontrada:(NSNotification *) notification
{
    NSLog(@"promocion Encontrada");
    userInfoPromocion = [notification userInfo];

    dispatch_async(dispatch_get_main_queue(), ^{
        _referenciaLabel.text = [NSString stringWithFormat:@"Referencia:%@",[userInfoPromocion valueForKeyPath:@"modelo"][0]];
        
        if ([_productoTextField.text containsString:@"."] || [_productoTextField.text containsString:@"-"]) {
            _tipoCodigoLabel.text = [NSString stringWithFormat:@"Cód.Barra: %@",[userInfoPromocion valueForKeyPath:@"codigoBarra"][0]];
        } else {
            _tipoCodigoLabel.text = [NSString stringWithFormat:@"Código: %@",[userInfoPromocion valueForKeyPath:@"idProduct"][0]];
        }
        _descripcionProductoLabel.text = [userInfoPromocion valueForKeyPath:DESCRIPCION_ARTICULO][0];
        _garantiaLabel.text = [NSString stringWithFormat:@"Garantía:%@ meses   Garantía extendida: %@",[userInfoPromocion valueForKeyPath:GARANTIA_ORIGINAL][0],[userInfoPromocion valueForKeyPath:GARANTIA_EXTENDIDA][0]];
        _seccionLabel.text = [NSString stringWithFormat:@"%@  %@",[userInfoPromocion valueForKeyPath:SECCION][0],[userInfoPromocion valueForKeyPath:DESCRIPCION_SECCION][0]];
        [_promocionTableView reloadData];
        NSString *descontinuado = [userInfoPromocion valueForKeyPath:DESCONTINUADO][0];
        NSString *coleccion = [userInfoPromocion valueForKeyPath:@"coleccion"][0];
        _descontinuadoLabel.textColor = [UIColor whiteColor];
        if ([descontinuado isEqualToString:@"N"]) {
            if (coleccion != nil) {
                _descontinuadoLabel.hidden = NO;
                _descontinuadoLabel.textColor = [UIColor blackColor];
                _descontinuadoLabel.text = [NSString stringWithFormat:@"Colección:%@",coleccion];
                _descontinuadoLabel.backgroundColor = [UIColor clearColor];
            } else {
                _descontinuadoLabel.hidden = YES;
                _descontinuadoLabel.text = @"";
                _descontinuadoLabel.backgroundColor = [UIColor whiteColor];
            }
        } else {
            _descontinuadoLabel.hidden = NO;
            _descontinuadoLabel.text = @"DESCONTINUADO";
            _descontinuadoLabel.backgroundColor = [UIColor greenColor];
        }
        _categoriaLabel.text = [NSString stringWithFormat:@"%@",[userInfoPromocion valueForKeyPath:CATEGORIA][0]];
        [_promocionTableView reloadData];
        [_procesandoActivityIndicator stopAnimating];
        [self.view setNeedsDisplay];
        
    });
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}

- (IBAction)productoAction:(id)sender {
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    NSString *usuario = [preferencias objectForKey:IDUSUARIO];
    NSString *token = [preferencias objectForKey:TOKEN];
    NSString *codigoLocal = [preferencias objectForKey:CODIGO_LOCAL];
    [_procesandoActivityIndicator startAnimating];
    [UIViewController getPromocion:usuario token:token producto:_productoTextField.text lugar:codigoLocal controlador:self];
}

#pragma mark - uitableview Methods -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userInfoPromocion count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    // Reuse and create cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setBackgroundColor:[UIColor lightGrayColor]];
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setCurrencySymbol:@""];
    NSNumber *precio = @([[userInfoPromocion valueForKey:PRECIO][indexPath.row] floatValue]);
    NSNumber *precioNormal = @([[userInfoPromocion valueForKey:PRECIO_NORMAL][indexPath.row] floatValue]);
    float ahorro = [precioNormal floatValue] - [precio floatValue];
    
    NSString *precioCalculado=[NSString stringWithFormat:@"PVP$ %@ PVP$ %@ Ahorras PVP$%@ (%@%%)",[currencyFormatter stringFromNumber:[NSNumber numberWithDouble:[precio floatValue]]],[currencyFormatter stringFromNumber:[NSNumber numberWithDouble:[precioNormal floatValue]]],[currencyFormatter stringFromNumber:[NSNumber numberWithDouble:ahorro]],[userInfoPromocion valueForKeyPath:DESCUENTO_TEXTO][indexPath.row]];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:precioCalculado];
    
    NSRange range1 = [precioCalculado rangeOfString:@"PVP$ " options:NSBackwardsSearch range:NSMakeRange(0, [attributeString length] - 3)];

    NSRange range2 = [precioCalculado rangeOfString:@"Ahorras PVP" options:NSBackwardsSearch range:NSMakeRange(0, [attributeString length])];
    
    long desde = range1.location;
    long hasta = range2.location - range1.location;
    
    
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@2
                            range:NSMakeRange(desde,hasta )];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, desde)];
    
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, desde)];


    cell.detailTextLabel.text = [NSString stringWithFormat:@"desde: %@ hasta: %@",[[userInfoPromocion valueForKeyPath:FECHA_INICIO][indexPath.row] componentsSeparatedByString:@" "][0],[[userInfoPromocion valueForKeyPath:FECHA_FIN][indexPath.row] componentsSeparatedByString:@" "][0] ];
    cell.detailTextLabel.adjustsFontSizeToFitWidth=YES;
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];

    [cell.textLabel  setFont: [UIFont fontWithName:@"ArialMT" size:12]];
    cell.textLabel.textColor = [UIColor grayColor] ;
    cell.textLabel.attributedText = attributeString;
    cell.textLabel.adjustsFontSizeToFitWidth=YES;
    
    CGRect lbl1Frame = CGRectMake(8, 0, _promocionTableView.frame.size.width, 25);
    UILabel *lbl;
    lbl = [[UILabel alloc] initWithFrame:lbl1Frame];
    lbl.tag = 2;
    lbl.text = [NSString stringWithFormat:@"%@-%@",[userInfoPromocion valueForKeyPath:ID_PROMOCION][indexPath.row],[userInfoPromocion valueForKeyPath:DESCRIPCION][indexPath.row]];
    [lbl setFont:[UIFont boldSystemFontOfSize:12.0]];
    lbl.textColor = [UIColor blackColor];
    [cell.contentView addSubview:lbl];
    _descontinuadoLabel.hidden = NO;
    return cell;
}
@end
