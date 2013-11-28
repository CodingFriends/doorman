//
//  PasswordHero.m
//  doorman
//
//  Created by mrFridge on 23.06.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PasswordHero.h"
#import "DMRandom.h"


@implementation PasswordHero

@synthesize passwordLength, hasUpperCase, hasLowerCase, hasNumbers, hasSpecialChars, isSpeakable, specialChars;

- (PasswordHero*) init {
	self = [super init];
    if (self) {
        
        passwordsPerSecond = 2.0 * pow(10, 9);
        NSLog(@"passwordManager > init > pps: %f", passwordsPerSecond);
        
        lowerCaseLetters = @[@"a", @"b",@"c", @"d",
                             @"e", @"f",@"g", @"h",@"i", @"j",@"k", @"l",
                             @"m", @"n",@"o", @"p",@"q", @"r",@"s", @"t",
                             @"u", @"v",@"w", @"x",@"y", @"z"];
        upperCaseLetters = @[@"A", @"B",@"C", @"D",
                             @"E", @"F",@"G", @"H",@"I", @"J",@"K", @"L",@"M", @"N",
                             @"O", @"P",@"Q", @"R",@"S", @"T",@"U", @"V",
                             @"W", @"X", @"Y",@"Z"];
        upperForLowerCaseDict = [NSDictionary dictionaryWithObjects:upperCaseLetters forKeys:lowerCaseLetters];
        numbers = @[@"1", @"2",@"3", @"4",@"5", @"6",
					@"7", @"8",@"9", @"0"];
		allSpecialChars = @[@"!", @"§", @"$", @"%",
                            @"&", @"/", @"(", @")", @"[", @"]", @"{", @"}",@"<", @">",
                            @"?", @"#", @"@",  @"=", @"-", @"_", @".", @",", @"+", @"*", @":"];
        leetDict = [NSDictionary dictionaryWithObjects:
                    @[@"3",@"0",@"!",@"4",@"5"] 
                                               forKeys:
                    @[@"e",@"o",@"i",@"a",@"s"]];
		self.specialChars = [NSMutableArray arrayWithArray:allSpecialChars];
        
        
        
        passwordLength = 12;
        hasLowerCase = YES;
        hasNumbers = YES;
        hasSpecialChars = NO;
        hasUpperCase = NO;
        isSpeakable = YES;
        lastSyllableHasLastConsonant = NO;
        lastSyllableHasFirstConsonant = NO;
        lastSyllableLength = 0;
        
        
        firstConsonants = @[@"b", @"c", @"d", @"f",
							@"g",@"h",@"j", @"k", @"l", @"m", @"n",@"o",@"p",
							@"qu", @"r",@"s", @"t",@"v", @"w", @"x",@"y", @"z",@"ch",
							@"b", @"c", @"d", @"f",
							@"g",@"h",@"j", @"k", @"l", @"m", @"n",@"o",@"p",
							@"qu", @"r",@"s", @"t",@"v", @"w", @"x", @"z",@"ch",
							@"sh", @"sc",@"sp", @"st",@"ph",@"squ", @"bh",@"dh",
							@"gh",@"kh",@"th", @"wh",@"h", @"bl",@"br",
							@"cl", @"cr",@"dr", @"tl",@"tr", @"gl", @"gr",@"kl",
							@"kr", @"pr",@"sl", @"tr",@"tl",@"vr",@"vl",
							@"wr", @"wl",@"xl", @"chr",@"chl",@"shr", @"shl",@"scl",
							@"scr", @"spl",@"spr", @"str",@"stl",@"phl",@"phr",
							@"thr", @"thl"];
        lastConsonants = @[@"b", @"c", @"d", @"f",
						   @"g",@"h", @"k", @"l", @"m", @"n",@"o",@"p",
						   @"qu", @"r",@"s", @"t",@"v", @"w", @"x", @"z",
						   @"b", @"c", @"d", @"f",
						   @"g",@"h",@"j", @"k", @"l", @"m", @"n",@"o",@"p",
						   @"qu", @"r",@"s", @"t",@"v", @"w", @"x", @"z",@"ch",
						   @"ch",@"sh",@"th", @"sp", @"st",
						   @"ll",@"rr",@"mm", @"nn", @"tt", @"ss", @"gh",@"ck"];
        vowels = @[@"a", @"e", @"i", @"o", @"u",
				   @"a", @"e", @"i", @"o", @"u", @"y",
				   @"ay", @"uy", @"oy", @"ei", @"ie", @"au", @"ou",@"ai", @"aa", @"ee", @"oo",
				   @"eu",@"eo",@"ui",@"uo",@"a", @"e", @"i", @"o", @"u"];
        
        
        
        random = [[DMRandom alloc] init];
    }
	return self;
}



-(NSString*) createPassword {
    NSString* password = [self createPasswordCandidate];
    for (NSInteger i = 0; i < 20; i++) {
        if (NO ==[self checkPasswordBeforeOut:password]){
            password = [self createPasswordCandidate];
        } else {
            break;
        }
    }
    return password;
}

-(NSString*) createSpeakablePassword {
    NSString* password = [self createSpeakablePasswordCandidate];
    for (NSInteger i = 0; i < 20; i++) {
        if (NO == [self checkPasswordBeforeOut:password]){
            password = [self createSpeakablePasswordCandidate];
        } else {
            break;
        }
    }
    return password;
}

/*!
 @abstract erzeugt ein zufälliges passwort gemäss den optionen.
 @updated 2009-08-08 gaby & anna
 */
-(NSString*) createPasswordCandidate{
    NSMutableArray* characters = [NSMutableArray arrayWithCapacity:80];
    if (hasLowerCase){
        [characters addObjectsFromArray:lowerCaseLetters];
    }
    if (hasNumbers){
        [characters addObjectsFromArray:numbers];
    }            
    if (hasSpecialChars){
        [characters addObjectsFromArray:specialChars];   
    }            
    if (hasUpperCase){
        [characters addObjectsFromArray:upperCaseLetters];   
    }
    NSMutableString* password = [NSMutableString stringWithString:@""];
    
	for (NSInteger i = 0; i < passwordLength; i++) {
		NSInteger r = [random randomIntBetween:0 and:[characters count]-1];
		[password appendString:characters[r]];
	}	
    
    //NSLog(@"createPassword: %@", password);
    return [NSString stringWithString: password];
}


/*!
 @abstract Gibt ein aussprechbares Passwort zurück.
 @discussion erzeugt so lange silben bis die länge stimmt. zwischen den silben werden sonderzeichen eingefügt
 @updated 2009-08-08 gaby & anna
 */
-(NSString*) createSpeakablePasswordCandidate{
    NSMutableString* speakablePassword = [NSMutableString stringWithCapacity:passwordLength];
    
    //am anfang kann auch sonderzeichen oder zahl stehen
    CGFloat numberOrSpecialProbability = [random randomFloatBetween:0 and:1];
    if (hasNumbers && (numberOrSpecialProbability > 0.6)) {
        NSString* randomNumber = numbers[[random randomIntBetween:0 and:[numbers count]-1]];
        [speakablePassword appendString: randomNumber];
    } else if (hasSpecialChars && (numberOrSpecialProbability < 0.3)) {
        NSString* randomSpecial = specialChars[[random randomIntBetween:0 and:[specialChars count]-1]];
        [speakablePassword appendString: randomSpecial];
    }
    
    //silben erzeugen mit evtl zahl oder sonderzeichen am ende
    while ([speakablePassword length] < passwordLength) {
        [speakablePassword appendString:[self createSyllable]];
        
        CGFloat numberOrSpecialProbability = [random randomFloatBetween:0 and:1];
        if (hasNumbers && (numberOrSpecialProbability > 0.6)) {
            NSString* randomNumber = numbers[[random randomIntBetween:0 and:[numbers count]-1]];
            [speakablePassword appendString: randomNumber];
        } else if (hasSpecialChars && (numberOrSpecialProbability < 0.3)) {
            NSString* randomSpecial = specialChars[[random randomIntBetween:0 and:[specialChars count]-1]];
            [speakablePassword appendString: randomSpecial];
        }
    }
    
    //wenn zu lang rekursiv selbst aufrufen
    if([speakablePassword length] > passwordLength){
        speakablePassword = [NSMutableString stringWithString:[self createSpeakablePasswordCandidate]];
    }
    
    if (self.hasLowerCase && self.hasUpperCase) {
        
        for (NSInteger i = 0; i < passwordLength; i++) {
            NSString* charAtI = [speakablePassword substringWithRange:NSMakeRange(i, 1)];
            NSString* caseReplacement = upperForLowerCaseDict[charAtI];
            if (caseReplacement) {
                CGFloat replaceProbability = [random randomFloatBetween:0 and:1];
                if (replaceProbability > 0.8) {
                    [speakablePassword replaceCharactersInRange:NSMakeRange(i, 1) withString: caseReplacement];
                }
            }
        }
    } else if (self.hasUpperCase && NO == self.hasLowerCase) {
        speakablePassword = [NSMutableString stringWithString:[speakablePassword uppercaseString]];
    }
    
    
    return speakablePassword;
}

/*!
 @abstract Erzeugt eine zufällige silbe zufälliger länge.
 @updated 2009-08-08 gaby & anna
 */
-(NSString*) createSyllable{
    CGFloat firstConsonantProbability = [random randomFloatBetween:0 and:1];
    CGFloat lastConsonantProbability = [random randomFloatBetween:0 and:1];
    NSMutableString* syllable = [NSMutableString stringWithCapacity:7];
    if (firstConsonantProbability < 0.75 || !lastSyllableHasLastConsonant) {
        lastSyllableHasLastConsonant = YES;
        NSInteger randomFirstConsonant = [random randomIntBetween:0 and:[firstConsonants count]-1];
        [syllable appendString:firstConsonants[randomFirstConsonant]];
    } else {
        lastSyllableHasFirstConsonant = NO;
    }
    NSInteger randomVowel = [random randomIntBetween:0 and:[vowels count]-1];
    [syllable appendString:vowels[randomVowel]];
    if (lastConsonantProbability < 0.5) {
        lastSyllableHasLastConsonant = YES;
        NSInteger randomLastConsonant = [random randomIntBetween:0 and:[lastConsonants count]-1];
        [syllable appendString:lastConsonants[randomLastConsonant]];
    } else {
        lastSyllableHasLastConsonant = NO;
    }
    
    lastSyllableLength = [syllable length];
    return syllable;
}

/*!
 @abstract Ersetzt im übergeben String buchstaben durch zahlen gemäss leetspeak.
 @updated 2009-08-08 gaby & anna
 */
-(NSString*) applyLeetSpeak:(NSString*) aString {
    NSMutableString* newPassword = [NSMutableString stringWithString:aString];
    for(NSInteger i = 0; i < [aString length]; i++){
        NSRange r = NSMakeRange(i, 1);
        NSString* leetChar = leetDict[[aString substringWithRange:r]];
        if (leetChar != nil) {
            [newPassword replaceCharactersInRange:r withString:leetChar];
        }
    }
    return [NSString stringWithString:newPassword];
}


/*!
 @abstract prüft ob das passwort die geforderten optionen erfüllt.
 @discussion jed der gesetzten optionen muss im passwort mit midestens einem zeichen erfüllt sein.
 @updated 2009-08-08 gaby & anna
 */
- (BOOL) checkPasswordBeforeOut:(NSString*) password{
    BOOL existsLetter = !hasLowerCase;
    BOOL existsUpperLetter = !hasUpperCase;
    BOOL existsNumber = !hasNumbers;
    BOOL existsSpecialChar = !hasSpecialChars;
    
    for (NSInteger i = 0; i< passwordLength; i++){
        NSString* singleChar = [password substringWithRange:NSMakeRange(i, 1)];
        if (NO == existsLetter && [lowerCaseLetters containsObject:singleChar]){
            existsLetter = YES;
            continue;
        }
        if (NO == existsUpperLetter && [upperCaseLetters containsObject:singleChar]){
            existsUpperLetter = YES;
            continue;
        }
        if (NO == existsNumber && [numbers containsObject:singleChar]){
            existsNumber = YES;
            continue;
        }
        if (NO == existsSpecialChar && [specialChars containsObject:singleChar]){
            existsSpecialChar = YES;
            continue;
        }
    }
	
    BOOL isOK = existsLetter && existsUpperLetter && existsNumber && existsSpecialChar;
    
    if (NO == isOK) {
        NSLog(@"PH > check > is not ok %@", password);
    }
    return isOK;
}


-(NSInteger) passwordStrength {
    CGFloat possibleSymbols = 0;
    if (hasNumbers) {
        possibleSymbols += 10;
    }
    if (hasSpecialChars) {
        possibleSymbols += [specialChars count];
    }
    if (hasUpperCase) {
        possibleSymbols += [upperCaseLetters count];
    }
    if (hasLowerCase) {
        possibleSymbols += [lowerCaseLetters count];
    }
    
    CGFloat possibleCombinations = pow(possibleSymbols, (CGFloat)passwordLength);
    CGFloat secondsToCrack = (possibleCombinations / passwordsPerSecond)/(2);
    NSInteger passwordStrength = (NSInteger)log10(secondsToCrack);
    
    if (isSpeakable && passwordStrength > 0) {
        passwordStrength -= 2;
    }
    
    NSLog(@"Time to brute force: %.1f days @ 10^%ld passwords/sec; possible combinations 10^%ld; strength %ld", secondsToCrack/(3600*24), (NSInteger)(log10(passwordsPerSecond)), (NSInteger)log10(possibleCombinations), passwordStrength);
    
    return passwordStrength;
}

-(void) setSpecialChars:(NSArray *)theCharsArray {
    if (theCharsArray == nil || [theCharsArray count] == 0) {
        specialChars = [NSMutableArray arrayWithArray:allSpecialChars];
    } else {
        specialChars = theCharsArray;
    }
}

- (void) setSpecialCharsAsString: (NSString*) specialString {
    NSMutableArray* specialArray = [NSMutableArray arrayWithCapacity:32];
    if (specialString == nil || [specialString length] == 0) {
        [self setSpecialChars:nil];
    } else {
        for (NSInteger i = 0; i < [specialString length]; i++) {
            [specialArray addObject:[specialString substringWithRange:NSMakeRange(i, 1)]];
        }
        [self setSpecialChars:specialArray];
    }
}

- (NSString*) specialCharsAsString {
    NSMutableString* specialString = [NSMutableString stringWithCapacity:32];
    for (NSString* c in self.specialChars) {
        [specialString appendString:c];
    }
    return specialString;
}





@end
