//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import "Util/Constants.h"

@implementation LeftMenuViewController

#pragma mark - UIViewController Methods -

NSDictionary *ACCIONES;
long menuActual;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.slideOutAnimationEnabled = YES;
	
	return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tableView.separatorColor = [UIColor clearColor];
	
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    ACCIONES = [preferencias objectForKey:ACCIONES_AUTORIZADAS];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cambioLocal:)
                                                 name:CAMBIO_LOCAL
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accionesEncontradas:)
                                                 name:ACCIONES_ENCONTRADAS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accionesError:)
                                                 name:ACCIONES_ERROR
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refrescarMenu:)
                                                 name:REFRESCAR_MENU
                                               object:nil];
}

- (void) cambioLocal:(NSNotification *) notification
{
    [_tableView reloadData];
}

- (void) refrescarMenu:(NSNotification *) notification
{
    NSLog(@"refrescarMenu menu");
    [_tableView reloadData];
}

- (void) accionesEncontradas:(NSNotification *) notification
{
    NSLog(@"accionesEncontradas menu");
    ACCIONES = [notification userInfo];
}

- (void) accionesError:(NSNotification *) notification
{
    NSLog(@"accionesError menu");
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    menuActual = 0;
	return [ACCIONES count] + 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    NSString *local = [preferencias objectForKey:LOCAL_PREFERIDO];
    NSString *codigoLocal = [preferencias objectForKey:CODIGO_LOCAL];
    NSString *formato = [preferencias objectForKey:FORMATO_PREFERIDO];
    NSString *nombreImagen =  [NSString stringWithFormat:@"%@_menu.png", [formato lowercaseString]];
    
    UIImage *myImage = [UIImage imageNamed:nombreImagen];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
    //imageView.frame = CGRectMake(10,10,100,100);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 180, 80)];
    
    overlayView.backgroundColor = [UIColor clearColor];
    
    UITextView *myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    
    myTextView.text = [NSString stringWithFormat:@"%@-%@", codigoLocal,local];
    [myTextView setTextColor:[UIColor whiteColor]];
    [myTextView setFont:[UIFont boldSystemFontOfSize:20]];
    myTextView.backgroundColor = [UIColor clearColor];
    //some other setup like setting the font for the UITextView...
    [overlayView addSubview:myTextView];
    [myTextView sizeToFit];
    
    UITextView *versionTextView = [[UITextView alloc] initWithFrame:CGRectMake(170, 75, 200, 80)];
    versionTextView.text = VERSION;
    [versionTextView setTextColor:[UIColor whiteColor]];
    [versionTextView setFont:[UIFont boldSystemFontOfSize:8]];
    versionTextView.backgroundColor = [UIColor clearColor];
    //some other setup like setting the font for the UITextView...
    [overlayView addSubview:versionTextView];
    [versionTextView sizeToFit];
    
    [imageView addSubview:overlayView];
    
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    long indice = indexPath.row;
    long delta = 3 - [ACCIONES count];

    
    indice = indice + delta;
    
	switch (indice)
	{
		case 0:
			cell.textLabel.text = [self obtenerMenu:menuActual];
			break;
			
		case 1:
			cell.textLabel.text = [self obtenerMenu:menuActual];
			break;
			
		case 2:
			cell.textLabel.text = [self obtenerMenu:menuActual];
			break;
			
		case 3:
			cell.textLabel.text = @"Parámetros";
			break;
        case 4:
            cell.textLabel.text = @"Cerrar sesión";
            break;
	}
    menuActual++;
	cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor grayColor];
	
	return cell;
}

- (NSString *) obtenerMenu:(long) indice {
    long contador = 0;
    NSString *nombre = @"";
    for (NSDictionary *dic in ACCIONES) {
        if (contador == indice) {
         nombre = [dic objectForKey:@"nombre"];
            if ([nombre isEqualToString:@"stock"]) {
                nombre = @"Stock";
            } else if ([nombre isEqualToString:@"promocion"]) {
                nombre = @"Promociones";
            } else if ([nombre isEqualToString:@"credito"]) {
                nombre = @"Crédito";
            }
         return nombre;
        }
        contador++;
    }
    return @"";
}

- (NSString *) obtenerControlador:(long) indice {
    long contador = 0;
    NSString *nombre = @"";
    for (NSDictionary *dic in ACCIONES) {
        if (contador == indice) {
            nombre = [dic objectForKey:@"nombre"];
            if ([nombre isEqualToString:@"stock"]) {
                nombre = @"StockViewController";
            } else if ([nombre isEqualToString:@"promocion"]) {
                nombre = @"PromocionViewController";
            } else if ([nombre isEqualToString:@"credito"]) {
                nombre = @"CreditoViewController";
            }
            return nombre;
        }
        contador++;
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
															 bundle: nil];
	
	UIViewController *vc ;
    long indice = indexPath.row;
    long delta = 3 - [ACCIONES count];
    
    if (indice >= [ACCIONES count]) {
         indice = indice + delta;
    }
    
    switch (indice)
	{
		case 0:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: [self obtenerControlador:0]];
			break;
			
		case 1:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: [self obtenerControlador:1]];
			break;
			
		case 2:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: [self obtenerControlador:2]];
			break;
			
		case 3:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:SELECCIONAR_FORMATO
             object:nil userInfo:nil];
			break;
	}
    
    if (indexPath.row == [ACCIONES count] + 1) {
        NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
        [preferencias setObject:@"" forKey:USUARIO];
        [preferencias setObject:@"" forKey:CLAVE];
        [preferencias setObject:nil forKey:LOCAL_PREFERIDO];
        [preferencias setObject:nil forKey:FORMATO_PREFERIDO];
        [preferencias setObject:nil forKey:ACCIONES_AUTORIZADAS];
        [preferencias synchronize];
    }
	[[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
															 withSlideOutAnimation:self.slideOutAnimationEnabled
																	 andCompletion:nil];
}

@end
