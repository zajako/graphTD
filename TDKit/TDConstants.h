//
//  TDConstants.h
//  TDKit
//
//  Created by Tommy Allen on 7/14/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#ifndef TDKit_TDConstants_h
#define TDKit_TDConstants_h

#define kTDEntitySprite		400

typedef enum {
	kTDActionMove			= 500,
	kTDActionRotate			= 501
} kTDAction;

typedef enum {
	kTDEntityCreep			= 601,
	kTDEntityTower			= 602,
	kTDEntityProjectile		= 603
} kTDEntity;

typedef enum {
	kTDBlaster              = 701,
	kTDBeam                 = 702,
    kTDSpazer               = 703,
	kTDSplash               = 704,
    kTDTime                 = 705
} kTDSelected;

typedef enum {
	kTDStatusSlow           = 801,
	kTDStatusHaste          = 802,
    kTDStatusMight          = 803,
	kTDStatusPoison         = 804,
    kTDStatusRange          = 805
} kTDStatus;

#endif
