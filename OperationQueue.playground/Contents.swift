/*
 Operation and OperationQueue are built on top of GCD
 Though a little overhead compared to GCD, you can add dependency among various operations and re-use, cancel or suspend them.
 1. GCD follows FIFO
 2. Operations run concurrently by default.
 Adv of Operation:
 1. Dependencies can be added
 2. Execution priority can be changed (NSOperationQueuePriority: Int (veryLow, low, normal, high, veryHigh))
 3. cancel an operation even after adding to queue:
    1. if exec is done, cancel has no effect
    2. if executing, code exec doesnt stop but cancelled prop is set to true.
    3. if still waiting to be executed, it will be cancelled.
 4. NSOperation has finished, cancelled and ready.
 5. Once operation is finished, completion block is invoked if assigned.
 
 NSBlockOperation and NSInvocationOperation
 */
import UIKit
import PlaygroundSupport

let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://algoos.com/wp-content/uploads/2015/08/ireland-02.jpg", "http://bdo.se/wp-content/uploads/2014/01/Stockholm1.jpg"]

class Downloader {
    
    class func downloadImageWithURL(url:String) -> UIImage! {
        do {
            let data = try Data(contentsOf: URL(string: url)!)
            return UIImage(data: data)
        } catch  {
            print(error)
        }
        return UIImage()
    }
}

class MyViewController : UIViewController {
    
    var imageView1 = UIImageView()
    var imageView2 = UIImageView()
    var imageView3 = UIImageView()
    var imageView4 = UIImageView()

    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
//        simpleOperationQueue(mainView: view)//withoutCompletionBlock
        simpleOperationQueueWithCompletionBlock(mainView: view)
        self.view = view
    }

    func simpleOperationQueue(mainView: UIView) {
        let queue = OperationQueue()
        queue.addOperation {
            let img1 = Downloader.downloadImageWithURL(url: imageURLs[0])
            OperationQueue.main.addOperation {
                self.imageView1 = UIImageView(image: img1)
                mainView.addSubview(self.imageView1)
            }
        }
        queue.addOperation {
            let img2 = Downloader.downloadImageWithURL(url: imageURLs[1])
            OperationQueue.main.addOperation {
                self.imageView2 = UIImageView(image: img2)
                mainView.addSubview(self.imageView2)
            }
        }
        queue.addOperation {
            let img3 = Downloader.downloadImageWithURL(url: imageURLs[2])
            OperationQueue.main.addOperation {
                self.imageView3 = UIImageView(image: img3)
                mainView.addSubview(self.imageView3)
            }
        }
        queue.addOperation {
            let img4 = Downloader.downloadImageWithURL(url: imageURLs[3])
            OperationQueue.main.addOperation {
                self.imageView4 = UIImageView(image: img4)
                mainView.addSubview(self.imageView4)
            }
        }
    }
    
    func simpleOperationQueueWithCompletionBlock(mainView: UIView) {
        let queue = OperationQueue()
        let operation1 = BlockOperation {
            let img1 = Downloader.downloadImageWithURL(url: imageURLs[0])
            OperationQueue.main.addOperation {
                self.imageView1 = UIImageView(image: img1)
                mainView.addSubview(self.imageView1)
            }
        }
        operation1.completionBlock = {
            print("operation 1 completed")
        }
        queue.addOperation(operation1)
        let operation2 = BlockOperation {
            let img2 = Downloader.downloadImageWithURL(url: imageURLs[1])
            OperationQueue.main.addOperation {
                self.imageView2 = UIImageView(image: img2)
                mainView.addSubview(self.imageView2)
            }
        }
        operation2.completionBlock = {
            print("op 2 completed")
        }
        operation2.addDependency(operation1)//NOTE THIS
        queue.addOperation(operation2)
        let operation3 = BlockOperation {
            let img3 = Downloader.downloadImageWithURL(url: imageURLs[2])
            OperationQueue.main.addOperation {
                self.imageView3 = UIImageView(image: img3)
                mainView.addSubview(self.imageView3)
            }
        }
        operation3.completionBlock = {
            print("op 3 completed")
        }
        queue.addOperation(operation3)
        queue.cancelAllOperations()//NOTE THIS
    }
    
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

