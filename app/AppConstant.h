
#import "AppDelegate.h"
#import "UserReview.h"
//-------------------------------------------------------------------------------------------------------------------------------------------------
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		FIREBASE							@"https://bazr.firebaseio.com"

//-------------------------------------------------------------------------------------------------------------------------------------------------


#define		PF_CATEGORY_CLASS_NAME					@"Category"				//	Class name


#define		PF_INSTALLATION_CLASS_NAME			@"_Installation"		//	Class name
#define		PF_INSTALLATION_OBJECTID			@"objectId"				//	String
#define		PF_INSTALLATION_USER				@"user"					//	Pointer to User Class
#define		PF_INSTALLATION_BADGE				@"badge"					//	Pointer to User Class

#define		PF_USER_CLASS_NAME					@"_User"				//	Class name
#define		PF_USER_OBJECTID					@"objectId"				//	String
#define		PF_USER_USERNAME					@"username"				//	String
#define		PF_USER_PASSWORD					@"password"				//	String
#define		PF_USER_EMAIL						@"email"				//	String
#define		PF_USER_EMAILCOPY					@"emailCopy"			//	String
#define		PF_USER_FULLNAME					@"fullname"				//	String
#define		PF_USER_FULLNAME_LOWER				@"fullname_lower"		//	String
#define		PF_USER_PHONENUBER					@"phoneNumber"			//	String
#define		PF_USER_FACEBOOKID					@"facebookId"			//	String
#define		PF_USER_PICTURE						@"picture"				//	File
#define		PF_USER_THUMBNAIL					@"thumbnail"			//	File


#define		PF_BIDLIST_CLASS_NAME				@"BidList"              //	Class name
#define		PF_BIDLIST_JOBID                    @"JobPointer"			//	Pointer to Chatroom Class
#define		PF_BIDLIST_POSTER                   @"Poster"              //	Pointer to user Class
#define		PF_BIDLIST_BIDDER                   @"Bidder"              //	Pointer to user Class
#define		PF_BIDLIST_DESCRIPTION              @"bidDescription"      //	String
#define		PF_BIDLIST_PRICE                    @"BidPrice"            //	Number
#define		PF_BIDLIST_REJECTED                 @"Rejected"            //	BOOL


#define		PF_CHATROOMS_CLASS_NAME				@"ChatRooms"			//	Class name
#define		PF_CHATROOMS_NAME					@"name"					//	String
#define		PF_CHATROOMS_DESCRIPTION			@"chatDescription"		//	String
#define		PF_CHATROOMS_CATEGORY               @"Category"             //	String
#define		PF_CHATROOMS_POSTDATE               @"Postdate"             //	Date
#define		PF_CHATROOMS_EXPIREDATE             @"Expiredate"           //	Date
#define		PF_CHATROOMS_BUDGET                 @"Budget"               //	String
#define		PF_CHATROOMS_LOCATION               @"Location"             //	PFGeo
#define		PF_CHATROOMS_CREATEDAT			    @"createdAt"		    //	Date
#define		PF_CHATROOMS_UPDATEDAT			    @"updatedAt"		    //	Date
#define		PF_CHATROOMS_POSTER					@"Poster"				//	Pointer to User Class
#define		PF_CHATROOMS_AWARDED			    @"awarded"              //	BOOL
#define		PF_CHATROOMS_COMPLETE			    @"completed"            //	BOOL
#define		PF_CHATROOMS_BADGE                  @"badgecount"			//	Number
#define     PF_CHATROOMS_BADGEWORKER            @"badgecountworker"     //  Number
#define		PF_CHATROOMS_AWARDED_USER			@"awardedUser"          //	Pointer to User Class
#define		PF_CHATROOMS_COUNT_BID				@"bidcount"				//	Number
#define		PF_CHATROOMS_RATING                 @"rating"				//	Number
#define		PF_CHATROOMS_COUNT_VIEW				@"viewcount"			//	Number
#define		PF_CHATROOMS_COUNT_MSG				@"messagecount"			//	Number


#define		PF_MESSAGES_CLASS_NAME				@"Messages2"			//	Class name
#define		PF_MESSAGES_USER					@"user"					//	Pointer to User Class
#define		PF_MESSAGES_ROOMID					@"roomId"				//	String
#define		PF_MESSAGES_DESCRIPTION				@"description"			//	String
#define		PF_MESSAGES_LASTUSER				@"lastUser"				//	Pointer to User Class
#define		PF_MESSAGES_LASTMESSAGE				@"lastMessage"			//	String
#define		PF_MESSAGES_COUNTER					@"counter"				//	Number
#define		PF_MESSAGES_UPDATEDACTION			@"updatedAction"		//	Date

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		NOTIFICATION_APP_STARTED			@"NCAppStarted"
#define		NOTIFICATION_USER_LOGGED_IN			@"NCUserLoggedIn"
#define		NOTIFICATION_USER_LOGGED_OUT		@"NCUserLoggedOut"


// Posts
#define		PF_POSTS_CLASS_NAME                 @"Posts"                //	Class name
#define		PF_POSTS_USERKEY                    @"userKey"              //	String
#define		PF_POSTS_USERNAMEKEY                @"usernameKey"          //	String
#define		PF_POSTS_TEXTKEY                    @"textKey"              //	String
#define		PF_POSTS_LOCATIONKEY                @"locationKey"          //	String
#define		PF_POSTS_NAMEKEY                    @"nameKey"              //	String

// NSNotification userInfo keys:
#define		PF_POSTS_FILTERDISTANCEKEY          @"filterDistance"       //	String
#define		PF_POSTS_LOCATION                   @"location"             //	String
#define		PF_POSTS_FILTERDISTANCEDIDCHANGE    @"filterDistanceDidChangeNotification"              //	String
#define		PF_POSTS_CURRENTLOCATIONDIDCHANGE   @"CurrentLocationDidChangeNotification"             //	String
#define		PF_POSTS_CREATENOFICATION           @"PostCreatedNotification"                          //	String
#define		PF_POSTS_CANTVIEWPOST               @"CantViewPost"
#define		PF_POSTS_USERDEFAULTSDISTANCEKEY    @"filterDistanceKey" 
#define		PF_POSTS_LOCATIONACCURACY           @"locationAccuracy"     // Double


//static NSString * const kFilterDistanceKey = @"filterDistance";
//static NSString * const kPAWLocationKey = @"location";
//static NSString * const PAWFilterDistanceDidChangeNotification = @"PAWFilterDistanceDidChangeNotification";
//static NSString * const PAWCurrentLocationDidChangeNotification = @"PAWCurrentLocationDidChangeNotification";
//static NSString * const PAWPostCreatedNotification = @"PAWPostCreatedNotification";
//static NSString * const kPAWWallCantViewPost = @"Can’t view post! Get closer.";
//static NSString * const PAWUserDefaultsFilterDistanceKey = @"filterDistance";
//typedef double PAWLocationAccuracy;



//#define		PF_POSTS_TITLE                      @"title"                //	String
//#define		PF_POSTS_POSTUSER                   @"postUser"             //	Pointer to User Class
//#define		PF_POSTS_DESCRIPTION				@"postDescription"		//	String


//static double FeetToMeters(double feet) {
//    return feet * 0.3048;
//}
//
//static double MetersToFeet(double meters) {
//    return meters * 3.281;
//}
//
//static double MetersToKilometers(double meters) {
//    return meters / 1000.0;
//}

static double const DefaultFilterDistance = 1000.0;
static double const PostMaximumSearchDistance = 100.0; // Value in kilometers
//static int *PostsSearchDefaultLimit = 20;



#define APP_DELEGATE  ((AppDelegate*)[[UIApplication sharedApplication] delegate])


#define kLabelAllowance 50.0f
#define kStarViewHeight 30.0f
#define kStarViewWidth 160.0f
#define kLeftPadding 5.0f

#define kTabBarHeight 0


