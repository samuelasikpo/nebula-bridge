;; Title: NebulaBridge Protocol - Bitcoin <-> Stacks Asset Gateway
;;
;; Summary:
;; NebulaBridge is a decentralized cross-chain asset gateway designed 
;; to enable seamless and verifiable transfers between Bitcoin and 
;; Stacks. It ensures that digital value moves securely across chains 
;; without centralized custody or reliance on trusted intermediaries.
;;
;; Overview:
;; This protocol establishes a validator-governed bridge with layered 
;; security controls and flexible operational mechanisms. By combining 
;; multi-signature validation, fraud heuristics, and emergency safeguards, 
;; NebulaBridge aims to deliver institutional-grade safety for cross-chain 
;; participants. 
;;
;; Key Features:
;; - Validator-governed transaction confirmation (N-of-M model)
;; - Multi-phase deposit & withdrawal pipelines
;; - Real-time balance proofing and fraud detection
;; - Dynamic emergency controls (circuit breakers & admin recovery)
;; - Configurable thresholds (min/max limits, confirmation depth)
;;
;; Security Highlights:
;; - Multi-signature validator consensus with replay protection
;; - Cross-chain validation of Bitcoin sender & recipient addresses
;; - Strict deposit/withdrawal range enforcement
;; - Controlled emergency withdrawal by deployer

;; Traits

(define-trait bridgeable-token-trait (
  (transfer
    (uint principal principal)
    (response bool uint)
  )
  (get-balance
    (principal)
    (response uint uint)
  )
))

;; Error Codes

(define-constant ERROR-NOT-AUTHORIZED u1000)
(define-constant ERROR-INVALID-AMOUNT u1001)
(define-constant ERROR-INSUFFICIENT-BALANCE u1002)
(define-constant ERROR-INVALID-BRIDGE-STATUS u1003)
(define-constant ERROR-INVALID-SIGNATURE u1004)
(define-constant ERROR-ALREADY-PROCESSED u1005)
(define-constant ERROR-BRIDGE-PAUSED u1006)
(define-constant ERROR-INVALID-VALIDATOR-ADDRESS u1007)
(define-constant ERROR-INVALID-RECIPIENT-ADDRESS u1008)
(define-constant ERROR-INVALID-BTC-ADDRESS u1009)
(define-constant ERROR-INVALID-TX-HASH u1010)
(define-constant ERROR-INVALID-SIGNATURE-FORMAT u1011)

;; Protocol Constants

(define-constant CONTRACT-DEPLOYER tx-sender)
(define-constant MIN-DEPOSIT-AMOUNT u100000)
(define-constant MAX-DEPOSIT-AMOUNT u1000000000)
(define-constant REQUIRED-CONFIRMATIONS u6)

;; Data Variables

(define-data-var bridge-paused bool false)
(define-data-var total-bridged-amount uint u0)
(define-data-var last-processed-height uint u0)

;; Data Maps

(define-map deposits
  { tx-hash: (buff 32) }
  {
    amount: uint,
    recipient: principal,
    processed: bool,
    confirmations: uint,
    timestamp: uint,
    btc-sender: (buff 33),
  }
)

(define-map validators
  principal
  bool
)

(define-map validator-signatures
  {
    tx-hash: (buff 32),
    validator: principal,
  }
  {
    signature: (buff 65),
    timestamp: uint,
  }
)