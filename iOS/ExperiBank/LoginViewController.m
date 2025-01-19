//
//  LoginViewController.h
//  NiftyGifties
//
//  Created by TechFlitter on 09/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "PaymentHomeViewController.h"

#define INIT_BALANCE 100.0f

@implementation LoginViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(!self)
        return nil;
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setAccessibilityLabel:@"loginView"];
    [scrollView setAccessibilityLabel:@"scrollView"];
    [versionLabel setAccessibilityLabel:@"versionLabel"];
    [usernameTextField setAccessibilityLabel:@"usernameTextField"];
    [usernameTextField setAccessibilityIdentifier:@"usernameTextField"];
    [passwordTextField setAccessibilityLabel:@"passwordTextField"];
    [passwordTextField setAccessibilityIdentifier:@"passwordTextField"];
    [loginButton setAccessibilityLabel:@"loginButton"];
    
    scrollView.contentSize = self.view.frame.size;
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    versionLabel.text = [NSString stringWithFormat:@"Build Version : %@", [infoDict objectForKey:@"CFBundleVersion"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emailOrPasswordChanged)
                                                 name:UITextFieldTextDidChangeNotification object:nil];
    [usernameTextField setText:@"company"];
    [passwordTextField setText:@"company"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    usernameTextField = nil;
    passwordTextField = nil;
    loginButton = nil;
}

- (void)displayErrorAlert:(NSString *)message 
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"EriBank", @"EriBank")
                                message:message
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"Dismiss", @"Dismiss")
                      otherButtonTitles:nil] show];
}

- (IBAction)emailOrPasswordChanged
{
    //[loginButton setEnabled:[self readyToSignIn]];
}

- (BOOL)readyToSignIn
{
    return [usernameTextField.text length] != 0 && [passwordTextField.text length] != 0;
}

- (BOOL)validSignIn
{
    return [usernameTextField.text isEqualToString:@"company"] && [passwordTextField.text isEqualToString:@"company"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)source
{
    if(source == usernameTextField)
        [passwordTextField becomeFirstResponder];
    else if(source == passwordTextField)
        [self loginPressed:source];
    
    return YES;
}

- (IBAction)loginPressed:(id)source
{
    [usernameTextField resignFirstResponder]; 
    [passwordTextField resignFirstResponder]; 
    
    if(![self validSignIn]) {
        [self displayErrorAlert:@"Invalid username or password!"];
        return;
    }
    
    BOOL isRefilled = [[NSUserDefaults standardUserDefaults] boolForKey:@"Refilled"];
    if (!isRefilled) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Refilled"];
        [[NSUserDefaults standardUserDefaults] setFloat:INIT_BALANCE forKey:@"Balance"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    PaymentHomeViewController *paymentHomeViewController = [[PaymentHomeViewController alloc]
                                                            initWithNibName:@"PaymentHomeViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:paymentHomeViewController];
    navigationController.navigationBarHidden = YES;
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self emailOrPasswordChanged];
    [self.view endEditing:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end
