
/**
Constructor
Do not call Function in Constructor.
*/
@class FD1304_W01(containerId)
{
	@super(containerId);
	
}
@extends BaseWindow;


@function FD1304_W01:onReady()
{
	@super.onReady();
	
	this.onCheckSetting();
	this.findCompById('investType').enable(false);
	this.findCompById('infoType').enable(false);
};

@function FD1304_W01:onWillActive(reload)
{
	@super.onWillActive(reload);		
	
};


@function FD1304_W01:onbtnCloseClick(comp, info)
{	
	this.close(0);
};


@function FD1304_W01:onBTN_CONFIRMClick(comp, info)
{

	//TODO:edit here
	this.opener.afterCallback('1');
	this.close();
};


@function FD1304_W01:onCheckSetting()
{
	if(!this.data.investType){  //투자권유불원
		this.findCompById('investType').setCheck(true);
	}
	
	if(!this.data.infoType){  //정보제공미제공
		this.findCompById('infoType').setCheck(true);
	}	
};



