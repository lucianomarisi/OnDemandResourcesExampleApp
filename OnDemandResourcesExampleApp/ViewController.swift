//
//  ViewController.swift
//  OnDemandResourcesExampleApp
//
//  Created by Luciano Marisi on 27/10/2015.
//  Copyright © 2015 TechBrewers LTD. All rights reserved.
//

import UIKit

private let redTagString = "RedTag"
private let blueTagString = "BlueTag"

class ViewController: UIViewController {

  @IBOutlet weak var redImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create a resource request with the required tag(s)
    let resourceRequest = NSBundleResourceRequest(tags: [redTagString, blueTagString])
    
    // Optionally define the loading priority if downloading multiple resources,
    // use NSBundleResourceRequestLoadingPriorityUrgent if resources are required now
    resourceRequest.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent
    
    // Check if the resources are cached first
    resourceRequest.conditionallyBeginAccessingResourcesWithCompletionHandler({ [unowned self](resourcesAvailable : Bool) -> Void in
      if (resourcesAvailable) {
        // Do something with the resources
        print("Resources originally available")
        self.updateImageView()
      } else {
        // Resources not available to they will need to be downloaded
        // using beginAccessingResourcesWithCompletionHandler:
        print("Resources will be downloaded")
        resourceRequest.beginAccessingResourcesWithCompletionHandler({ [unowned self] (error : NSError?) -> Void in
          if (error != nil) {
            print("Failed to download resources with error: \(error)")
          } else {
            print("Resources downloaded successfully")
           self.updateImageView()
          }
        })
      }
    })
    
    // Optionally set the preservation priority of the tag
    let preservationPriorityForRedTag = 0.5
    NSBundle.mainBundle().setPreservationPriority(preservationPriorityForRedTag, forTags: [redTagString])
    
    /* Call endAccessingResources when the resources are no longer needed
    
    resourceRequest.endAccessingResources()
    
    */
    
    
    /* Managed the request state through the progress property
    
    resourceRequest.progress.pause()
    resourceRequest.progress.cancel()
    resourceRequest.progress.resume()
    
    */
  }
  
  func updateImageView() {
    // Access images as you normally would
    let redImage = UIImage(named: "Red.png")
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
      self.redImageView.image = redImage
    })
  }


}

