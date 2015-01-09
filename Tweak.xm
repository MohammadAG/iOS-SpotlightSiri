#import <substrate.h>
#import <UIKit/UIKit.h>

@interface SBSearchHeader
@property(readonly, retain, nonatomic) UITextField *searchField;
@end

@interface SpringBoard
- (void)setNextAssistantRecognitionStrings:(id)arg1;
@end

@interface SBAssistantController
+ (id)sharedInstance;
- (void)handleSiriButtonUpEventFromSource:(int)arg1;
- (_Bool)handleSiriButtonDownEventFromSource:(int)arg1 activationEvent:(int)arg2;
@end

@interface SBSearchViewController
- (void)dismissAnimated:(_Bool)arg1 completionBlock:(id)arg2;
- (void)_searchFieldEditingChanged;
@end

static SpringBoard *springBoard = nil;

%hook SBSearchViewController

- (void)_searchFieldReturnPressed {
    SBSearchHeader *_searchHeader = MSHookIvar<SBSearchHeader*>(self, "_searchHeader");
    UITextField *searchField = _searchHeader.searchField;
    
    NSString *searchString = [searchField.text lowercaseString];
    if ([searchString hasPrefix:@"siri"]) {
        NSString *searchStringWithoutSiri = [searchString
                                         stringByReplacingOccurrencesOfString:@"siri" withString:@""];
        if (![[searchStringWithoutSiri stringByReplacingOccurrencesOfString:@" " withString:@""] isEqual:@""]) {
            NSArray *myStrings = [NSArray arrayWithObjects:searchStringWithoutSiri, nil];
            [springBoard setNextAssistantRecognitionStrings:myStrings];
        }
        SBAssistantController *assistantController = [%c(SBAssistantController) sharedInstance];
        [assistantController handleSiriButtonDownEventFromSource:1 activationEvent:1];
        [assistantController handleSiriButtonUpEventFromSource:1];
        searchField.text = @"";
        [self _searchFieldEditingChanged];
        [self dismissAnimated:YES completionBlock:nil];
    } else {
        %orig;
    }
}

%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)fp8 {
    %orig;
    springBoard = self;
}

%end