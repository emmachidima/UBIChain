import { describe, it, expect, beforeEach } from "vitest"

type Principal = string

interface UBIState {
  admin: Principal
  paused: boolean
  treasury: Principal
  registeredUsers: Map<Principal, number> // block height
  currentBlock: number
}

const UBI: UBIState = {
  admin: "STADMIN111",
  paused: false,
  treasury: "STTREASURY1",
  registeredUsers: new Map(),
  currentBlock: 1000
}

const CLAIM_INTERVAL = 144
const CLAIM_AMOUNT = 100_000

function isAdmin(caller: Principal) {
  return caller === UBI.admin
}

function register(caller: Principal) {
  if (UBI.registeredUsers.has(caller)) return { error: 102 }
  UBI.registeredUsers.set(caller, UBI.currentBlock)
  return { value: true }
}

function canClaim(caller: Principal) {
  const lastClaim = UBI.registeredUsers.get(caller)
  if (lastClaim === undefined) return { value: false }
  return { value: UBI.currentBlock - lastClaim >= CLAIM_INTERVAL }
}

function claim(caller: Principal) {
  if (UBI.paused) return { error: 104 }
  const lastClaim = UBI.registeredUsers.get(caller)
  if (lastClaim === undefined) return { error: 101 }
  if (UBI.currentBlock - lastClaim < CLAIM_INTERVAL) return { error: 103 }

  UBI.registeredUsers.set(caller, UBI.currentBlock)
  return { value: CLAIM_AMOUNT }
}

describe("UBI Claim Contract", () => {
  beforeEach(() => {
    UBI.paused = false
    UBI.admin = "STADMIN111"
    UBI.treasury = "STTREASURY1"
    UBI.registeredUsers = new Map()
    UBI.currentBlock = 1000
  })

  it("allows new users to register", () => {
    const res = register("STUSER1")
    expect(res).toEqual({ value: true })
    expect(UBI.registeredUsers.has("STUSER1")).toBe(true)
  })

  it("prevents double registration", () => {
    register("STUSER1")
    const res = register("STUSER1")
    expect(res).toEqual({ error: 102 })
  })

  it("allows claims after interval", () => {
    register("STUSER1")
    UBI.currentBlock += CLAIM_INTERVAL
    const res = claim("STUSER1")
    expect(res).toEqual({ value: CLAIM_AMOUNT })
  })

  it("blocks claim before interval", () => {
    register("STUSER1")
    UBI.currentBlock += 50
    const res = claim("STUSER1")
    expect(res).toEqual({ error: 103 })
  })

  it("prevents claim if not registered", () => {
    const res = claim("STGUEST")
    expect(res).toEqual({ error: 101 })
  })

  it("respects paused state", () => {
    register("STUSER1")
    UBI.currentBlock += CLAIM_INTERVAL
    UBI.paused = true
    const res = claim("STUSER1")
    expect(res).toEqual({ error: 104 })
  })

  it("returns false for canClaim if not registered", () => {
    const res = canClaim("STGUEST")
    expect(res).toEqual({ value: false })
  })

  it("returns true for canClaim after time", () => {
    register("STUSER1")
    UBI.currentBlock += CLAIM_INTERVAL
    const res = canClaim("STUSER1")
    expect(res).toEqual({ value: true })
  })

  it("returns false for canClaim before interval", () => {
    register("STUSER1")
    UBI.currentBlock += 10
    const res = canClaim("STUSER1")
    expect(res).toEqual({ value: false })
  })
})
