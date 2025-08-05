;; UBI Claim Contract

;; Error Codes
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-NOT-REGISTERED u101)
(define-constant ERR-ALREADY-REGISTERED u102)
(define-constant ERR-NOT-ELIGIBLE u103)
(define-constant ERR-PAUSED u104)
(define-constant ERR-ZERO-ADDRESS u105)

;; Constants
(define-constant CLAIM-AMOUNT u100000) ;; 0.1 STX in microstacks
(define-constant CLAIM-INTERVAL u144)  ;; Approx. 24 hours

;; Variables
(define-data-var admin principal tx-sender)
(define-data-var paused bool false)
(define-data-var claim-treasury principal tx-sender)

;; Maps
(define-map registered-users principal uint)

;; Internal Helpers

(define-private (is-admin)
  (is-eq tx-sender (var-get admin))
)

(define-private (ensure-not-paused)
  (if (not (var-get paused))
      true
      (err ERR-PAUSED))
)

(define-private (is-zero-address (addr principal))
  (is-eq addr 'SP000000000000000000002Q6VF78)
)

;; Admin-only Functions

(define-public (set-paused (pause bool))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (var-set paused pause)
    (ok pause)
  )
)

(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (not (is-zero-address new-admin)) (err ERR-ZERO-ADDRESS))
    (var-set admin new-admin)
    (ok true)
  )
)

(define-public (set-treasury (new-treasury principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (not (is-zero-address new-treasury)) (err ERR-ZERO-ADDRESS))
    (var-set claim-treasury new-treasury)
    (ok true)
  )
)

;; User Functions

(define-public (register)
  (match (map-get? registered-users tx-sender)
    (some dummy) (err ERR-ALREADY-REGISTERED)
    (none)
      (begin
        (map-set registered-users tx-sender block-height)
        (ok true)
      )
  )
)

(define-public (claim)
  (begin
    (try! (ensure-not-paused))
    (match (map-get? registered-users tx-sender)
      (none) (err ERR-NOT-REGISTERED)
      (some last-claim)
        (begin
          (asserts! (>= (- block-height last-claim) CLAIM-INTERVAL) (err ERR-NOT-ELIGIBLE))
          (map-set registered-users tx-sender block-height)
          (try! (stx-transfer? CLAIM-AMOUNT (var-get claim-treasury) tx-sender))
          (ok CLAIM-AMOUNT)
        )
    )
  )
)

;; Read-only

(define-read-only (is-registered (user principal))
  (ok (is-some (map-get? registered-users user)))
)

(define-read-only (get-last-claim (user principal))
  (ok (default-to u0 (map-get? registered-users user)))
)

(define-read-only (can-claim (user principal))
  (match (map-get? registered-users user)
    (some last-claim)
      (ok (>= (- block-height last-claim) CLAIM-INTERVAL))
    (none)
      (ok false)
  )
)

(define-read-only (get-admin)
  (ok (var-get admin))
)

(define-read-only (get-treasury)
  (ok (var-get claim-treasury))
)

(define-read-only (is-paused)
  (ok (var-get paused))
)
