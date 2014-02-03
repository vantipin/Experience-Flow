//
//  StatSet.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 07.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "StatSet.h"


@implementation StatSet

@dynamic name;
@dynamic m;
@dynamic ws;
@dynamic bs;
@dynamic s;
@dynamic t;
@dynamic ld;
@dynamic i;
@dynamic a;
@dynamic w;

+(StatSet *)createStatSetWithName:(NSString *)setName withM:(int)M withWs:(int)WS withBS:(int)BS withS:(int)S withT:(int)T withI:(int)Initiative withA:(int)A withW:(int)W withLD:(int)LD withContext:(NSManagedObjectContext *)context
{
    StatSet *statSet = [StatSet fetchStatSetWithName:setName withContext:context];
    if (!statSet)
    {
        statSet = [NSEntityDescription insertNewObjectForEntityForName:@"StatSet" inManagedObjectContext:context];
        
        statSet.name = setName;
        statSet.m = M;
        statSet.ws = WS;
        statSet.bs = BS;
        statSet.s = S;
        statSet.t = T;
        statSet.i = Initiative;
        statSet.a = A;
        statSet.w = W;
        statSet.ld = LD;
        
        [StatSet saveContext:context];
    
    }
    return statSet;
}


+(NSArray *)fetchStatSetsWithContext:(NSManagedObjectContext *)context
{
    return [StatSet fetchRequestForObjectName:@"StatSet" withPredicate:nil withContext:context];
}

+(StatSet *)fetchStatSetWithName:(NSString *)setName withContext:(NSManagedObjectContext *)context
{
    NSArray *array = [StatSet fetchRequestForObjectName:@"StatSet"
                                       withPredicate:[NSPredicate predicateWithFormat:@"name = %@",setName]
                                         withContext:context];
    StatSet *statSet = (array)?[array lastObject]:nil;
    return statSet;
}

+(BOOL)deleteStatSetWithName:(NSString *)setName withContext:(NSManagedObjectContext *)context
{
    return [StatSet clearEntityForNameWithObjName:@"StatSet" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",setName] withGivenContext:context];
}

@end
