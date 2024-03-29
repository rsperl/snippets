
var nativeEndian binary.ByteOrder

func setByteOrder() {
	buf := [2]byte{}
	*(*uint16)(unsafe.Pointer(&buf[0])) = uint16(0xABCD)

	switch buf {
	case [2]byte{0xCD, 0xAB}:
		nativeEndian = binary.LittleEndian
	case [2]byte{0xAB, 0xCD}:
		nativeEndian = binary.BigEndian
	default:
		panic("Could not determine native endianness.")
	}
}

func isLittleEndian() bool {
	if nativeEndian == nil {
		setByteOrder()
	}
	return nativeEndian == binary.LittleEndian
}

func littleEndianToDecimal(b []byte) int {
	return int(nativeEndian.Uint64(b))
}

func bytesToHex(b []byte) string {
	return hex.EncodeToString(b)
}