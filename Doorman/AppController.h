//
//  AppController.h
//  doorman
//
//  Created by aninka on 6/24/09.
//  Copyright 2009 __Mr. Fridge and his coding friends__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class PasswordHero;


@interface AppController : NSObject {

    NSMutableArray* favoritePasswords;
    IBOutlet NSWindow* doormanWindow;
	IBOutlet NSDrawer* favoritePasswordsDrawer;
	IBOutlet NSTableView* favoritesTableView;

    IBOutlet NSButton* hasLowerCaseCheck;
    IBOutlet NSButton* hasNumbersCheck;
    IBOutlet NSButton* hasSpecialCharsCheck;
    IBOutlet NSButton* hasUpperCaseCheck;
    IBOutlet NSButton* isSpeakableCheck;
	IBOutlet NSButton* favoriteButton;
    
    IBOutlet NSButton* copyButton;
    
    IBOutlet NSTextField* passwordLengthTextField;

	IBOutlet NSTextField* specialCharsTextField;
    IBOutlet NSTextField* passwordTextField;
    IBOutlet NSTextField* strengthDescription;
    IBOutlet NSStepper* passwordLengthStepper;

    IBOutlet NSLevelIndicator* passwordStrengthLevelIndicator;
    
    IBOutlet NSImageView* favoritesOverlayImage;
    IBOutlet NSMenu* doormanMenu;
    IBOutlet NSMenuItem* updateMenuItem;

	
	PasswordHero* passwordHero;
    
    
    BOOL showFavoritesOverlay;
}


- (void)awakeFromNib;
-(IBAction) createPasswordClicked:(id) sender;
-(IBAction) optionCheckBoxClicked:(id) sender;
-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication;
-(IBAction) checkForUpdate:(id)sender;
-(IBAction) setLength: (id)sender;
-(IBAction) addToFavorites:(id) sender;
-(IBAction) copyPasswordToClipboard:(id)sender;

- (NSCellStateValue) stateFor:(bool) b;

@end
