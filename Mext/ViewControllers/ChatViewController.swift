import Foundation
import Firebase
import JSQMessagesViewController
import UIKit
import FirebaseDatabase
import Toast_Swift

class ChatViewController: JSQMessagesViewController {
    let TAG = "ChatViewController"
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    var currUser: User!
    var chatRoom: ChatRoom!
    var chatRoomName: String {
        return chatRoom.UID
    }
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(HexColorHelper.APPTHEME_GREEN)
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(HexColorHelper.APPTHEME_YELLOW)
    var currUserPhoto: UIImage! = UIImage(named:"nobody_m.original")!
    var chatPartnerPhoto: UIImage! = UIImage(named:"nobody_m.original")!
    
    var messages = [Message]()
    
    var localTyping = false
    var usersTypingQuery: FIRDatabaseQuery!
    
    var currWord = ""
    var currMessageLength = 0
    
    // Popup suggestion tableview for text
    var popUpTableView: UITableView? = nil
    let POPUPTAG = 10000001
    var soundClips: [SoundClip] = []
    var soundFileUrls = [String]()
    var attrStringIndex = [[Int]]()
    
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            FirebaseHelper.userIsTypingRef(chatRoomName).setValue(newValue)
        }
    }
    
    var chatingTextBox: UITextView?
    
    // Message editing
    let TEXTVIEW_TAG = 1000
    var prevCursorPosition = 0
    var currCursorPosition = 0
    var prevStartToCursorText = ""
    var currStartToCursorText = ""
    var isBackSpace = false
    var currLetter = ""
    
    var firstLetterIsSpace = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = chatRoom.title
        //self.collectionView.collectionViewLayout.bubbleSizeCalculator = CustomBubbleSizeCalculator()
        self.setup()
        self.observeMessages()
        self.observeTyping()
        //self.hideKeyboardWhenTappedAround()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardDidHide), name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
}

// MARK: Setup
extension ChatViewController {
    func setup() {
        self.senderId = currUser.UID
        self.senderDisplayName = currUser.displayName
        
//        let data = NSData(contentsOfURL: NSURL(string: currUser.photoUrl)!)!
//        let image = UIImage(data: data)!
//        image.af_inflate()
//        
//        currUserPhoto = image
//        
//        let data1 = NSData(contentsOfURL: NSURL(string: chatRoom.chatRoomPictureUrl)!)!
//        let image1 = UIImage(data: data1)!
//        image1.af_inflate()
//        
//        currUserPhoto = image1
    }
    
    func addMessage(id: String, text: String, soundFileUrls: [String]?, attrStringIndex: [[Int]]?) {
        let message = Message(senderId: id, displayName: "", text: text, soundFileUrls: soundFileUrls, attrStringIndex: attrStringIndex)
        messages.append(message)
    }
    
    private func observeMessages() {
        let messagesQuery = FirebaseHelper.messagesRef(chatRoomName).queryLimitedToLast(25)
        
        messagesQuery.observeEventType(.ChildAdded, withBlock: { snapshot in
            guard let value = snapshot.value as? [String: AnyObject] else { return }
            guard let id = value["senderId"] as? String else { return }
            guard let text = value["text"] as? String else { return }
            
            var soundFileURLs: [String]?
            
            if let urls = value["soundFileUrls"] as? [String] {
                soundFileURLs = urls
            }
            
            var attrStringIndex: [[Int]]?
            
            if let attrStringIndexArray = value["attrStringIndex"] as? [[Int]] {
                attrStringIndex = attrStringIndexArray
            }
            
            self.addMessage(id, text: text, soundFileUrls: soundFileURLs, attrStringIndex: attrStringIndex)
            
            //            let tempRef = FirebaseHelper.messagesRef(chatRoomName).child()
            //            tempRef.queryOrderedByChild("tag").queryEqualToValue("hello")
            //                .observeEventType(.ChildAdded, withBlock: { (snapshot) in
            //                    print(snapshot)
            //                    let text = snapshot.value!["soundName"]! as! String
            //                    print(text)
            //                })
            
            self.finishReceivingMessage()
        })
    }
    
    private func observeTyping() {
        let isTypingQuery = FirebaseHelper.userIsTypingRef(chatRoomName).child("1")
        isTypingQuery.onDisconnectRemoveValue()
        
        usersTypingQuery = isTypingQuery.queryOrderedByValue().queryEqualToValue(true)
        
        usersTypingQuery.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.childrenCount == 1 && self.isTyping {
                return
            }
            
            // 4 Are there others typing?
            self.showTypingIndicator = snapshot.childrenCount > 0
            self.scrollToBottomAnimated(true)
        })
        
    }
}

// MARK: ChatView implement method
extension ChatViewController {
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        self.messages.removeAtIndex(indexPath.row)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageAvatarImageDataSource? {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return JSQMessagesAvatarImageFactory.avatarImageWithPlaceholder(currUserPhoto, diameter: 12)
        default:
            return JSQMessagesAvatarImageFactory.avatarImageWithPlaceholder(chatPartnerPhoto, diameter: 12)
        }
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor.blackColor()
        }
        
        let attributedString = NSMutableAttributedString(string: message.text, attributes: [NSFontAttributeName: UIFont.init(name: "Helvetica Neue", size: 17.0)!])
        if let attrStringIndex = message.attrStringIndex {
            if let soundFileUrls = message.soundFileUrls{
                for (index, element) in attrStringIndex.enumerate() {
                    //attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor() , range: NSMakeRange(index[0],index[1]))
                    attributedString.addAttribute(NSLinkAttributeName, value: "playMusic://\(soundFileUrls[index])" , range: NSMakeRange(element[0],element[1]))
                }
            }
        }
        
        
        //                attributedString.addAttribute(NSForegroundColorAttributeName, value: GradientColor(UIGradientStyle.TopToBottom, frame: CGRect(x: 0, y: 0, width: 1000, height: 1000), colors: [UIColor.redColor(), UIColor.grayColor()]), range: myRange)
        cell.textView!.linkTextAttributes = [NSForegroundColorAttributeName: HexColorHelper.APPTHEME_PINK]
        cell.textView!.attributedText = attributedString
        cell.textView!.delegate = self
        return cell
    }
    
    override func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let absoluteString = URL.absoluteString
        if URL.scheme == "playMusic"{
            MusicPlayerHelper.playSoundClipFromUrl(absoluteString.substringFromIndex(absoluteString.startIndex.advancedBy(12)))
        }
        return true
    }
}

//MARK: Toolbar
extension ChatViewController {
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        if firstLetterIsSpace {
            self.view.makeToast("No blank space in the start of the sentence")
            return
        }
        
        let itemRef = FirebaseHelper.messagesRef(chatRoomName).childByAutoId()
        let messageItem = [
            "text": text,
            "senderId": senderId,
            "soundFileUrls": soundFileUrls,
            "attrStringIndex":attrStringIndex
        ]
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        FirebaseHelper.updateChatRoomLastMessage(chatRoomName, lastMessage: text)
        finishSendingMessage()
        
        if self.popUpTableView != nil {
            self.popUpTableView!.removeFromSuperview()
            self.popUpTableView = nil
        }
        chatingTextBox?.textColor = UIColor.blackColor()
        isTyping = false
        soundFileUrls = []
        attrStringIndex = [[Int]]()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
    }
    
    override func textViewDidBeginEditing(textView: UITextView) {
        chatingTextBox = textView
        textView.tag = TEXTVIEW_TAG
    }
    
    override func textViewDidChangeSelection(textView: UITextView) {
        if textView.tag == TEXTVIEW_TAG {
            if let selectedRange = textView.selectedTextRange {
                self.prevCursorPosition = self.currCursorPosition
                self.currCursorPosition = textView.offsetFromPosition(textView.beginningOfDocument, toPosition: selectedRange.start)
                
                var text: String = textView.text!
                let end = text.endIndex.advancedBy(0, limit: text.startIndex)
                self.prevStartToCursorText = self.currStartToCursorText
                self.currStartToCursorText = textView.textInRange(textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: selectedRange.start)!)!
                //                        var substring: String = text.substringToIndex(text.startIndex.advancedBy(currCursorPosition, limit: end))
                currMessageLength = String(currStartToCursorText).utf16.count
                currWord = currStartToCursorText.componentsSeparatedByString(" ").last!
                
                if !currWord.containsString(".") && !currWord.containsString("#") &&
                    !currWord.containsString("$") && !currWord.containsString("[") &&
                    !currWord.containsString("]") {
                    FirebaseHelper.searchSoundClip("\(currWord.lowercaseString)"){ matchingSoundClips in
                        if let matchingSoundClips = matchingSoundClips{
                            self.soundClips = matchingSoundClips
                            let resultsCount = self.soundClips.count
                            if resultsCount>0 {
                                let numRows = resultsCount>3 ?  3 : resultsCount
                                self.popUpTableView = UITableView(frame: CGRectMake(0, self.inputToolbar.frame.origin.y - CGFloat(48*numRows), self.inputToolbar.frame.width, CGFloat(48*numRows)))
                                self.popUpTableView!.rowHeight = 48.0
                                self.popUpTableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
                                self.popUpTableView!.delegate = self
                                self.popUpTableView!.dataSource = self
                                self.popUpTableView!.tag = self.POPUPTAG
                                self.view.addSubview(self.popUpTableView!)
                            }
                        } else {
                            if self.popUpTableView != nil {
                                self.popUpTableView!.removeFromSuperview()
                                self.popUpTableView = nil
                            }
                        }
                    }
                }
                
                //print("prevCursorPosition - \(prevCursorPosition)")
                //print("currCursorPosition - \(currCursorPosition)")
                //print("prevSubstring - \(prevStartToCursorText)")
                //print("currSubstring - \(currStartToCursorText)")
                //print("prevSubstring utf - \(String(prevStartToCursorText).utf16.count)")
                //print("currSubstring utf - \(String(currStartToCursorText).utf16.count)")
                //print("lastword - \(lastWord)")
                //print("text length - \(textView.text.characters.count)")
                //print("substring length - \(substring.characters.count)")
                //print("substring utf - \(String(substring).utf16.count)")
            }
        }
    }
    
    override func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        //        self.currLetter = text
        //        let  char = text.cStringUsingEncoding(NSUTF8StringEncoding)!
        //        let isBackSpace = strcmp(char, "\\b")
        //        if (isBackSpace == -92) {
        //            self.isBackSpace = true
        //        } else {
        //            self.isBackSpace = false
        //        }
        //
        if text == "" && range.length > 0 {
            let stringToDelete = (textView.text! as NSString).substringWithRange(range)
            self.isBackSpace = true
            self.currLetter = stringToDelete
        } else {
            self.isBackSpace = false
            self.currLetter = text
        }
        if text == UIPasteboard.generalPasteboard().string {
            chatingTextBox!.insertText("")
        }
        return true
    }
    
    override func textViewDidChange(textView: UITextView) {
        super.textViewDidChange(textView)
        
        let text = textView.text
        if text != "" {
            firstLetterIsSpace = text[text.startIndex.advancedBy(0)...text.startIndex.advancedBy(0)] == " "
        }
        
        for index in (0..<attrStringIndex.count).reverse() {
            if attrStringIndex[index][0] >= prevCursorPosition {
                attrStringIndex[index][0] = attrStringIndex[index][0] + (currCursorPosition-prevCursorPosition)
            } else if attrStringIndex[index][0] + attrStringIndex[index][1] >= prevCursorPosition {
                attrStringIndex.removeAtIndex(index)
                soundFileUrls.removeAtIndex(index)
                let attributedString = NSMutableAttributedString(string:chatingTextBox!.text, attributes: [NSFontAttributeName: UIFont.init(name: "Helvetica Neue", size: 16.0)!])
                for stringIndex in attrStringIndex {
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: HexColorHelper.APPTHEME_PINK, range: NSMakeRange(stringIndex[0],stringIndex[1]))
                }
                chatingTextBox!.attributedText = attributedString
                if let newPosition = chatingTextBox!.positionFromPosition(chatingTextBox!.beginningOfDocument, inDirection: UITextLayoutDirection.Right, offset: prevCursorPosition) {
                    chatingTextBox!.selectedTextRange = chatingTextBox!.textRangeFromPosition(newPosition, toPosition: newPosition)
                }
            }
        }
        
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.soundClips.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let soundClip = soundClips[indexPath.row]
        let cell = MusicSuggestionTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell", soundFileUrl: soundClip.soundFileUrl)
        
        cell.songName?.text = "\(soundClip.soundName) - \(soundClip.source)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.soundFileUrls.append(soundClips[indexPath.row].soundFileUrl)
        
        let currWordCount = String(currWord).utf16.count
        self.attrStringIndex.append([currMessageLength - currWordCount, currWordCount])
        print("currMessageLength - \(currMessageLength)")
        print("currWordCount - \(currWordCount)")
        if self.popUpTableView != nil {
            self.popUpTableView!.removeFromSuperview()
            self.popUpTableView = nil
        }
        if let chatingTextBox = chatingTextBox {
            let attributedString = NSMutableAttributedString(string:chatingTextBox.text + " ", attributes: [NSFontAttributeName: UIFont.init(name: "Helvetica Neue", size: 16.0)!])
            if self.attrStringIndex.count != 0 {
                for stringIndex in attrStringIndex {
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: HexColorHelper.APPTHEME_PINK, range: NSMakeRange(stringIndex[0],stringIndex[1]))
                    print("added index - \(stringIndex[0])")
                }
            }
            chatingTextBox.attributedText = attributedString
        }
    }
    
}

// MARK: Keyboard dismiss listener
extension ChatViewController {
    func keyboardDidHide(notif: NSNotification) {
        if self.popUpTableView != nil {
            self.popUpTableView!.removeFromSuperview()
            self.popUpTableView = nil
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first!
        if touch.view!.tag != POPUPTAG {
            if self.popUpTableView != nil {
                self.popUpTableView!.removeFromSuperview()
                self.popUpTableView = nil
            }
        }
    }
}