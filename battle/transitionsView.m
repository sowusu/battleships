//
//  transitionsView.m
//  battle
//
//  Created by Nana Kwame Owusu on 3/29/15.
//  Copyright (c) 2015 Nana Kwame Owusu. All rights reserved.
//

#import "transitionsView.h"
#import "ViewController.h"

@interface transitionsView ()

@end

@implementation transitionsView


@synthesize p1_defenseCells;
@synthesize p1_attackCells;
@synthesize p2_attackCells;
@synthesize p2_defenseCells;
@synthesize p1_ship_sizes;
@synthesize p2_ship_sizes;

@synthesize player1;
@synthesize player2;

@synthesize computer_hits;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString* player = player2;
    
    if (player_turn){
        player = player1;
    }
    
    if (game_type){
        if (is_init_turn_1 && player_turn){
            [messageBoard setText:[NSString stringWithFormat:@"%@, hit the ready button to position your fleet!", player]];
        }
        else if (is_init_turn_2 && !player_turn){
            [messageBoard setText:[NSString stringWithFormat:@"%@ completed fleet positioning! Press Ready to to position yours.", player]];
        }
        else{
            [messageBoard setText:[NSString stringWithFormat:@"%@ is about to play.", player]];
        }
    }
    else{
        if (is_init_turn_1 || is_init_turn_2){
            [messageBoard setText:[NSString stringWithFormat:@"%@, hit the ready button to position your fleet!", player]];
        }
        else{
            [messageBoard setText:[NSString stringWithFormat:@"%@ is about to play.", player]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)set_isInitForP1:(bool)isInitP1 ForP2:(bool)isInitP2{
    is_init_turn_1 = isInitP1;
    is_init_turn_2 = isInitP2;
}

-(void)setGameType:(bool)the_type{
    game_type = the_type;
}
-(bool)getGameType;{
    return game_type;
}

-(bool)getTurn{
    return player_turn;
}

-(void)setTurn:(bool)the_turn{
    player_turn = the_turn;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    ViewController* game_view_contoller = [segue destinationViewController];
    
    [game_view_contoller setP1_attackCells:p1_attackCells];
    [game_view_contoller setP1_defenseCells:p1_defenseCells];
    [game_view_contoller setP2_attackCells:p2_attackCells];
    [game_view_contoller setP2_defenseCells:p2_defenseCells];
    [game_view_contoller setP1_ship_sizes:p1_ship_sizes];
    [game_view_contoller setP2_ship_sizes:p2_ship_sizes];
    
    [game_view_contoller setPlayer1:player1];
    [game_view_contoller setPlayer2:player2];
    
    [game_view_contoller setComputer_hits:computer_hits];
    
    
    [game_view_contoller setSinglePlayer:game_type];
    [game_view_contoller setTurn:player_turn];
    [game_view_contoller set_isInitForP1:is_init_turn_1 ForP2:is_init_turn_2];
}


@end
