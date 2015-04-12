//
//  ViewController.h
//  battle
//
//  Created by Nana Kwame Owusu on 3/27/15.
//  Copyright (c) 2015 Nana Kwame Owusu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shipView.h"
#import "BoardCell.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController{
    
    
    NSMutableArray* p1_ships;
    NSMutableArray* p2_ships;
    int cells_on_side;
    int ship_chosen;
    int attackCellSide;
    int defenseCellSide;
    CGPoint five_init_loc;
    CGPoint four_init_loc;
    CGPoint three_1_init_loc;
    CGPoint three_2_init_loc;
    CGPoint two_init_loc;
    
    bool isSinglePlayer;
    bool player_turn;
    
    bool is_init_turn_1;
    bool is_init_turn_2;
    IBOutlet UITextView *instructions;
    
    AVAudioPlayer* sink_sound;
    AVAudioPlayer* win_sound;
    
    bool attack_cell_chosen;
    
    
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

@property (strong, nonatomic) IBOutlet UILabel *currentPlayer;


@property (strong, nonatomic) IBOutlet UIButton *nextViewbutton;

@property (strong, nonatomic) IBOutlet UIView *attack_board;

@property (strong, nonatomic) IBOutlet UIView *defense_board;


@property (strong, nonatomic) IBOutlet UIView *ship_dock;

-(void)show_board:(int)cellSide forView:(UIView*)myview attViews:(bool) doit storedCells:(NSMutableArray*)source;

-(void)set_isInitForP1:(bool)isInitP1 ForP2:(bool)isInitP2;

-(void)setTurn:(bool)the_turn;
-(bool)getTurn;

-(void)rotateShip: (UITapGestureRecognizer *) sender;
-(bool)getSinglePlayer;
-(void)setSinglePlayer:(bool)player_state;

@end

