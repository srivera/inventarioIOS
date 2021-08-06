//
//  HomeViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "HomeViewController.h"
#import "LeftMenuViewController.h"
#import "Util/Constants.h"

NSString *formatoSeleccionado;
NSString *usuario;
NSString *token;
UITableView *lugaresTableView;
int indice = 0;

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	formatoSeleccionado = nil;
	self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 503);
	self.portraitSlideOffsetSegment.selectedSegmentIndex = [self indexFromPixels:[SlideNavigationController sharedInstance].portraitSlideOffset];
	self.landscapeSlideOffsetSegment.selectedSegmentIndex = [self indexFromPixels:[SlideNavigationController sharedInstance].landscapeSlideOffset];
	self.panGestureSwitch.on = [SlideNavigationController sharedInstance].enableSwipeGesture;
	self.shadowSwitch.on = [SlideNavigationController sharedInstance].enableShadow;
	self.limitPanGestureSwitch.on = ([SlideNavigationController sharedInstance].panGestureSideOffset == 0) ? NO : YES;
	self.slideOutAnimationSwitch.on = ((LeftMenuViewController *)[SlideNavigationController sharedInstance].leftMenu).slideOutAnimationEnabled;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lugaresEncontrados:)
                                                 name:LUGARES_ENCONTRADOS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lugaresError:)
                                                 name:LUGARES_ERROR
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imagenesEncontrados:)
                                                 name:IMAGENES_ENCONTRADAS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imagenesError:)
                                                 name:IMAGENES_ERROR
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(seleccionarFormato:)
                                                 name:SELECCIONAR_FORMATO
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accionesEncontradas:)
                                                 name:ACCIONES_ENCONTRADAS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accionesError:)
                                                 name:ACCIONES_ERROR
                                               object:nil];
    
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    usuario = [preferencias objectForKey:IDUSUARIO];
    token = [preferencias objectForKey:TOKEN];
    IMAGENES = [preferencias objectForKey:IMAGENES_ACTUALES];
    LOCAL_SELECCIONADO = [preferencias objectForKey:LOCAL_PREFERIDO];
    if (LOCAL_SELECCIONADO != nil) {
        formatoSeleccionado = [preferencias objectForKey:FORMATO_PREFERIDO];
        self.navigationItem.title = LOCAL_SELECCIONADO;
    }
    [UIViewController getLugares:usuario token:token controlador:self];
    if ([IMAGENES count] > 0) {
        [self cambiarImagen:indice];
        [_totalPageControl setNumberOfPages:[IMAGENES count]];
    }
    [UIViewController getAcciones:usuario token:token controlador:self];
}

- (void) seleccionarFormato:(NSNotification *) notification
{
    [self seleccionarFormatosPermitidos];
}

- (void) imagenesEncontrados:(NSNotification *) notification
{
    NSLog(@"imagenes encontradas");
    IMAGENES = [notification userInfo];
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    [preferencias setObject:IMAGENES forKey:IMAGENES_ACTUALES];
    [preferencias synchronize];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cambiarImagen:indice];
        [_totalPageControl setNumberOfPages:[IMAGENES count]];
    });
}

- (void) cambiarImagen:(int) indiceActual {
    //if ([IMAGENES count] < 1) {
    //    return;
    //}
    
    _siguienteButton.hidden = NO;
    _anteriorButton.hidden = NO;
    if ((int) indiceActual == 0) {
        _anteriorButton.hidden = YES;
    }
    if ((int) indiceActual + 1 == (int) [IMAGENES count]) {
        _siguienteButton.hidden = YES;
    }
    if ((int) indiceActual >= (int) [IMAGENES count]) {
        indice = (int)[IMAGENES count] - 1;
        return;
    }
    if ((int) indiceActual < 0) {
        indice = 0;
        return;
    }
    

    NSString *imagen = [IMAGENES valueForKeyPath:IMAGEN][indiceActual];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:imagen options:indiceActual];
    [_imagenImageView setImage:[UIImage imageWithData:decodedData]];
    [_totalPageControl setCurrentPage:indiceActual];
    [_imagenImageView setNeedsDisplay];
}

- (void) accionesEncontradas:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:ACCIONES_ENCONTRADAS]) {
        NSLog(@"accionesEncontradas home");
        NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
        [preferencias setObject:[notification userInfo] forKey:ACCIONES_AUTORIZADAS];
        [preferencias synchronize];
    }
}

- (void) accionesError:(NSNotification *) notification
{
    NSLog(@"accionesError home");
}

- (void) lugaresError:(NSNotification *) notification
{
    NSLog(@"lugaresError");
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error en locales"
                                                                   message:[notification object]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}
- (void) imagenesError:(NSNotification *) notification
{
    NSLog(@"imagenesError");
    NSString *mensaje;
    @try {
        mensaje = [notification object];
        if ([mensaje isEqual:[NSNull null]]) {
            mensaje = @"al descargar";
        }
    } @catch (NSException *exception) {
        mensaje = @"al descargar";
    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Imágenes no disponibles"
                                                                   message:mensaje
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}
- (void) lugaresEncontrados:(NSNotification *) notification
{

    if ([[notification name] isEqualToString:LUGARES_ENCONTRADOS]) {
        LUGARES_PERMITIDOS = [notification userInfo];
        FORMATOS_PERMITIDOS = [[NSMutableDictionary alloc] init];
        FORMATOS_DISPONIBLES = [[NSMutableArray alloc] init];

        [FORMATOS_PERMITIDOS setValue:@"SUKASA" forKey:@"1"];
        [FORMATOS_PERMITIDOS setValue:@"TODOHOGAR" forKey:@"2"];
        [FORMATOS_PERMITIDOS setValue:@"NAVIDAD" forKey:@"3"];
        
        for (NSString* key in FORMATOS_PERMITIDOS) {
            [FORMATOS_DISPONIBLES addObject:[FORMATOS_PERMITIDOS objectForKey:key]];
        }
        
        [FORMATOS_DISPONIBLES addObject:FORMATO_TODOS];
        NSLog(@"Lugares encontrados %lu", (unsigned long)[LUGARES_PERMITIDOS count]);
        if (formatoSeleccionado != nil) {
            return;
        } else {
            [self seleccionarFormatosPermitidos];
        }
    }
}

- (void) seleccionarFormatosPermitidos {
    int lugaresPermitidos = (int)[LUGARES_PERMITIDOS count];
    //lugaresPermitidos = 1;
    switch (lugaresPermitidos) {
        case 0:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self errorSinLocales:@"No tiene un local asignado, comuníquese con el administrador del sistema"];
            });
            break;
        }
        case 1:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                for(id key in LUGARES_PERMITIDOS) {
                    LOCAL_SELECCIONADO = [key valueForKeyPath:NOMBRE_LOCAL];
                }
                formatoSeleccionado = FORMATOS_DISPONIBLES[0];
                NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
                [preferencias setObject:LOCAL_SELECCIONADO forKey:LOCAL_PREFERIDO];
                [preferencias setObject:formatoSeleccionado forKey:FORMATO_PREFERIDO];
                [preferencias synchronize];
                self.navigationItem.title = LOCAL_SELECCIONADO;
                [self encontrarLocal];
            });
            break;
        }
        default:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self seleccionarLugar];
            });
        }
            break;
    }
}

- (void) errorSinLocales:(NSString *) detalleError {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:detalleError
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) seleccionarLugar {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Lugares autorizados \n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                                             message:nil preferredStyle:UIAlertControllerStyleAlert];
    CGFloat marginX = 10.0F;
    CGFloat marginY = 30.0F;
    CGFloat marginWIDTH = 250.0F;
    CGFloat marginHEIGHT = 150.0F;
    CGRect pickerFrame = CGRectMake(marginX, marginY, marginWIDTH, marginHEIGHT);
    CGRect tableFrame = CGRectMake(marginX , marginY + marginHEIGHT, marginWIDTH, marginHEIGHT);
    UIPickerView *regionsPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    lugaresTableView = [[UITableView alloc] initWithFrame:tableFrame];
    regionsPicker.tag = 1;
    
    regionsPicker.dataSource = self;
    regionsPicker.delegate = self;
    lugaresTableView.dataSource = self;
    lugaresTableView.delegate = self;
    
    [regionsPicker setShowsSelectionIndicator:YES];
    [alertController.view addSubview:regionsPicker];
    [alertController.view addSubview:lugaresTableView];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Seleccionar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (LOCAL_SELECCIONADO == nil) {
            [self seleccionarLugar];
        }
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:^{}];
    
    formatoSeleccionado = FORMATOS_DISPONIBLES[0];
    [lugaresTableView reloadData];
}
- (void) encontrarLocal {
    for(id key in LUGARES_PERMITIDOS) {
        NSString *nombreLocal = [key valueForKeyPath:NOMBRE_LOCAL];
        if ([nombreLocal isEqualToString:LOCAL_SELECCIONADO]) {
            NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
            [preferencias setObject:[key valueForKeyPath:CODIGO_LOCAL] forKey:CODIGO_LOCAL];
            [preferencias synchronize];
        }
    }
}

- (IBAction)siguienteAction:(id)sender {
    indice++;
    [self cambiarImagen:indice];
}
- (IBAction)anteriorAction:(id)sender {
    indice--;
    [self cambiarImagen:indice];
}
- (IBAction)imagenesAction:(id)sender {
    [UIViewController getImagenes:usuario formato:formatoSeleccionado token:token controlador:self];
}

#pragma mark - uitableview Methods -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FORMATOS_SELECCIONADOS = [[NSMutableArray alloc] init];

    for(id key in LUGARES_PERMITIDOS) {
        NSString *value = [key valueForKeyPath:FORMATO];
        if ([value isEqualToString:formatoSeleccionado] || [FORMATO_TODOS isEqualToString:formatoSeleccionado]) {
            [FORMATOS_SELECCIONADOS addObject:[key valueForKeyPath:NOMBRE_LOCAL]];
        }
    }

    return [FORMATOS_SELECCIONADOS count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    // Reuse and create cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    // Update cell data contents

    cell.textLabel.text = FORMATOS_SELECCIONADOS[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    LOCAL_SELECCIONADO = cell.textLabel.text;
    NSLog(@"Local seleccionado %@",LOCAL_SELECCIONADO);
    [self encontrarLocal];
    self.navigationItem.title = LOCAL_SELECCIONADO;
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults];
    [preferencias setObject:LOCAL_SELECCIONADO forKey:LOCAL_PREFERIDO];
    [preferencias setObject:formatoSeleccionado forKey:FORMATO_PREFERIDO];
    [preferencias synchronize];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"CambioLocal"
     object:nil userInfo:nil];
}

#pragma mark - uipickerview Methods -

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    formatoSeleccionado = FORMATOS_DISPONIBLES[row];
    [lugaresTableView reloadData];
    
    NSLog(@"formato de local seleccionado %@", formatoSeleccionado);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [FORMATOS_DISPONIBLES count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return FORMATOS_DISPONIBLES[row];
}


#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
	return NO;
}

#pragma mark - IBActions -

- (IBAction)bounceMenu:(id)sender
{
	static Menu menu = MenuLeft;
	
	[[SlideNavigationController sharedInstance] bounceMenu:menu withCompletion:nil];
	
	menu = (menu == MenuLeft) ? MenuRight : MenuLeft;
}

- (IBAction)slideOutAnimationSwitchChanged:(UISwitch *)sender
{
	((LeftMenuViewController *)[SlideNavigationController sharedInstance].leftMenu).slideOutAnimationEnabled = sender.isOn;
}

- (IBAction)limitPanGestureSwitchChanged:(UISwitch *)sender
{
	[SlideNavigationController sharedInstance].panGestureSideOffset = (sender.isOn) ? 50 : 0;
}

- (IBAction)changeAnimationSelected:(id)sender
{
	[[SlideNavigationController sharedInstance] openMenu:MenuRight withCompletion:nil];
}

- (IBAction)shadowSwitchSelected:(UISwitch *)sender
{
	[SlideNavigationController sharedInstance].enableShadow = sender.isOn;
}

- (IBAction)enablePanGestureSelected:(UISwitch *)sender
{
	[SlideNavigationController sharedInstance].enableSwipeGesture = sender.isOn;
}

- (IBAction)portraitSlideOffsetChanged:(UISegmentedControl *)sender
{
	[SlideNavigationController sharedInstance].portraitSlideOffset = [self pixelsFromIndex:sender.selectedSegmentIndex];
}

- (IBAction)landscapeSlideOffsetChanged:(UISegmentedControl *)sender
{
	[SlideNavigationController sharedInstance].landscapeSlideOffset = [self pixelsFromIndex:sender.selectedSegmentIndex];
}

#pragma mark - Helpers -

- (NSInteger)indexFromPixels:(NSInteger)pixels
{
	if (pixels == 60)
		return 0;
	else if (pixels == 120)
		return 1;
	else
		return 2;
}

- (NSInteger)pixelsFromIndex:(NSInteger)index
{
	switch (index)
	{
		case 0:
			return 60;
			
		case 1:
			return 120;
			
		case 2:
			return 200;
			
		default:
			return 0;
	}
}

@end
