//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface ProfileView : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate,UITableViewDelegate, UITableViewDataSource>
{
    int totalbadgecount;
    int totalworkerbadgecount;
    BOOL checkfirst;
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic,retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) NSString* stringPosted;
@property (nonatomic, retain) NSString* stringPerformed;

@end
