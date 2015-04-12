//
//  transitionsView.h
//  battle
//
//  Created by Nana Kwame Owusu on 3/29/15.
//  Copyright (c) 2015 Nana Kwame Owusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface transitionsView : UIViewController{
    
    
    IBOutlet UITextView *messageBoard;
    bool player_turn;
    bool game_type;
    bool is_init_turn_1;
    bool is_init_turn_2;
    
}

@property (nonatomic, strong) NSMutableArray* p1_attackCells;
@property (nonatomic, strong) NSMutableArray* p1_defenseCells;
@property (nonatomic, strong) NSMutableArray* p2_attackCells;
@property (nonatomic, strong) NSMutableArray* p2_defenseCells;
@property (nonatomic, strong) NSMutableArray* p1_ship_sizes;
@property (nonatomic, strong) NSMutableArray* p2_ship_sizes;

@property (nonatomic, strong) NSString* player1;
@property (nonatomic, strong) NSString* player2;

@property (nonatomic, strong) NSMutableArray* computer_hits;

-(void)set_isInitForP1:(bool)isInitP1 ForP2:(bool)isInitP2;


-(void)setTurn:(bool)the_turn;
-(bool)getTurn;

-(void)setGameType:(bool)the_type;
-(bool)getGameType;

@end
