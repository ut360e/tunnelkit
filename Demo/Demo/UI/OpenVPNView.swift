//
//  OpenVPNView.swift
//  Demo
//
//  Created by Davide De Rosa on 12/16/23.
//  Copyright (c) 2024 Davide De Rosa. All rights reserved.
//
//  https://github.com/keeshux
//
//  This file is part of TunnelKit.
//
//  TunnelKit is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  TunnelKit is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with TunnelKit.  If not, see <http://www.gnu.org/licenses/>.
//

import SwiftUI
import TunnelKitOpenVPN
import TunnelKitManager

struct OpenVPNView: View {
    let vpn: NetworkExtensionVPN

    let vpnStatus: VPNStatus

    let keychain: Keychain

    @State private var server = "nl-free-50"

    @State private var domain = "protonvpn.net"

    @State private var portText = "80"

    @State private var username = ""

    @State private var password = ""

    var body: some View {
        List {
            formView
            buttonView
        }
    }
}

private extension OpenVPNView {
    var formView: some View {
        Section {
            TextField("Server", text: $server)
            TextField("Domain", text: $domain)
            TextField("Port", text: $portText)
            TextField("Username", text: $username)
            TextField("Password", text: $password)
        }
    }

    var buttonView: some View {
        Section {
            Button(vpnStatus.actionText(for: vpnStatus)) {
                switch vpnStatus {
                case .disconnected:
                    connect()

                case .connected, .connecting, .disconnecting:
                    disconnect()
                }
            }
        }
    }

    func connect() {
        do {
            let ovpnBase64 = "Y2xpZW50CmRldiB0dW4KcHJvdG8gdGNwCnJlbW90ZSAxODUuMTUzLjE4MS4xNTkgNDQzCnJlc29sdi1yZXRyeSBpbmZpbml0ZQpub2JpbmQKCnBlcnNpc3Qta2V5CnBlcnNpc3QtdHVuCgpyZW1vdGUtY2VydC10bHMgc2VydmVyCmF1dGggU0hBMjU2CmNpcGhlciBBRVMtMTI4LUdDTQpkYXRhLWNpcGhlcnMgQUVTLTEyOC1HQ00KZGF0YS1jaXBoZXJzLWZhbGxiYWNrIEFFUy0xMjgtQ0JDCnRscy1ncm91cHMgWDI1NTE5OnNlY3AyNTZyMQp0bHMtdmVyc2lvbi1taW4gMS4yCnRscy1jaXBoZXIgVExTLUVDREhFLUVDRFNBLVdJVEgtQUVTLTEyOC1HQ00tU0hBMjU2Cgp0bHMtZ3JvdXBzIFgyNTUxOTpzZWNwMjU2cjEKdGxzLWNsaWVudAprZXktZGlyZWN0aW9uIDEKa2VlcGFsaXZlIDEwIDYwCmF1dGgtdXNlci1wYXNzCnZlcmIgMAppZ25vcmUtdW5rbm93bi1vcHRpb24gYmxvY2stb3V0c2lkZS1kbnMKYmxvY2stb3V0c2lkZS1kbnMKc2V0ZW52IG9wdCBibG9jay1vdXRzaWRlLWRucwpzbmRidWYgMzkzMjE2CnJjdmJ1ZiAzOTMyMTYKCnJlZGlyZWN0LWdhdGV3YXkgZGVmMSBieXBhc3MtZGhjcAojcm91dGUgMC4wLjAuMCAwLjAuMC4wCnJvdXRlIDEwLjEyLjAuMCAyNTUuMjU1LjAuMAoKcHVsbAphdXRoLW5vY2FjaGUKY29tcC1sem8gbm8KZmxvYXQKc2NyaXB0LXNlY3VyaXR5IDIKPGNhPgotLS0tLUJFR0lOIENFUlRJRklDQVRFLS0tLS0KTUlJQi96Q0NBYVNnQXdJQkFnSVVYMEpCbUNsdUpqMjVIQUd4emxJMEljT3RYS2t3Q2dZSUtvWkl6ajBFQXdJdwpLekVwTUNjR0ExVUVBd3dnVkhONGNsTmtTV05KUVc5R2JGZG5ObGh2Um05cVN6bFZZVE5GT1ZBME1HUXdIaGNOCk1qVXdPREExTWpNMU1ETTRXaGNOTXpVd09EQXpNak0xTURNNFdqQXJNU2t3SndZRFZRUUREQ0JVYzNoeVUyUkoKWTBsQmIwWnNWMmMyV0c5R2IycExPVlZoTTBVNVVEUXdaREJaTUJNR0J5cUdTTTQ5QWdFR0NDcUdTTTQ5QXdFSApBMElBQkdtc21vOG5uWGRlbTFtL1dtdjM3aFdBNjVFeXAvMGd3TGhIclN2T3ZLci9GWXV0UFF0QWt4RUtMSkdlCktiTDVHSGkxUzN0Y1VCYzlEREJEaXlDZTV1U2pnYVV3Z2FJd0RBWURWUjBUQkFVd0F3RUIvekFkQmdOVkhRNEUKRmdRVXk4bzAvSldVbGN4UnZYTGJWNE5DVmMzanRLd3daZ1lEVlIwakJGOHdYWUFVeThvMC9KV1VsY3hSdlhMYgpWNE5DVmMzanRLeWhMNlF0TUNzeEtUQW5CZ05WQkFNTUlGUnplSEpUWkVsalNVRnZSbXhYWnpaWWIwWnZha3M1ClZXRXpSVGxRTkRCa2doUmZRa0dZS1c0bVBia2NBYkhPVWpRaHc2MWNxVEFMQmdOVkhROEVCQU1DQVFZd0NnWUkKS29aSXpqMEVBd0lEU1FBd1JnSWhBTVVocmZMRkkrMGhDcEJFZkFYd2R2UU85bW0wRUxNODM1a09HQ254Rkt4RApBaUVBajlHdHVCS0RtTitaSGRJbXZ6OFhUZnlvOEFBTE1NNXU3RmwyREllTFRmND0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo8L2NhPgoKPGNlcnQ+CkNlcnRpZmljYXRlOgogICAgRGF0YToKICAgICAgICBWZXJzaW9uOiAzICgweDIpCiAgICAgICAgU2VyaWFsIE51bWJlcjoKICAgICAgICAgICAgNmM6OGI6YTE6MDI6N2M6YTk6MjA6MzE6ZTA6ZGY6ZDU6MWQ6MjQ6N2U6NWI6ZGIKICAgICAgICBTaWduYXR1cmUgQWxnb3JpdGhtOiBlY2RzYS13aXRoLVNIQTI1NgogICAgICAgIElzc3VlcjogQ049VHN4clNkSWNJQW9GbFdnNlhvRm9qSzlVYTNFOVA0MGQKICAgICAgICBWYWxpZGl0eQogICAgICAgICAgICBOb3QgQmVmb3JlOiBBdWcgIDUgMjM6NTI6MTIgMjAyNSBHTVQKICAgICAgICAgICAgTm90IEFmdGVyIDogTm92ICA4IDIzOjUyOjEyIDIwMjcgR01UCiAgICAgICAgU3ViamVjdDogQ049VHN4clNkSWNJQW9GbFdnNlhvRm9qSzlVYTNFOVA0MGQKICAgICAgICBTdWJqZWN0IFB1YmxpYyBLZXkgSW5mbzoKICAgICAgICAgICAgUHVibGljIEtleSBBbGdvcml0aG06IGlkLWVjUHVibGljS2V5CiAgICAgICAgICAgICAgICBQdWJsaWMtS2V5OiAoMjU2IGJpdCkKICAgICAgICAgICAgICAgIHB1YjoKICAgICAgICAgICAgICAgICAgICAwNDo5ZDozMTowNzo5OTphMzozZDoyZjozZjo4MTpiMzpjZjpiNDozZTpjZDoKICAgICAgICAgICAgICAgICAgICBmYjpkNjo0Zjo5NDo1YTpiMjo2Mjo2Mzo0MTphMjo2Nzo1YzoxMjo1MDozZToKICAgICAgICAgICAgICAgICAgICAxOTo3Nzo3OTphZjphODo3OTphOTowNDphNTo2ZjpjNToxYjozNjo4OTplZjoKICAgICAgICAgICAgICAgICAgICA2NTo0MTpiMzpkYzo0NDozMDpiYzplYTo3NzpiMzoxODo4ZTpmYTo3Yzo2ODoKICAgICAgICAgICAgICAgICAgICAyMTphYjphZjpkMDo4NgogICAgICAgICAgICAgICAgQVNOMSBPSUQ6IHByaW1lMjU2djEKICAgICAgICAgICAgICAgIE5JU1QgQ1VSVkU6IFAtMjU2CiAgICAgICAgWDUwOXYzIGV4dGVuc2lvbnM6CiAgICAgICAgICAgIFg1MDl2MyBCYXNpYyBDb25zdHJhaW50czogCiAgICAgICAgICAgICAgICBDQTpGQUxTRQogICAgICAgICAgICBYNTA5djMgU3ViamVjdCBLZXkgSWRlbnRpZmllcjogCiAgICAgICAgICAgICAgICBBMTo3NjpDQjo1MDoxMjpFODo3QTo0MDo2RjowOTo0ODo4MTowMjoxODo1MTpCRDozRjo4MTo5Qzo0OQogICAgICAgICAgICBYNTA5djMgQXV0aG9yaXR5IEtleSBJZGVudGlmaWVyOiAKICAgICAgICAgICAgICAgIGtleWlkOkNCOkNBOjM0OkZDOjk1Ojk0Ojk1OkNDOjUxOkJEOjcyOkRCOjU3OjgzOjQyOjU1OkNEOkUzOkI0OkFDCiAgICAgICAgICAgICAgICBEaXJOYW1lOi9DTj1Uc3hyU2RJY0lBb0ZsV2c2WG9Gb2pLOVVhM0U5UDQwZAogICAgICAgICAgICAgICAgc2VyaWFsOjVGOjQyOjQxOjk4OjI5OjZFOjI2OjNEOkI5OjFDOjAxOkIxOkNFOjUyOjM0OjIxOkMzOkFEOjVDOkE5CiAgICAgICAgICAgIFg1MDl2MyBFeHRlbmRlZCBLZXkgVXNhZ2U6IAogICAgICAgICAgICAgICAgVExTIFdlYiBDbGllbnQgQXV0aGVudGljYXRpb24KICAgICAgICAgICAgWDUwOXYzIEtleSBVc2FnZTogCiAgICAgICAgICAgICAgICBEaWdpdGFsIFNpZ25hdHVyZQogICAgU2lnbmF0dXJlIEFsZ29yaXRobTogZWNkc2Etd2l0aC1TSEEyNTYKICAgIFNpZ25hdHVyZSBWYWx1ZToKICAgICAgICAzMDo0NTowMjoyMDoyYjo4YzpmMjoxMzpkYzo4OTpjZDoxYTpiYzo4ODpiNjowZTpkNjpiNzoKICAgICAgICBlYjo5NDpmYjpjOTpmMzpmMjplYTo5MTpiOTpjYjpjYjphNDpiYTo3NDpiZjowMjo5OTo5MDoKICAgICAgICAwMjoyMTowMDpiMTo2OTozMTpjMTowMjpmMDoxYToxYTpkMTplMToxYzpjODplZjoxMDoyYjoKICAgICAgICA0ODpkZjo1ZDozZDpjYjoyMDo3NjpkYTozNzpiNzpmYjozZjpkYjozMDo5ZDplZDpiOAotLS0tLUJFR0lOIENFUlRJRklDQVRFLS0tLS0KTUlJQ0REQ0NBYktnQXdJQkFnSVFiSXVoQW55cElESGczOVVkSkg1YjJ6QUtCZ2dxaGtqT1BRUURBakFyTVNrdwpKd1lEVlFRRERDQlVjM2h5VTJSSlkwbEJiMFpzVjJjMldHOUdiMnBMT1ZWaE0wVTVVRFF3WkRBZUZ3MHlOVEE0Ck1EVXlNelV5TVRKYUZ3MHlOekV4TURneU16VXlNVEphTUNzeEtUQW5CZ05WQkFNTUlGUnplSEpUWkVsalNVRnYKUm14WFp6WlliMFp2YWtzNVZXRXpSVGxRTkRCa01Ga3dFd1lIS29aSXpqMENBUVlJS29aSXpqMERBUWNEUWdBRQpuVEVIbWFNOUx6K0JzOCswUHMzNzFrK1VXckppWTBHaVoxd1NVRDRaZDNtdnFIbXBCS1Z2eFJzMmllOWxRYlBjClJEQzg2bmV6R0k3NmZHZ2hxNi9RaHFPQnR6Q0J0REFKQmdOVkhSTUVBakFBTUIwR0ExVWREZ1FXQkJTaGRzdFEKRXVoNlFHOEpTSUVDR0ZHOVA0R2NTVEJtQmdOVkhTTUVYekJkZ0JUTHlqVDhsWlNWekZHOWN0dFhnMEpWemVPMApyS0V2cEMwd0t6RXBNQ2NHQTFVRUF3d2dWSE40Y2xOa1NXTkpRVzlHYkZkbk5saHZSbTlxU3psVllUTkZPVkEwCk1HU0NGRjlDUVpncGJpWTl1UndCc2M1U05DSERyVnlwTUJNR0ExVWRKUVFNTUFvR0NDc0dBUVVGQndNQ01Bc0cKQTFVZER3UUVBd0lIZ0RBS0JnZ3Foa2pPUFFRREFnTklBREJGQWlBcmpQSVQzSW5OR3J5SXRnN1d0K3VVKzhuego4dXFSdWN2THBMcDB2d0taa0FJaEFMRnBNY0VDOEJvYTBlRWN5TzhRSzBqZlhUM0xJSGJhTjdmN1A5c3duZTI0Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0KPC9jZXJ0PgoKPGtleT4KLS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JR0hBZ0VBTUJNR0J5cUdTTTQ5QWdFR0NDcUdTTTQ5QXdFSEJHMHdhd0lCQVFRZ0pTRXhnZnNoTmwyekE2TkUKMXo2ejYvVXRhS2JjNmdFVFFOdFpuOFZCWTllaFJBTkNBQVNkTVFlWm96MHZQNEd6ejdRK3pmdldUNVJhc21KagpRYUpuWEJKUVBobDNlYStvZWFrRXBXL0ZHemFKNzJWQnM5eEVNTHpxZDdNWWp2cDhhQ0dycjlDRwotLS0tLUVORCBQUklWQVRFIEtFWS0tLS0tCjwva2V5PgoKPHRscy1jcnlwdD4KIwojIDIwNDggYml0IE9wZW5WUE4gc3RhdGljIGtleQojCi0tLS0tQkVHSU4gT3BlblZQTiBTdGF0aWMga2V5IFYxLS0tLS0KZmIzNDY5MzY5OGM2YmQ3N2JmMDhjMDk4NDNiODhkZGEKYmNjZTEyNjQ3ZmM3NjAxNzliZTFjNGI4ZDFjMjBmY2YKN2ZjNzI5MmJiZjYwZDNhZGZhNWQ4NzNhNDllOTdjYmUKZWExODIwYThkNGZhNmEyZTI3YTRkMTk2ODg4M2ZiM2IKODM2YThkZDQ5ZGE0ZDM0Y2NiYzU1ZmEzZDBhY2JhNjMKYzI3M2E1ZjJiZjk5ZGFmMjRhZTkzYTEzYmJlM2I1ZjcKNGQyMmFjNmJkNmJiYWEyOTY0MDBjMzU5ZDk1ZjYzYTYKODEwYzY3MzM3YzczMmI2Y2YyZGQ0NzM0MDIyZTExYWYKZjY1YzNiOWY5Y2I5MGE0NDYyODg5ZTMyOTEyMGI2ZjMKZjI2ZDM3MzYwNTIzMzg1YTg0ZmI1Y2Y1NjExNDA2MzgKOWI2MGNjMTIyNTE2YWY0NmMwNzg3YmY2NGRiNTYwMjAKNzhhYmU0NTRjYTBkZTdlY2ZkOWIwNmJjZjY0M2FjN2EKMDIyYjg0MWJjMWI0NDgwNzJiNDMzYTZkMzY2NWMwMGEKOTgzMzgwODgyYjAyODQzYmUxYzhkZmQ1ZmIwMTQ3YjIKZDI5OTYwYmUzYzRhNDhjNWJkNTJiN2QxMDI5NGRjZmEKMzUwNWNmODExZGRiYmY4ZTRmZDRjZGEzMmEwYjY0YjMKLS0tLS1FTkQgT3BlblZQTiBTdGF0aWMga2V5IFYxLS0tLS0KPC90bHMtY3J5cHQ+"
                
                // Credentials
                let username = "showrav017@gmail.com"
                let password = "123456"
            
            guard let ovpnData = Data(base64Encoded: ovpnBase64),
                  let ovpnContent = String(data: ovpnData, encoding: .utf8) else {
                NSLog("OpenVPN: Failed to decode base64 configuration")
                throw NSError(domain: "OpenVPNManager",
                                 code: 1001,
                                 userInfo: [NSLocalizedDescriptionKey: "Failed to decode base64 configuration"])
            }
            let result = try OpenVPN.ConfigurationParser.parsed(fromContents: ovpnContent)
            let credentials = OpenVPN.Credentials(username, password)
            let passwordReference: Data
            do {
                var keychain: Keychain = Keychain(group: "group.com.ehsan.ios.TunnelKit.Demo")
                passwordReference = try keychain.set(password: credentials.password, for: credentials.username, context: "com.ehsan.ios.TunnelKit.Demo.OpenVPN-Tunnel")
            } catch {
                print("Keychain failure: \(error)")
                return
            }
            
            let builder = result.configuration.builder()
            let cfg = builder.build()

            var providerConfiguration = OpenVPN.ProviderConfiguration("TunnelKit.OpenVPN",
                                                                      appGroup: "group.com.ehsan.ios.TunnelKit.Demo",
                                                                      configuration: cfg)
            
            providerConfiguration.username = credentials.username
            providerConfiguration.shouldDebug = false
            //providerConfiguration.debugLogPath = "\(uniqueFileName).log"
            providerConfiguration.masksPrivateData = false
            providerConfiguration._appexSetDebugLogPath()
            
            
            providerConfiguration.print()
            print(providerConfiguration._appexDebugLogURL)
            
            Task {
                var extra = NetworkExtensionExtra()
                extra.passwordReference = passwordReference
                extra.userData = [credentials.username: credentials.password]
                try await vpn.reconnect(
                    "com.ehsan.ios.TunnelKit.Demo.OpenVPN-Tunnel",
                    configuration: providerConfiguration,
                    extra: extra,
                    after: .seconds(2)
                )
            }
        } catch {
            print("OpenVPN connection failed: \(error.localizedDescription)")
        }
    }
    
    /*func connect() {
        let hostname = ((domain == "") ? server : [server, domain].joined(separator: "."))
        let port = UInt16(portText)!
        
        

        let credentials = OpenVPN.Credentials(username, password)
        var builder = OpenVPN.DemoConfiguration.make(params: .init(
            title: "TunnelKit.OpenVPN",
            appGroup: appGroup,
            hostname: hostname,
            port: port,
            socketType: .udp
        ))
        builder.username = credentials.username

        let passwordReference: Data
        do {
            passwordReference = try keychain.set(password: credentials.password, for: credentials.username, context: TunnelIdentifier.openVPN)
        } catch {
            print("Keychain failure: \(error)")
            return
        }

        let cfg = builder
        Task {
            var extra = NetworkExtensionExtra()
            extra.passwordReference = passwordReference
            try await vpn.reconnect(
                TunnelIdentifier.openVPN,
                configuration: cfg,
                extra: extra,
                after: .seconds(2)
            )
        }
    }*/

    func disconnect() {
        Task {
            await vpn.disconnect()
        }
    }
}

/*
#Preview {
    OpenVPNView(vpn: NetworkExtensionVPN(),
                vpnStatus: .disconnected,
                keychain: Keychain(group: appGroup))
}*/
