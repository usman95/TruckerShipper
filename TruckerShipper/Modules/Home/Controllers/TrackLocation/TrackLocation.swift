//
//  TrackLocation.swift
//  TruckerShipper
//
//  Created by Mac Book on 19/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import GoogleMaps
import SocketIO

class TrackLocation: BaseController {

    @IBOutlet weak var mapView: GMSMapView!
    var inProgressMile: TripMilesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.connectSocket()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disconnectSocket()
    }
    
}
//MARK:- Socket
extension TrackLocation{
    open class SocketConnection {
        public static let default_ = SocketConnection()
        let manager: SocketManager
        
        private init() {
            let token = AppStateManager.sharedInstance.loggedInUser.authToken ?? ""
            let param:[String:Any] = ["token":token]
            let route = Constants.SocketBaseURL
            let socketURL: URL = Utility.URLforRoute(route: route, params: param)! as URL
            manager = SocketManager(socketURL: socketURL, config: [.log(true), .compress])
            manager.config = SocketIOClientConfiguration(arrayLiteral: .connectParams(param), .secure(false))
        }
    }
    private func connectSocket(){
        let socket = SocketConnection.default_.manager.defaultSocket
        if socket.status != .connected{
            socket.connect()
        }
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("received-location-to-shipper-\(Constants.inProgressMileId)") {data, ack in
            print(data)
        }
        socket.on("received-finished-ride-shipper-\(Constants.inProgressMileId)") {data, ack in
            print(data)
        }
    }
    private func disconnectSocket(){
        let socket = SocketConnection.default_.manager.defaultSocket
        socket.removeAllHandlers()
        socket.disconnect()
    }
}
