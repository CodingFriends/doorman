
/*!
 @abstract app controller
 @updated 2011-01-27 julius
 */

#import "AppController.h"
#import "PasswordHero.h"


@implementation AppController

- (AppController*) init {
	self = [super init];
    if (self) {
		passwordHero = [[PasswordHero alloc ]init];
		favoritePasswords = [NSMutableArray arrayWithCapacity:16];
        showFavoritesOverlay = YES;
	}
	return self;
}


- (void)awakeFromNib {
    [doormanWindow center];
    
    if (IS_IN_APP_STORE) {
        [doormanMenu removeItem:updateMenuItem];
    } else {
        [self checkForUpdate:self];
    }
}


- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    //voreingestellte optionen laden 
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
    bool isFirstStart = ![defaults boolForKey:@"isNotFirstStart"];
    if (isFirstStart) {
        isFirstStart = NO;
        [defaults setBool:!isFirstStart forKey:@"isNotFirstStart"];
    } else {
        passwordHero.hasLowerCase = [defaults boolForKey:@"hasLowerCase"];
        passwordHero.hasNumbers = [defaults boolForKey:@"hasNumbers"];
        passwordHero.hasSpecialChars = [defaults boolForKey:@"hasSpecialChars"];
        passwordHero.hasUpperCase = [defaults boolForKey:@"hasUpperCase"];
        passwordHero.specialChars = [defaults arrayForKey:@"specialCharacters"];
        passwordHero.isSpeakable = [defaults boolForKey:@"isSpeakable"];
        
        NSInteger passwordLength = [defaults integerForKey:@"passwordLength"];
        if (passwordLength < 5) {
            passwordHero.passwordLength = 12;
        } else {
            passwordHero.passwordLength = passwordLength;
        }
    }
    
    [hasLowerCaseCheck setState:[self stateFor:passwordHero.hasLowerCase]];
    
    
    [hasNumbersCheck setState:[self stateFor:passwordHero.hasNumbers]];
    [hasSpecialCharsCheck setState: [self stateFor:passwordHero.hasSpecialChars]];
    [hasUpperCaseCheck setState:[self stateFor:passwordHero.hasUpperCase]];
    [isSpeakableCheck setState:[self stateFor:passwordHero.isSpeakable]];
    
    [specialCharsTextField setEnabled: passwordHero.hasSpecialChars];
    [specialCharsTextField setStringValue:[passwordHero specialCharsAsString]];
    
    [passwordLengthStepper setIntValue: passwordHero.passwordLength];
    [passwordLengthTextField setIntValue: passwordHero.passwordLength];
	
    [self optionCheckBoxClicked:self];
    
    [self createPasswordClicked:self];
}    

-(IBAction) setLength: (id)sender{
	passwordHero.passwordLength = [passwordLengthStepper integerValue];
	[passwordLengthTextField setIntegerValue: passwordHero.passwordLength];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setInteger:passwordHero.passwordLength forKey:@"passwordLength"];    
}


/*!
 @abstract IBAction wird aufgerufen wenn der create passwort button gedrückt wurde.
 @discussion ruft die entsprechende createpassword funktion auf
 @updated 2009-08-08 gaby & anna
 */
-(IBAction) createPasswordClicked:(id) sender{
    [copyButton setEnabled:YES];
    
    NSString* specials = [specialCharsTextField stringValue];
    [passwordHero setSpecialCharsAsString:specials];
    if ([specials length] == 0) {
        [specialCharsTextField setStringValue:[passwordHero specialCharsAsString]];
        [hasSpecialCharsCheck setState:NSOffState];
        [self optionCheckBoxClicked:self];
    }
    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:passwordHero.specialChars forKey:@"specialCharacters"];
    
    
    if ([passwordHero isSpeakable]) {
        [passwordTextField setStringValue:[passwordHero createSpeakablePassword]];
    } else {
        [passwordTextField setStringValue:[passwordHero createPassword]];
    }
    
	NSInteger strength  = [passwordHero passwordStrength];
    [passwordStrengthLevelIndicator setIntegerValue:strength];
    
    if (strength < 4) {
        [strengthDescription setStringValue:NSLocalizedString(@"Unsecure", @"Unsecure")];
    } else if (strength < 6) {
        [strengthDescription setStringValue:NSLocalizedString(@"OK for web accounts",@"OK for web accounts")];
    }  else  if (strength < 9) {
        [strengthDescription setStringValue:NSLocalizedString(@"Save for private data",@"Save for private data")];
    }  else {
        [strengthDescription setStringValue:NSLocalizedString(@"Save for confidential data",@"Save for confidential data")];
    }
    
    [favoriteButton setImage:[NSImage imageNamed:@"star_white"]];
    [favoritesTableView deselectAll:self];
}


/*!
 @abstract IBAction wird aufgerufen wenn sich eine der optionen ändert.
 @discussion prüft ob die optionen kombination zulässig ist und deaktiviert entsprechend andere optionen.
 @updated 2009-08-08 gaby & anna
 */
-(IBAction) optionCheckBoxClicked:(id) sender {
    passwordHero.hasNumbers = ([hasNumbersCheck state] == NSOnState); 
    passwordHero.hasSpecialChars = ([hasSpecialCharsCheck state] == NSOnState); 
    passwordHero.hasUpperCase = ([hasUpperCaseCheck state] == NSOnState); 
    passwordHero.hasLowerCase = ([hasLowerCaseCheck state] == NSOnState); 
    
    passwordHero.isSpeakable = ([isSpeakableCheck state] == NSOnState); 
    
    if (passwordHero.isSpeakable && NO == passwordHero.hasLowerCase && NO == passwordHero.hasUpperCase) {
        [hasLowerCaseCheck setState:NSOnState];
        passwordHero.hasLowerCase = YES;
    }
    
    NSInteger numberOfCheckedOptions = 0;
    if (passwordHero.hasLowerCase) {numberOfCheckedOptions++;}
    if (passwordHero.hasUpperCase) {numberOfCheckedOptions++;}
    if (passwordHero.hasSpecialChars) {numberOfCheckedOptions++;}
    if (passwordHero.hasNumbers) {numberOfCheckedOptions++;}
    
    
    if (numberOfCheckedOptions < 2) {
        [hasLowerCaseCheck setEnabled:![passwordHero hasLowerCase]];
        [hasUpperCaseCheck setEnabled:![passwordHero hasUpperCase]];
        [hasSpecialCharsCheck setEnabled:![passwordHero hasSpecialChars]];
        [hasNumbersCheck setEnabled:![passwordHero hasNumbers]];
    } else {
        [hasLowerCaseCheck setEnabled:YES];
        [hasUpperCaseCheck setEnabled:YES];
        if (passwordHero.isSpeakable) {
            [hasLowerCaseCheck setEnabled: passwordHero.hasUpperCase];
            [hasUpperCaseCheck setEnabled: passwordHero.hasLowerCase];
        }
        [hasNumbersCheck setEnabled:YES];
        [hasSpecialCharsCheck setEnabled:YES];
    }
    
    [specialCharsTextField setEnabled: passwordHero.hasSpecialChars];
    
    //in preferences speichern    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:passwordHero.hasLowerCase forKey:@"hasLowerCase"];
	[defaults setBool:passwordHero.hasNumbers forKey:@"hasNumbers"];
	[defaults setBool:passwordHero.hasSpecialChars forKey:@"hasSpecialChars"];
	[defaults setBool:passwordHero.hasUpperCase forKey:@"hasUpperCase"];
    [defaults setBool:passwordHero.isSpeakable forKey:@"isSpeakable"];
}


-(IBAction) copyPasswordToClipboard:(id)sender {
    NSString* password = [passwordTextField stringValue];
    NSPasteboard* pb = [NSPasteboard generalPasteboard];
    [pb clearContents];
    [pb setString:password forType:NSPasteboardTypeString];
}


#pragma mark -
#pragma mark Favorite Password Methods


-(IBAction)addToFavorites:(id) sender{
    
    if (showFavoritesOverlay) {
        showFavoritesOverlay = NO;
        [favoritesOverlayImage setFrameOrigin:NSMakePoint(720, 0)];
    }
    
	//wenn plus erstmals gedrügt ausfahren, dann offen lassen bis man alle elemente gelöscht hat oder man programm beendet
	//[favoritePasswordsDrawer open];
	if (NO == [favoritePasswords containsObject:[passwordTextField stringValue]] && ![[passwordTextField stringValue] isEqual:@""]) {
		[favoritePasswords addObject:[passwordTextField stringValue]];
		//NSLog(@"Passwort: %@", [passwordTextField stringValue]);
		//tabelle füllen (textanzeige)
		[favoritesTableView reloadData];
		
		[favoriteButton setImage:[NSImage imageNamed:@"star_yellow"]];
        [favoritesTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:([self numberOfRowsInTableView:favoritesTableView]-1)] byExtendingSelection:NO];
	} else if ([favoritePasswords containsObject:[passwordTextField stringValue]] && NO == [[passwordTextField stringValue] isEqual:@""]) {
        //remove
        NSInteger row = [favoritePasswords indexOfObject:[passwordTextField stringValue]];
        if (row >= 0 && row < [favoritePasswords count])  {
            [favoritePasswords removeObjectAtIndex:row];
            [favoritesTableView deselectAll:self];
            [favoritesTableView reloadData];
            [favoriteButton setImage:[NSImage imageNamed:@"star_white"]];

        }
    }
	//makiert letztes eingefügtes Passwort
	
	[doormanWindow makeFirstResponder:favoritesTableView];
}





- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [favoritePasswords count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row {
	return favoritePasswords[row];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
	NSInteger row = [favoritesTableView selectedRow];
    if (row < 0 || row >= [favoritePasswords count]) {
        return;
    }
    [passwordTextField setStringValue:favoritePasswords[row]];
    [favoriteButton setImage:[NSImage imageNamed:@"star_yellow"]];
}


#pragma mark -
#pragma mark update Method


/*!
 @abstract IBAction prüft auf updates.
 @discussion läd die versionsnummer aus einer textdatei im web und vergleicht.
 @updated 2009-10-02 gaby v091002
 */
- (IBAction)checkForUpdate:(id)sender
{
	NSString *newVersionString = [NSString stringWithContentsOfURL:[NSURL URLWithString:NSLocalizedString(@"VersionCheckURL", @"VersionCheckURL")] encoding:NSUTF8StringEncoding error:nil];
	CGFloat newVersion = 0; 
	if ( newVersionString == nil ) {
        if (sender != self) {
            NSRunAlertPanel(
                            NSLocalizedString(@"Error", @"Error"), 
                            NSLocalizedString(@"ConnectionFailedMsg",@"Connection failed. Please check if you are connected to the Internet and try again later."), 
                            NSLocalizedString(@"OK", @"OK"), 
                            nil, 
                            nil);
        }
        return;
    } 
    newVersion = [newVersionString floatValue];
    CGFloat version = [[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"] floatValue];
    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	CGFloat ingnoreLowerEqual = [defaults floatForKey:@"ignoreUpdatesLowerEqual"];
	
    if ( newVersion <= version) {
        if (sender != self) {
            NSRunAlertPanel(
                            NSLocalizedString(@"NoUpdate",@"No Update Available"), 
                            NSLocalizedString(@"NoUpdateMsg",@"You already have the latest version of Doorman."), 
                            NSLocalizedString(@"OK", @"OK"), 
                            nil, 
                            nil);
        }
    } else {
		if (sender != self || (sender == self && ingnoreLowerEqual < newVersion)) {
			CGFloat update;
			if (sender == self) {
				update = NSRunAlertPanel(
										 NSLocalizedString(@"Update", @"Update available"), 
										 [NSString stringWithFormat: NSLocalizedString(@"UpdateMsg",@"Version %f of Doorman is available (you have %f). Would you like to visit the web site?"), newVersion, version],
										 NSLocalizedString(@"Visit", @"Visit WebSite"), 
										 NSLocalizedString(@"Don't remind me again", @"Don't remind me again"),
										 NSLocalizedString(@"Later", @"Later")
										 );
			} else {
				update = NSRunAlertPanel(
										 NSLocalizedString(@"Update", @"Update available"), 
										 [NSString stringWithFormat:NSLocalizedString(@"UpdateMsg",@"Version %f of Doorman is available (you have %f). Would you like to visit the web site?"), newVersion, version],
										 NSLocalizedString(@"Visit", @"Visit WebSite"), 
										 NSLocalizedString(@"Later", @"Later"), 
										 nil);
			}
			if (update==NSAlertDefaultReturn) {
				[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:									 NSLocalizedString(@"SoftwareURL", @"http://mr-fridge.de/software/doorman/index.php")]];
			} else if ((update == NSAlertAlternateReturn) && (sender == self)) {
				NSLog(@"ingoring update");
				NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
				[defaults setFloat:newVersion forKey:@"ignoreUpdatesLowerEqual"];
			}
		}
		
    }
}

- (NSCellStateValue) stateFor:(bool) b {
    if (b) {
        return NSOnState;
    }
    return NSOffState;
}


/*!
 @abstract Delegate methode von NSApplication.
 @updated 2009-08-08 gaby & anna
 */
-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}




@end
