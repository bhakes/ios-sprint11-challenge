//
//  BHSearchNetworkController.m
//  LyricFinder
//
//  Created by Benjamin Hakes on 3/1/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

#import "BHSearchNetworkController.h"

@implementation BHSearchNetworkController


- (instancetype)init
{
    self = [super init];
    if (self) {
        _songs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)searchForSongLyricsForArtist:(NSString *)artist withSong:(NSString *)song completion:(void (^)(NSString *lyrics, NSError *))completion {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURLComponents *components = [NSURLComponents componentsWithURL:baseURL resolvingAgainstBaseURL:YES];
    
    NSURLQueryItem *artistItem = [NSURLQueryItem queryItemWithName:@"q_artist" value:artist];
    NSURLQueryItem *songItem = [NSURLQueryItem queryItemWithName:@"q_track" value:song];
    [components setQueryItems:@[artistItem, songItem]];
    
    NSURL *url = [components URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:apiKey forHTTPHeaderField:@"X-Mashape-Key"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error fetching data from Mashape API: %@", error);
            completion(nil, error);
            return;
        }
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        if (![dictionary isKindOfClass:[NSDictionary class]]) {
            NSLog(@"JSON is not a dictionary");
            completion(nil, [[NSError alloc] init]);
            return;
        }
        
        NSString *lyrics_body = dictionary[@"lyrics_body"];
        
        completion(lyrics_body, nil);
        
    }] resume];
    
}

static NSString * const baseURLString = @"https://musixmatchcom-musixmatch.p.rapidapi.com/wsr/1.1/matcher.lyrics.get";
static NSString * const apiKey = @"168ccdedc4msh7ab784d5d3d2678p168253jsn0b531d8de768";

@end
