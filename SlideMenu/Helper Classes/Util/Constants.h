//
//  Constants.h
//  yacare
//
//  Created by CESAR ALVAREZ C. on 29/1/16.
//  Copyright © 2016 CESAR ALVAREZ C. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * const VERSION = @"1.5 build 1";

// VALORES DE CONFIGURACION E INSTALACION
static NSString * const DISPOSITIVO = @"idToken";
static NSString * const TOKEN = @"token";
static NSString * const VALOR_TOKEN = @"valorToken";
static NSString * const TOKEN_REFRESH = @"tokenRefresh";
static NSString * const IDUSUARIO = @"idUsuario";
static NSString * const USUARIO = @"usuario";
static NSString * const IMAGENES_ACTUALES = @"imagenes";
static NSString * const LOCAL_PREFERIDO = @"localPreferido";
static NSString * const FORMATO_PREFERIDO = @"formatoPreferido";
static NSString * const CLAVE = @"password";
static NSString * const IMEI = @"imei";
static NSString * const DURACION_TOKEN = @"duracionToken";
static NSString * const SISTEMA_OPERATIVO = @"sistemaOperativo";
static NSString * const ERROR_CODE = @"errorCode";
static NSString * const ERROR = @"error";
static NSString * const ERROR_MESSAGE = @"message";

static NSString * const CAMBIO_LOCAL = @"CambioLocal";

//nombre de los eventos de notificaciones
static NSString * const LOGIN_EXITOSO = @"LoginExitoso";
static NSString * const LOGIN_ERROR = @"LoginError";
static NSString * const LUGARES_ENCONTRADOS = @"LugaresEncontrados";
static NSString * const LUGARES_ERROR = @"LugaresError";
static NSString * const CLIENTES_ENCONTRADOS = @"ClientesEncontrados";
static NSString * const CLIENTES_ERROR = @"ClientesError";
static NSString * const PROMOCION_ENCONTRADA = @"PromocionEncontrada";
static NSString * const PROMOCION_ERROR = @"PromocionError";
static NSString * const STOCK_ENCONTRADO = @"StockEncontrado";
static NSString * const STOCK_ERROR = @"StockError";
static NSString * const DISPOSITIVO_REGISTRADO = @"DispositivoRegistrado";
static NSString * const DISPOSITIVO_ERROR = @"DispositivoError";
static NSString * const IMAGENES_ENCONTRADAS = @"ImagenesEncontradas";
static NSString * const IMAGENES_ERROR = @"ImagenesError";
static NSString * const ACCIONES_ENCONTRADAS = @"AccionesEncontradas";
static NSString * const ACCIONES_ERROR = @"AccionesError";
static NSString * const ACCIONES_AUTORIZADAS = @"AccionesAutorizadas";
static NSString * const TOKEN_REFRESCADO = @"TokenRefrescado";
static NSString * const TOKEN_ERROR = @"TokenError";
static NSString * const ESCANEO_EXITOSO = @"EscaneoExitoso";
static NSString * const SELECCIONAR_FORMATO = @"SeleccionarFormato";
static NSString * const REFRESCAR_MENU = @"RefrescarMenu";

static NSString * const DESCRIPCION = @"descripcion";
static NSString * const ID_PROMOCION = @"idPromocion";
static NSString * const DESCRIPCION_ARTICULO = @"desArticulo";
static NSString * const DESCUENTO_TEXTO = @"descuentoTexto";
static NSString * const PRECIO = @"precio";
static NSString * const PRECIO_NORMAL = @"precioNormal";
static NSString * const FECHA_INICIO = @"fechaInicio";
static NSString * const FECHA_FIN = @"fechaFin";
static NSString * const GARANTIA_ORIGINAL = @"garantiaOriginal";
static NSString * const GARANTIA_EXTENDIDA = @"garantiaExtendida";
static NSString * const SECCION = @"codigoSeccion";
static NSString * const SUBSECCION = @"codigoSubseccion";
static NSString * const CATEGORIA = @"descripcionCategoria";
static NSString * const CODIGO_CATEGORIA = @"codigoCategoria";
static NSString * const DESCRIPCION_SECCION = @"descripcionSeccion";
static NSString * const NOMBRECOMPLEMENTARIO = @"nombre";
static NSString * const DESCONTINUADO = @"descontinuado";

//columnas
static NSString * const VALOR_PAGAR = @"valorPagar";
static NSString * const NOMBRE = @"primerNombre";
static NSString * const APELLIDO = @"primerApellido";
static NSString * const CUPO_DISPONIBLE = @"cupoDisponible";
static NSString * const FECHA_CORTE = @"fechaCorte";
static NSString * const FECHAMAX_PAGO = @"fechaMaximaPago";
static NSString * const DIAS_MORA = @"diasMora";
static NSString * const ESTADO_CUENTA = @"estadoCuenta";
static NSString * const NOMBRE_LOCAL = @"nombre";
static NSString * const CODIGO_LOCAL = @"local";
static NSString * const NOMBRE_PRODUCTO = @"nombreItem";
static NSString * const CANTIDAD_PRODUCTO = @"cantidad";
static NSString * const FORMATO = @"formato";
static NSString * const FORMATO_TODOS = @"TODOS";
static NSString * const NOMBRE_IMAGEN = @"nombre";
static NSString * const IMAGEN = @"imagen";

//static NSString * const URL = @"https://5927bdb6-b171-43e7-8abf-151ec719062c.mock.pstmn.io";
//static NSString * const URL = @"https://b278a547-8f2f-45b0-a448-2d816b4038ca.mock.pstmn.io";
//static NSString * const URL = @"http://192.168.2.82:8081";
static NSString * const URL = @"http://200.105.234.42:8080";
//static NSString * const URL = @"http://app.sukasa.com:8080";
static NSDictionary *LUGARES_PERMITIDOS;
static NSDictionary *IMAGENES;
static NSDictionary *FORMATOS_PERMITIDOS;
static NSMutableArray *FORMATOS_DISPONIBLES;
static NSMutableArray *FORMATOS_SELECCIONADOS;
static NSDictionary *ACCIONES_PERMITIDAS;

static NSString *LOCAL_SELECCIONADO;


@interface Constants : NSObject

@end
