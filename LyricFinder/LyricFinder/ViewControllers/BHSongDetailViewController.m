//
//  SongDetailViewController.m
//  LyricFinder
//
//  Created by Benjamin Hakes on 3/1/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

#import "BHSongDetailViewController.h"
#import "BHSearchNetworkController.h"
#import "BHSong.h"
#import "BHSongController.h"

@interface BHSongDetailViewController ()


@end

@implementation BHSongDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self updateViews];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _searchController = [[BHSearchNetworkController alloc] init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _searchController = [[BHSearchNetworkController alloc] init];
    }
    return self;
}

-(void)updateViews{
    
    _lyricTextView.text = [_song lyrics];
    _songNameTextField.text = [_song title];
    _artistNameTextField.text = [_song artist];
    
    [self updateRating];
}

- (void) updateRating{
    
    NSString *newRatingString = [NSString stringWithFormat:@"Rating: %.0f", [_song rating]];
    _ratingLabel.text = newRatingString;
    
}

- (IBAction)stepperTapped:(id)sender {
    
    UIStepper *stepper = (UIStepper*)sender;
    double newRatingValue = [stepper value];
    
    if (newRatingValue > 5) {
        newRatingValue = 5;
    } else if (newRatingValue < 0) {
        newRatingValue = 0;
    }
    
    [_song setRating:newRatingValue];

    [self updateRating];
}

- (IBAction)searchButtonTapped:(id)sender {
    
    [_searchController searchForSongLyricsForArtist:[_artistNameTextField text] withSong:[_songNameTextField  text] completion:^(NSString *lyrics, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lyricTextView.text = lyrics;
        });
    
    }];
}

- (IBAction)saveButtonTapped:(id)sender {
    
    _song.rating = [_ratingStepper value];
    _song.title = [_songNameTextField text];
    _song.artist = [_artistNameTextField text];
    _song.lyrics = [_lyricTextView text];
    
    if (_isUpdatingView) {
        [_songController updateSong:_song];
    } else {
        [_songController createSong:_song];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
