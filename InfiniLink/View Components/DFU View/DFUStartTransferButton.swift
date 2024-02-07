//
//  DFUStartTransferButton.swift
//  DFUStartTransferButton
//
//  Created by Alex Emry on 9/15/21.
//
//


import Foundation
import SwiftUI

struct DFUStartTransferButton: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var updateStarted: Bool
    @Binding var firmwareSelected: Bool
    @Binding var externalResources: Bool
    
    
    @ObservedObject var dfuUpdater = DFU_Updater.shared
    @ObservedObject var bleManager = BLEManager.shared
    @ObservedObject var downloadManager = DownloadManager.shared
    
    var body: some View {
        Button {
            if updateStarted {
                dfuUpdater.stopTransfer()
                updateStarted = false
                dfuUpdater.firmwareURL = URL(fileURLWithPath: "")
                dfuUpdater.firmwareSelected = false
                dfuUpdater.firmwareFilename = ""
                dfuUpdater.resourceFilename = ""
            } else {
                dfuUpdater.percentComplete = 0
                if externalResources {
                    downloadManager.startTransfer = true
                    downloadManager.startDownload(url: downloadManager.browser_download_resources_url, isExternalResources: externalResources)
                    updateStarted = true
                } else {
                    if dfuUpdater.local {
                        dfuUpdater.transfer()
                        updateStarted = true
                    } else {
                        downloadManager.startTransfer = true
                        downloadManager.startDownload(url: downloadManager.browser_download_url, isExternalResources: externalResources)
                        
                        updateStarted = true
                    }
                }
            }
        } label: {
            Text(updateStarted ? NSLocalizedString("stop_transfer", comment: "") :
                    (dfuUpdater.local ? NSLocalizedString("download_and_install", comment: "") :
                        (downloadManager.downloading ? NSLocalizedString("downloading", comment: "") : NSLocalizedString("download_and_install", comment: ""))))
            .frame(maxWidth: .infinity)
            .font(.body.weight(.semibold))
            .padding(14)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .disabled(buttonDisabled())
        .opacity(buttonDisabled() ? 0.5 : 1.0)
    }
}

#Preview {
    DFUStartTransferButton(updateStarted: .constant(false), firmwareSelected: .constant(true), externalResources: .constant(false))
}
