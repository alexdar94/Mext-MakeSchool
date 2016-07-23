import Foundation
import Firebase
import Parse
import JSQMessagesViewController
import UIKit
import FirebaseDatabase

class ChatViewController: JSQMessagesViewController {
    let TAG = "ChatViewController"
    
    var chatRoom: ChatRoom!
    var chatRoomName: String {
        return chatRoom.UID
    }
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    
    var messages = [Message]()
    
    var localTyping = false
    var usersTypingQuery: FIRDatabaseQuery!
    
    var currWord = ""
    var currMessageLength = 0
    
    // Popup suggestion tableview for text
    var popUpTableView: UITableView? = nil
    var soundClips: [SoundClip] = []
    var soundFileUrls = [String]()
    var attrStringIndex = [String: [Int]]()
    
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            FirebaseHelper.userIsTypingRef(chatRoomName).setValue(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = chatRoom.title
        self.setup()
        self.observeMessages()
        self.observeTyping()
        
        //let childUpdates = ["/\(chatRoomName)/test": "update"]
        //ref.updateChildValues(childUpdates)
        
        //        let tempRef = FirebaseHelper.soundClipsRef(chatRoomName)
        //        tempRef.queryOrderedByChild("tag").queryEqualToValue("hello")
        //            .observeEventType(.ChildAdded, withBlock: { (snapshot) in
        //                print(snapshot)
        //                let text = snapshot.value!["soundName"]! as! String
        //                print(text)
        //            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
}

// MARK: Setup
extension ChatViewController {
    //    func retrieveMessages() {
    //        let messagesQuery = ref.child(chatRoomName).queryLimitedToLast(25)
    //        messagesQuery.observeEventType(.Value, withBlock: { snapshot in
    //            for message in snapshot.children.allObjects {
    //                if let text = message.value["text"]{
    //                    let message = JSQMessage(senderId: message.key, displayName: message.key, text: String(text!))
    //                    self.messages += [message]
    //                }
    //            }
    //            self.reloadMessagesView()
    //        })
    //    }
    
    func setup() {
        self.senderId = "a"
        self.senderDisplayName = "a"
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
            
            if let attrStringIndexDic = value["attrStringIndex"] as? [String: AnyObject] {
                
                for index in attrStringIndexDic.values {
                    if (attrStringIndex?.append(index as! [Int])) == nil {
                        attrStringIndex = [index as! [Int]]
                    }
                }
                //attrStringIndex.sortInPlace{$0 < $1}
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
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
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
        
        let attributedString = NSMutableAttributedString(string: message.text)
        if let attrStringIndex = message.attrStringIndex {
            if let soundFileUrls = message.soundFileUrls{
                for (index, element) in attrStringIndex.enumerate() {
                    //attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor() , range: NSMakeRange(index[0],index[1]))
                    attributedString.addAttribute(NSLinkAttributeName, value: "playMusic://\(soundFileUrls[index])" , range: NSMakeRange(element[0],element[1]))
                }
            }
        }
        
        
        //        attributedString.addAttribute(NSForegroundColorAttributeName, value: GradientColor(UIGradientStyle.TopToBottom, frame: CGRect(x: 0, y: 0, width: 1000, height: 1000), colors: [UIColor.redColor(), UIColor.grayColor()]), range: myRange)
        cell.textView!.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.greenColor()]
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
        let itemRef = FirebaseHelper.messagesRef(chatRoomName).childByAutoId()
        let messageItem = [
            "text": text,
            "senderId": senderId,
            "soundFileUrls": soundFileUrls,
            "attrStringIndex":attrStringIndex
        ]
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        
        isTyping = false
        soundFileUrls = []
        attrStringIndex = [:]
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
    }
    
    override func textViewDidChange(textView: UITextView) {
        super.textViewDidChange(textView)
        
        let message = textView.text
        currMessageLength = message.characters.count
        
        var keywordArr = message.componentsSeparatedByString(" ")
        currWord = keywordArr[keywordArr.count-1]
        
        FirebaseHelper.searchSoundClip(currWord.lowercaseString){ matchingSoundClips in
            if let matchingSoundClips = matchingSoundClips{
                self.soundClips = matchingSoundClips
                let resultsCount = self.soundClips.count
                if resultsCount>0 {
                    let numRows = resultsCount>4 ?  4 : resultsCount
                    self.popUpTableView = UITableView(frame: CGRectMake(0, self.inputToolbar.frame.origin.y - CGFloat(48*numRows), self.inputToolbar.frame.width, CGFloat(48*numRows)))
                    self.popUpTableView!.rowHeight = 48.0
                    self.popUpTableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
                    self.popUpTableView!.delegate = self
                    self.popUpTableView!.dataSource = self
                    self.view.addSubview(self.popUpTableView!)
                }
            } else {
                if self.popUpTableView != nil {
                    self.popUpTableView!.removeFromSuperview()
                    self.popUpTableView = nil
                }
            }
        }
        
        //        ParseHelper.searchSoundClips(currWord){(result: [PFObject]?, error: NSError?) -> Void in
        //
        //            guard error == nil else {
        //                print(error)
        //                return
        //            }
        //
        //            self.soundClips = result as? [SoundClip] ?? []
        //            let resultsCount = self.soundClips.count
        //            if resultsCount>0 {
        //                let numRows = resultsCount>4 ?  4 : resultsCount
        //                self.popUpTableView = UITableView(frame: CGRectMake(0, self.inputToolbar.frame.origin.y - CGFloat(48*numRows), self.inputToolbar.frame.width, CGFloat(48*numRows)))
        //                self.popUpTableView!.rowHeight = 48.0
        //                self.popUpTableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //                self.popUpTableView!.delegate = self
        //                self.popUpTableView!.dataSource = self
        //                self.view.addSubview(self.popUpTableView!)
        //            } else {
        //                if self.popUpTableView != nil {
        //                    self.popUpTableView!.removeFromSuperview()
        //                    self.popUpTableView = nil
        //                }
        //            }
        //        }
        
        let attributedString = NSMutableAttributedString(string:message)
        if message.characters.count > 1{
            let myRange = NSMakeRange(0,1)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor() , range: myRange)
        }
        
        textView.attributedText = attributedString
        
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
        self.attrStringIndex[FirebaseHelper.generateFIRUID(FirebaseHelper.ref)] = [currMessageLength - currWord.characters.count,currWord.characters.count]

        if self.popUpTableView != nil {
            self.popUpTableView!.removeFromSuperview()
            self.popUpTableView = nil
        }
    }

}