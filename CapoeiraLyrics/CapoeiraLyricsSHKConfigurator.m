//
//  CapoeiraLyricsSHKConfigurator.m
//  CapoeiraLyrics
//
//  Created by Vlad Tsepelev on 19.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CapoeiraLyricsSHKConfigurator.h"

#import "PrivateConstants.h"

@implementation CapoeiraLyricsSHKConfigurator


-(NSString *)appName{
    return [PrivateConstants appName];
}

-(NSString *)appURL{
    return [PrivateConstants appURL];
}

-(NSString *)facebookAppId{
    return [PrivateConstants facebookAppId];
}

-(NSString *)facebookLocalAppId{
    if([Configuration isLiteVersion])
        return @"lite";
    else if([Configuration isFullVersion]){
        return @"full";
    }else {
        return @"";
    }
}

-(NSString *)twitterConsumerKey{
    return [PrivateConstants twitterConsumerKey];
}

-(NSString *)twitterSecret{
    return [PrivateConstants twitterSecret];
}

-(NSNumber *)allowAutoShare{
    return [NSNumber numberWithBool:NO];
}

-(NSNumber *)allowOffline{
    return [NSNumber numberWithBool:NO];
}





@end
