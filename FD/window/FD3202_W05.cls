
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3202_W05(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD3202_W05.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD3202_W05:onReady()
{
	@super.onReady();

	//TODO:edit here

};

@function FD3202_W05:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	
	this.lblFundContent = this.findCompById('lblFundContent');
	
	this.checkFundDetailInfo();
	
};


@function FD3202_W05:checkFundDetailInfo()
{
	var thisObj = this;
	var cont = thisObj.opener.getContainer();
				
	this.sendData('SOFFT107',
		function(queryData, groupName)
		{
			var InBlock1 = queryData.getBlockData('InBlock1')[0];
			
			InBlock1['D1처리구분'] = '1';
		
			var InBlock2 = queryData.getBlockData('InBlock2')[0];
										
			InBlock2['D1투신국내외구분'] = '1';
			InBlock2['D1투신펀드코드'] = thisObj.fundInfo["D1투신펀드코드"];
			InBlock2['D1이용사번호'] = theApp.systemInfo.fno;
			InBlock2['D1펀드내용'] = '';
			InBlock2['D1투자기간일수'] = '';
			InBlock2['D1환매수수료내용'] = '';
			InBlock2['D1보수내용'] = '';
			InBlock2['D1운용전략내용'] = '';
			InBlock2['D1위험관리전략내용'] = '';
			InBlock2['D1가입대상명'] = '';
			InBlock2['D1목표수익률'] = '0';
			InBlock2['D1펀드운용역명'] = '';
																
			queryData.printQueryData();				
		 },
		//afterOutBlockData
		function(queryData, groupName)
		{			
			if(queryData)
			{
				queryData.printQueryData();
				
				var InBlock2 = queryData.getBlockData('InBlock2')[0];
				var content1 = "";
				var content2 = "";
				
				if(InBlock2){					
					content1 = InBlock2["D1운용전략내용"];
					content2 = InBlock2["D1위험관리전략내용"];
				}
				
				thisObj.lblFundContent.setText(content1.trim() + " " + content2.trim());				
			}
		});
	
};
@function FD3202_W05:onbtnCloseClick(comp, info)
{

	//TODO:edit here
	this.close(0);

};

@function FD3202_W05:onbtnConfirmClick(comp, info)
{

	//TODO:edit here
	this.close(0);

};
