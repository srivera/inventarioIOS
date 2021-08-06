//
//  Network.h
//  home
//
//  Created by CESAR ALVAREZ C. on 10/9/16.
//  Copyright © 2016 CESAR ALVAREZ C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>


@interface UIViewController (Network) 

// verificar acceso a internet
+ (BOOL) currentNetworkStatus;
+ (BOOL) verificaError:(NSDictionary *) resultado;

+ (void) login:(NSString *) usuario clave:(NSString *) clave idPushMessage:(NSString *) idPushMessage controlador:(UIViewController *) controlador;

+ (void) registrarDispositivo:(NSString *) usuario sistemaOperativo:(NSString *) clave idPushMessage:(NSString *) idPushMessage controlador:(UIViewController *) controlador;

+ (void) getStock:(NSString *) usuario token:(NSString *) token producto:(NSString *) producto codigoAlmacen:(NSString *) codigoAlmacen formato:(NSString *) formato controlador:(UIViewController *) controlador;

+ (void) getPromocion:(NSString *) usuario token:(NSString *) token producto:(NSString *) producto lugar:(NSString *) lugar controlador:(UIViewController *) controlador;

+ (void) getLugares:(NSString *) usuario token:(NSString *) token  controlador:(UIViewController *) controlador;

+ (void) getClientes:(NSString *) usuario token:(NSString *) token  identificacion:(NSString *) identificacion controlador:(UIViewController *) controlador;

+ (void) getImagenes:(NSString *) usuario formato:(NSString *) formato token:(NSString *) token controlador:(UIViewController *) controlador;

+ (void) getAcciones:(NSString *) usuario token:(NSString *) token controlador:(UIViewController *) controlador;

+ (void) refreshToken:(NSString *) usuario token:(NSString *) token  controlador:(UIViewController *) controlador;
@end
