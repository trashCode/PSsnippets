$serial = get-WmiObject Win32_ComputerSystemProduct
$serial.IdentifyingNumber
$serial.Name #le model