//
// SyngleChance Engine - macos-bindings.mm
// ©2018 Vinyl Darkscratch.  You may use this code for anything you'd like.
// https://www.queengoob.org
//

#include "macos-bindings.h"
#include <string>

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

BOOL isCached = NO;

NSURL *originalBackground;
NSDictionary<NSWorkspaceDesktopImageOptionKey, id> *originalOptions;

NSScreen *screen = [NSScreen mainScreen];
NSWorkspace *sharedworkspace = [NSWorkspace sharedWorkspace];

void macOS::CacheCurrentBackground() {
	if (isCached == NO) {
		originalBackground = [sharedworkspace desktopImageURLForScreen:screen];
		originalOptions = [sharedworkspace desktopImageOptionsForScreen:screen];
	}
	isCached = YES;
}

void macOS::ChangeBackground(std::string imageURL, double red, double green, double blue) {
	NSURL *URL = [NSURL fileURLWithPath:@(imageURL.c_str())];
	NSDictionary<NSWorkspaceDesktopImageOptionKey, id> *options = @{NSWorkspaceDesktopImageScalingKey : @3, NSWorkspaceDesktopImageAllowClippingKey : @0, NSWorkspaceDesktopImageFillColorKey : [NSColor colorWithSRGBRed:red green:green blue:blue alpha:1.0]};
	NSError *error = nil;

	BOOL success = [sharedworkspace setDesktopImageURL:[URL absoluteURL] forScreen:screen options:options error:&error];
	if (!success) {
		NSLog(@"ERROR DURING DESKTOP BACKGROUND CHANGE: %@", error);
	}
}

void macOS::ResetBackground() {
	NSError *error = nil;
	if (isCached) {
		BOOL success = [sharedworkspace setDesktopImageURL:originalBackground forScreen:screen options:originalOptions error:&error];
		if (!success) {
			NSLog(@"ERROR DURING DESKTOP BACKGROUND RESET: %@", error);
		}
	}
}

void macOS::Beep() {
	NSBeep();
}
