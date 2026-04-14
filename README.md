# Universal Network & Cipher Validator

A cross-platform PowerShell (pwsh) automation tool built on Ubuntu Linux. This utility validates network connectivity, confirms SSL/TLS handshake integrity, and audits SSH/SFTP cipher negotiation.

## 🛠 Features
- **TCP Connectivity:** Verified port reachability with timeout handling.
- **Security Audit:** Automated SSL/TLS handshake verification for HTTPS endpoints.
- **Cipher Negotiation:** Probes Port 22 (SSH/SFTP) to identify active encryption algorithms (Ciphers) and Key Exchange (KEX) methods.
- **Efficiency:** Built-in idempotency logic to skip already-validated hosts.
- **Logging:** Generates a structured audit trail for compliance monitoring.

## 📂 Project Structure
- `NetworkFunctions.psm1`: The logic layer containing core validation functions.
- `Run-Validation.psh`: The execution script for orchestration and reporting.
- `Endpoints.csv`: Input file for hostnames and ports.
- `automation.log`: Local audit trail (not uploaded to GitHub).

## 🚀 How to Use
1. Clone the repository to your local machine.
2. Ensure **PowerShell (pwsh)** and **OpenSSH** are installed.
3. Populate `Endpoints.csv` with your targets.
4. Execute the script:
   ```bash
   ./Run-Validation.psh

 ## 🗺️ Roadmap
- [ ] **Parallel Processing:** Implement `ForEach-Object -Parallel` to scan hundreds of endpoints simultaneously.
- [ ] **Certificate Expiry Tracking:** Extract SSL expiration dates to proactively alert on renewals.
- [ ] **Notification Layer:** Integrate Webhooks to send failed connection alerts to Slack or Discord.
- [ ] **Security+ Compliance:** Add automated checks for deprecated ciphers (like Triple DES or RC4).
