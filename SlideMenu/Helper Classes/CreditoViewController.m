//
//  FriendsViewController.m
//  SlideMenu
//
//  Created by Aryan Ghassemi on 12/31/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "CreditoViewController.h"

@implementation CreditoViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(creditoEncontrado:)
                                                 name:CLIENTES_ENCONTRADOS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(creditoError:)
                                                 name:CLIENTES_ERROR
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(escaneoExitoso:)
                                                 name:ESCANEO_EXITOSO
                                               object:nil];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    NSString *formato = [preferencias objectForKey:FORMATO_PREFERIDO];
    NSString *local = [preferencias objectForKey:LOCAL_PREFERIDO];
    
    self.navigationItem.title = local;
    NSString *nombreImagen =  @"sukasa_menu.png";
    
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
}


- (void) escaneoExitoso:(NSNotification *) notification
{
    _cedulaRucTextField.text = (NSString *) [notification object];
    NSLog(@"escaneoExitoso %@",_cedulaRucTextField.text);
    [self cedulaRucAction:nil];
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (void) creditoError:(NSNotification *) notification
{
    NSLog(@"creditoError");
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error en crédito"
                                                                   message:[notification object]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
        [_estadoCuentaValorLabel setText:@""];
        [_cupoDisponibleValorLabel setText:@""];
        [_fechaCorteValorLabel setText:@""];
        [_pagarValorLabel setText:@""];
        [_fechaMaximoValorLabel setText:@""];
        [_diasMoraValorLabel setText:@""];
        [_nombreLabel setText:@""];
        [_procesandoActivityIndicator stopAnimating];
    });
}

- (void) creditoEncontrado:(NSNotification *) notification
{
    NSLog(@"credito Encontrado");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = [notification userInfo];
        [_estadoCuentaValorLabel setText:[userInfo valueForKey:ESTADO_CUENTA]];
        [_cupoDisponibleValorLabel setText:[userInfo valueForKey:CUPO_DISPONIBLE]];
        [_fechaCorteValorLabel setText:[userInfo valueForKey:FECHA_CORTE]];
        NSNumber *aPagar = @([[userInfo valueForKey:VALOR_PAGAR] floatValue]);
        NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [currencyFormatter setCurrencySymbol:@""]; //To remove currency symbol
        [_pagarValorLabel setText:[currencyFormatter stringFromNumber:[NSNumber numberWithDouble:[aPagar floatValue]]]];
        [_fechaMaximoValorLabel setText:[userInfo valueForKey:FECHAMAX_PAGO]];
        [_diasMoraValorLabel setText:[userInfo valueForKey:DIAS_MORA]];
        [_nombreLabel setText:[NSString stringWithFormat:@"%@ %@", [userInfo valueForKey:NOMBRE], [userInfo valueForKey:APELLIDO]]];
        [self.view setNeedsDisplay];
        [_procesandoActivityIndicator stopAnimating];
    });
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}
- (IBAction)cedulaRucAction:(id)sender {
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    NSString *usuario = [preferencias objectForKey:IDUSUARIO];
    NSString *token = [preferencias objectForKey:TOKEN];
    [_procesandoActivityIndicator startAnimating];
    [UIViewController getClientes:usuario token:token identificacion:_cedulaRucTextField.text controlador:self];
}



@end
