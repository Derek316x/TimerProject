//
//  ViewController.m
//  TimerProject
//
//  Created by Z on 8/15/15.
//  Copyright (c) 2015 dereknetto. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *highscoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *loseLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;
@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *backToTitleButton;


@property (nonatomic) BOOL gameButtonPressed;
@property (nonatomic) BOOL winEnabled;

@property (weak, nonatomic) IBOutlet UIView *gameButtonView;

@property (nonatomic) double time;
@property (nonatomic) NSTimer *gameTimer;
@property (nonatomic) NSTimer *startGameEventTimer;

@property (nonatomic) double highscore;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.highscore = 999;
    self.gameButtonView.layer.cornerRadius = self.gameButtonView.bounds.size.width/2;
    [self titleScreenView];
}

- (IBAction)playButtonTapped:(UIButton *)sender {
    [self newGameView];
    [self startGame];
}
- (IBAction)playAgainButtonTapped:(UIButton *)sender {
    [self newGameView];
    [self startGame];
}

- (IBAction)backToMainButtonTapped:(UIButton *)sender {
    [self titleScreenView];
}

#pragma mark - View update methods

-(void)titleScreenView{
    self.titleLabel.hidden = NO;
    self.playButton.hidden = NO;
    self.highscoreLabel.hidden = NO;
    
    double highscore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Highscore"] doubleValue];
    self.highscoreLabel.text = [NSString stringWithFormat:@"%.3lf",highscore];

    self.timerLabel.hidden = YES;
    self.gameButtonView.hidden = YES;
    self.loseLabel.hidden = YES;
    self.playAgainButton.hidden = YES;
    self.backToTitleButton.hidden = YES;
}

-(void)newGameView{
    self.gameButtonView.hidden = NO;
    self.gameButtonView.backgroundColor = [UIColor redColor];
    
    self.loseLabel.hidden = YES;
    self.timerLabel.hidden = YES;
    self.titleLabel.hidden = YES;
    self.highscoreLabel.hidden = YES;
    self.playButton.hidden = YES;
    self.playAgainButton.hidden = YES;
    self.backToTitleButton.hidden = YES;
    
}

#pragma mark - Game lifecycle methods

-(void)startGame{
    
    self.gameButtonPressed = NO;
    self.winEnabled = NO;
    self.time = 0.00;
    self.timerLabel.text = [NSString stringWithFormat:@"%.3lf",self.time];
    
    //calls startGameEvent method after random time
    double randomTime = (((double)arc4random_uniform(999)/999) * 6) + 1;
    NSTimer *timerToStartGameEvent = [NSTimer timerWithTimeInterval:randomTime target:self selector:@selector(startGameEvent) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timerToStartGameEvent forMode:NSDefaultRunLoopMode];
    self.startGameEventTimer = timerToStartGameEvent;
}

-(void)startGameEvent{
    if (self.gameButtonPressed == NO) {
        
        self.winEnabled = YES;
        
        NSLog(@"creating timer...");
        self.gameTimer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        NSLog(@"adding timer to run loop...");
        [[NSRunLoop currentRunLoop] addTimer:self.gameTimer forMode:NSDefaultRunLoopMode];
        
        self.timerLabel.hidden = NO;
        self.time = 0.00;
        self.timerLabel.text = [NSString stringWithFormat:@"%.3lf",self.time];
        
        self.gameButtonView.backgroundColor = [UIColor greenColor];
    }
}

- (IBAction)gameButtonTapped:(UIButton *)sender {
    self.gameButtonPressed = YES;
    NSLog(@"invaliding timer...");
     [self.gameTimer invalidate];
    
    NSLog(@"Game button pressed");
    
    if (self.winEnabled == NO) {
        
        self.loseLabel.hidden = NO;
        self.gameButtonView.hidden = YES;
        [self.startGameEventTimer invalidate];
        self.startGameEventTimer = nil;
    }
    
    self.playAgainButton.hidden = NO;
    self.backToTitleButton.hidden = NO;
    
    [self updateHighscore];
}

-(void)updateTime{
        self.time = self.time + 0.001;
        self.timerLabel.text = [NSString stringWithFormat:@"%.3lf",self.time];
}

-(void)updateHighscore{

    if ((self.highscore > self.time) && (self.time != 0.00)) {
        self.highscore = self.time;
        self.highscoreLabel.text = [NSString stringWithFormat:@"%.3lf",self.highscore];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithDouble:self.highscore] forKey:@"Highscore"];
    }
}

@end
