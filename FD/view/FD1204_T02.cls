
/**
Constructor
Do not call Function in Constructor.
*/
@class FD1204_T02()
{
	@super();	
}
@extends AView;


//초기화
@function FD1204_T02:onArrInit()
{	
	this.listview.removeAllItems();
	
	this.startDate = Utils.yyyymmdd(new Date());
	this.endDate = Utils.yyyymmdd(new Date());
	
	this.button3.setText('당일');
	this.label8.setText( '총 0건');
	this.dayType = 0;
	
	this.nodata.show(AComponent.GONE);
};


@function FD1204_T02:init(context, evtListener)
{
	@super.init(context, evtListener);	
			
	this.accView = this.getContainer().findCompById('AccView').loadView;
	this.accDbx = this.accView.accDbx;
	this.secureTxf = this.accView.secureTxf;
	this.listview = this.findCompById('ListView1');
	this.listview.setDelegator(this);
	
	this.button3 = this.findCompById('Button3');
	this.label8 = this.findCompById('Label8');
	
	this.startDate = Utils.yyyymmdd(new Date());
	this.endDate = Utils.yyyymmdd(new Date());
	this.length = 0;
	this.dayType = 0;
	
	this.nodata = this.findCompById('Nodata');
};

//화면이 활성화된 후 이벤트
@function FD1204_T02:onActiveDone(reload)
{
	@super.onActiveDone(reload);	
};

@function FD1204_T02:onWillActive(reload)
{
	@super.onWillActive(reload);	
	
	this.fnDoSendDataManage();
};

//화면이 소멸되기 전 이벤트
@function FD1204_T02:onWillDeactive(reload)
{		
	this.onArrInit();
};


@function FD1204_T02:sendSACMQ603(contiKey)
{
	var thisObj = this;
	var cont = thisObj.getContainer();
	
	if(!this.accDbx.getSelectedItemData() || !this.accDbx.getSelectedItemData()['D1계좌번호']){
		AToast.show('계좌번호를 선택하세요.');
		return;
	}
	
	if(!afc.isSimulator)
	{
		if(!this.secureTxf.getCipherData())
		{
			AToast.show('계좌 비밀번호를 입력하세요.');
			this.secureTxf.addClass('active');
			return;
		}
	}	
	
	if(!contiKey) {
		this.length = 0;
		this.listview.removeAllItems();
	}
	
	theApp.accNetManager.addSkipErrorCode('SACMQ603', '2679');
	cont.sendData('SACMQ603', function(queryData, groupName){
	
		var InBlock1 = queryData.getBlockData('InBlock1')[0];
		InBlock1['D1조회구분'] = '1';
		InBlock1['D1시작계좌번호'] = thisObj.accDbx.getSelectedItemData()['D1계좌번호'];
		InBlock1['D1조회지점번호'] = '001';
		InBlock1['D1조회시작일'] = thisObj.startDate;
		InBlock1['D1조회종료일'] = thisObj.endDate;
		InBlock1['D1상품유형코드'] = 'zz';
		InBlock1['D1사고유형코드'] = '15';
		InBlock1['D1처리구분'] = '3';

		if(contiKey && contiKey != 0) {
			queryData.setContiKey(contiKey);
		}			
		
		if(afc.isSimulator)
		{
			queryData.printQueryData();
		}	
	},
				  function(queryData, groupName) {
		var errorData = this.getLastError();	
		
		if(errorData.errCode == '2679') {
			AToast.show('조회내역이 없습니다.');
			thisObj.label8.setText( '총 0건');
			thisObj.nodata.show(AComponent.VISIBLE);
		} else {
			thisObj.nodata.show(AComponent.GONE);
		}
		
		if(!queryData) return;
		var OutBlock1 = queryData.getBlockData('OutBlock2');

		//next키 저장
		thisObj.contiKey = queryData.getContiKey();

		afc.log(thisObj.contiKey);
		if(afc.isSimulator)
		{
			queryData.printQueryData();
		}	
		
		thisObj.length += OutBlock1.length;
		thisObj.label8.setText( '총 ' + thisObj.length + '건');
		
		thisObj.listview.addItem('FD/view/FD1204_V01.lay', OutBlock1);
	});	
};

@function FD1204_T02:bindData(item, data, listview) {
	if(item.view.setData) {
		item.view.setData(data);
	}
};

@function FD1204_T02:fnDoSendDataManage() {
	this.nodata.show(AComponent.GONE);
	this.secureTxf.removeClass('active');
	this.sendSACMQ603();	
};

@function FD1204_T02:onButton3Click(comp, info)
{
	var win = AWindow.createWindow('FD/window/FD1204_W01.lay', 'FD120401');
	win.setWindowOption(
	{
		isAutoCenter: true
	});
	win.dayType = this.dayType;
	win.date = [this.startDate, this.endDate];
	win.open(this, 0, 0, 580, 530);
};

@function FD1204_T02:onWindowResult(result, awindow)
{
	var winId = awindow.getId();
	if(winId == 'FD120401')
	{
		if(Array.isArray(result)) {
			this.startDate = result[0];
			this.endDate = result[1];
			this.button3.setText(result[2]);
			this.dayType = result[3];
			this.sendSACMQ603();
		}
	}
};