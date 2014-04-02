//
//  StatSet.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 02.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "StatSet.h"


@implementation StatSet

@dynamic aMelee;
@dynamic aRange;
@dynamic bs;
@dynamic ag;
@dynamic wp;
@dynamic m;
@dynamic name;
@dynamic str;
@dynamic to;
@dynamic w;
@dynamic ws;
@dynamic intl;
@dynamic cha;

+(StatSet *)createTemporaryStatSetWithM:(int)M
                                 withWs:(int)Ws
                                 withBS:(int)Bs
                                  withStr:(int)Str
                                  withTo:(int)To
                                  withAg:(int)Ag
                                 withWp:(int)Wp
                                  withInt:(int)Intl
                                 withCha:(int)Cha
                             withAMelee:(int)AMelee
                             withARange:(int)ARange
                                  withW:(int)W
                            withContext:(NSManagedObjectContext *)context;
{
    StatSet *statSet = [NSEntityDescription insertNewObjectForEntityForName:@"StatSet" inManagedObjectContext:context];
    statSet.m = M;
    statSet.ws = Ws;
    statSet.bs = Bs;
    statSet.w = W;
    statSet.aMelee = AMelee;
    statSet.aRange = ARange;
    statSet.str = Str;
    statSet.to = To;
    statSet.ag = Ag;
    statSet.wp = Wp;
    statSet.intl = Intl;
    statSet.cha = Cha;
    
    return statSet;
}

+(NSArray *)fetchStatSetsWithContext:(NSManagedObjectContext *)context;
{
    NSArray *allStatSets = [StatSet fetchRequestForObjectName:@"StatSet" withPredicate:[NSPredicate predicateWithFormat:@"name != nil"] withContext:context];
    return allStatSets;
}

+(StatSet *)fetchStatSetWithName:(NSString *)setName withContext:(NSManagedObjectContext *)context;
{
    NSArray *allStatSets = [StatSet fetchRequestForObjectName:@"StatSet" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",setName] withContext:context];
    return [allStatSets lastObject];
}

+(BOOL)deleteStatSetWithName:(NSString *)setName withContext:(NSManagedObjectContext *)context;
{
    return [StatSet clearEntityForNameWithObjName:@"StatSet" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",setName] withGivenContext:context];
}
@end
