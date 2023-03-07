function math.pointOnSphere(alt, azu, rad, orgX, orgY, orgZ)
    alt = alt and tonumber(alt) or 0
    azu = azu and tonumber(azu) or 0
    rad = rad and tonumber(rad) or 0

    orgX = orgX and tonumber(orgX) or 0
    orgY = orgY and tonumber(orgY) or 0
    orgZ = orgZ and tonumber(orgZ) or 0

    return  orgX + rad * math.sin( azu ) * math.cos( alt ),
            orgY + rad * math.cos( azu ) * math.cos( alt ),
            orgZ + rad * math.sin( alt )
end

function math.sign(n)
    return n >= 0 and 1 or -1
end

function math.round(n, bracket)
    bracket = bracket or 1

    return math.floor(n / bracket + math.sign(n) * 0.5) * bracket
end