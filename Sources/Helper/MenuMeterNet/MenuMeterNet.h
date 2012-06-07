//
//  MenuMeterNet.h
//
// 	Constants and other definitions for the Net Meter
//
//	Copyright (c) 2002-2010 Alex Harper
//
// 	This file is part of MenuMeters.
// 
// 	MenuMeters is free software; you can redistribute it and/or modify
// 	it under the terms of the GNU General Public License version 2 as 
//  published by the Free Software Foundation.
// 
// 	MenuMeters is distributed in the hope that it will be useful,
// 	but WITHOUT ANY WARRANTY; without even the implied warranty of
// 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// 	GNU General Public License for more details.
// 
// 	You should have received a copy of the GNU General Public License
// 	along with MenuMeters; if not, write to the Free Software
// 	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
// 


///////////////////////////////////////////////////////////////
//	
//	Constants
//
///////////////////////////////////////////////////////////////

// Widths of the various displays
#define kNetArrowDisplayWidth				13
#define kNetNumberDisplayGapWidth			2
#define kNetDisplayGapWidth					2

// String for primary interface selection (primary interface)
#define kNetPrimaryInterface				@"primary"

///////////////////////////////////////////////////////////////
//	
//	Preference information
//
///////////////////////////////////////////////////////////////

// Pref dictionary keys
#define kNetIntervalPref					@"NetInterval"
#define kNetDisplayModePref					@"NetDisplayMode"
#define kNetDisplayOrientationPref			@"NetOrientation"
#define kNetThroughputLabelPref				@"NetThroughputLabel"
#define kNetThroughput1KBoundPref			@"NetThroughput1KBound"
#define kNetGraphStylePref					@"NetGraphStyle"
#define kNetGraphLengthPref					@"NetGraphLength"
#define kNetScaleModePref					@"NetScaleMode"
#define kNetScaleCalcPref					@"NetScaleCalc"
#define kNetPreferInterfacePref				@"NetPreferInterface"
#define kNetTransmitColorPref				@"NetTransmitColor"
#define kNetReceiveColorPref				@"NetReceiveColor"
#define kNetInactiveColorPref				@"NetInactiveColor"

// Display modes
enum {
	kNetDisplayArrows						= 1,
	kNetDisplayThroughput					= 2,
	kNetDisplayGraph						= 4
};
#define kNetDisplayDefault					kNetDisplayArrows

// Display orientation
enum {
	kNetDisplayOrientTxRx		= 0,
	kNetDisplayOrientRxTx
};
#define kNetDisplayOrientationDefault		kNetDisplayOrientTxRx

// Timer
#define kNetUpdateIntervalMin				0.5
#define kNetUpdateIntervalMax				20.0
#define kNetUpdateIntervalDefault			2.0

// Net scaling types
enum {
	kNetScaleInterfaceSpeed		= 0,
	kNetScalePeakTraffic
};
#define kNetScaleDefault					kNetScaleInterfaceSpeed

// Net scaling calcs
enum {
	kNetScaleCalcLinear			= 0,
	kNetScaleCalcSquareRoot,
	kNetScaleCalcCubeRoot,
	kNetScaleCalcLog
};
#define kNetScaleCalcDefault				kNetScaleCalcCubeRoot

// Graph display
#define kNetGraphWidthMin					11
#define kNetGraphWidthMax					88
#define kNetGraphWidthDefault				33

// Net graph styles
enum {
	kNetGraphStyleStandard		= 0,
	kNetGraphStyleCentered,
	kNetGraphStyleOpposed,
	kNetGraphStyleInverseOpposed
};
#define kNetGraphStyleDefault				kNetGraphStyleStandard

// Throughput label
#define kNetThroughputLabelDefault			YES

// Thoughput 1K bound
#define kNetThroughput1KBoundDefault		NO

// Colors
											// Moss green
#define kNetTransmitColorDefault			[NSColor colorWithDeviceRed:0.0f green:0.5f blue:0.25f alpha:1.0f]
											// Brick red
#define kNetReceiveColorDefault				[NSColor colorWithDeviceRed:0.5f green:0.0f blue:0.0f alpha:1.0f]
											// Light grey
#define kNetInactiveColorDefault			[NSColor darkGrayColor]

///////////////////////////////////////////////////////////////
//
//	Localized strings
//
///////////////////////////////////////////////////////////////

#define kTxLabel						@"Tx:"
#define kRxLabel						@"Rx:"
#define kPPPTitle						@"PPP:"
#define kTCPIPTitle						@"TCP/IP:"
#define kIPv4Title						@"IPv4:"
#define kIPv6Title						@"IPv6:"
#define kTCPIPInactiveTitle				@"Inactive"
#define kAppleTalkTitle					@"AppleTalk:"
#define kAppleTalkFormat				@"Net: %@ Node: %@ Zone: %@"
#define kThroughputTitle				@"Throughput:"
#define kPeakThroughputTitle			@"Peak Throughput:"
#define kTrafficTotalTitle				@"Traffic Totals:"
#define kTrafficTotalFormat				@"%@ %@ (%@ bytes)"
#define kOpenNetworkUtilityTitle		@"Open Network Utility"
#define kOpenNetworkPrefsTitle			@"Open Network Preferences"
#define kOpenInternetConnectTitle		@"Open Internet Connect"
#define kSelectPrimaryInterfaceTitle	@"Display primary interface"
#define kSelectInterfaceTitle			@"Display this interface"
#define kCopyIPv4Title					@"Copy IPv4 address"
#define kCopyIPv6Title					@"Copy IPv6 address"
#define kPPPConnectTitle				@"Connect"
#define kPPPDisconnectTitle				@"Disconnect"
#define kNoInterfaceErrorMessage		@"No Active Interfaces"
#define kGbpsLabel						@"Gbps"
#define kMbpsLabel						@"Mbps"
#define kKbpsLabel						@"Kbps"
#define kByteLabel						@"B"
#define kKBLabel						@"KB"
#define kMBLabel						@"MB"
#define kGBLabel						@"GB"
#define kBytePerSecondLabel				@"B/s"
#define kKBPerSecondLabel				@"KB/s"
#define kMBPerSecondLabel				@"MB/s"
#define kGBPerSecondLabel				@"GB/s"
#define kPPPNoConnectTitle				@"Not Connected"
#define kPPPConnectingTitle				@"Connecting..."
#define kPPPConnectedTitle				@"Connected"
#define kPPPConnectedWithTimeTitle		@"Connected %02d:%02d:%02d"
#define kPPPDisconnectingTitle			@"Disconnecting..."


