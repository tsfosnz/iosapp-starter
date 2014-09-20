//
//  NetworkCache.h
//  Quick
//
//  Created by hello on 14-9-20.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

/**
 * we probably need this network cache to track all data from network API,
 * from network API, we will fetch data and display them in View, 
 * what if the app is going offline this time? If we still have those 
 * data, then we can re-build a cached data for View.
 *
 * also the network API is alwasy the most time-consuming op, and what 
 * we can do, is to fetch the data only if it's updated
 *
 * so we will need this cache to save API data
 * use core data or not? From sqlite db op, we can get more simple solution, 
 * maybe core data is good too, but I prefer that the simple one I known.
 *
 * when we save those data, we can use key/value/timestamp storage pattern, and
 * the key is the identifier for the API, and the value is content from it, 
 * the timestamp is to track the update, or maybe we will need even more
 * ETag or something, I don't know it yet.
 *
 */

#import "Model.h"

@interface NetworkCache : Model

@end
