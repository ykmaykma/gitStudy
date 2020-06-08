
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5001_V06()
{
	@super();

	//TODO:edit here

}
@extends AView;


@function FD5001_V06:init(context, evtListener)
{
	@super.init(context, evtListener);

	//TODO:edit here
	
	this.grid = this.findCompById('Grid1');
	


};

//화면이 활성화된 후 이벤트
@function FD5001_V06:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	var thisObj = this;
	var cont = thisObj.getContainer();	
	this.name =	this.viewData.name;
	this.barAcc = this.viewData.barAcc;
	this.acc = this.viewData.acc;
	
	this.grid.setCellText(1,1,this.name);
	this.grid.setCellText(2,1,this.barAcc);
	

};

@function FD5001_V06:onButton1Click(comp, info)
{

	//TODO:edit here
	this.requestAccountInfo();

};
//계좌정보 가져오기
@function FD5001_V06:requestAccountInfo()
{
	var thisObj = this;
	var cont = thisObj.getContainer();
	cont.sendData('SACEQ306',
	//beforeInBlockBuffer
	function(queryData, groupName)
	{
		var inblockData = queryData.getBlockData('InBlock1');
		inblockData[0]['D1전자금융사용자ID'] = this.headerInfo.USER_ID;
	},
	
	//afterOutBlockData
	
	function(queryData, groupName)
	{
		if (afc.isSimulator) queryData.printQueryData();
		//기존의 계좌정보 클리어합니다.
		theApp.accInfo.clearInfo();
		
		if(!queryData){
			return;
		} 
		
		var OutBlock1 = queryData.getBlockData('OutBlock1');
		if(OutBlock1 && OutBlock1.length > 0)
		{
			//계좌정보 재세팅합니다.
			theApp.accInfo.setAccData(OutBlock1);
			
			theApp.fundAcc = thisObj.acc;
			theApp.goPageCheck('FD5002', false, {tabId:'FD5002_T01'});
		}
		else return;
		
	});
};