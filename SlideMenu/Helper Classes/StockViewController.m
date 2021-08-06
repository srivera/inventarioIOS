//
//  StockViewController.m
//  comoHogar
//
//  Created by CESAR ALVAREZ C. on 12/20/19.
//  Copyright © 2019 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockViewController.h"


@implementation StockViewController
NSDictionary *userInfo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stockEncontrado:)
                                                 name:STOCK_ENCONTRADO
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stockError:)
                                                 name:STOCK_ERROR
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(escaneoExitoso:)
                                                 name:ESCANEO_EXITOSO
                                               object:nil];
    
    userInfo = nil;
    _tipoCodigoLabel.text = @"Código de Barras / Interno";
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    
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
    
}


- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (IBAction)codigoTextField:(id)sender {
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    NSString *usuario = [preferencias objectForKey:IDUSUARIO];
    NSString *token = [preferencias objectForKey:TOKEN];
    NSString *formatoActual = [preferencias objectForKey:FORMATO_PREFERIDO];
    NSString *codigoLocal = [preferencias objectForKey:CODIGO_LOCAL];
    
    [_procesandoActivityIndicator startAnimating];
    [UIViewController getStock:usuario token:token producto:_codigoTextField.text codigoAlmacen:codigoLocal formato:formatoActual  controlador:self];
}

- (void) escaneoExitoso:(NSNotification *) notification
{
    _codigoTextField.text = (NSString *) [notification object];
    NSLog(@"escaneoExitoso %@",_codigoTextField.text);
    [self codigoTextField:nil];
}

- (void) stockError:(NSNotification *) notification
{
    NSLog(@"stockError");
    _referenciaLabel.text = @"";
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error Stock"
                                                                   message:[notification object]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
        [_procesandoActivityIndicator stopAnimating];
        userInfo = nil;
        _descripcionProductoLabel.text = @"";
        _garantiaLabel.text = @"";
        [_stockTableView reloadData];
    });
}
- (void) stockEncontrado:(NSNotification *) notification
{
    NSLog(@"stock Encontrado");
    userInfo = [notification userInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *referencia = [NSString stringWithFormat:@"Referencia:%@",[userInfo valueForKeyPath:@"modelo"][0]];
        double cantidad = [[userInfo valueForKeyPath:CANTIDAD_PRODUCTO][0] doubleValue];
        
        if ([referencia containsString:@"null"]) {
            _referenciaLabel.text = @"";
        } else {
            _referenciaLabel.text = referencia;
        }
        if ([_codigoTextField.text containsString:@"."] || [_codigoTextField.text containsString:@"-"]) {
            _tipoCodigoLabel.text = [NSString stringWithFormat:@"Código Barra: %@",[userInfo valueForKeyPath:@"codigoBarra"][0]];
        } else {
            _tipoCodigoLabel.text = [NSString stringWithFormat:@"Código: %@",[userInfo valueForKeyPath:@"idProduct"][0]];
        }
        _descripcionProductoLabel.text = [userInfo valueForKeyPath:NOMBRE_PRODUCTO][0];
        _garantiaLabel.text = [NSString stringWithFormat:@"Garantía:%@ meses   Garantía extendida: %@",[userInfo valueForKeyPath:GARANTIA_ORIGINAL][0],[userInfo valueForKeyPath:GARANTIA_EXTENDIDA][0]];
        NSString *precio = [NSString stringWithFormat:@"PVP$ %@",[userInfo valueForKeyPath:PRECIO_NORMAL][0]];
        _precioNormalLabel.text = precio;
        
        _seccionLabel.text = [NSString stringWithFormat:@"%@ %@",[userInfo valueForKeyPath:SECCION][0],[userInfo valueForKeyPath:DESCRIPCION_SECCION][0]];

        NSString *descontinuado = [userInfo valueForKeyPath:DESCONTINUADO][0];
        NSString *coleccion = [NSString stringWithFormat:@"Colección:%@",[userInfo valueForKeyPath:@"coleccion"][0]];
        _descontinuadoLabel.textColor = [UIColor whiteColor];
        
        if (cantidad == 0 && [userInfo count] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                userInfo = nil;
                [_stockTableView reloadData];
                [self errorSinLocales:@"No existe stock para el item"];
            });
            return;
        }
        
        if ([descontinuado isEqualToString:@"N"]) {
            if (![coleccion containsString:@"null"]) {
                _descontinuadoLabel.hidden = NO;
                _descontinuadoLabel.textColor = [UIColor blackColor];
                _descontinuadoLabel.text = coleccion;
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
        _categoriaLabel.text = [NSString stringWithFormat:@"%@",[userInfo valueForKeyPath:CATEGORIA][0]];
        
        [_stockTableView reloadData];
        [_procesandoActivityIndicator stopAnimating];
        [self.view setNeedsDisplay];
    });
}

- (void) errorSinLocales:(NSString *) detalleError {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"COMOHOGAR"
                                                                   message:detalleError
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    // Reuse and create cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    [cell setBackgroundColor:[UIColor lightGrayColor]];
    // Update cell data contents
    @try {
        cell.textLabel.text = [userInfo valueForKeyPath:NOMBRE_LOCAL][indexPath.row];
        [cell.textLabel setTextColor:[UIColor blackColor]];
    } @catch (NSException *exception) {
        NSLog(@"error %@",exception);
        
    }
    
    cell.detailTextLabel.text =
    [NSString stringWithFormat:@"%@",[userInfo valueForKeyPath:CANTIDAD_PRODUCTO][indexPath.row]];
    [cell.detailTextLabel setTextColor:[UIColor redColor]];
    return cell;
}
@end
