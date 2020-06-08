
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3202_W03(containerId)
{
	@super(containerId);

	//TODO:edit here

}
@extends BaseWindow;


@function FD3202_W03:onReady()
{
	@super.onReady();

	//TODO:edit here
				
};

@function FD3202_W03:onCloseBtnClick(comp, info)
{

	//TODO:edit here
	this.close(0);
};

@function FD3202_W03:sendDataManage(reload)
{	
	var thisObj = this;	
	
	this.sendData('SDPNQ060',
		function(queryData, groupName)
		{										
			queryData.printQueryData();
										
		 },
		//afterOutBlockData
		function(queryData, groupName)
		{
		
			var errMsg = this.getLastError('errMsg');
			var errCode = this.getLastError('errCode');
				
//			AToast.show(this.getLastError('errMsg')+'('+this.getLastError('errCode')+')');
									
			queryData.printQueryData();
			
			if(!queryData) return;
			
			var OutBlock1 = queryData.getBlockData('OutBlock1');
			
			if(!OutBlock1) return;
			
			for(var j=0;j<OutBlock1.length;j++){
				if(OutBlock1[j]['D1장애여부'] == 'O'){					
					thisObj.BankInfoGrid.addRowWithData([OutBlock1[j]['D1은행명'],OutBlock1[j]['D1은행번호']]);
				}						
			}				
			
	});			

}

@function FD3202_W03:onActiveDone(reload)
{	
	@super.onActiveDone(reload);
	
	this.BankInfoGrid = this.findCompById('BankInfoGrid');
				
	//기존목록 제거
	this.BankInfoGrid.removeAll();	
	
	//등록된 은행코드 로드
	this.sendDataManage();		
	
};

@function FD3202_W03:onBankInfoGridSelect(comp, info)
{
	//TODO:edit here
	
	if(comp.indexOfRow(info) < 0) return;
	
	var rowData =  comp.getDataByOption(info); /*comp.getRowDataByIndex(comp.getRowIndexByInfo(info));*/
	
	this.close(rowData);

};

@function FD3202_W03:onBankInfoGridScrollBottom(comp, info)
{

	//TODO:edit here
	if(this.contiKey)
	{
		this.sendDataManage(true);
	}
	else
	{	
		if(comp.getRowCount() > 0) AToast.show(Message.LastList);
	}

};
