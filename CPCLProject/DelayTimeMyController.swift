//
//  DelayTimeMyController.swift
//  newproject
//
//  Created by sang on 1/8/23.
//
import UIKit
import CoreBluetooth
import UIKit

import CoreBluetooth
import SPIndicator
import Bluejay




 //var  device_name = "PL-SOZIB(BLE)"



import UIKit

class DelayTimeMyController: UIViewController , UITableViewDelegate, UITableViewDataSource,CBCentralManagerDelegate, CBPeripheralDelegate{
    private var centralManager: CBCentralManager?
        private var discoveredPeripherals: [CBPeripheral] = []
    
    let serviceUUID = CBUUID(string: "49535343-FE7D-4AE5-8FA9-9FAFD205E455".uppercased())
    let characteristicUUID = CBUUID(string: "49535343-8841-43F4-A8D4-ECBE34729BB3")
  let service333 = "49535343-FE7D-4AE5-8FA9-9FAFD205E455".uppercased()
  let  char  = "49535343-8841-43F4-A8D4-ECBE34729BB3"
   
    
    //cnc
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!

    @IBOutlet weak var tableview: UITableView!
    
  var pe:CBPeripheral?

    let BEAN_NAME = "AC695X_1(BLE)"
    var myCharacteristic : CBCharacteristic!
        
        var isMyPeripheralConected = false
    


    
    let services: [CBUUID]? = nil
    
    //angel sir
  
  var peripherals = [CBPeripheral]()
  
  //
  var CBCManager:CBCentralManager? //
 var peripheralDic:NSMutableDictionary?
  
  
  
  var character:CBCharacteristic?
  
  var device_name: String = "AC695X_1(BLE)" {
         didSet {
             if device_name != oldValue {
                 print("String has changed from '\(oldValue)' to '\(device_name)'")
                 
             startScanningForPeripherals();
                if (self.CBCManager == nil) {
                 self.CBCManager = CBCentralManager.init(delegate: self, queue: nil, options: nil)
                     
                    

             }
             }
         }
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hreloooo")
           centralManager?.delegate = self
           tableview.delegate = self
           tableview.dataSource = self
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
           tableview.delegate = self
           tableview.dataSource = self
           manager = CBCentralManager(delegate: self, queue: nil)
           print(serviceUUID)
           
           if (self.CBCManager == nil) {
               self.CBCManager = CBCentralManager.init(delegate: self, queue: nil, options: nil)
}
        
    }
     
     func startPrinting() {
            guard let printerPeripheral = peripheral else {
                print("Printer not connected.")
                return
            }

            // Replace with the UUID of the printer's characteristic for data transfer
            let printerCharacteristicUUID = CBUUID(string: "49535343-8841-43F4-A8D4-ECBE34729BB3")

            // Discover the characteristic for data transfer
            for service in printerPeripheral.services ?? [] {
                if service.uuid == serviceUUID {
                    printerPeripheral.discoverCharacteristics([printerCharacteristicUUID], for: service)
                }
            }
        }
     
     func startScanningForPeripherals() {
         self.CBCManager = CBCentralManager.init(delegate: self, queue: nil, options: nil)
         self.CBCManager?.scanForPeripherals(withServices: nil, options: nil)
         // Clear the existing list of discovered peripherals
         discoveredPeripherals.removeAll()
         tableview.reloadData()
     }
     override func didReceiveMemoryWarning()
     {
         super.didReceiveMemoryWarning()
     }
     
       func centralManagerDidUpdateState(_ central: CBCentralManager) {
               if central.state == .poweredOn {
               
                   self.CBCManager?.scanForPeripherals(withServices: nil, options: nil)
                   SPIndicator.present(title: "Scan Started", message: "Scan all bluetooth devices for that is on 10m.", preset: .done, from: .bottom)
                   
                   
                   
               } else {
                   print("Bluetooth is not available.")
                   SPIndicator.present(title: "Scan Result", message: "Bluetooth is not available.", preset: .done, from: .bottom)
               }
           }
       

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return discoveredPeripherals.count
           
              }
              
              func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                  let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                  let peripheral = discoveredPeripherals[indexPath.row]
                  cell.textLabel?.text = peripheral.name ?? "Unknown Device"
                  cell.detailTextLabel?.text = peripheral.identifier.uuidString
                
                  
                  return cell
              }
       func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
           if !discoveredPeripherals.contains(peripheral) {
              
               discoveredPeripherals.append(peripheral)
               tableview.reloadData()
               
           }
          
      
          
           print("Aaaa")
           print( peripheral.name as Any)
          // print(peripheral)
           
           if (((self.peripheralDic?.object(forKey: peripheral.name as Any)) != nil) == false) {
               if (peripheral.name != nil) {
                   self.peripheralDic?.setObject(peripheral, forKey: peripheral.name! as NSCopying)
                  // self.tab?.reloadData()
                   if peripheral.name == device_name {//PL-SOZIB(BLE    //AC695X_1(BLE)
                       print("angenl+++++1")
                       self.CBCManager?.connect(peripheral, options: nil)
                       //centralManager?.connect(peripheral, options: nil)
                       
                   }
                   
                   
               }
           }
       }
         //angel sir
     
           
     func centralManager(_ central: CBCentralManager, didConnectperipheral: CBPeripheral) {
         print("didConnectPeripheral--Connect")
         self.CBCManager?.stopScan()
         peripheral?.delegate = self
         print(peripheral.services)
         peripheral?.discoverServices([CBUUID.init(string: service333)])
         SPIndicator.present(title: "Connection", message: "Connected with \(device_name)", preset: .done, from: .bottom)
     }
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let peripheral = discoveredPeripherals[indexPath.row]
           let devicename = peripheral.identifier.uuidString
           let devicenamfe = peripheral.name
           let selectedRow = discoveredPeripherals[indexPath.row]
           //let sec = storyboard?.instantiateViewController(identifier: "secondd") as! SecondView
                                //          present(sec,animated: true)
           
           
          
           let alert = UIAlertController(title: "Confirmation", message: "Are  you  want to pair on \n \(devicenamfe).", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
               switch action.style{
                   case .default:
                   let deviceNameq = peripheral.name ?? "Unknown"
                   
                   //let sec = storyboard?.instantiateViewController(identifier: "secondd") as! SecondView
                                                 // present(sec,animated: true)
                   print(deviceNameq)
                   self.device_name = peripheral.name ?? "Unknown"
                   print(self.device_name)
                   print("default")
                   
                  
                   case .cancel:
                   
                   print("cancel")
                   
                   
                   case .destructive:
                   
                   print("destructive")
                   
                   
               }
           }))
           alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
               switch action.style{
                   case .default:
                   print("default")
                   
                   
                   case .cancel:
                   print("cancel")
                   
                   case .destructive:
                   print("destructive")
                   
               }
           }))
           self.present(alert, animated: true, completion: nil)
           
          
           
       }
     func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
         print("didFailToConnectPeripheral--disconnect,%s",error as Any)
     }
     func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
         print("didDisconnectPeripheral--\(error.debugDescription)")
     }
     
     func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
         if let error = error  {
             
             return
         } else {
             
         }
         for service in peripheral.services ?? [] {
             
             let serviceUUID = service.uuid.debugDescription
            print("Service UUID22222: \(serviceUUID)")
             peripheral.discoverCharacteristics(nil, for: service)
             
         }
     }
     
       func peripheralX(_ peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
           
           
            if let error = error {
               // Handle the error, if any.
               print(error)
               return
           }
 
           if let services = peripheral.services {
               for service in services {
                   // Access the service's UUID.
                   let serviceUUID = service.uuid
                  print("Service UUIDXXXX: \(serviceUUID)")
               }
            }
           
          }
     
       @objc  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
           
           
                    self.CBCManager?.stopScan()
                 
           self.peripheral=peripheral
           self.peripheral.delegate = self
           self.peripheral.discoverServices(nil)
           // let name = peripheral.name
           
           
          
            
           
       }
  
   /*
    func convertToGrayScaleAndPrint(with image: UIImage, peripheral: CBPeripheral, characteristic: CBCharacteristic) {

       
        
      
       let newImage = convertImageToDifferentColorScale(with: UIImage(named: "testing")!, imageStyle: "CIPhotoEffectNoir")
       
       guard let cpclData = checkingmm(with: newImage) else {
           print("Error: Unable to convert image to CPCL data.")
           return
       }
       print(cpclData)
      
        let chunkSize = 182  // Specify the chunk size (adjust as needed)
                var offset = 0
     
       
        
       
        while offset < cpclData.count {
                    let chunkLength = min(cpclData.count - offset, chunkSize)
                    let chunkData = cpclData.subdata(in: offset..<offset + chunkLength)
           
                    peripheral.writeValue(chunkData, for: characteristic, type: .withResponse)
            
                    offset += chunkLength
     Thread.sleep(forTimeInterval: 0.01)
                }
        
       
       self.showToast(message: "This is a toast message!", seconds: 3.0)
        


        
        
       
    }
    */
    func compressImage(_ image: UIImage) -> UIImage {
        // Set the desired compression quality (adjust as needed)
        let compressionQuality: CGFloat = 0.5
        if let imageData = image.jpegData(compressionQuality: compressionQuality) {
            if let compressedImage = UIImage(data: imageData) {
                return compressedImage
                print("Convert")
            }
        }
        // In case of any error, return the original image itself
        return image
    }
   
    
    //me
    /*
     func convertToGrayScaleAndPrint(with image: UIImage, peripheral: CBPeripheral, characteristic: CBCharacteristic) {
         let newImage = convertImageToDifferentColorScale(with: UIImage(named: "testing")!, imageStyle: "CIPhotoEffectNoir")
         let compressionQuality: CGFloat = 0.5
         let compressedImage = compressImage(newImage)
         guard let cpclData = checkingmm1(with: compressedImage) else {
             print("Error: Unable to convert image to CPCL data.")
             return
         }
         print(cpclData)
         let dispatchQueue = DispatchQueue(label: "com.tht.CPCLProject", qos: .background, attributes: .concurrent)
         
         let chunkSize = 182 // Specify the chunk size (adjust as needed)
         var offset = 0
         self.showToast(message: "This is a toast message!", seconds: 3.0)
         while offset < cpclData.count {
             let chunkLength = min(cpclData.count - offset, chunkSize)
             let chunkData = cpclData.subdata(in: offset..<offset + chunkLength)
             dispatchQueue.async {
                 peripheral.writeValue(chunkData, for: characteristic, type: .withoutResponse)
                
             }

             offset += chunkLength
             Thread.sleep(forTimeInterval: 0.020) // Reduced delay to 0.005 seconds (5 milliseconds)
             
         }
         
       
     }
     */
   
     
 
   

    
  
  //backup
        
         func convertToGrayScaleAndPrint(with image: UIImage, peripheral: CBPeripheral, characteristic: CBCharacteristic) {
             let newImage = convertImageToDifferentColorScale(with: UIImage(named: "man")!, imageStyle: "CIPhotoEffectNoir")
            
           let compressionQuality: CGFloat = 0.5
             let compressedImage = compressImage(newImage)
             guard let cpclData = checkingmm1(with: compressedImage) else {
                 print("Error: Unable to convert image to CPCL data.")
                 return
             }

             let chunkSize = 179 // Specify the chunk size (adjust as needed)
             var offset = 0

             // Create a concurrent dispatch queue for parallel execution
             let dispatchQueue = DispatchQueue(label: "com.tht.CPCLProject", qos: .background, attributes: .concurrent)
             self.showToast(message: "This is a toast message!", seconds: 3.0)
             
             while offset < cpclData.count {
                 let chunkLength = min(cpclData.count - offset, chunkSize)
                 let chunkData = cpclData.subdata(in: offset..<offset + chunkLength)

                 // Use GCD to send the data in parallel
                 dispatchQueue.async {
                     peripheral.writeValue(chunkData, for: characteristic, type: .withoutResponse)
                 }

                 offset += chunkLength
                 Thread.sleep(forTimeInterval: 0.020) // Reduced delay to 0.005 seconds (5 milliseconds)
             }

             
         }
         
         
    
    

    /*
     func convertToGrayScaleAndPrint(with image: UIImage, peripheral: CBPeripheral, characteristic: CBCharacteristic) {
         let newImage = convertImageToDifferentColorScale(with: image, imageStyle: "CIPhotoEffectNoir")
         let compressionQuality: CGFloat = 0.5
         let compressedImage = compressImage(newImage)
         guard let cpclData = checkingmm1(with: compressedImage) else {
             print("Error: Unable to convert image to CPCL data.")
             return
         }

         let chunkSize = 1024 // Specify the chunk size (adjust as needed)
         var offset = 0

         // Create a concurrent dispatch queue for parallel execution
         let dispatchQueue = DispatchQueue(label: "com.tht.CPCLProject", qos: .background, attributes: .concurrent)

         while offset < cpclData.count {
             let chunkLength = min(cpclData.count - offset, chunkSize)
             let chunkData = cpclData.subdata(in: offset..<offset + chunkLength)

             // Use GCD to send the data in parallel
             dispatchQueue.async {
                 peripheral.writeValue(chunkData, for: characteristic, type: .withResponse)
             }

             offset += chunkLength
             Thread.sleep(forTimeInterval: 0.002) // Reduced delay to 0.002 seconds (2 milliseconds)
         }

         self.showToast(message: "Image sent to printer.", seconds: 3.0)
     }

     */
   
     func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
     {
         print("UIII")
         
         if let error = error {
                     // Handle error if needed.
                     return
                 }
                 
                 guard let characteristics = service.characteristics else {
                     print("ddddsdsd")
                     return
                 }
                 
                 // Loop through the discovered characteristics.
    
                 for characteristic in characteristics {
                     print("Char")
                     print(characteristic.uuid)
                     if(characteristic.uuid == CBUUID(string: "49535343-8841-43F4-A8D4-ECBE34729BB3"))
                     {
                         print("angenl++++4")
                         print(service.uuid)
                         let newImage = convertImageToDifferentColorScale(with: UIImage(named: "testing")!, imageStyle: "CIPhotoEffectNoir")
                          print(newImage)
                          print("V")
                      
                         let operationQueue = OperationQueue()
                     convertToGrayScaleAndPrint(with: newImage, peripheral: peripheral, characteristic: characteristic)
                         // Add a block operation to the queue
                     
                         
                         
                         print("ariful0")
                       
                        break
                         
                     }
               
                 }
         
      
         
     }
    //new
    
    func checkingmm1(with image: UIImage) -> Data? {
        let width = 384 ///364Int(image.size.width)
        let height = 384//364Int(image.size.height)

        // Pixels will be drawn in this array
        var pixels = [UInt32](repeating: 0, count: width * height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        // Create a context with pixels
        guard let context = CGContext(data: &pixels, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else {
            return nil
        }

        // Calculate the centered origin for drawing the image
        let originX = (width - Int(image.size.width)) / 2
        let originY = (height - Int(image.size.height)) / 2

        context.draw(image.cgImage!, in: CGRect(x: originX, y: originY, width: width, height: height))

        var bytes = [UInt8](repeating: 0, count: width / 8 * height)
        var p = [Int](repeating: 0, count: 8)
        var bw = 0

        for y in 0..<height {
            for x in 0..<(width / 8) {
                for z in 0..<8 {
                    let rgbaPixel = pixels[y * width + x * 8 + z]

                    let red = (rgbaPixel >> 16) & 0xFF
                    let green = (rgbaPixel >> 8) & 0xFF
                    let blue = rgbaPixel & 0xFF
                    let gray = 0.299 * Double(red) + 0.587 * Double(green) + 0.114 * Double(blue) // Grayscale conversion formula

                    if gray <= 128 {
                        p[z] = 1
                    } else {
                        p[z] = 0
                    }
                }

                let value = p[0] * 128 + p[1] * 64 + p[2] * 32 + p[3] * 16 + p[4] * 8 + p[5] * 4 + p[6] * 2 + p[7]
                bytes[bw] = UInt8(value)
                bw += 1
            }
        }
        print(bytes.count)
        
        var commandData = Data()
           
                   
           



 let t_line1 = "! 0 200 200 \(height) 1 \r\n"
 let t_line2 = "PW \(width)\r\n"
 let t_line3 = "DENSITY 12\r\n"
 let t_line4 = "SPEED 6\r\n"
 let t_line5 = "CG \(width/8) \(height) "
 let t_line6="0 0 "

 let cpclCommands = t_line1 + t_line2 + t_line3 + t_line4 + t_line5 + t_line6


 let imageData = Data(bytes: &bytes, count: bytes.count)

    

//print(imageData)


 var cpclData = cpclCommands.data(using: .utf8)!
 
 cpclData.append(imageData)

 
 cpclData.append(0x0A);
 cpclData.append(0x50)
 cpclData.append(0x52)
 cpclData.append(0x20)
 cpclData.append(0x30)
 cpclData.append(0x0A)
 cpclData.append(0x46)
 cpclData.append(0x4F)
 cpclData.append(0x52)
 
 cpclData.append(0x4D)
 cpclData.append(0x0A)
 
 cpclData.append(0x50)
 cpclData.append(0x52)
 
 cpclData.append(0x49)
 cpclData.append(0x4E)
 
 cpclData.append(0x54)
 cpclData.append(0x0A)

 
                  
        return cpclData;
        
           }
   }

//for cpcl


extension DelayTimeMyController {
    func showToast(message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}







