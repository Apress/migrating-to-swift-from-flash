//
//  ViewController.swift
//  TestFindPrimeNumbers
//
//  Created by Radoslava Leseva on 29/04/2016.
//  Copyright © 2016 diadraw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var resultsTextView: UITextView!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchSlider: UISlider!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var concurrencySwitch: UISwitch!
    @IBOutlet weak var searchProgress: UIProgressView!
    
    // MARK: Actions
    @IBAction func searchValueChanged(sender: AnyObject) {
        updateSearchLabel()
    }
    
    @IBAction func startSearch(sender: AnyObject) {
        // Reset any previous results shown on the screen.
        resetResults()
        
        // Get a timestamp for when we started the search, so we can time it:
        startTimestamp = NSDate()
        
        // Check if the concurrency switch is on
        // and start a search for prime numbers accordingly:
        if concurrencySwitch.on {
            concurrentlyFindPrimeNumbersLessThan(number: UInt(searchSlider.value))
            
            // Enable the Cancel button, so we can cancel a concurrent search:
            cancelButton.enabled = true
            
            // Make sure we can't hit Start again before the search has completed:
            startButton.enabled = false
        } else {
            findPrimeNumbersLessThan(number: UInt(searchSlider.value))
        }
    }
    
    @IBAction func cancelSearch(sender: AnyObject) {
        // Cancel any blocks that have not been run yet:
        for block in blocks {
            dispatch_block_cancel(block)
        }
        
        // Update the screen to show that the search was cancelled.
        resultsTextView.text.appendContentsOf("\nSearch cancelled.")
        
        // Disable Cancel, but enable Start:
        cancelButton.enabled = false
        startButton.enabled = true
    }
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view,
        // typically from a nib.
        
        updateSearchLabel()
        cancelButton.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: User interface helper methods
    func updateSearchLabel() {
        searchLabel.text = "Find prime numbers less than \(Int(searchSlider.value))"
    }
    
    func displayResults(resultsArray primes: [UInt]) {
        // Check how long the search took:
        let endTime = NSDate()
        
        // Reset the two buttons, so we can start another search:
        cancelButton.enabled = false
        startButton.enabled = true
        
        if primes.isEmpty {
            resultsTextView.text = "No prime numbers were found."
            return
        }
        
        // Iterate through the primes array and construct a string,
        // which will be displayed in the text view:
        var resultStr = "\(primes.count) prime numbers were found."
        if let startTime = startTimestamp {
            resultStr += "The search took \(endTime.timeIntervalSinceDate(startTime)) seconds.\n\n"
        }
        resultStr += "\n\n"
        
        for i in primes.indices {
            resultStr += "Prime [\(i + 1)] = \(primes[i])\n"
        }
        
        // Workaround for the Memory view issue:
        printAddressOf(resultStr)

        resultsTextView.text = resultStr
        
        // The search has finished, now disable the Cancel button:
        cancelButton.enabled = false
    }
    
    func resetResults() {
        // Delete the results of the last search:
        resultsTextView.text = ""
        searchProgress.progress = 0.0
    }
    
    func displayProgress(percent amountDone: Float) {
        dispatch_async(dispatch_get_main_queue(), {
            self.searchProgress.progress = amountDone
            self.resultsTextView.text = "Progress: \(Int(100.0 * amountDone))%"
        })
    }
    
    // MARK: Prime numbers helper methods
    func isItPrime(number number: UInt) -> Bool {
        // We know that 0 and 1 are not prime:
        if number < 2 {
            return false
        }
        
        // Do a brute-force check for the rest of the numbers:
        for div: UInt in 2 ..< number {
            if (number % div) == 0 {
                return false
            }
        }
        
        return true
    }
    
    func findPrimeNumbersInRange(range r: Range<UInt>) -> [UInt] {
        // We will collect the results in this array:
        var primeNumbers = [UInt] ()
        
        for i in r {
            if isItPrime(number: i) {
                primeNumbers.append(i)
            }
        }
        
        return primeNumbers
    }
    
    // Define an alias for the callback
    // we want to use to report progress:
    typealias ProgressHandler = (Float) -> ()
    
    func findPrimeNumbersInRange(range r: Range<UInt>, progressHandler: ProgressHandler) -> [UInt] {
        // We will collect the results in this array:
        var primeNumbers = [UInt] ()
        
        for i in r {
            if isItPrime(number: i) {
                primeNumbers.append(i)
                
                // Calculate the proportion of work done and call the progress handler
                let progress = Float(i - r.first!) / Float(r.count)
                progressHandler(progress)
            }
        }
        
        // Job done:
        progressHandler(1.0)
        
        return primeNumbers
    }
    
    // MARK: Search for prime numbers without concurrency
    func findPrimeNumbersLessThan(number limit: UInt) {
        // Make sure we have been given a valid limit:
        assert(limit > 0)
        
        // Find all prime numbers smaller than limit:
        let primes = findPrimeNumbersInRange(range: 0...(limit - 1))
        
        // and then display them:
        displayResults(resultsArray: primes)
    }
    
    // MARK: Search for prime numbers, using concurrency
    // An array of execution blocks:
    var blocks = [dispatch_block_t]()
    
    /***** Listing 8-3 *****/
    func concurrentlyFindPrimeNumbersLessThan(number limit: UInt) {
        // Make sure we clear the blocks array from any old task references:
        blocks.removeAll()
        
        // Let us split the search into four:
        let concurrentTaskCount: UInt = 4
        
        // Based on the numer of concurrent tasks we want,
        // calculate the size of the interval each task will need to search through:
        let rangeSize = limit / concurrentTaskCount + limit % concurrentTaskCount
        
        // Keep track of how many tasks have completed:
        var tasksDone: UInt = 0
        
        // An array to combine results in the end:
        var primes = [UInt]()
        
        // Create a custom serial queue:
        let queue = dispatch_queue_create("com.diadraw.primeNumberSearchQueue", DISPATCH_QUEUE_SERIAL);
        
        for i in 0 ..< concurrentTaskCount {
            // Work out the interval for the search:
            let rangeStart = i * rangeSize
            if rangeStart >= limit {
                // If we have already covered the whole interval, mark the task as complete:
                tasksDone += 1
                continue
            }
            let rangeEnd = min(UInt(rangeStart + rangeSize - 1), limit - 1)
            
            // Define a block of code to perform the search:
            let block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {
                // Tasks have now started executing and we cannot cancel them,
                // so disable the Cancel button:
                dispatch_async(dispatch_get_main_queue(), {
                    self.cancelButton.enabled = false
                })
                
                let primesInCurrentRange = self.findPrimeNumbersInRange(range: rangeStart ... rangeEnd)
                
                // Perform the writing to the primes array synchronously,
                // so that no more than one task can write to it
                // at the same time:
                dispatch_sync(queue, {
                    primes.appendContentsOf(primesInCurrentRange)
                    
                    // Keep track of how many tasks have completed:
                    tasksDone += 1
                    
                    // When we've got the last chunk of results in, display them:
                    if tasksDone == concurrentTaskCount {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.displayResults(resultsArray: primes)
                        })
                    }
                })
            }
            
            // Enqueue the block to be executed asynchronously:
            dispatch_async(queue, block)
        }
    }
    
    /***** Original implementation from Listing 7-16.
           Rename to concurrentlyFindPrimeNumbersLessThan to test the method without deadlocks. *****/
    func concurrentlyFindPrimeNumbersLessThan_Listing_7_16(number limit: UInt) {
        // Make sure we clear the blocks array from any old task references:
        blocks.removeAll()
        
        // Let us split the search into four:
        let concurrentTaskCount: UInt = 4
        // Based on the numer of concurrent tasks we want,
        // calculate the size of the interval each task will need to search through:
        let rangeSize = limit / concurrentTaskCount + limit % concurrentTaskCount
        
        // Keep track of how many tasks have completed:
        var tasksDone: UInt = 0
        
        // An array to combine results in the end:
        var primes = [UInt]()

        // Create a custom concurrent queue:
        let queue = dispatch_queue_create("com.diadraw.primeNumberSearchQueue", DISPATCH_QUEUE_CONCURRENT);
        
        for i in 0 ..< concurrentTaskCount {
            // Work out the interval for the search:
            let rangeStart = i * rangeSize
            if rangeStart >= limit {
                // If we have already covered the whole interval, mark the task as complete:
                tasksDone += 1
                continue
            }
            let rangeEnd = min(UInt(rangeStart + rangeSize - 1), limit - 1)
            
            // Define a block of code to perform the search:
            let block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {
                // Tasks have now started executing and we cannot cancel them,
                // so disable the Cancel button:
                dispatch_async(dispatch_get_main_queue(), {
                    self.cancelButton.enabled = false
                })
                
                let primesInCurrentRange = self.findPrimeNumbersInRange(range: rangeStart ... rangeEnd)
                
                // Set a barrier around writing to the primes array,
                // so that no more than one task can write to it
                // at the same time:
                dispatch_barrier_async(queue, {
                    primes.appendContentsOf(primesInCurrentRange)
                    
                    // Keep track of how many tasks have completed:
                    tasksDone += 1
                    
                    // When we've got the last chunk of results in, display them:
                    if tasksDone == concurrentTaskCount {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.displayResults(resultsArray: primes)
                        })
                    }
                })
            }
            
            // Add the block to the queue, but after a delay:
            blocks.append(block)
            
            let delayInSeconds = 5.0
            let startTime = dispatch_time(DISPATCH_TIME_NOW,
                                          Int64(delayInSeconds * Double(NSEC_PER_SEC)))
            dispatch_after(startTime, queue, block)
        }
    }
    
    /***** Rename this to concurrentlyFindPrimeNumbersLessThan to try out Listing 7-14. *****/
    func concurrentlyFindPrimeNumbersLessThan_Listing_7_14(number limit: UInt) {
        // Let us split the search into four:
        let concurrentTaskCount: UInt = 4
        // Based on the numer of concurrent tasks we want,
        // calculate the size of the interval each task will need to search through:
        let rangeSize = limit / concurrentTaskCount + limit % concurrentTaskCount
        
        // Keep track of how many tasks have completed:
        var tasksDone: UInt = 0
        
        // An array to combine results in the end:
        var primes = [UInt]()
        
        // Create a custom concurrent queue:
        let queue = dispatch_queue_create("com.diadraw.primeNumberSearchQueue", DISPATCH_QUEUE_CONCURRENT);
        
        for i in 0 ..< concurrentTaskCount {
            // Work out the interval for the search:
            let rangeStart = i * rangeSize
            if rangeStart >= limit {
                // If we have already covered the whole interval, mark the task as complete:
                tasksDone += 1
                continue
            }
            let rangeEnd = min(UInt(rangeStart + rangeSize - 1), limit - 1)
            
            // Define a block of code to perform the search:
            let block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {
                let primesInCurrentRange = self.findPrimeNumbersInRange(range: rangeStart ... rangeEnd)
                
                // Set a barrier around writing to the primes array,
                // so that no more than one task can write to it
                // at the same time:
                dispatch_barrier_async(queue, {
                    primes.appendContentsOf(primesInCurrentRange)
                    
                    // Keep track of how many tasks have completed:
                    tasksDone += 1
                    
                    // When we've got the last chunk of results in, display them:
                    if tasksDone == concurrentTaskCount {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.displayResults(resultsArray: primes)
                        })
                    }
                })
            }
            
            // Add the block to the background queue:
            dispatch_async(queue, block)
        }
    }

    /***** Rename this to concurrentlyFindPrimeNumbersLessThan to try out Listing 7-12. *****/
    func concurrentlyFindPrimeNumbersLessThan_Listing_7_12(number limit: UInt) {
        // Make sure we have been given a valid limit:
        assert(limit > 0)
        
        // Obtain a reference to one of the existing queues:
        let queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        
        // Create a block of code that will be added to the queue:
        let block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {
            let primes = self.findPrimeNumbersInRange(range: 0...(limit - 1), progressHandler: self.displayProgress)
            
            // When the search is done, 
            // obtain a reference to the main queue 
            // and dispatch the task of updating the UI to it:
            let mainQueue = dispatch_get_main_queue()
            dispatch_async(mainQueue, {
                self.displayResults(resultsArray: primes)
            })
        }
        
        // Add the code block to the background queue, 
        // so it can be scheduled for execution:
        dispatch_async(queue, block)
    }
    
    // MARK: Timing helpers
    var startTimestamp: NSDate?
    
    // MARK: Debugging helper methods
    func printAddressOf(symboToInspect: UnsafePointer<Void>) {
        print("Actual address in memory: \(symboToInspect)")
    }
}