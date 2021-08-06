//
//  LoginViewController.m
//  SlideMenu
//
//  Created by CESAR ALVAREZ C. on 12/6/19.
//  Copyright © 2019 Aryan Ghassemi. All rights reserved.
//


#import "LoginViewController.h"
#import "Util/Constants.h"

@implementation LoginViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    _usuarioTextField.delegate = self;
    _claveTextField.delegate = self;
    
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    NSString *dispositivo = [preferencias objectForKey:DISPOSITIVO];
    if (![dispositivo isEqualToString:@""]) {
        _registrarButton.hidden = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginExitoso:)
                                                 name:LOGIN_EXITOSO
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginError:)
                                                 name:LOGIN_ERROR
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginError:)
                                                 name:DISPOSITIVO_ERROR
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dispositivoRegistrado:)
                                                 name:DISPOSITIVO_REGISTRADO
                                               object:nil];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    _usuarioTextField.text = [preferencias valueForKey:USUARIO];
    _claveTextField.text = [preferencias valueForKey:CLAVE];
    
    if (![_usuarioTextField.text isEqualToString:@""] && ![_claveTextField.text isEqualToString:@""]) {
            [self loginAction:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) loginError:(NSNotification *) notification {
    NSLog(@"loginError");
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:[notification object]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(), ^{
         [self presentViewController:alert animated:YES completion:nil];
        [_procesandoIndicatorView stopAnimating];
    });
   
}

- (void) dispositivoRegistrado:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentarMensaje:@"Ha sido enviada su solicitud."];
    });
}

- (void) loginExitoso:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:LOGIN_EXITOSO]) {
        NSDictionary *userInfo = [notification userInfo];
        NSString *token = [userInfo valueForKey:VALOR_TOKEN];
        NSString *tokenRefresh = [userInfo valueForKey:TOKEN_REFRESH];
        NSString *idUsuario = [NSString stringWithFormat: @"%@", [userInfo valueForKey:IDUSUARIO]] ;
        NSString *duracionToken = [userInfo valueForKey:DURACION_TOKEN];
        
        NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
        [preferencias setObject:token forKey:TOKEN];
        [preferencias setObject:idUsuario forKey:IDUSUARIO];
        [preferencias setObject:_usuarioTextField.text forKey:USUARIO];
        [preferencias setObject:_claveTextField.text forKey:CLAVE];
        [preferencias setObject:tokenRefresh forKey:TOKEN_REFRESH];
        [preferencias synchronize];
        
        //programar el refresh del token
        dispatch_async(dispatch_get_main_queue(), ^{
            //recuperar locales
            [_procesandoIndicatorView stopAnimating];
            //programar actualizacion de token dependiendo la duracion
            if (duracionToken != nil) {
               [self progamarRefreshToken:duracionToken];
            }

            [self performSegueWithIdentifier:@"HomeViewController" sender:nil];
        });
    }
}
-(void) presentarError:(NSString *) errorMensaje {
    NSLog(@"error code");

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:errorMensaje
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) presentarMensaje:(NSString *) mensaje {
    NSLog(@"presentar Mensaje");
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Información"
                                                                   message:mensaje
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)refreshToken{
    NSLog(@"refresh token");
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    NSString *idUsuario = [preferencias objectForKey:IDUSUARIO];
    NSString *tokenRefresh= [preferencias objectForKey:TOKEN_REFRESH];
    [UIViewController refreshToken:idUsuario token:tokenRefresh
                       controlador:self];
}

-(void)progamarRefreshToken:(NSString *) duracionToken {
    [NSTimer scheduledTimerWithTimeInterval:[duracionToken integerValue]
                                     target:self
                                   selector:@selector(refreshToken)
                                   userInfo:nil
                                    repeats:NO];
}
- (IBAction)loginAction:(id)sender {
    NSLog(@"login");
    if ([_usuarioTextField.text isEqualToString:@""]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Es obligatorio ingresar el usuario"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if ([_claveTextField.text isEqualToString:@""]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Es obligatorio ingresar la clave"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    [preferencias setObject:_urlTextView.text forKey:URL];
    [preferencias synchronize];

     NSString *imei = [preferencias objectForKey:IMEI];
    
    [_procesandoIndicatorView startAnimating];
    [UIViewController login:_usuarioTextField.text clave:_claveTextField.text idPushMessage:imei controlador:self];
}

- (IBAction)registrarAction:(id)sender {
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    NSString *uuid;
    uuid = [preferencias valueForKey:IMEI];
    if (uuid == nil) {
        uuid = [[NSUUID UUID] UUIDString];
    }
    if ([_usuarioTextField.text isEqualToString:@""]) {
        [self presentarError:@"Es obligatorio ingresar el usuario, para solicitar autorización de acceso a este dispositivo."];
        return;
    }
    
    [preferencias setObject:uuid forKey:IMEI];
    [preferencias synchronize];
    [_procesandoIndicatorView startAnimating];
    [UIViewController registrarDispositivo:_usuarioTextField.text sistemaOperativo:@"IOS" idPushMessage:uuid controlador:self];
    [_procesandoIndicatorView stopAnimating];
}

@end
