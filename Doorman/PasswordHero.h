//
//  PasswordHero.h
//  doorman
//
//  Created by mrFridge on 23.06.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class DMRandom;

@interface PasswordHero : NSObject {

    CGFloat passwordsPerSecond;
    
	NSInteger passwordLength;
	BOOL hasLowerCase;
	BOOL hasNumbers;
	BOOL hasSpecialChars;
	BOOL hasUpperCase;
	BOOL isSpeakable;
    
    BOOL lastSyllableHasFirstConsonant;
    BOOL lastSyllableHasLastConsonant;
    NSInteger lastSyllableLength;

	
	NSArray* lowerCaseLetters;
	NSArray* upperCaseLetters;
	NSArray* numbers;
	NSArray* allSpecialChars;
	NSDictionary* leetDict;
	NSDictionary* upperForLowerCaseDict;
    
    NSArray* firstConsonants;
    NSArray* vowels;
    NSArray* lastConsonants;    
	NSArray* specialChars;
    DMRandom* random;
    
	
}
-(NSInteger) passwordStrength;


@property (assign) NSInteger passwordLength;
@property (assign) BOOL hasLowerCase;
@property (assign) BOOL hasNumbers;
@property (assign) BOOL hasSpecialChars;
@property (assign) BOOL hasUpperCase;
@property (assign) BOOL isSpeakable;
@property (strong, nonatomic) NSArray* specialChars;




- (NSString*) specialCharsAsString;
- (void) setSpecialCharsAsString: (NSString*) specialString;


-(NSString*) createPassword;
-(NSString*) createPasswordCandidate;

-(NSString*) createSpeakablePassword;
-(NSString*) createSpeakablePasswordCandidate;

-(NSString*) createSyllable;
-(NSString*) applyLeetSpeak:(NSString*) aString;
- (BOOL) checkPasswordBeforeOut:(NSString*) password;

@end
