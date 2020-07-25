//Source: https://www.appcoda.com/grand-central-dispatch/
import Foundation
import UIKit
import PlaygroundSupport

let queue = DispatchQueue(label: "com.myapp.myqueue")

func simpleQueues() {
    //it moves out only after finishing the code inside - sync
    queue.sync {//inside is a work item
        for i in 0..<10 {
            print("R", i)
        }
    }
    print("out")

    //it starts the exec and moves out even before this is finished - async
    queue.async {
        for i in 0..<10 {
            print("R", i)
        }
    }
    for i in 10..<20 {
        print("R", i)
    }
}
//simpleQueues()


print("--------------********---------------")
//QoS: Quality of Service:
//userintercative > userinitaiated > default > utility > background
func queuesWithQoS() {
    let queue1 = DispatchQueue(label: "com.myapp.queue1", qos: .userInteractive)
    let queue2 = DispatchQueue(label: "com.myapp.queue2", qos: .userInteractive)

    queue1.async {
        for i in 10..<20 {
            print("R", i)
        }
    }
    queue2.async {
        for i in 100..<110 {
            print("R", i)
        }
    }
}
//queuesWithQoS()

print("--------------********---------------")
func queuesWithMainAlso() {
    let queue1 = DispatchQueue(label: "com.myapp.queue1", qos: .userInitiated)
    let queue2 = DispatchQueue(label: "com.myapp.queue2", qos: .default)

    queue1.async {
        for i in 10..<20 {
            print("R", i)
        }
    }
    queue2.async {
        for i in 100..<110 {
            print("R", i)
        }
    }
    //main has highest by default (better than userinteractive)
    for i in 1000..<1010 {
        print("Main", i)
    }
}
//queuesWithMainAlso()

print("--------------********---------------")
//trying multiple work items on the same queue
func concurrentQueues() {
    //all work items are processed one after other (by default all queues are serial) - if attribute is not concurrent that is
    let anotherQueue = DispatchQueue(label: "com.myapp.queue", qos: .utility, attributes: .concurrent)
    anotherQueue.async {
        for i in 10..<20 {
            print("First", i)
        }
    }
    anotherQueue.async {
        for i in 100..<110 {
            print("Second", i)
        }
    }
    anotherQueue.async {
        for i in 1000..<1010 {
            print("Third", i)
        }
    }
}
//concurrentQueues()

print("--------------********---------------")
var inactiveQueue: DispatchQueue!
//inactive queues
func inactiveQueues() {
    let anotherQueue = DispatchQueue(label: "com.myapp.queue", qos: .utility, attributes: .initiallyInactive)
    inactiveQueue = anotherQueue
    
    anotherQueue.async {
        for i in 10..<20 {
            print("First", i)
        }
    }
    anotherQueue.async {
        for i in 100..<110 {
            print("Second", i)
        }
    }
    anotherQueue.async {
        for i in 1000..<1010 {
            print("Third", i)
        }
    }
}

func concurrentInactiveQueues() {
    let anotherQueue = DispatchQueue(label: "com.myapp.queue", qos: .utility, attributes: [.initiallyInactive, .concurrent])//array and single element is possible due to option set
    inactiveQueue = anotherQueue
    
    anotherQueue.async {
        for i in 10..<20 {
            print("First", i)
        }
    }
    anotherQueue.async {
        for i in 100..<110 {
            print("Second", i)
        }
    }
    anotherQueue.async {
        for i in 1000..<1010 {
            print("Third", i)
        }
    }
}
//Use one of the below method calls along with if let.
//concurrentQueues()
//concurrentInactiveQueues()
if let queue = inactiveQueue {
    queue.activate()
}

func queueWithDelay() {
    let delayQueue = DispatchQueue(label: "com.myapp.queue")
    delayQueue.asyncAfter(deadline: .now() + 3.0) {
        print(Date())
    }
}
//queueWithDelay()

func mainAndGlobalQueues() {
    DispatchQueue.global(qos: .userInitiated).async {
        for i in 0..<10 {
            print("G", i)
        }
    }
    DispatchQueue.main.async {
        for i in 10..<20 {
            print("M", i)
        }
    }
}
//mainAndGlobalQueues()



class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        
        let imageURL: URL = URL(string: "http://www.appcoda.com/wp-content/uploads/2015/12/blog-logo-dark-400.png")!
        
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: imageURL) { (imageData, response, error) in
            if let data = imageData {
                print("image downloaded")
                let image = UIImageView(image: UIImage(data: data))
                DispatchQueue.main.async {
                    view.addSubview(image)
                }
            }
        }
        
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

//DispatchWorkItem: block of code that can be dispatched on any queue
func useWorkItem() {
    var value = 10
    
    let workItem = DispatchWorkItem {
        value += 5
        print("5 added", value)
    }
    let queue = DispatchQueue.global()
    //find 2 ways of execution below
    queue.async {
        workItem.perform()
    }
    queue.async(execute: workItem)
}
useWorkItem()
