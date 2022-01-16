import Combine
import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    // Predefined BLE service UUID used by Xiaomi in miScale2 (1 gen. as well)
    private let serviceUUID = CBUUID.init(string: "181B")
    private var myCentral: CBCentralManager!

    @Published var isBluetoothOn = false
    
    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isBluetoothOn = true
            self.scan()
        }
        else {
            isBluetoothOn = false
        }
    }
    
    // Scan for the advirtisment that contains service UUID used by Xiaomi
    func scan() {
        myCentral.scanForPeripherals(
            withServices: [serviceUUID],
            options: [CBCentralManagerScanOptionAllowDuplicatesKey : true]
        )
        print("\nStart scanning...\n")
    }
    
    func stopScanning() {
        myCentral.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("===Advertisment found===")
        print("Name: \(peripheral.name ?? "Unknown")")
        print("RSSI: \(RSSI)")
        
        // 1. Get service data from advertisement
        guard let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID : NSData]
        else {return}
        
        // 2. Get an array of bytes from service data
        guard let scaleData = serviceData[serviceUUID]
        else {return}
        
        // 3. Check for bytes length. Just in case. Array we are looking for is exactly 13 bytes long
        if (scaleData.length != 13) {return}
        
        // 4. Make a weight value from bytes #11, #12
        let weightBuffer: [UInt8] = [scaleData[11], scaleData[12]]
        let weightUInt16 = weightBuffer.withUnsafeBytes { $0.load(as: UInt16.self) }
        let weight = Double(weightUInt16) / 200
        
        // 5. Make an impedance value from bytes #9, #10
        let impedanceBuffer: [UInt8] = [scaleData[9], scaleData[10]]
        let impedanceUInt16 = impedanceBuffer.withUnsafeBytes { $0.load(as: UInt16.self) }
        let impedance = Double(impedanceUInt16)
        
        // 6. Send measurments to the publisher in order to keep and handle them in the ModelData
        let measurements = ScaleMeasurment(weight: weight, impedance: impedance)
        _measurementsPublisher.send(measurements)
    }
    
    // MARK: - Data Publisher
    
    var measurementsPublisher: AnyPublisher<ScaleMeasurment, Never> { _measurementsPublisher.eraseToAnyPublisher() }
    private var _measurementsPublisher = PassthroughSubject<ScaleMeasurment, Never>()
}

