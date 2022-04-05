//VGA 时序
//640x480(60Hz) 25.175MHz

/*
//	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	96;
parameter	H_SYNC_BACK	=	45+3;
parameter	H_SYNC_ACT	=	640;	//	646
parameter	H_SYNC_FRONT=	13+3;
parameter	H_SYNC_TOTAL=	800;
//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	2;
parameter	V_SYNC_BACK	=	30+2;
parameter	V_SYNC_ACT	=	480;	//	484
parameter	V_SYNC_FRONT=	9+2;
parameter	V_SYNC_TOTAL=	525;
//	Start Offset
*/

//	Horizontal Parameter	( Pixel )
//parameter	H_SYNC_CYC	=	40;
//parameter	H_SYNC_BACK	=	220;
//parameter	H_SYNC_ACT	=	1280;	//	646
//parameter	H_SYNC_FRONT=	110;
//parameter	H_SYNC_TOTAL=	1650;
//	Virtical Parameter		( Line )
//parameter	V_SYNC_CYC	=	5;
//parameter	V_SYNC_BACK	=	20;
//parameter	V_SYNC_ACT	=	720;	//	484
//parameter	V_SYNC_FRONT=	5;
//parameter	V_SYNC_TOTAL=	750;
//	Start Offset
parameter	X_START		=	H_SYNC_CYC+H_SYNC_BACK;//144
parameter	Y_START		=	V_SYNC_CYC+V_SYNC_BACK;//34
