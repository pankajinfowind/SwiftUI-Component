//
//  Landing.swift
//  Detezo
//
//  Created by Pankaj Sonava on 12/12/23.
//

import SwiftUI
import FamilyControls
import AVKit

struct Landing: View {
    let center = AuthorizationCenter.shared
    @State var selection = FamilyActivitySelection()
    @State var isPresented = false
    
//    @State private var isScanning: Bool = false
    // Camera Scanner
    @State private var cameraPermission: CameraPermission = .idle
    @State private var session: AVCaptureSession = .init()
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    @State private var errorMEssage: String = ""
    @State private var showError: Bool = false
    @Environment(\.openURL) private var openURL
    @StateObject private var qrDelegate = QRScannerDelegate()
    @State private var scannedCode: String = ""
    
    // Screen variable
    @State private var loginNavigate = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HeaderView(isCenterTitle: false, isBackExist: false, showExtraButton: false)
                }.frame(height: 50)
                
                // Attendees section
                Spacer().frame(height: 20)
                VStack(alignment: .leading){
                    Spacer().frame(width: ScreenWidth - 40, height: 0)
                    DetezoHeaderLabel(text: LandingScreenTexts.attendees)
                    Spacer().frame(height: 8)
                    DetezoDescriptionLabel(text: LandingScreenTexts.attendeesDesc)
                }
                Spacer()
                VStack {
                    GeometryReader {
                        let _ = $0.size
                        ZStack{
                            CameraScanner(frameSize: CGSize(width: 250, height: 250), session: $session)
                                .scaleEffect(0.91)
                            ForEach(0...4, id: \.self) {index in
                                let rotation = Double(index) * 90
                                
                                RoundedRectangle(cornerRadius: 2, style: .circular)
                                    .trim(from: 0.61, to: 0.64)
                                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                    .rotationEffect(.init(degrees: rotation))
                            }
                        }
                        .frame(width: 250, height: 250)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                Spacer()
                
                // Hosts section
                VStack(alignment: .leading){
                    Seprator()
                    Spacer().frame(height: 22)
                    DetezoHeaderLabel(text: LandingScreenTexts.hosts).padding(.horizontal, 20)
                    Spacer().frame(height: 8)
                    DetezoDescriptionLabel(text: LandingScreenTexts.hostsDesc)
                        .padding(.horizontal, 20)
                    Spacer().frame(height: 50)
                    HStack(spacing: 13) {
                        NavigationLink {
                            Login()
                        } label: {
                            DetezoMainNavigationBtn(title: LandingScreenTexts.logIn)
                        }
                        NavigationLink {
                            SignUp()
                        } label: {
                            DetezoMainNavigationBtn(title: LandingScreenTexts.signUp)
                        }
                    }.padding(.horizontal, 20)
                        
                    Spacer().frame(height: 29)
                }
                                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.appBG)
                .onAppear {
                    Task {
                        do {
                            try await center.requestAuthorization(for: .individual)
                            checkCameraPermission()
                        } catch {
                            print("Failed to enroll Aniyah with error: \(error)")
                            checkCameraPermission()
                        }
                    }
                }
                .alert(errorMEssage, isPresented: $showError) {
                    if cameraPermission == .denied {
                        Button(LandingScreenTexts.settings){
                            let settingsString = UIApplication.openSettingsURLString
                            if let settingsURL = URL(string: settingsString) {
                                openURL(settingsURL)
                            }
                        }
                        Button(CommonTexts.cancel, role: .cancel) {
                            
                        }
                    }
                }
                .onChange(of: qrDelegate.scannedCode) {
                    if let code = qrDelegate.scannedCode {
                        scannedCode =  code
                        session.stopRunning()
                    }
                }
        }
    }
    
    /// Checking Camera Permission
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
                setupCamera()
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    cameraPermission = .approved
                    setupCamera()
                } else {
                    cameraPermission = .denied
                    presentError("Please Provide Access to Camera for scanning codes")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError("Please Provide Access to Camera for scanning codes")
            default: break
            }
        }
    }
    
    func reactiveCamera() {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    
    /// Setting Up Camera
    func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInUltraWideCamera, .builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("UNKNOWN ERROR")
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError("UNKNOWN ERROR")
                return
            }
            
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            
            qrOutput.metadataObjectTypes = [.qr]
            
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
        } catch {
            presentError(error.localizedDescription)
        }
    }
    func presentError(_ message: String) {
        errorMEssage = message
        showError.toggle()
    }
}

#Preview {
    Landing()
}

