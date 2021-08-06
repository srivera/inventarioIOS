//
//  Network.m
//  home
//
//  Created by CESAR ALVAREZ C. on 10/9/16.
//  Copyright © 2016 CESAR ALVAREZ C. All rights reserved.
//

#import "UIViewController+Network.h"
#import "Constants.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#include <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>


@implementation UIViewController (CustomStyles)

#pragma mark WS
+ (BOOL) verificaError:(NSDictionary *) resultado evento:(NSString *) evento{
    NSString* key = nil;
    NSString *errorCode;
    NSString *errorText;

    for(key in resultado)
    { // this loop will not execute if the dictionary is empty
        @try {
            if ([key isEqualToString:ERROR_CODE]) {
                errorCode = [resultado valueForKey:ERROR_CODE] ;
            } else  if ([key isEqualToString:ERROR_MESSAGE]) {
                errorText = [resultado valueForKey:ERROR_MESSAGE] ;
            } else {
                break; // exit loop as soon as we enter it (key will be set to some key)
            }
        } @catch (NSException *exception) {
            break;
        }
    }

    if (errorCode != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
             postNotificationName:evento
             object:errorText userInfo:resultado];
        });
        return YES;
    }
    
    if (errorText != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
             postNotificationName:evento
             object:errorText userInfo:resultado];
        });
        return YES;
    }
    return NO;
}

+ (void) login:(NSString *) usuario clave:(NSString *) clave idPushMessage:(NSString *) idPushMessage controlador:(UIViewController *) controlador {
    NSString *targetUrl = [NSString stringWithFormat:@"%@/erp-rest/seguridad/login", URL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:usuario forHTTPHeaderField:USUARIO];
    [request setValue:clave forHTTPHeaderField:CLAVE];
    [request setValue:idPushMessage forHTTPHeaderField:IMEI ];
    [request setURL:[NSURL URLWithString:targetUrl]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          if (data == nil) {
              [[NSNotificationCenter defaultCenter]
               postNotificationName:LOGIN_ERROR
               object:@"Error de comunicación con el servidor." userInfo:nil];
              return;
          }
          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
 
          if ([self verificaError:result evento:LOGIN_ERROR]) {
              return;
          }
          NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
          [preferencias setObject:usuario forKey:USUARIO];
          [preferencias synchronize];
          NSLog(@"Data received: %@", result);
          [[NSNotificationCenter defaultCenter]
           postNotificationName:LOGIN_EXITOSO
           object:nil userInfo:result];
      }] resume];
}

+ (void) registrarDispositivo:(NSString *) usuario sistemaOperativo:(NSString *) sistemaOperativo idPushMessage:(NSString *) idPushMessage controlador:(UIViewController *) controlador {
    NSString *targetUrl = [NSString stringWithFormat:@"%@/erp-rest/seguridad/registrarDispositivo", URL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:usuario  forHTTPHeaderField:USUARIO];
    [request setValue:sistemaOperativo forHTTPHeaderField:SISTEMA_OPERATIVO];
    [request setValue:idPushMessage forHTTPHeaderField:IMEI];
    [request setURL:[NSURL URLWithString:targetUrl]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          
          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
          if ([self verificaError:result evento:DISPOSITIVO_ERROR]) {
              return;
          }
          NSLog(@"Data received: %@", result);
          NSString *idDispositivo = [result valueForKey:DISPOSITIVO];
          
          NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
          [preferencias setObject:idDispositivo forKey:DISPOSITIVO];
          [preferencias synchronize];
          
          [[NSNotificationCenter defaultCenter]
           postNotificationName:DISPOSITIVO_REGISTRADO
           object:nil userInfo:result];
      }] resume];
}

+ (void) getStock:(NSString *) usuario token:(NSString *) token producto:(NSString *) producto codigoAlmacen:(NSString *) codigoAlmacen formato:(NSString *) formato controlador:(UIViewController *) controlador {
    producto = [producto stringByReplacingOccurrencesOfString:@"."
                                                   withString:@"-"];
    NSString *targetUrl = [NSString stringWithFormat:@"%@/erp-rest/stock/getStock/%@/%@/%@", URL,producto,codigoAlmacen,formato];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:usuario forHTTPHeaderField:IDUSUARIO];
    [request setValue:token forHTTPHeaderField:TOKEN];
    [request setURL:[NSURL URLWithString:targetUrl]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
          if ([self verificaError:result evento:STOCK_ERROR]) {
              return;
          }
          NSLog(@"Data received: %@", result);
          [[NSNotificationCenter defaultCenter]
           postNotificationName:STOCK_ENCONTRADO
           object:nil userInfo:result];
      }] resume];
}

+ (void) getPromocion:(NSString *) usuario token:(NSString *) token producto:(NSString *) producto lugar:(NSString *) lugar controlador:(UIViewController *) controlador {
    producto = [producto stringByReplacingOccurrencesOfString:@"."
                                                   withString:@"-"];
    NSString *targetUrl = [NSString stringWithFormat:@"%@/erp-rest/promocion/getPromocion/%@/%@", URL,producto,lugar];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:usuario forHTTPHeaderField:@"idusuario"];
    [request setValue:token forHTTPHeaderField:TOKEN];
    [request setURL:[NSURL URLWithString:targetUrl]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
          if ([self verificaError:result evento:PROMOCION_ERROR]) {
              return;
          }
          NSLog(@"Data received: %@", result);
          [[NSNotificationCenter defaultCenter]
           postNotificationName:PROMOCION_ENCONTRADA
           object:nil userInfo:result];
      }] resume];
}

+ (void) getLugares:(NSString *) usuario token:(NSString *) token  controlador:(UIViewController *) controlador {
    NSString *targetUrl = [NSString stringWithFormat:@"%@/erp-rest/lugar/getLugaresPorUsuario", URL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:usuario forHTTPHeaderField:IDUSUARIO];
    [request setValue:token forHTTPHeaderField:TOKEN];
    [request setURL:[NSURL URLWithString:targetUrl]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
          if ([self verificaError:result evento:LUGARES_ERROR]) {
              return;
          }
          NSLog(@"Data received: %@", result);
          [[NSNotificationCenter defaultCenter]
           postNotificationName:LUGARES_ENCONTRADOS
           object:nil userInfo:result];
      }] resume];
}

+ (void) getImagenes:(NSString *) usuario formato:(NSString *) formato token:(NSString *) token  controlador:(UIViewController *) controlador {
    NSString *targetUrl = [NSString stringWithFormat:@"%@/erp-rest/imagen/getImagenes/%@", URL,formato];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:usuario forHTTPHeaderField:IDUSUARIO];
    [request setValue:token forHTTPHeaderField:TOKEN];
    [request setURL:[NSURL URLWithString:targetUrl]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
          if ([self verificaError:result evento:IMAGENES_ERROR]) {
              return;
          }
          
          [[NSNotificationCenter defaultCenter]
           postNotificationName:IMAGENES_ENCONTRADAS
           object:nil userInfo:result];
      }] resume];
}

+ (void) getAcciones:(NSString *) usuario token:(NSString *) token  controlador:(UIViewController *) controlador {
    NSString *targetUrl = [NSString stringWithFormat:@"%@/erp-rest/seguridad/getAcciones", URL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:usuario forHTTPHeaderField:IDUSUARIO];
    [request setValue:token forHTTPHeaderField:TOKEN];
    [request setURL:[NSURL URLWithString:targetUrl]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
          if ([self verificaError:result evento:ACCIONES_ERROR]) {
              return;
          }
          NSLog(@"Data received: %@", result);
          [[NSNotificationCenter defaultCenter]
           postNotificationName:ACCIONES_ENCONTRADAS
           object:nil userInfo:result];
      }] resume];
}

+ (void) getClientes:(NSString *) usuario token:(NSString *) token identificacion:(NSString *) identificacion controlador:(UIViewController *) controlador {
    NSString *targetUrl = [NSString stringWithFormat:@"%@/erp-rest/cliente/getCliente/%@", URL,identificacion];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:usuario forHTTPHeaderField:IDUSUARIO];
    [request setValue:token forHTTPHeaderField:TOKEN];
    [request setURL:[NSURL URLWithString:targetUrl]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
          if ([self verificaError:result evento:CLIENTES_ERROR]) {
              return;
          }
          NSLog(@"Data received: %@", result);
          [[NSNotificationCenter defaultCenter]
           postNotificationName:CLIENTES_ENCONTRADOS
           object:nil userInfo:result];
      }] resume];
}

+ (void) refreshToken:(NSString *) usuario token:(NSString *) token  controlador:(UIViewController *) controlador {
    NSString *targetUrl = [NSString stringWithFormat:@"%@/erp-rest/seguridad/refreshToken", URL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:usuario forHTTPHeaderField:IDUSUARIO];
    [request setValue:token forHTTPHeaderField:TOKEN_REFRESH];
    [request setURL:[NSURL URLWithString:targetUrl]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
          if ([self verificaError:result evento:TOKEN_ERROR]) {
              return;
          }
          NSLog(@"Data received: %@", result);
          [[NSNotificationCenter defaultCenter]
           postNotificationName:TOKEN_REFRESCADO
           object:nil userInfo:result];
      }] resume];
}
@end
