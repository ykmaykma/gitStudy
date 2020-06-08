/**
Constructor
Do not call Function in Constructor.

오늘의 주문내역에서만 사용
*/
@class FD3203_L04()
{
	@super();

	this.sellFundInfo = null;

}
@extends AView;


@function FD3203_L04:init(context, evtListener)
{
	@super.init(context, evtListener);
	
	this.lblFundCode = this.findCompByGroup('listViewGrp')[0];
	this.lblFundOtpName = this.findCompByGroup('listViewGrp')[1];
	this.lblFundCancel = this.findCompByGroup('listViewGrp')[2];
	this.lblFundKorName = this.findCompByGroup('listViewGrp')[3];
	
	this.lblFundCancel.show(AComponent.GONE);
	/*
	if(this.getContainer().containerId == "FD1201") {
		this.lblFundCancel.show(AComponent.VISIBLE);
	} else {
		this.lblFundCancel.show(AComponent.GONE);
	}
	*/
};


@function FD3203_L04:setData(data)
{		
	
	this.lblFundCode.setText(data.a1);
	this.lblFundOtpName.setText(data.a2);
	this.lblFundKorName.setText(data.a3);
	
	this.sellFundInfo = (data.a4);
	
	this.txtPw = (data.a5);
	this.ifReserved = data.a6;
	
	if(this.getContainer().containerId == "FD1201") {
		if(this.sellFundInfo["D1취소여부"] == "1") {
			this.lblFundCancel.setText("취소완료");
		} else {
			this.lblFundCancel.setText("정상");
		}
		
	}

//	alert("this.sellFundInfo->[" + afc.log(this.sellFundInfo) + "]");

};


@function FD3203_L04:onnextBtnClick(comp, info)
{

	//TODO:edit here
	var thisObj = this;
	var cont = thisObj.getContainer();
	
	cont.fundSellInfo = thisObj.sellFundInfo;
	
	//오늘의 주문내역
	if(cont.containerId == "FD1201") {
		var win = AWindow.createWindow('FD/window/FD1201_W02.lay', 'FD1201W02');		

		win.fundInfo = thisObj.sellFundInfo;
		win.txtPw = thisObj.txtPw;
		win.ifReserved = thisObj.ifReserved;
		win.openAsDialog(this, '100%', '100%');	
	}
};

@function FD3203_L04:onWindowResult(result, windowObj)
{
	//TODO:edit here
	var thisObj = this;
	var cont = thisObj.getContainer();
			
	if(windowObj.containerId == 'FD1201W02')
	{
		if(result)
		{
			cont.fnDoSendDataManage();
		}
	}
};