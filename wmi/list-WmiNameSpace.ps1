gwmi -namespace "root" -class "__Namespace" | Select Name

gwmi -namespace root\cimv2 -list |select -First 10
gwmi -namespace root\WMI -list |select -First 10