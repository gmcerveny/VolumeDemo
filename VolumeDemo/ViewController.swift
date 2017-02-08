//
//  ViewController.swift
//  VolumeDemo
//
//  Created by Greg Cerveny on 2/8/17.
//
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var engine = AVAudioEngine()
    var sampler = AVAudioUnitSampler()
    var player = AVAudioPlayerNode()
    var buffer :AVAudioPCMBuffer!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initEngine()
    }
    
    func initEngine() {
        let mixer = engine.mainMixerNode
        
        engine.attach(sampler)
        engine.connect(sampler, to: mixer, format: sampler.outputFormat(forBus: 0))
        
        engine.attach(player)
        engine.connect(player, to: mixer, format: sampler.outputFormat(forBus: 0))
        
        let soundUrl = Bundle.main.url(forResource: "C1", withExtension: ".wav",subdirectory: "Sounds")!
        try! sampler.loadAudioFiles(at: [soundUrl])
        
        let file = try! AVAudioFile(forReading: soundUrl)
        buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length))
        try! file.read(into: buffer)
        
        try! engine.start()
    }

    @IBAction func playerTouched(_ sender: Any) {
        player.scheduleBuffer(buffer, completionHandler: nil)
        player.play()
    }
    
    @IBAction func samplerTouched(_ sender: Any) {
        sampler.startNote(24, withVelocity: 127, onChannel: 0)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

