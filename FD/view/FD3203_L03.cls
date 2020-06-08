
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3203_L03()
{
	@super();
}
@extends AView;


@function FD3203_L03:init(context, evtListener)
{
	@super.init(context, evtListener);
	
	this.lblFundCode = this.findCompByGroup('listViewGrp')[0];
	this.lblFundOtpName = this.findCompByGroup('listViewGrp')[1];
	this.lblFundKorName = this.findCompByGroup('listViewGrp')[2];
};


@function FD3203_L03:setData(data)
{		
	this.lblFundCode.setText(data.a1);
	this.lblFundOtpName.setText(data.a2);
	this.lblFundKorName.setText(data.a3);
	this.ifInBlockReserved = data.a4;
	this.ifOutBlock1Reserved = data.a5;
	this.ifOutBlock2Reserved = data.a6;
};

@function FD3203_L03:onnextBtnClick(comp, info)
{
	//TODO:edit here
	var thisObj = this;
	var cont = thisObj.getContainer();
	
	//이체내역 상세 윈도우 화면 팝업
	var win = AWindow.createWindow('FD/window/FD1201_W03.lay', 'FD1201W03');		

	win.inParam = thisObj.ifInBlockReserved;
	win.out1Param = thisObj.ifOutBlock1Reserved;
	win.out2Param = thisObj.ifOutBlock2Reserved;
	
	win.setWindowOption(
	{
		isModal: true,
		modalBgOption: 'light'
	});

	win.openAsDialog(this, '100%', '100%');	
};
