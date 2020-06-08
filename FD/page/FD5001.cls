
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5001()
{
	@super();

	//TODO:edit here
	this.view1 = null;

}
@extends BasePage;


@function FD5001:onReady()
{
	@super.onReady();

	//TODO:edit here
	
	//this.view1 = this.findCompById('View1').viewLoad('FD/view/FD5001_V01.lay');

	
	
	// 탭뷰
	this.tabView = this.findCompById('TabView1');
	
	// 탭메니저
	this.tvManager = this.makeTabViewManager(this.tabView, this);

	// 탭메뉴
	this.tvMenuMap = [
		['신규계좌',	 'FD5001_T01'], 
		['계좌이체',	 'FD5001_T02']
	];
	this.lastTabId = 'FD5001_T01';	

	// 탭추가
	for(var i=0; i < this.tvMenuMap.length; i++)
	{	
		this.tvManager.addTab({	
			tabId	: this.tvMenuMap[i][1], 
			url		: 'FD/view/' + this.tvMenuMap[i][1] + '.lay',
			name	: this.tvMenuMap[i][0], 
			data	: false
		}); // data 는 탭이 선택될때 조건을 초기화 할지 여부
	}
};

@function FD5001:onBackBtnClick(comp, info)
{

	//TODO:edit here
	theApp.goPrevPageCheck(false);

};



@function FD5001:initByPageData()
{
	var tabId = this.lastTabId;
	var unshift = false;
	
	if(!this.pageData)
	{
		this.pageData = {tabId:tabId, item:[]};
	}
	else
	{
		if(!this.pageData.tabId) this.pageData.tabId = tabId;
		else this.lastTabId = this.pageData.tabId;
		if(!this.pageData.item) this.pageData.item = [];
		if(this.pageData.data) unshift = this.pageData.data.unshift; 
	}
	
	this.tvManager.changeTab(this.pageData.tabId, false);
};






@function FD5001:onWillActive(reload)
{	
	@super.onWillActive(reload);
	this.initByPageData()
};

@function FD5001:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	
}


@function FD5001:onWillDeactive(reload)
{
	@super.onWillDeactive(reload);			
}
