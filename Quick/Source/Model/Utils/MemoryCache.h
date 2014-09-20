//
//  MemoryCache.h
//  Quick
//
//  Created by hello on 14-9-20.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

/**
 * we probably need this memory cache to track all buffs across the app
 * to consider this situation, if we have many buffers
 * 
 * save
 * load
 * remove
 *
 * should I use core data or not, the purpose is to keep the memory 
 * usage more effective, we know the data is kept in memory, and we 
 * use variable refered to it, and if we didn't manage all references 
 * well, the data could be retained in memory and not released.
 *
 * for this problem, to build a memory cache for all those data, 
 * is it a better idea or not?
 *
 */

#import "Model.h"

@interface MemoryCache : Model

@end
