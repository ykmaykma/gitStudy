
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3203_L02()
{
	@super();
}
@extends AView;


@function FD3203_L02:init(context, evtListener)
{
	@super.init(context, evtListener);
	
	this.lblFundCode = this.findCompByGroup('listViewGrp')[0];
	this.lblFundOtpName = this.findCompByGroup('listViewGrp')[1];
	this.lblFundKorName = this.findCompByGroup('listViewGrp')[2];
	this.accPwd = null;
};


@function FD3203_L02:setData(data)
{		
	this.lblFundCode.setText(data.a1);
	this.lblFundOtpName.setText(data.a2);
	this.lblFundKorName.setText(data.a3);
	this.ifInBlockReserved = data.a4;
	this.ifOutBlock1Reserved = data.a5;
	this.ifOutBlock2Reserved = data.a6;
	this.accPwd = data.a7;
};

@function FD3203_L02:onnextBtnClick(comp, info)
{
	//TODO:edit here
	var thisObj = this;
	var cont = thisObj.getContainer();
	
	//이체내역 상세 윈도우 화면 팝업
	// 월정액적립식
	// 2019.06.04. 적립식 매수현황 전문이 SOFFQ586에서 SACMQ619로 변경되며
	// 월정액적립식과 일정액적립식 구분변경('D1CMS약정여부==1'->'D1납입방법명=="월정액적립식"')
	
	if(this.ifOutBlock2Reserved['D1납입방법명'] == "월정액적립식"){
		var win = AWindow.createWindow('FD/window/FD1201_W03.lay', 'FD1201W03');
	}else{
	// 매일적립식(자유적립식)
		var win = AWindow.createWindow('FD/window/FD1201_W04.lay', 'FD1201W04');
	}

	win.inParam = thisObj.ifInBlockReserved;
	win.out1Param = thisObj.ifOutBlock1Reserved;
	win.out2Param = thisObj.ifOutBlock2Reserved;
	win.accPwd = this.accPwd;
	
	win.setWindowOption(
	{
		isModal: true,
		modalBgOption: 'light'
	});
	
	// 월정액적립식
	// 2019.06.04.적립식 매수현황 전문이 SOFFQ586에서 SACMQ619로 변경되며
	// 월정액적립식과 일정액적립식 구분변경('D1CMS약정여부==1'->'D1납입방법명=="월정액적립식"')
	
	if(this.ifOutBlock2Reserved['D1납입방법명'] == "월정액적립식"){
		win.openAsDialog(this, '100%', '100%');	
	}else{
	// 매일적립식(자유적립식)
		win.openAsDialog(this);	
	}
};

@function FD3203_L02:onWindowResult(result, awindow)
{

		//TODO:edit here
	var thisObj = this;
	var cont = thisObj.getContainer();		
	var winId = awindow.getId();
	
	if(winId == 'FD1201W04')
	{
		if(result) {
			cont.fnDoSendDataManage();
		}
	}
};

