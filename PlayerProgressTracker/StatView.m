//
//  StatView.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 03.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "StatView.h"
#import "Character.h"
#import "Skill.h"
#import "WarhammerDefaultSkillSetManager.h"

@interface StatView()

//direct links on characters core skills
@property (nonatomic) Skill *mSkill;
@property (nonatomic) Skill *wsSkill;
@property (nonatomic) Skill *bsSkill;
@property (nonatomic) Skill *sSkill;
@property (nonatomic) Skill *tSkill;
@property (nonatomic) Skill *iSkill;
@property (nonatomic) Skill *ldSkill;
@property (nonatomic) WarhammerDefaultSkillSetManager *skillManager;

@end

@implementation StatView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setCharacter:(Character *)character
{
    if (character){
        _character = character;
        [self updateStats];
    }
}

-(WarhammerDefaultSkillSetManager *)skillManager
{
    if (!_skillManager){
        _skillManager = [WarhammerDefaultSkillSetManager sharedInstance];
    }
    
    return _skillManager;
}

-(Skill *)mSkill
{
    _mSkill = [self.skillManager checkCoreSkillWithTemplate:self.skillManager.movement withCharacter:self.character];
    return _mSkill;
}

-(Skill *)wsSkill
{
    _wsSkill = [self.skillManager checkCoreSkillWithTemplate:self.skillManager.weaponSkill withCharacter:self.character];
    return _wsSkill;
}

-(Skill *)bsSkill
{
    _bsSkill = [self.skillManager checkCoreSkillWithTemplate:self.skillManager.ballisticSkill withCharacter:self.character];
    return _bsSkill;
}

-(Skill *)sSkill
{
    _sSkill = [self.skillManager checkCoreSkillWithTemplate:self.skillManager.strenght withCharacter:self.character];
    return _sSkill;
}

-(Skill *)tSkill
{
    _tSkill = [self.skillManager checkCoreSkillWithTemplate:self.skillManager.toughness withCharacter:self.character];
    return _tSkill;
}

-(Skill *)iSkill
{
    _iSkill = [self.skillManager checkCoreSkillWithTemplate:self.skillManager.initiative withCharacter:self.character];
    return _iSkill;
}

-(Skill *)ldSkill
{
    _ldSkill = [self.skillManager checkCoreSkillWithTemplate:self.skillManager.toughness withCharacter:self.character];
    return _ldSkill;
}

-(void)updateStats
{
    self.m.text = [NSString stringWithFormat:@"%d",self.mSkill.thisLvl];
    self.ws.text = [NSString stringWithFormat:@"%d",self.wsSkill.thisLvl];
    self.bs.text = [NSString stringWithFormat:@"%d",self.bsSkill.thisLvl];
    self.s.text = [NSString stringWithFormat:@"%d",self.sSkill.thisLvl];
    self.t.text = [NSString stringWithFormat:@"%d",self.tSkill.thisLvl];
    self.i.text = [NSString stringWithFormat:@"%d",self.iSkill.thisLvl];
    self.ld.text = [NSString stringWithFormat:@"%d",self.ldSkill.thisLvl];
    self.w.text = [NSString stringWithFormat:@"%d",self.character.wounds];
    self.a.enabled = false; //TODO smart count
}

-(void)initFields
{
    if (!self.settable){
        
        self.m.enabled = false;
        self.ws.enabled = false;
        self.bs.enabled = false;
        self.s.enabled = false;
        self.t.enabled = false;
        self.i.enabled = false;
        self.w.enabled = false;
        self.a.enabled = false;
        self.ld.enabled = false;
        
        self.m.backgroundColor = [UIColor clearColor];
        self.ws.backgroundColor = [UIColor clearColor];
        self.bs.backgroundColor = [UIColor clearColor];
        self.s.backgroundColor = [UIColor clearColor];
        self.t.backgroundColor = [UIColor clearColor];
        self.i.backgroundColor = [UIColor clearColor];
        self.w.backgroundColor = [UIColor clearColor];
        self.a.backgroundColor = [UIColor clearColor];
        self.ld.backgroundColor = [UIColor clearColor];
    }
    else{
        self.m.delegate = _executer;
        self.ws.delegate = _executer;
        self.bs.delegate = _executer;
        self.s.delegate = _executer;
        self.t.delegate = _executer;
        self.i.delegate = _executer;
        self.w.delegate = _executer;
        self.a.delegate = _executer;
        self.ld.delegate = _executer;
        
        self.m.enabled = true;
        self.ws.enabled = true;
        self.bs.enabled = true;
        self.s.enabled = true;
        self.t.enabled = true;
        self.i.enabled = true;
        self.w.enabled = true;
        self.a.enabled = true;
        self.ld.enabled = true;
        
        self.m.backgroundColor = [UIColor whiteColor];
        self.ws.backgroundColor = [UIColor whiteColor];
        self.bs.backgroundColor = [UIColor whiteColor];
        self.s.backgroundColor = [UIColor whiteColor];
        self.t.backgroundColor = [UIColor whiteColor];
        self.i.backgroundColor = [UIColor whiteColor];
        self.w.backgroundColor = [UIColor whiteColor];
        self.a.backgroundColor = [UIColor whiteColor];
        self.ld.backgroundColor = [UIColor whiteColor];
    }
}


-(BOOL)nonEmptyStats
{
    if (self.m.text.length == 0 || self.ws.text.length == 0 || self.bs.text.length == 0 || self.s.text.length == 0 || self.t.text.length == 0 || self.i.text.length == 0 || self.w.text.length == 0 || self.a.text.length == 0 || self.ld.text.length == 0){
        return false;
    }
    
    return true;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
