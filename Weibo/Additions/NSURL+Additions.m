//
//  NSURL+Additions.m
//  NetEaseMicroBlog
//
//  Created by wuzhikun on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSURL+Additions.h"


@implementation NSURL (Additions)

+ (NSDictionary *)parseURLQueryString:(NSString *)queryString {
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
	for(NSString *pair in pairs) {
		NSArray *keyValue = [pair componentsSeparatedByString:@"="];
		if([keyValue count] == 2) {
			NSString *key = [keyValue objectAtIndex:0];
			NSString *value = [keyValue objectAtIndex:1];
			value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			if(key && value)
				[dict setObject:value forKey:key];
		}
	}
	return [NSDictionary dictionaryWithDictionary:dict];
}

+ (NSURL *)smartURLForString:(NSString *)str {
	NSURL *     result;
	NSString *  trimmedStr;
	NSRange     schemeMarkerRange;
	NSString *  scheme;
	
	assert(str != nil);
	
	result = nil;
	
	trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
		schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
		
		if (schemeMarkerRange.location == NSNotFound) {
			result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
		} else {
			scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
			assert(scheme != nil);
			
			if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
				|| ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
				result = [NSURL URLWithString:trimmedStr];
			} else {
				// It looks like this is some unsupported URL scheme.
			}
		}
	}
	
	return result;
}

@end
