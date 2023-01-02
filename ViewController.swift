//
//  ViewController.swift
//  Twittermenti
//
//  Created by Rishabh Joshi on 28/11/2022.
//  Copyright © Rishabh Joshi. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON
class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var Label: UILabel!
    
    let sentimentClassifier = TwitterSentimentClassifier()
    
    let swifter = Swifter(consumerKey: "7gQmbJNdDNwSWsi3THr7ih7F7", consumerSecret: "b5HVcaCXlJnH9nAHEBnAdfzKnBs3B9evikCX2bUXfyeXUxh031")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }

    @IBAction func predictPressed(_ sender: Any) {
        if let searchText = textField.text{
            swifter.searchTweet(using: searchText, lang: "en", count:100, tweetMode: .extended, success: {(results,metadata) in
    //            print(results)
                
                var tweets = [TwitterSentimentClassifierInput]()
                for i in 0..<96{
                    if let tweet = results[i]["full_text"].string{
                        let tweetForClassification = TwitterSentimentClassifierInput(text: tweet)
    //                    print(tweet)
                        tweets.append(tweetForClassification)
                }
                }
                do{
                    let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                    
                    var sentimentScore = 0
    //                print(predictions[0].label)
                    
                    for pred in predictions {
                        let sentiment = pred.label
                        if(sentiment == "Pos"){
                            sentimentScore += 1
                        }else if sentiment == "Neg"{
                            sentimentScore -= 1
                        }
    //                    print(pred.label)
                    }
//                    print(sentimentScore)
                    if sentimentScore > 20 {
                        self.sentimentLabel.text = "😍"
//                        self.Label.text = "\(sentimentScore)"
                    }
                    else if sentimentScore > 10 {
                        self.sentimentLabel.text = "😀"
//                        self.Label.text = "\(sentimentScore)"
                            }
                    else if sentimentScore > 0 {
                                self.sentimentLabel.text = "🙂"
//                        self.Label.text = "\(sentimentScore)"
                            }
                    else if sentimentScore == 0 {
                                self.sentimentLabel.text = "😐"
//                        self.Label.text = "\(sentimentScore)"
                            }
                    else if sentimentScore > -10 {
                                self.sentimentLabel.text = "😕"
//                        self.Label.text = "\(sentimentScore)"
                            }
                    else if sentimentScore > -20 {
                                self.sentimentLabel.text = "😡"
//                        self.Label.text = "\(sentimentScore)"
                            }
                    else {
                                self.sentimentLabel.text = "🤮"
//                        self.Label.text = "\(sentimentScore)"
                            }
                }
                catch{
                    print("There was an error making the prediction\(error)")
                }
                
                
    //            print(tweets)
                
                
            }){(error) in
                print("There was an error with the Twitter API Request,\(error)")
            }
        }
//        let prediction = try! sentimentClassifier.prediction(text: "Apple is the best company!")
//
//        print(prediction.label)
        
    
    }
    
}

